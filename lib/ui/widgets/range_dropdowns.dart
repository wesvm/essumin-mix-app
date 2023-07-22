import 'package:flutter/material.dart';

class RangeDropdowns extends StatelessWidget {
  final List<int> fromOptions;
  final List<int> toOptions;
  final int fromValue;
  final int toValue;
  final ValueChanged<int?> onFromValueChanged;
  final ValueChanged<int?> onToValueChanged;

  const RangeDropdowns({
    Key? key,
    required this.fromOptions,
    required this.toOptions,
    required this.fromValue,
    required this.toValue,
    required this.onFromValueChanged,
    required this.onToValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Desde el'),
        const SizedBox(width: 16.0),
        DropdownButton<int>(
          value: fromValue,
          onChanged: onFromValueChanged,
          items: fromOptions
              .where((option) => option < toValue)
              .map((option) => DropdownMenuItem<int>(
                  value: option, child: Text(option.toString())))
              .toList(),
        ),
        const SizedBox(width: 16.0),
        const Text('al'),
        const SizedBox(width: 16.0),
        DropdownButton<int>(
          value: toValue,
          onChanged: onToValueChanged,
          items: toOptions
              .where((option) => option > fromValue)
              .map((option) => DropdownMenuItem<int>(
                    value: option,
                    child: Text(option.toString()),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
