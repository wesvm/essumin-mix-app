import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:essumin_mix/data/models/simbologia/simbologia.dart';
import 'package:flutter/material.dart';

class AdicionalesStartPopup extends StatelessWidget {
  final List<Sigla> acronymsData;
  final List<Simbologia> riggerData;

  const AdicionalesStartPopup({
    required this.acronymsData,
    required this.riggerData,
    Key? key,
  }) : super(key: key);

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
              'Adicionales: ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(150, 35),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/acronyms', arguments: {
                      'data': acronymsData,
                    });
                  },
                  child: const Text('Acronyms'),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(150, 35),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/rigger', arguments: {
                      'data': riggerData,
                    });
                  },
                  child: const Text('Rigger'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
