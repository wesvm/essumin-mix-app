import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:essumin_mix/data/models/sigla/sigla.dart';

class SiglaLoader {
  Future<Map<String, List<Sigla>>> loadSiglaData() async {
    final dataJson =
        await rootBundle.loadString('assets/data/siglas/siglas.json');
    final data = json.decode(dataJson);

    final Map<String, List<Sigla>> siglaMap = {};

    data.forEach((key, value) {
      final siglaList =
          List<Sigla>.from(value.map((item) => Sigla.fromJson(item)));
      siglaMap[key] = siglaList;
    });

    return siglaMap;
  }
}
