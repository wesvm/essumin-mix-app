import 'package:flutter/material.dart';

class ShowOptionsRadio<T> extends StatefulWidget {
  final T initialValue;
  final T option1Value;
  final String option1Label;
  final T option2Value;
  final String option2Label;
  final ValueChanged<T>? onChanged;

  const ShowOptionsRadio(
      {Key? key,
      required this.initialValue,
      required this.option1Value,
      required this.option1Label,
      required this.option2Value,
      required this.option2Label,
      this.onChanged})
      : assert(initialValue == option1Value || initialValue == option2Value,
            "El valor inicial debe ser igual a uno de los option values"),
        super(key: key);

  @override
  ShowOptionsRadioState createState() => ShowOptionsRadioState<T>();
}

class ShowOptionsRadioState<T> extends State<ShowOptionsRadio<T>> {
  late T _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<T>(
          value: widget.option1Value,
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value ?? widget.option1Value!;
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedOption);
              }
            });
          },
        ),
        Text(widget.option1Label),
        const SizedBox(width: 20),
        Radio<T>(
          value: widget.option2Value,
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value ?? widget.option2Value!;
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedOption);
              }
            });
          },
        ),
        Text(widget.option2Label),
      ],
    );
  }
}
