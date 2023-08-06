import 'package:flutter/material.dart';

class EndScreen extends StatefulWidget {
  final int totalItems;
  final int score;

  const EndScreen({
    Key? key,
    required this.score,
    required this.totalItems,
  }) : super(key: key);

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  @override
  Widget build(BuildContext context) {
    String message;
    if (widget.score == widget.totalItems) {
      message = 'Perfecto';
    } else if (widget.score >= widget.totalItems / 2) {
      message = 'Masomenos';
    } else {
      message = 'Muy mal';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Acertadas: ${widget.score}/${widget.totalItems}'),
            const SizedBox(height: 16.0),
            Text(message),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
