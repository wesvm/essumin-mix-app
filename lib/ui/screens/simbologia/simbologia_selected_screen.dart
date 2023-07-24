import 'package:essumin_mix/data/models/simbologia/simbologia.dart';
import 'package:essumin_mix/ui/screens/simbologia/simbologias_screen.dart';
import 'package:essumin_mix/ui/widgets/random_switch.dart';
import 'package:essumin_mix/ui/widgets/show_option_checkbox.dart';
import 'package:flutter/material.dart';

class SimbologiaSelectedScreen extends StatefulWidget {
  final String category;
  final List<Simbologia> data;

  const SimbologiaSelectedScreen(
      {Key? key, required this.category, required this.data})
      : super(key: key);

  @override
  SimbologiaSelectedScreenState createState() =>
      SimbologiaSelectedScreenState();
}

class SimbologiaSelectedScreenState extends State<SimbologiaSelectedScreen> {
  bool isRandom = true;
  int rangeOption = 5;
  String languageOption = 'es';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opciones')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Simbologia seleccionada: ${widget.category[0].toUpperCase()}${widget.category.substring(1)}'),
            const SizedBox(height: 16.0),
            Text('Longitud: ${widget.data.length}'),
            const SizedBox(height: 16.0),
            RandomSwitch(
              value: isRandom,
              onChanged: (value) {
                setState(() {
                  isRandom = value;
                });
              },
            ),
            ShowOptionsRadio<int>(
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
            const SizedBox(height: 16.0),
            ShowOptionsRadio<String>(
              initialValue: languageOption,
              option1Value: 'es',
              option1Label: 'Español',
              option2Value: 'en',
              option2Label: 'Ingles',
              onChanged: (selectedOption) {
                setState(() {
                  languageOption = selectedOption;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimbologiasScreen(
                      category: widget.category,
                      data: widget.data,
                      rangeOption: rangeOption,
                      language: languageOption,
                      isRandom: isRandom,
                    ),
                  ),
                );
              },
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
    );
  }
}
