import 'package:essumin_mix/data/models/simbologia/simbologia.dart';
import 'package:flutter/material.dart';

class SimbologiaStartPopup extends StatelessWidget {
  final Map<String, List<Simbologia>> simbologiasData;

  const SimbologiaStartPopup({Key? key, required this.simbologiasData})
      : super(key: key);

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
              'Simbologias de:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: simbologiasData.keys.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(150, 35),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/simbologias', arguments: {
                        'category': category,
                        'data': simbologiasData[category],
                      });
                    },
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
