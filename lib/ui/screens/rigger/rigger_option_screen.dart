import 'package:essumin_mix/data/models/simbologia/simbologia.dart';
import 'package:essumin_mix/ui/screens/rigger/rigger_info_screen.dart';
import 'package:essumin_mix/ui/screens/rigger/riggers_quiz_screen.dart';
import 'package:essumin_mix/ui/screens/rigger/riggers_screen.dart';
import 'package:essumin_mix/ui/themes/custom_switch.dart';
import 'package:essumin_mix/ui/widgets/help_icon_button.dart';
import 'package:essumin_mix/ui/widgets/show_option_checkbox.dart';
import 'package:flutter/material.dart';

class RiggerOptionScreen extends StatefulWidget {
  final List<Simbologia> data;

  const RiggerOptionScreen({
    required this.data,
    super.key,
  });

  @override
  State<RiggerOptionScreen> createState() => _RiggerOptionScreenState();
}

class _RiggerOptionScreenState extends State<RiggerOptionScreen> {
  bool isRandom = true;
  bool quizImage = false;
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
            const Text('Rigger'),
            const SizedBox(height: 16.0),
            Text('Longitud: ${widget.data.length}'),
            const SizedBox(height: 16.0),
            CustomSwitch(
              label: 'Quiz Image',
              value: quizImage,
              onChanged: (value) {
                setState(() {
                  quizImage = value;
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
                    builder: (context) => !quizImage
                        ? RiggersScreen(
                            data: widget.data,
                            rangeOption: rangeOption,
                            language: languageOption,
                            isRandom: isRandom)
                        : RiggersQuizScreen(
                            language: languageOption,
                            rangeOption: rangeOption,
                            isRandom: isRandom,
                            data: widget.data),
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
        toScreen: RiggerInfo(
          data: widget.data,
        ),
      ),
    );
  }
}
