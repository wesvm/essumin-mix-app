import 'dart:math';

import 'package:flutter/material.dart';
import 'package:string_normalizer/string_normalizer.dart';

import 'package:essumin_mix/data/models/simbologia/simbologia.dart';

import 'package:essumin_mix/ui/screens/end_screen.dart';
import 'package:essumin_mix/ui/widgets/progress_bar.dart';
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
  SimbologiasScreenState createState() => SimbologiasScreenState();
}

class SimbologiasScreenState extends State<SimbologiasScreen> {
  String selectedCategory = '';
  List<Simbologia> displayedOptions = [];
  bool isButtonDisabled = true;
  int currentIndex = 0;

  final TextEditingController _textEditingController = TextEditingController();
  bool isCorrect = false;
  int score = 0;
  int progressBarIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.category[0].toUpperCase() + widget.category.substring(1);
    score = 0;
    progressBarIndex = 0;
    _updateDisplayedOptions();
  }

  void _updateDisplayedOptions() {
    if (widget.isRandom) {
      final List<Simbologia> shuffledList = [...widget.data]..shuffle();

      displayedOptions = widget.rangeOption == 0
          ? shuffledList
          : shuffledList.sublist(
              0, min(widget.rangeOption, shuffledList.length));
    } else {
      final int limit =
          widget.rangeOption == 0 ? 5 : min(5, widget.data.length);
      displayedOptions = widget.data.sublist(0, limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldReturnPrevious = await showDialog(
          context: context,
          builder: (_) => const ReturnPreviousScreenPopup(),
        );
        return shouldReturnPrevious ?? false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(selectedCategory)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressBar(
                totalItems: displayedOptions.length,
                currentIndex: progressBarIndex,
              ),
              const SizedBox(height: 16.0),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: const Color.fromRGBO(113, 128, 150, 0.25),
                ),
                child: Image.asset(
                  displayedOptions[currentIndex].imgUrl,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Ingrese el valor de la simbologia',
                  ),
                  onChanged: (text) {
                    _updateButtonState(text.trim().isEmpty);
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isButtonDisabled ? null : () => _checkAnswer(),
                    child: const Text('Comprobar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkAnswer() {
    final String userValue =
        _textEditingController.text.trim().toLowerCase().normalize();
    final Simbologia currentOption = displayedOptions[currentIndex];
    List<String> allValues = [];

    String currentLanguage =
        widget.language == 'es' ? currentOption.esValue : currentOption.enValue;
    List<String>? currentLanguageSynonyms = widget.language == 'es'
        ? currentOption.esSynonyms
        : currentOption.enSynonyms;

    allValues = [
      currentLanguage.toLowerCase(),
      ...currentLanguageSynonyms?.map((synonym) => synonym.toLowerCase()) ?? [],
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
    _showResultDialog(isCorrect, currentLanguage);
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
        return ResultDialog(
          title: resultText,
          message: currentOption,
          isCorrect: isCorrect,
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
        );
      },
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
