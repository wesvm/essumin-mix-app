import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:essumin_mix/data/option.dart';

class DataLoader {
  Future<Map<String, List<Option>>> loadDataFromJson() async {
    final dataJson = await rootBundle.loadString('assets/data/data.json');
    final data = json.decode(dataJson);

    Map<String, List<Option>> optionsMap = {};

    data.forEach((key, value) {
      final optionsList =
          List<Option>.from(value.map((option) => Option.fromJson(option)));
      optionsMap[key] = optionsList;
    });

    return optionsMap;
  }
}
