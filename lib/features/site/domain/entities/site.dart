import 'package:freezed_annotation/freezed_annotation.dart';

part 'site.freezed.dart';

@freezed
class Site with _$Site {
  const Site._();

  const factory Site({
    required String siteId,
    String? siteName,
    String? siteAddress,
    double? siteLon,
    double? siteLat,
    double? siteAlt,
    int? siteSts,
    DateTime? siteCreated,
    DateTime? siteUpdate,
  }) = _Site;

  /// Check if site is active
  bool get isActive => siteSts == 1;

  /// Check if site has coordinates
  bool get hasCoordinates => siteLon != null && siteLat != null;

  /// Get display name (fallback to ID if name is null)
  String get displayName => siteName ?? siteId;
}
