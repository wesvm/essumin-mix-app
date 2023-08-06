import 'package:flutter/material.dart';

class ReturnPreviousScreenPopup extends StatelessWidget {
  const ReturnPreviousScreenPopup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Regresar a la pantalla anterior?'),
      content: const Text(
          '¿Estás seguro de que deseas regresar a la pantalla anterior? Se perderá el progreso actual.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Regresar'),
        ),
      ],
    );
  }
}
