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

  factory SiteModel.fromJson(Map<String, dynamic> json) =>
      _$SiteModelFromJson(json);

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
