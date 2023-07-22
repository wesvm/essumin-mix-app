import 'package:flutter/material.dart';

class ShowOptionsCheckbox extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  const ShowOptionsCheckbox({Key? key, this.onChanged}) : super(key: key);

  @override
  ShowOptionsCheckboxState createState() => ShowOptionsCheckboxState();
}

class ShowOptionsCheckboxState extends State<ShowOptionsCheckbox> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: _showAll,
          onChanged: (value) {
            setState(() {
              _showAll = value!;
              if (widget.onChanged != null) {
                widget.onChanged!(_showAll);
              }
            });
          },
        ),
        const Text('Mostrar todo'),
        const SizedBox(width: 20),
        Checkbox(
          value: !_showAll,
          onChanged: (value) {
            setState(() {
              _showAll = !value!;
              if (widget.onChanged != null) {
                widget.onChanged!(_showAll);
              }
            });
          },
        ),
        const Text('Mostrar 5'),
      ],
    );
  }
}
