import 'dart:math';

import 'package:essumin_mix/data/models/simbologia/rigger.dart';
import 'package:essumin_mix/ui/screens/end_screen.dart';
import 'package:essumin_mix/ui/themes/custom_app_bar.dart';
import 'package:essumin_mix/ui/widgets/adicionales/container_img_gif_rigger.dart';
import 'package:essumin_mix/ui/widgets/result_dialog.dart';
import 'package:essumin_mix/ui/widgets/return_previous_screen_popup.dart';
import 'package:essumin_mix/ui/widgets/sigla/speech_stt_widget.dart';
import 'package:flutter/material.dart';

import 'package:essumin_mix/data/models/simbologia/simbologia.dart';
import 'package:string_normalizer/string_normalizer.dart';

class RiggersScreen extends StatefulWidget {
  final String language;
  final int rangeOption;
  final bool isRandom;
  final List<Simbologia> data;

  const RiggersScreen(
      {Key? key,
      required this.language,
      required this.rangeOption,
      required this.isRandom,
      required this.data})
      : super(key: key);

  @override
  State<RiggersScreen> createState() => _RiggersScreenState();
}

class _RiggersScreenState extends State<RiggersScreen> {
  bool closeScreen = false;
  String selectedCategory = '';
  List<RSimbologia> displayedOptions = [];
  bool isButtonDisabled = true;
  int currentIndex = 0;

  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<SpeechToTextWidgetState> _sttWidget = GlobalKey();
  bool isCorrect = false;
  int score = 0;
  int progressBarIndex = 0;

  late String title;
  late String inputText;
  late String buttonText;
  late List<RSimbologia> rigger;

  late List<String> resultTextTitle;
  late String resultTextButton;

  @override
  void initState() {
    super.initState();
    score = 0;
    progressBarIndex = 0;
    _selectedLanguague();
    _updateDisplayedOptions();
  }

  void _selectedLanguague() {
    if (widget.language == 'es') {
      title = 'Señal: ';
      inputText = 'Ingrese el valor de la señal';
      buttonText = 'Comprobar';

      resultTextTitle = ['Correcto', 'Incorrecto'];
      resultTextButton = 'Continuar';

      rigger = widget.data
          .map((simbologia) => RSimbologia(
                imgUrl: simbologia.imgUrl,
                gifUrl: simbologia.gifUrl,
                value: simbologia.esValue,
                synonyms: simbologia.esSynonyms,
              ))
          .toList();
    } else {
      title = 'Hand signal: ';
      inputText = 'Enter the hand signal value';
      buttonText = 'Check';

      resultTextTitle = ['Correct', 'Incorrect'];
      resultTextButton = 'Continue';

      rigger = widget.data
          .map((simbologia) => RSimbologia(
                imgUrl: simbologia.imgUrl,
                gifUrl: simbologia.gifUrl,
                value: simbologia.enValue,
                synonyms: simbologia.enSynonyms,
              ))
          .toList();
    }
  }

  void _updateDisplayedOptions() {
    if (widget.isRandom) {
      final List<RSimbologia> shuffledList = [...rigger]..shuffle();

      displayedOptions = widget.rangeOption == 0
          ? shuffledList
          : shuffledList.sublist(
              0, min(widget.rangeOption, shuffledList.length));
    } else {
      final int limit = widget.rangeOption == 0 ? 5 : min(5, rigger.length);
      displayedOptions = rigger.sublist(0, limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (closeScreen) {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
    }

    return WillPopScope(
      onWillPop: () async {
        return _showReturnPreviousScreenPopup(context);
      },
      child: Scaffold(
        appBar: _shouldShowAppBar(context)
            ? CustomAppBar(
                progressBarIndex: progressBarIndex,
                totalItems: displayedOptions.length,
                onLeadingPressed: () {
                  Navigator.of(context).maybePop();
                })
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ContianerImageGif(
                        imgUrl: displayedOptions[currentIndex].imgUrl,
                        gifUrl: displayedOptions[currentIndex].gifUrl),
                  ),
                  const SizedBox(height: 16.0),
                  SpeechToTextWidget(
                    key: _sttWidget,
                    language: widget.language,
                    labelText: inputText,
                    onChanged: _updateButtonState,
                    textEditingController: _textEditingController,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          color: const Color(0xFF0d1117),
          padding: const EdgeInsets.all(7.5),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isButtonDisabled ? null : () => _checkAnswer(),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }

  bool _shouldShowAppBar(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;

    return screenHeight > keyboardHeight + screenHeight / 1.5;
  }

  void _checkAnswer() {
    final String userValue =
        _textEditingController.text.trim().toLowerCase().normalize();
    final RSimbologia currentOption = displayedOptions[currentIndex];

    List<String> allValues = [];

    allValues = [
      currentOption.value.toLowerCase(),
      ...currentOption.synonyms?.map((synonym) => synonym.toLowerCase()) ?? [],
    ];

    isCorrect = allValues.contains(userValue);
    if (isCorrect) {
      setState(() {
        score++;
      });
    }
    setState(() {
      progressBarIndex++;
    });

    _sttWidget.currentState?.cancelListening();

    _showResultDialog(isCorrect, currentOption.value);
    _updateButtonState(true);
  }

  void _showResultDialog(bool isCorrect, String currentOption) async {
    String title = isCorrect ? resultTextTitle[0] : resultTextTitle[1];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            bool shouldPop = await _showReturnPreviousScreenPopup(context);
            if (shouldPop) {
              setState(() {
                closeScreen = true;
              });
            }
            return shouldPop;
          },
          child: ResultDialog(
            title: title,
            message: currentOption,
            textButton: resultTextButton,
            isCorrect: isCorrect,
            onClose: () {
              Navigator.pop(context);
              if (currentIndex < displayedOptions.length - 1) {
                setState(() {
                  currentIndex++;
                  _textEditingController.clear();
                  FocusScope.of(context).unfocus();
                });
              } else {
                _showEndScreen();
              }
            },
          ),
        );
      },
    );
  }

  Future<bool> _showReturnPreviousScreenPopup(BuildContext context) async {
    bool? result = await showDialog(
      context: context,
      builder: (context) => const ReturnPreviousScreenPopup(),
    );
    return result ?? false;
  }

  void _showEndScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EndScreen(score: score, totalItems: displayedOptions.length),
      ),
    );
  }

  void _updateButtonState(bool isEmpty) {
    setState(() {
      isButtonDisabled = isEmpty;
    });
  }
}
