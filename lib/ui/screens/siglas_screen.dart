import 'package:essumin_mix/ui/screens/end_screen.dart';
import 'package:flutter/material.dart';
import 'package:essumin_mix/data/option.dart';
import 'package:string_normalizer/string_normalizer.dart';

import 'package:essumin_mix/ui/widgets/progress_bar.dart';
import 'package:essumin_mix/ui/widgets/result_dialog.dart';
import 'package:essumin_mix/ui/widgets/return_previous_screen_popup.dart';

class SiglasScreen extends StatefulWidget {
  final String category;
  final List<Option> options;
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
  int currentIndex = 0;
  List<Option> displayedOptions = [];
  String selectedCategory = '';
  bool isButtonDisabled = true;
  int score = 0;

  final TextEditingController _textEditingController = TextEditingController();
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.category[0].toUpperCase() + widget.category.substring(1);
    score = 0;
    _updateDisplayedOptions();
  }

  void _updateDisplayedOptions() {
    final int startIndex = widget.startIndex - 1;
    final int endIndex = widget.endIndex - 1;

    if (widget.isRandom) {
      final availableIndexes =
          List.generate(widget.options.length, (index) => index);

      availableIndexes.shuffle();

      final int limit = widget.rangeOption == 0 ? endIndex : startIndex + 5;

      final selectedIndexes = availableIndexes
          .where((index) => index >= startIndex && index <= limit - 1);

      displayedOptions =
          selectedIndexes.map((index) => widget.options[index]).toList();
    } else {
      final int limit = widget.rangeOption == 0
          ? endIndex
          : startIndex == 59
              ? endIndex
              : startIndex + 5;
      displayedOptions = widget.options.sublist(startIndex, limit);
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
                currentIndex: currentIndex,
              ),
              const SizedBox(height: 16.0),
              Text('Sigla: ${displayedOptions[currentIndex].key}'),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Ingrese el valor de la sigla',
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
    final Option currentOption = displayedOptions[currentIndex];
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
