import 'package:flutter/material.dart';
import 'dart:math';

import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:essumin_mix/ui/screens/end_screen.dart';
import 'package:essumin_mix/ui/themes/custom_app_bar.dart';
import 'package:essumin_mix/ui/widgets/result_dialog.dart';
import 'package:essumin_mix/ui/widgets/return_previous_screen_popup.dart';
import 'package:essumin_mix/ui/widgets/sigla/text_tts_widget.dart';

import 'package:string_normalizer/string_normalizer.dart';

class SiglasTtsScreen extends StatefulWidget {
  final String category;
  final List<Sigla> options;
  final bool isRandom;
  final int startIndex;
  final int endIndex;
  final int rangeOption;

  const SiglasTtsScreen(
      {required this.category,
      required this.options,
      required this.isRandom,
      required this.startIndex,
      required this.endIndex,
      required this.rangeOption,
      super.key});

  @override
  State<SiglasTtsScreen> createState() => _SiglasTtsScreenState();
}

class _SiglasTtsScreenState extends State<SiglasTtsScreen> {
  bool closeScreen = false;

  int currentIndex = 0;
  List<Sigla> displayedOptions = [];
  bool isButtonDisabled = true;
  int score = 0;
  int progressBarIndex = 0;
  bool isCorrect = false;

  final TextEditingController _textEditingController = TextEditingController();

  TtsState ttsState = TtsState.stopped;
  bool showText = false;

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

      final List<int> indices = List.generate(
        endIndex - startIndex,
        (index) => startIndex + index,
      );

      final Random random = Random();

      for (int i = indices.length - 1; i > 0; i--) {
        int j = random.nextInt(i + 1);
        int temp = indices[i];
        indices[i] = indices[j];
        indices[j] = temp;
      }

      displayedOptions = indices
          .sublist(0, numElementsToShow)
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
                  })
              : null,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sigla:', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 16.0),
                  Center(
                    child: SpeakableTextWidget(
                      text: displayedOptions[currentIndex].key,
                      showText: showText,
                      ttsState: ttsState,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Ingrese el valor de la sigla',
                    ),
                    onChanged: (text) {
                      _updateButtonState(text.trim().isEmpty);
                    },
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              isButtonDisabled ? null : () => _checkAnswer(),
                          child: const Text('Comprobar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool _shouldShowAppBar(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        kToolbarHeight -
        (mediaQuery.viewInsets.bottom > 0 ? mediaQuery.viewInsets.bottom : 0);

    return availableHeight > mediaQuery.size.height / 1.5;
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
    _showResultDialog(isCorrect, currentOption.value);
    _resetSpeakableTtsWidgetState();
    _updateButtonState(true);
  }

  void _resetSpeakableTtsWidgetState() {
    setState(() {
      ttsState = TtsState.stopped;
      showText = false;
    });
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
    return await showDialog(
      context: context,
      builder: (context) => const ReturnPreviousScreenPopup(),
    );
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
