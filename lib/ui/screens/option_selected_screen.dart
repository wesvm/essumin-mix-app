import 'package:essumin_mix/ui/screens/siglas_screen.dart';
import 'package:flutter/material.dart';
import 'package:essumin_mix/data/option.dart';

class OptionSelectedScreen extends StatelessWidget {
  final String category;
  final List<Option> options;

  const OptionSelectedScreen(
      {Key? key, required this.category, required this.options})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Longitud de Opciones')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Categoría seleccionada: ${category[0].toUpperCase()}${category.substring(1)}'),
            const SizedBox(height: 16.0),
            Text('Longitud de opciones: ${options.length}'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SiglasScreen(category: category, options: options),
                  ),
                );
              },
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
    );
  }
}
