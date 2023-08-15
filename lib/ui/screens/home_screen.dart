import 'package:essumin_mix/data/models/sigla/acronym_loader.dart';
import 'package:essumin_mix/data/models/simbologia/rigger_loader.dart';
import 'package:essumin_mix/ui/widgets/adicionales/start_popup.dart';
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
  late Future<Map<String, List<Simbologia>>> _riggerData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _siglasData = SiglaLoader().loadSiglaData();
    _simbologiasData = SimbologiaLoader().loadSimbologiaData();
    _acronymsData = AcronymLoader().loadAcronymData();
    _riggerData = RiggerLoader().loadRiggerData();
  }

  ElevatedButton _buildElevatedButton<T>(
      String buttonText, Map<String, List<T>> data, void Function() onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(
          const Size(150, 35),
        ),
      ),
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }

  FutureBuilder<Map<String, List<T>>> _buildFutureBuilder<T>(
      Future<Map<String, List<T>>> future,
      String errorMessage,
      Widget Function(Map<String, List<T>> data) builder) {
    return FutureBuilder<Map<String, List<T>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(errorMessage));
        } else {
          final Map<String, List<T>> data = snapshot.data!;
          return builder(data);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFutureBuilder(
              _siglasData,
              'Error al cargar los datos de Siglas',
              (data) => _buildElevatedButton(
                'Siglas',
                data,
                () {
                  showDialog(
                    context: context,
                    builder: (_) => SiglaStartPopup(
                      siglasData: data,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            _buildFutureBuilder(
              _simbologiasData,
              'Error al cargar los datos de Simbologias',
              (data) => _buildElevatedButton(
                'Simbologias',
                data,
                () {
                  showDialog(
                    context: context,
                    builder: (_) => SimbologiaStartPopup(
                      simbologiasData: data,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: Future.wait([_acronymsData, _riggerData]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error al cargar los datos adicionales'));
                } else {
                  final Map<String, List<Sigla>> acronymsData =
                      snapshot.data![0];
                  final Map<String, List<Simbologia>> riggerData =
                      snapshot.data![1];

                  return ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(150, 35),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AdicionalesStartPopup(
                          acronymsData: acronymsData['mechanics']!,
                          riggerData: riggerData['rigger']!,
                        ),
                      );
                    },
                    child: const Text('Adicionales'),
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
