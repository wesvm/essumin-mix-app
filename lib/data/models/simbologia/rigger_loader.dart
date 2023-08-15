import 'dart:convert';
import 'package:essumin_mix/data/models/simbologia/simbologia.dart';
import 'package:flutter/services.dart';

class RiggerLoader {
  Future<Map<String, List<Simbologia>>> loadRiggerData() async {
    final dataJson =
        await rootBundle.loadString('assets/data/adicionales/rigger.json');
    final data = json.decode(dataJson);

    final Map<String, List<Simbologia>> rSimbologiaMap = {};

    data.forEach((key, value) {
      final rSimbologiaList =
          List<Simbologia>.from(value.map((item) => Simbologia.fromJson(item)));

      rSimbologiaMap[key] = rSimbologiaList;
    });

    return rSimbologiaMap;
  }
}
