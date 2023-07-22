import 'package:essumin_mix/ui/screens/siglas_screen.dart';
import 'package:essumin_mix/ui/widgets/random_switch.dart';
import 'package:essumin_mix/ui/widgets/range_dropdowns.dart';
import 'package:essumin_mix/ui/widgets/show_option_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:essumin_mix/data/option.dart';

class OptionSelectedScreen extends StatefulWidget {
  final String category;
  final List<Option> options;

  const OptionSelectedScreen(
      {Key? key, required this.category, required this.options})
      : super(key: key);

  @override
  OptionSelectedScreenState createState() => OptionSelectedScreenState();
}

class OptionSelectedScreenState extends State<OptionSelectedScreen> {
  bool isRandom = false;
  final List<int> fromOptions = [1, 5, 10, 20, 30, 40, 50, 60];
  final List<int> toOptions = [5, 10, 20, 30, 40, 50, 60, 0];

  int fromValue = 1;
  int toValue = 10;

  int rangeOption = 5;

  @override
  void initState() {
    super.initState();
    toOptions[toOptions.length - 1] = widget.options.length;
    rangeOption = 5;
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
            RandomSwitch(
              value: isRandom,
              onChanged: (value) {
                setState(() {
                  isRandom = value;
                });
              },
            ),
            ShowOptionsCheckbox(
              onChanged: (showAll) {
                setState(() {
                  if (showAll) {
                    rangeOption = 5;
                  } else {
                    rangeOption = toValue;
                  }
                });
              },
            ),
            RangeDropdowns(
              fromOptions: fromOptions,
              toOptions: toOptions,
              fromValue: fromValue,
              toValue: toValue,
              onFromValueChanged: (value) {
                setState(() {
                  fromValue = fromValue = value ?? 1;
                });
              },
              onToValueChanged: (value) {
                setState(() {
                  toValue = value ?? 5;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SiglasScreen(
                      category: widget.category,
                      options: widget.options,
                      isRandom: isRandom,
                      fromValue: fromValue,
                      toValue: toValue,
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
    );
  }
}
