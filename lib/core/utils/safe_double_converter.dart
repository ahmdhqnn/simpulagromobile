import 'package:freezed_annotation/freezed_annotation.dart';

class SafeDoubleConverter implements JsonConverter<double?, dynamic> {
  const SafeDoubleConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(double? object) => object;
}
