import 'package:flutter/material.dart';

class ResultDialog extends StatefulWidget {
  final String title;
  final String message;
  final bool isCorrect;
  final VoidCallback onClose;

  const ResultDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.isCorrect,
    required this.onClose,
  }) : super(key: key);

  @override
  ResultDialogState createState() => ResultDialogState();
}

class ResultDialogState extends State<ResultDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFF0d1117),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.isCorrect ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16,
                color: widget.isCorrect ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                widget.onClose();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF1e40af)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
