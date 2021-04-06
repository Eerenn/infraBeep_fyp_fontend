import 'dart:convert';

class Payload {
  final String name;
  final String hexVal;
  final int decodeType;
  final int frequency;
  final String rawlen;

  Payload({
    this.name,
    this.hexVal,
    this.decodeType,
    this.frequency,
    this.rawlen,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      decodeType: int.parse(json['decodeType']),
      name: json['name'],
      hexVal: json['hexVal'],
      frequency: int.parse(json['frequency']),
      rawlen: json['rawlen'],
    );
  }

  factory Payload.fromJsonString(Map<String, dynamic> json) {
    return Payload(
      decodeType: json['decodeType'],
      name: json['name'],
      hexVal: json['hexVal'],
      frequency: json['frequency'],
      rawlen: json['rawlen'],
    );
  }

  List<Payload> parsePayload(String payloads) {
    final parsed = jsonDecode(payloads).cast<Map<String, dynamic>>();

    return parsed.map<Payload>((json) => Payload.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        'decodeType': decodeType,
        'name': name,
        'hexVal': hexVal,
        'frequency': frequency,
        'rawlen': rawlen,
      };
}
