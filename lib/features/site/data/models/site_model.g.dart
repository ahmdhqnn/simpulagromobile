// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SiteModelImpl _$$SiteModelImplFromJson(Map<String, dynamic> json) =>
    _$SiteModelImpl(
      siteId: json['site_id'] as String,
      siteName: json['site_name'] as String?,
      siteAddress: json['site_address'] as String?,
      siteLon: (json['site_lon'] as num?)?.toDouble(),
      siteLat: (json['site_lat'] as num?)?.toDouble(),
      siteAlt: (json['site_alt'] as num?)?.toDouble(),
      siteSts: (json['site_sts'] as num?)?.toInt(),
      siteCreated: json['site_created'] == null
          ? null
          : DateTime.parse(json['site_created'] as String),
      siteUpdate: json['site_update'] == null
          ? null
          : DateTime.parse(json['site_update'] as String),
    );

Map<String, dynamic> _$$SiteModelImplToJson(_$SiteModelImpl instance) =>
    <String, dynamic>{
      'site_id': instance.siteId,
      'site_name': instance.siteName,
      'site_address': instance.siteAddress,
      'site_lon': instance.siteLon,
      'site_lat': instance.siteLat,
      'site_alt': instance.siteAlt,
      'site_sts': instance.siteSts,
      'site_created': instance.siteCreated?.toIso8601String(),
      'site_update': instance.siteUpdate?.toIso8601String(),
    };
