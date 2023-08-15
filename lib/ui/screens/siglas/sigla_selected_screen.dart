import 'package:essumin_mix/ui/screens/siglas/siglas_info_screen.dart';
import 'package:essumin_mix/ui/screens/siglas/siglas_tts_screen.dart';
import 'package:essumin_mix/ui/widgets/help_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:essumin_mix/data/models/sigla/sigla.dart';

import 'package:essumin_mix/ui/screens/siglas/siglas_screen.dart';

import 'package:essumin_mix/ui/themes/custom_switch.dart';
import 'package:essumin_mix/ui/widgets/range_dropdowns.dart';
import 'package:essumin_mix/ui/widgets/show_option_checkbox.dart';

class SiglaSelectedScreen extends StatefulWidget {
  final String category;
  final List<Sigla> options;

  const SiglaSelectedScreen(
      {Key? key, required this.category, required this.options})
      : super(key: key);

  @override
  SiglaSelectedScreenState createState() => SiglaSelectedScreenState();
}

class SiglaSelectedScreenState extends State<SiglaSelectedScreen> {
  bool isRandom = true;
  bool useSpeech = false;
  final List<int> fromOptions = [1, 5, 10, 20, 30, 40, 50, 60];
  final List<int> toOptions = [5, 10, 20, 30, 40, 50, 60, 0];

  int startIndex = 1;
  int endIndex = 10;

  int rangeOption = 5;

  @override
  void initState() {
    super.initState();
    toOptions[toOptions.length - 1] = widget.options.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opciones')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Sigla seleccionada: ${widget.category[0].toUpperCase()}${widget.category.substring(1)}'),
            const SizedBox(height: 16.0),
            Text('Longitud: ${widget.options.length}'),
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
            CustomSwitch(
              label: 'Speech?',
              value: useSpeech,
              onChanged: (value) {
                setState(() {
                  useSpeech = value;
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => !useSpeech
                        ? SiglasScreen(
                            category: widget.category,
                            options: widget.options,
                            isRandom: isRandom,
                            startIndex: startIndex,
                            endIndex: endIndex,
                            rangeOption: rangeOption,
                          )
                        : SiglasTtsScreen(
                            category: widget.category,
                            options: widget.options,
                            isRandom: isRandom,
                            startIndex: startIndex,
                            endIndex: endIndex,
                            rangeOption: rangeOption,
                          ),
                  ),
                );
              },
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: HelpIconButton(
        toScreen: SiglasInfo(
          category: widget.category,
          data: widget.options,
        ),
      ),
    );
  }
}
