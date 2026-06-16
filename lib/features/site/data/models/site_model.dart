// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/site.dart';

part 'site_model.freezed.dart';
part 'site_model.g.dart';

@freezed
class SiteModel with _$SiteModel {
  const SiteModel._();

  const factory SiteModel({
    @JsonKey(name: 'site_id') required String siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'site_address') String? siteAddress,
    @JsonKey(name: 'site_lon') double? siteLon,
    @JsonKey(name: 'site_lat') double? siteLat,
    @JsonKey(name: 'site_alt') double? siteAlt,
    @JsonKey(name: 'site_sts') int? siteSts,
    @JsonKey(name: 'site_created') DateTime? siteCreated,
    @JsonKey(name: 'site_update') DateTime? siteUpdate,
  }) = _SiteModel;

  factory SiteModel.fromJson(Map<String, dynamic> json) => SiteModel(
    siteId: _stringValue(json['site_id'] ?? json['siteId'] ?? json['id']),
    siteName: _nullableString(
      json['site_name'] ?? json['siteName'] ?? json['name'],
    ),
    siteAddress: _nullableString(
      json['site_address'] ?? json['siteAddress'] ?? json['address'],
    ),
    siteLon: _toDouble(json['site_lon'] ?? json['siteLon'] ?? json['lon']),
    siteLat: _toDouble(json['site_lat'] ?? json['siteLat'] ?? json['lat']),
    siteAlt: _toDouble(json['site_alt'] ?? json['siteAlt'] ?? json['alt']),
    siteSts: _toInt(json['site_sts'] ?? json['siteSts'] ?? json['status']),
    siteCreated: _toDateTime(json['site_created'] ?? json['siteCreated']),
    siteUpdate: _toDateTime(json['site_update'] ?? json['siteUpdate']),
  );

  /// Convert Model to Entity
  Site toEntity() => Site(
    siteId: siteId,
    siteName: siteName,
    siteAddress: siteAddress,
    siteLon: siteLon,
    siteLat: siteLat,
    siteAlt: siteAlt,
    siteSts: siteSts,
    siteCreated: siteCreated,
    siteUpdate: siteUpdate,
  );

  /// Convert Entity to Model
  factory SiteModel.fromEntity(Site entity) => SiteModel(
    siteId: entity.siteId,
    siteName: entity.siteName,
    siteAddress: entity.siteAddress,
    siteLon: entity.siteLon,
    siteLat: entity.siteLat,
    siteAlt: entity.siteAlt,
    siteSts: entity.siteSts,
    siteCreated: entity.siteCreated,
    siteUpdate: entity.siteUpdate,
  );
}

String _stringValue(dynamic value) => value?.toString().trim() ?? '';

String? _nullableString(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString().trim());
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value ? 1 : 0;
  if (value is num) return value.toInt();
  final text = value.toString().trim().toLowerCase();
  if (text == 'active' || text == 'aktif' || text == 'true') return 1;
  if (text == 'inactive' || text == 'nonaktif' || text == 'false') return 0;
  return int.tryParse(text);
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString().trim());
}
