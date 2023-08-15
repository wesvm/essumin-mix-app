import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:essumin_mix/ui/screens/acronyms/acronyms_info_screen.dart';
import 'package:essumin_mix/ui/screens/acronyms/acronyms_screen.dart';
import 'package:essumin_mix/ui/themes/custom_switch.dart';
import 'package:essumin_mix/ui/widgets/help_icon_button.dart';
import 'package:essumin_mix/ui/widgets/range_dropdowns.dart';
import 'package:essumin_mix/ui/widgets/show_option_checkbox.dart';
import 'package:flutter/material.dart';

class AcronymOptionScreen extends StatefulWidget {
  final List<Sigla> data;

  const AcronymOptionScreen({required this.data, super.key});

  @override
  State<AcronymOptionScreen> createState() => _AcronymOptionScreenState();
}

class _AcronymOptionScreenState extends State<AcronymOptionScreen> {
  bool isRandom = true;

  final List<int> fromOptions = [1, 5, 10, 20];
  final List<int> toOptions = [5, 10, 15, 25, 0];

  int startIndex = 1;
  int endIndex = 10;

  int rangeOption = 5;

  @override
  void initState() {
    super.initState();
    toOptions[toOptions.length - 1] = widget.data.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opciones')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Acronym'),
            const SizedBox(height: 16.0),
            Text('Longitud: ${widget.data.length}'),
            const SizedBox(height: 16.0),
            CustomSwitch(
              label: 'Aleatorio',
              value: isRandom,
              onChanged: (value) {
                setState(() {
                  isRandom = value;
                });
              },
            ),
            ShowOptionsRadio(
              initialValue: rangeOption,
              option1Value: 5,
              option1Label: "Mostrar 5",
              option2Value: 0,
              option2Label: "Mostrar todo",
              onChanged: (selectedOption) {
                setState(() {
                  rangeOption = selectedOption;
                });
              },
            ),
            RangeDropdowns(
              fromOptions: fromOptions,
              toOptions: toOptions,
              startIndex: startIndex,
              endIndex: endIndex,
              onStartIndexChanged: (value) {
                setState(() {
                  startIndex = value ?? 1;
                });
              },
              onEndIndexChanged: (value) {
                setState(() {
                  endIndex = value ?? 5;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AcronymsScreen(
                      data: widget.data,
                      isRandom: isRandom,
                      startIndex: startIndex,
                      endIndex: endIndex,
                      rangeOption: rangeOption,
                    ),
                  ),
                ),
              },
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: HelpIconButton(
        toScreen: AcronymsInfo(
          data: widget.data,
        ),
      ),
    );
  }
}
