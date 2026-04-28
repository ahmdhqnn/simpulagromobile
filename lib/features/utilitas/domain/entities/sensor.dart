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

  /// Check if sensor is active
  bool get isActive => sensSts == 1;

  /// Check if sensor has coordinates
  bool get hasCoordinates => sensLat != null && sensLon != null;

  /// Get display name (fallback to ID if name is null)
  String get displayName => sensName ?? sensId;
}
