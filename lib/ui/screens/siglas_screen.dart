import 'package:essumin_mix/ui/widgets/return_home_popup.dart';
import 'package:essumin_mix/ui/widgets/return_previous_screen_popup.dart';
import 'package:flutter/material.dart';
import 'package:essumin_mix/data/option.dart';
import 'package:string_normalizer/string_normalizer.dart';

class SiglasScreen extends StatefulWidget {
  final String category;
  final List<Option> options;
  final bool isRandom;
  final int fromValue;
  final int toValue;
  final int rangeOption;

  const SiglasScreen(
      {Key? key,
      required this.category,
      required this.options,
      required this.isRandom,
      required this.fromValue,
      required this.toValue,
      required this.rangeOption})
      : super(key: key);

  @override
  SiglasScreenState createState() => SiglasScreenState();
}

class SiglasScreenState extends State<SiglasScreen> {
  int currentIndex = 0;
  List<Option> displayedOptions = [];
  String selectedCategory = '';

  final TextEditingController _textEditingController = TextEditingController();
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.category[0].toUpperCase() + widget.category.substring(1);
    _updateDisplayedOptions();
  }

  void _updateDisplayedOptions() {
    final int startIndex = widget.fromValue - 1;
    final int endIndex = widget.toValue - 1;

    if (widget.isRandom) {
      final availableIndexes =
          List.generate(widget.options.length, (index) => index);
      availableIndexes.shuffle();

      final int limit = widget.rangeOption == widget.toValue ? endIndex : 4;

      final selectedIndexes = availableIndexes
          .where((index) => index >= startIndex && index <= limit);
      displayedOptions =
          selectedIndexes.map((index) => widget.options[index]).toList();
    } else {
      final int limit = widget.rangeOption == widget.toValue ? endIndex : 4;
      displayedOptions = widget.options.sublist(startIndex, limit + 1);
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
              Text('Sigla: ${displayedOptions[currentIndex].key}'),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Ingrese el valor de la sigla',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final String userValue = _textEditingController.text
                          .trim()
                          .toLowerCase()
                          .normalize();
                      final Option currentOption =
                          displayedOptions[currentIndex];
                      final List<String> allValues = [
                        currentOption.value.toLowerCase(),
                        ...currentOption.synonyms
                                ?.map((synonym) => synonym.toLowerCase()) ??
                            [],
                      ];
                      isCorrect = allValues.contains(userValue);
                      _showResultDialog(isCorrect, currentOption.value);
                    },
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

  Future<void> _showResultDialog(bool isCorrect, String currentOption) async {
    final String resultText = isCorrect ? 'Correcto' : 'Incorrecto';
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resultText),
        content: Text(currentOption),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (currentIndex < displayedOptions.length - 1) {
                setState(() {
                  currentIndex++;
                  _textEditingController.clear();
                });
              } else {
                showDialog(
                  context: context,
                  builder: (_) => const ReturnHomePopup(),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
