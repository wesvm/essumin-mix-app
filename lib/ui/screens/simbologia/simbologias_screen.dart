import 'dart:math';

import 'package:essumin_mix/data/models/simbologia/specific_simbologia.dart';
import 'package:essumin_mix/ui/themes/custom_app_bar.dart';
import 'package:essumin_mix/ui/widgets/sigla/speech_stt_widget.dart';
import 'package:flutter/material.dart';
import 'package:string_normalizer/string_normalizer.dart';

import 'package:essumin_mix/data/models/simbologia/simbologia.dart';

import 'package:essumin_mix/ui/screens/end_screen.dart';
import 'package:essumin_mix/ui/widgets/result_dialog.dart';
import 'package:essumin_mix/ui/widgets/return_previous_screen_popup.dart';

class SimbologiasScreen extends StatefulWidget {
  final String category;
  final String language;
  final int rangeOption;
  final bool isRandom;
  final List<Simbologia> data;

  const SimbologiasScreen(
      {Key? key,
      required this.category,
      required this.language,
      required this.rangeOption,
      required this.isRandom,
      required this.data})
      : super(key: key);

  @override
  State<SimbologiasScreen> createState() => _SimbologiasScreenState();
}

class _SimbologiasScreenState extends State<SimbologiasScreen> {
  bool closeScreen = false;
  String selectedCategory = '';
  List<SSimbologia> displayedOptions = [];
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
  late List<SSimbologia> simbologia;

  late List<String> resultTextTitle;
  late String resultTextButton;

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.category[0].toUpperCase() + widget.category.substring(1);
    score = 0;
    progressBarIndex = 0;
    _selectedLanguague();
    _updateDisplayedOptions();
  }

  void _selectedLanguague() {
    if (widget.language == 'es') {
      title = 'Simbologia: ';
      inputText = 'Ingrese el valor de la simbologia';
      buttonText = 'Comprobar';

      resultTextTitle = ['Correcto', 'Incorrecto'];
      resultTextButton = 'Continuar';

      simbologia = widget.data
          .map((simbologia) => SSimbologia(
                imgUrl: simbologia.imgUrl,
                value: simbologia.esValue,
                synonyms: simbologia.esSynonyms,
              ))
          .toList();
    } else {
      title = 'Symbology: ';
      inputText = 'Enter the symbology value';
      buttonText = 'Check';

      resultTextTitle = ['Correct', 'Incorrect'];
      resultTextButton = 'Continue';

      simbologia = widget.data
          .map((simbologia) => SSimbologia(
                imgUrl: simbologia.imgUrl,
                value: simbologia.enValue,
                synonyms: simbologia.enSynonyms,
              ))
          .toList();
    }
  }

  void _updateDisplayedOptions() {
    if (widget.isRandom) {
      final List<SSimbologia> shuffledList = [...simbologia]..shuffle();

      displayedOptions = widget.rangeOption == 0
          ? shuffledList
          : shuffledList.sublist(
              0, min(widget.rangeOption, shuffledList.length));
    } else {
      final int limit = widget.rangeOption == 0 ? 5 : min(5, simbologia.length);
      displayedOptions = simbologia.sublist(0, limit);
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
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromRGBO(113, 128, 150, 0.25),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          displayedOptions[currentIndex].imgUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
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
    final SSimbologia currentOption = displayedOptions[currentIndex];

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
