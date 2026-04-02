import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';

@freezed
class Device with _$Device {
  const Device._();

  const factory Device({
    required String devId,
    String? siteId,
    String? userId,
    String? devName,
    String? devToken,
    String? devLocation,
    double? devLon,
    double? devLat,
    double? devAlt,
    String? devNumberId,
    String? devIp,
    String? devPort,
    String? devImg,
    int? devSts,
    DateTime? devCreated,
    DateTime? devUpdate,
  }) = _Device;

  /// Check if device is active
  bool get isActive => devSts == 1;

  /// Check if device has coordinates
  bool get hasCoordinates => devLon != null && devLat != null;

  /// Get display name (fallback to ID if name is null)
  String get displayName => devName ?? devId;

  /// Get status text
  String get statusText => isActive ? 'Aktif' : 'Nonaktif';

  /// Get location display
  String get locationDisplay => devLocation ?? 'Lokasi tidak tersedia';
}
