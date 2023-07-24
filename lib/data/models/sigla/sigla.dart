class Sigla {
  final String key;
  final String value;
  final List<String>? synonyms;

  Sigla(this.key, this.value, {this.synonyms});

  factory Sigla.fromJson(Map<String, dynamic> json) {
    return Sigla(
      json['key'],
      json['value'],
      synonyms:
          json['synonyms'] != null ? List<String>.from(json['synonyms']) : null,
    );
  }
}
