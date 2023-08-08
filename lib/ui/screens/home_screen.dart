import 'package:essumin_mix/data/models/sigla/acronym_loader.dart';
import 'package:flutter/material.dart';

import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:essumin_mix/data/models/sigla/sigla_loader.dart';
import 'package:essumin_mix/data/models/simbologia/simbologia.dart';
import 'package:essumin_mix/data/models/simbologia/simbologia_loader.dart';
import 'package:essumin_mix/ui/widgets/simbologia/start_popup.dart';
import 'package:essumin_mix/ui/widgets/sigla/start_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, List<Sigla>>> _siglasData;
  late Future<Map<String, List<Sigla>>> _acronymsData;
  late Future<Map<String, List<Simbologia>>> _simbologiasData;

  @override
  void initState() {
    super.initState();
    _siglasData = SiglaLoader().loadSiglaData();
    _acronymsData = AcronymLoader().loadAcronymData();
    _simbologiasData = SimbologiaLoader().loadSimbologiaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _acronymsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else {
                  final Map<String, List<Sigla>> data = snapshot.data!;

                  return ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(150, 35),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/acronyms', arguments: {
                        'data': data['mecanica'],
                      });
                    },
                    child: const Text('Acronyms'),
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: _siglasData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else {
                  final Map<String, List<Sigla>> data = snapshot.data!;

                  return ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(150, 35),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => SiglaStartPopup(
                          siglasData: data,
                        ),
                      );
                    },
                    child: const Text('Siglas'),
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: _simbologiasData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else {
                  final Map<String, List<Simbologia>> data = snapshot.data!;

                  return ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(150, 35),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            SimbologiaStartPopup(simbologiasData: data),
                      );
                    },
                    child: const Text('Simbologias'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
