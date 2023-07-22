class Option {
  final String key;
  final String value;
  final List<String>? synonyms;

  Option(this.key, this.value, {this.synonyms});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      json['key'],
      json['value'],
      synonyms:
          json['synonyms'] != null ? List<String>.from(json['synonyms']) : null,
    );
  }
}
