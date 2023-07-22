import 'package:flutter/material.dart';

class RandomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const RandomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Aleatorio'),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
