import 'package:flutter/material.dart';
import 'package:essumin_mix/data/option.dart';
import 'package:essumin_mix/ui/widgets/return_home_popup.dart';

class SiglasScreen extends StatefulWidget {
  final String category;
  final List<Option> options;

  const SiglasScreen({Key? key, required this.category, required this.options})
      : super(key: key);

  @override
  SiglasScreenState createState() => SiglasScreenState();
}

class SiglasScreenState extends State<SiglasScreen> {
  int currentIndex = 0;
  List<Option> displayedOptions = [];
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.category[0].toUpperCase() + widget.category.substring(1);
    displayedOptions = widget.options.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
          context: context,
          builder: (_) => const ReturnHomePopup(),
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Siglas')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Categoría seleccionada: $selectedCategory'),
              const SizedBox(height: 16.0),
              Text(
                  'Sigla ${currentIndex + 1}: ${displayedOptions[currentIndex].key}'),
              const SizedBox(height: 16.0),
              Text('Valor: ${displayedOptions[currentIndex].value}'),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentIndex > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentIndex--;
                        });
                      },
                      child: const Text('Anterior'),
                    ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (currentIndex < displayedOptions.length - 1) {
                        setState(() {
                          currentIndex++;
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => const ReturnHomePopup(),
                        );
                      }
                    },
                    child: Text(currentIndex < displayedOptions.length - 1
                        ? 'Siguiente'
                        : 'Regresar al Home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
