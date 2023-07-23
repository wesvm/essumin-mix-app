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
  EndScreenState createState() => EndScreenState();
}

class EndScreenState extends State<EndScreen> {
  int finalScore = 0;

  @override
  Widget build(BuildContext context) {
    String message;
    if (widget.score == widget.totalItems) {
      message = 'Tan bueno?';
    } else if (widget.score >= widget.totalItems / 2) {
      message = 'Masomenos';
    } else {
      message = 'Asuu eres un asno JA!';
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
