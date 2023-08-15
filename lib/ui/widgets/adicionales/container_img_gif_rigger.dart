import 'package:flutter/material.dart';

class ContianerImageGif extends StatelessWidget {
  final String imgUrl;
  final String? gifUrl;

  const ContianerImageGif({
    required this.imgUrl,
    this.gifUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color.fromRGBO(113, 128, 150, 0.25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              imgUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 20),
        if (gifUrl != null)
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromRGBO(113, 128, 150, 0.25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                gifUrl!,
                fit: BoxFit.contain,
              ),
            ),
          ),
      ],
    );
  }
}
