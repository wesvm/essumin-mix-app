class Simbologia {
  final String imgUrl;
  final String? gifUrl;
  final String esValue;
  final List<String>? esSynonyms;
  final String enValue;
  final List<String>? enSynonyms;

  Simbologia({
    required this.imgUrl,
    this.gifUrl,
    required this.esValue,
    this.esSynonyms,
    required this.enValue,
    this.enSynonyms,
  });

  factory Simbologia.fromJson(Map<String, dynamic> json) {
    return Simbologia(
      imgUrl: json['imgUrl'],
      gifUrl: json['gifUrl'],
      esValue: json['es_value'],
      enValue: json['en_value'],
      esSynonyms: json['es_synonyms'] != null
          ? List<String>.from(json['es_synonyms'])
          : null,
      enSynonyms: json['en_synonyms'] != null
          ? List<String>.from(json['en_synonyms'])
          : null,
    );
  }
}
