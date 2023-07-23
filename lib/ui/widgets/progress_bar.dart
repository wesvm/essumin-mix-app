import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int totalItems;
  final int currentIndex;

  const ProgressBar(
      {Key? key, required this.totalItems, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage = currentIndex / totalItems;

    return Container(
      height: 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: const Color.fromRGBO(113, 128, 150, 0.25),
      ),
      child: Row(
        children: [
          Container(
            height: 8.0,
            width: MediaQuery.of(context).size.width * percentage,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              gradient: const LinearGradient(
                colors: [Color(0xFF62A7E8), Color(0xFF37C2D0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
