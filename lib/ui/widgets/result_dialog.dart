import 'package:flutter/material.dart';

class ResultDialog extends StatefulWidget {
  final String title;
  final String message;
  final String textButton;
  final bool isCorrect;
  final VoidCallback onClose;

  const ResultDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.textButton,
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
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.isCorrect ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: widget.isCorrect ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      widget.onClose();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color?>(
                        widget.isCorrect ? Colors.green[800] : Colors.red[900],
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text(widget.textButton),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
