import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:essumin_mix/data/models/sigla/sigla.dart';

class AcronymLoader {
  Future<Map<String, List<Sigla>>> loadAcronymData() async {
    final dataJson =
        await rootBundle.loadString('assets/data/adicionales/acronyms.json');
    final data = json.decode(dataJson);

    final Map<String, List<Sigla>> acronymMap = {};

    data.forEach((key, value) {
      final acronymList =
          List<Sigla>.from(value.map((item) => Sigla.fromJson(item)));
      acronymMap[key] = acronymList;
    });

    return acronymMap;
  }
}
