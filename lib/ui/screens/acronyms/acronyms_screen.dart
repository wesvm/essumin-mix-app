import 'dart:math';

import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:essumin_mix/ui/screens/end_screen.dart';
import 'package:essumin_mix/ui/themes/custom_app_bar.dart';
import 'package:essumin_mix/ui/widgets/result_dialog.dart';
import 'package:essumin_mix/ui/widgets/return_previous_screen_popup.dart';
import 'package:essumin_mix/ui/widgets/sigla/container_text_sigla.dart';
import 'package:flutter/material.dart';
import 'package:string_normalizer/string_normalizer.dart';

class AcronymsScreen extends StatefulWidget {
  final List<Sigla> data;
  final bool isRandom;
  final int startIndex;
  final int endIndex;
  final int rangeOption;

  const AcronymsScreen(
      {required this.data,
      required this.isRandom,
      required this.startIndex,
      required this.endIndex,
      required this.rangeOption,
      super.key});

  @override
  State<AcronymsScreen> createState() => _AcronymsScreenState();
}

class _AcronymsScreenState extends State<AcronymsScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  List<Sigla> displayedData = [];

  bool closeScreen = false;
  bool isCorrect = false;
  bool isButtonDisabled = true;

  int currentIndex = 0;
  int score = 0;
  int progressBarIndex = 0;

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

      displayedData = indices
          .sublist(0, numElementsToShow)
          .map((index) => widget.data[index])
          .toList();
    } else {
      final int limit =
          widget.rangeOption == 0 ? endIndex : min(endIndex, startIndex + 5);

      displayedData = widget.data.sublist(startIndex, limit);
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
                totalItems: displayedData.length,
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
              const Text('Acronym:', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 16.0),
              Center(
                child:
                    ContainerTextWidget(text: displayedData[currentIndex].key),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Input the acronym value: ',
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
                      onPressed: isButtonDisabled ? null : () => _checkAnswer(),
                      child: const Text('Check'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
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
    final Sigla currentOption = displayedData[currentIndex];
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
    _updateButtonState(true);
  }

  void _showResultDialog(bool isCorrect, String currentOption) async {
    final String resultText = isCorrect ? 'Correct' : 'Incorrect';

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
            textButton: 'Continue',
            onClose: () {
              Navigator.pop(context);

              if (currentIndex < displayedData.length - 1) {
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
            EndScreen(score: score, totalItems: displayedData.length),
      ),
    );
  }

  void _updateButtonState(bool isEmpty) {
    setState(() {
      isButtonDisabled = isEmpty;
    });
  }
}
