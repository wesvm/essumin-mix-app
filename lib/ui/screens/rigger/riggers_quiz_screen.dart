import 'package:essumin_mix/data/models/simbologia/rigger.dart';
import 'package:essumin_mix/ui/screens/end_screen.dart';
import 'package:essumin_mix/ui/widgets/result_dialog.dart';
import 'package:essumin_mix/ui/widgets/adicionales/images_grid_view.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'package:essumin_mix/ui/themes/custom_app_bar.dart';
import 'package:essumin_mix/ui/widgets/return_previous_screen_popup.dart';

import 'package:essumin_mix/data/models/simbologia/simbologia.dart';

class RiggersQuizScreen extends StatefulWidget {
  final String language;
  final int rangeOption;
  final bool isRandom;
  final List<Simbologia> data;

  const RiggersQuizScreen(
      {Key? key,
      required this.language,
      required this.rangeOption,
      required this.isRandom,
      required this.data})
      : super(key: key);

  @override
  State<RiggersQuizScreen> createState() => _RiggersQuizScreenState();
}

class _RiggersQuizScreenState extends State<RiggersQuizScreen> {
  bool closeScreen = false;

  List<RSimbologia> displayedOptions = [];
  List<RSimbologia> displayedImageData = [];

  bool isButtonDisabled = true;
  int currentIndex = 0;
  int selectedIndex = -1;

  bool isCorrect = false;
  int score = 0;
  int progressBarIndex = 0;

  late String title;
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
    _updateDisplayedImages();
  }

  void _selectedLanguague() {
    if (widget.language == 'es') {
      title = 'Seleccione la correcta: ';
      buttonText = 'Comprobar';

      resultTextTitle = ['Correcto', 'Incorrecto'];
      resultTextButton = 'Continuar';

      rigger = widget.data
          .map((simbologia) => RSimbologia(
                imgUrl: simbologia.imgUrl,
                value: simbologia.esValue,
                synonyms: simbologia.esSynonyms,
              ))
          .toList();
    } else {
      title = 'Select the correct one: ';
      buttonText = 'Check';

      resultTextTitle = ['Correct', 'Incorrect'];
      resultTextButton = 'Continue';

      rigger = widget.data
          .map((simbologia) => RSimbologia(
                imgUrl: simbologia.imgUrl,
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

  void _updateDisplayedImages() {
    displayedImageData = [displayedOptions[currentIndex]];
    var filtered = displayedOptions
        .where(
            (element) => element.value != displayedOptions[currentIndex].value)
        .toList();

    displayedImageData.addAll(filtered.take(3));
    displayedImageData.shuffle();
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
        return await _showReturnPreviousScreenPopup(context);
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 68,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(113, 128, 150, 0.25),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              displayedOptions[currentIndex].value,
                              style: const TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ImagesGridView(
                      data: displayedImageData,
                      selectedIndex: selectedIndex,
                      onItemSelected: (index) {
                        setState(
                          () {
                            selectedIndex = index;
                            _updateButtonState(selectedIndex == -1);
                          },
                        );
                      },
                    ),
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
    final availableHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        kToolbarHeight -
        (mediaQuery.viewInsets.bottom > 0 ? mediaQuery.viewInsets.bottom : 0);

    return availableHeight > mediaQuery.size.height / 1.5;
  }

  void _checkAnswer() {
    final String userValue = displayedImageData[selectedIndex].value;
    final String currentOption = displayedOptions[currentIndex].value;

    isCorrect = currentOption == userValue;

    if (isCorrect) {
      setState(() {
        score++;
      });
    }
    setState(() {
      progressBarIndex++;
    });
    _showResultDialog(isCorrect, currentOption);
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
                  _updateDisplayedImages();
                  selectedIndex = -1;
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
