import 'package:flutter/material.dart';

final ElevatedButtonThemeData customElevatedButtonTheme =
    ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color.fromRGBO(30, 58, 138, 0.25);
        }
        return const Color(0xFF1e40af);
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color(0xFFe4e4e7);
        }
        return Colors.white;
      },
    ),
  ),
);
