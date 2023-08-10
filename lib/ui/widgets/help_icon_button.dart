import 'package:flutter/material.dart';

class HelpIconButton extends StatelessWidget {
  final Widget toScreen;

  const HelpIconButton({required this.toScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFF1e40af),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => toScreen));
          },
          icon: const Icon(
            Icons.question_mark,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
