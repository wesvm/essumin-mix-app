import 'package:flutter/material.dart';

class RangeDropdowns extends StatelessWidget {
  final List<int> fromOptions;
  final List<int> toOptions;
  final int startIndex;
  final int endIndex;
  final ValueChanged<int?> onStartIndexChanged;
  final ValueChanged<int?> onEndIndexChanged;

  const RangeDropdowns({
    Key? key,
    required this.fromOptions,
    required this.toOptions,
    required this.startIndex,
    required this.endIndex,
    required this.onStartIndexChanged,
    required this.onEndIndexChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Desde el'),
        const SizedBox(width: 16.0),
        DropdownButton<int>(
          value: startIndex,
          onChanged: onStartIndexChanged,
          items: fromOptions
              .where((option) => option < endIndex)
              .map((option) => DropdownMenuItem<int>(
                  value: option, child: Text(option.toString())))
              .toList(),
        ),
        const SizedBox(width: 16.0),
        const Text('al'),
        const SizedBox(width: 16.0),
        DropdownButton<int>(
          value: endIndex,
          onChanged: onEndIndexChanged,
          items: toOptions
              .where((option) => option > startIndex)
              .map(
                (option) => DropdownMenuItem<int>(
                  value: option,
                  child: Text(option.toString()),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
