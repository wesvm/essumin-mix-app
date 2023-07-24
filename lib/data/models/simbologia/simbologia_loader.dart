import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:essumin_mix/data/models/simbologia/simbologia.dart';

class SimbologiaLoader {
  Future<Map<String, List<Simbologia>>> loadSimbologiaData() async {
    final dataJson =
        await rootBundle.loadString('assets/data/simbologias/maquinas.json');
    final data = json.decode(dataJson);

    final Map<String, List<Simbologia>> simbologiaMap = {};

    data.forEach((key, value) {
      final simbologiaList =
          List<Simbologia>.from(value.map((item) => Simbologia.fromJson(item)));

      simbologiaMap[key] = simbologiaList;
    });

    return simbologiaMap;
  }
}
