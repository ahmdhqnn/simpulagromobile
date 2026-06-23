import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor.freezed.dart';

@freezed
class Sensor with _$Sensor {
  const Sensor._();

  const factory Sensor({
    required String sensId,
    String? devId,
    String? sensName,
    String? sensAddress,
    String? sensLocation,
    double? sensLat,
    double? sensLon,
    double? sensAlt,
    int? sensSts,
    DateTime? sensCreated,
    DateTime? sensUpdate,
  }) = _Sensor;

  /// Backend can omit sens_sts on list/detail responses.
  /// Treat only an explicit 0 as inactive.
  bool get isActive => sensSts != 0;

  /// Check if sensor has coordinates
  bool get hasCoordinates => sensLat != null && sensLon != null;

  /// Get display name (fallback to ID if name is null)
  String get displayName => sensName ?? sensId;
}
