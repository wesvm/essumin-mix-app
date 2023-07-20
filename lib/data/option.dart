class Option {
  final String key;
  final String value;

  Option(this.key, this.value);

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(json['key'], json['value']);
  }
}
