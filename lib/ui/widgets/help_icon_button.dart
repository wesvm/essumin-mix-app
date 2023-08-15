import 'package:flutter/material.dart';

class HelpIconButton extends StatelessWidget {
  final Widget toScreen;

  const HelpIconButton({required this.toScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => toScreen));
      },
      iconSize: 50,
      icon: const CircleAvatar(
        backgroundColor: Color(0xFF1e40af),
        radius: 30,
        child: Icon(
          Icons.question_mark,
          color: Colors.white,
        ),
      ),
    );
  }
}
