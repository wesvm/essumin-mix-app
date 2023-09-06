import 'package:flutter/material.dart';

import 'package:essumin_mix/data/models/sigla/sigla.dart';

class SiglaStartPopup extends StatelessWidget {
  final Map<String, List<Sigla>> siglasData;

  const SiglaStartPopup({required this.siglasData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Colors.white),
      ),
      child: Container(
        color: const Color(0XFF0d1117),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Siglas de: ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: siglasData.keys.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/siglas', arguments: {
                        'category': category,
                        'options': siglasData[category],
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 30),
                    ),
                    child: Text(
                        '${category[0].toUpperCase()}${category.substring(1)}'),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
