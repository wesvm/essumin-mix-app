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
      message = 'Perfecto.';
    } else if (widget.score >= widget.totalItems / 2) {
      message = 'Masomenos.';
    } else {
      message = 'Muy mal.';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Acertadas: ${widget.score}/${widget.totalItems}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(150, 35),
                ),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
