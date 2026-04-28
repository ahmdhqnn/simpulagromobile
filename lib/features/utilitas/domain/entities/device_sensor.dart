import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_sensor.freezed.dart';

@freezed
class DeviceSensor with _$DeviceSensor {
  const DeviceSensor._();

  const factory DeviceSensor({
    required String dsId,
    required String devId,
    String? unitId,
    String? sensId,
    double? dcNormalValue,
    double? dsMinNormValue,
    double? dsMaxNormValue,
    double? dsMinValue,
    double? dsMaxValue,
    double? dsMinValWarn,
    double? dsMaxValWarn,
    String? dsName,
    String? dsAddress,
    int? dsSeq,
    int? dsSts,
    DateTime? dsCreated,
    DateTime? dsUpdate,
  }) = _DeviceSensor;

  /// Check if device sensor is active
  bool get isActive => dsSts == 1;

  /// Get display name (fallback to ID if name is null)
  String get displayName => dsName ?? dsId;

  /// Check if value is in normal range
  bool isValueNormal(double value) {
    if (dsMinNormValue != null && value < dsMinNormValue!) return false;
    if (dsMaxNormValue != null && value > dsMaxNormValue!) return false;
    return true;
  }

  /// Check if value is in warning range
  bool isValueWarning(double value) {
    if (dsMinValWarn != null && value < dsMinValWarn!) return true;
    if (dsMaxValWarn != null && value > dsMaxValWarn!) return true;
    return false;
  }
}
