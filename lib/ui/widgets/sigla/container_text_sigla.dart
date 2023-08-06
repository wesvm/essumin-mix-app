import 'package:flutter/material.dart';

class ContainerTextWidget extends StatelessWidget {
  final String text;

  const ContainerTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(113, 128, 150, 0.25),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
