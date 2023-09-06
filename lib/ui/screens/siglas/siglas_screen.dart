import 'dart:math';

import 'package:essumin_mix/ui/screens/end_screen.dart';
import 'package:essumin_mix/ui/themes/custom_app_bar.dart';
import 'package:essumin_mix/ui/widgets/sigla/container_text_sigla.dart';
import 'package:essumin_mix/ui/widgets/sigla/speech_stt_widget.dart';
import 'package:flutter/material.dart';
import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:string_normalizer/string_normalizer.dart';

import 'package:essumin_mix/ui/widgets/result_dialog.dart';
import 'package:essumin_mix/ui/widgets/return_previous_screen_popup.dart';

class SiglasScreen extends StatefulWidget {
  final String category;
  final List<Sigla> options;
  final bool isRandom;
  final int startIndex;
  final int endIndex;
  final int rangeOption;

  const SiglasScreen(
      {Key? key,
      required this.category,
      required this.options,
      required this.isRandom,
      required this.startIndex,
      required this.endIndex,
      required this.rangeOption})
      : super(key: key);

  @override
  SiglasScreenState createState() => SiglasScreenState();
}

class SiglasScreenState extends State<SiglasScreen> {
  bool closeScreen = false;

  int currentIndex = 0;
  List<Sigla> displayedOptions = [];
  bool isButtonDisabled = true;
  int score = 0;
  int progressBarIndex = 0;
  bool isCorrect = false;

  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<SpeechToTextWidgetState> _sttWidget = GlobalKey();

  @override
  void initState() {
    super.initState();
    score = 0;
    progressBarIndex = 0;
    _updateDisplayedOptions();
  }

  void _updateDisplayedOptions() {
    final int startIndex = widget.startIndex - 1;
    final int endIndex = widget.endIndex;

    if (widget.isRandom) {
      final int numElementsToShow = widget.rangeOption == 0
          ? endIndex - startIndex
          : min(widget.rangeOption, endIndex - startIndex);

      final List<int> indices =
          List.generate(endIndex - startIndex, (index) => startIndex + index)
            ..shuffle();

      displayedOptions = indices
          .take(numElementsToShow)
          .map((index) => widget.options[index])
          .toList();
    } else {
      final int limit =
          widget.rangeOption == 0 ? endIndex : min(endIndex, startIndex + 5);

      displayedOptions = widget.options.sublist(startIndex, limit);
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
                },
              )
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sigla:', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ContainerTextWidget(
                        text: displayedOptions[currentIndex].key),
                  ),
                  const SizedBox(height: 16.0),
                  SpeechToTextWidget(
                    key: _sttWidget,
                    language: 'es',
                    labelText: 'Ingrese el valor de la sigla',
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
            child: const Text('Comprobar'),
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
    final Sigla currentOption = displayedOptions[currentIndex];
    final List<String> allValues = [
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
    final String resultText = isCorrect ? 'Correcto' : 'Incorrecto';

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
            title: resultText,
            message: currentOption,
            isCorrect: isCorrect,
            textButton: 'Continuar',
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
