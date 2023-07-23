import 'package:flutter/material.dart';

class ShowOptionsRadio extends StatefulWidget {
  final ValueChanged<int>? onChanged;

  const ShowOptionsRadio({Key? key, this.onChanged}) : super(key: key);

  @override
  ShowOptionsRadioState createState() => ShowOptionsRadioState();
}

class ShowOptionsRadioState extends State<ShowOptionsRadio> {
  int _selectedOption = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<int>(
          value: 5,
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            });
          },
        ),
        const Text('Mostrar 5'),
        const SizedBox(width: 20),
        Radio<int>(
          value: 0,
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            });
          },
        ),
        const Text('Mostrar todo'),
      ],
    );
  }
}
