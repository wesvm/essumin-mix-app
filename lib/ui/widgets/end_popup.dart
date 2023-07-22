import 'package:flutter/material.dart';

class EndPopup extends StatelessWidget {
  const EndPopup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Posible nota'),
      content: const Text('00 // JAA'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
