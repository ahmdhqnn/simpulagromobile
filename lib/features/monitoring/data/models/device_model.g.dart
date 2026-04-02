// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceModelImpl _$$DeviceModelImplFromJson(Map<String, dynamic> json) =>
    _$DeviceModelImpl(
      devId: json['dev_id'] as String,
      siteId: json['site_id'] as String?,
      userId: json['user_id'] as String?,
      devName: json['dev_name'] as String?,
      devToken: json['dev_token'] as String?,
      devLocation: json['dev_location'] as String?,
      devLon: (json['dev_lon'] as num?)?.toDouble(),
      devLat: (json['dev_lat'] as num?)?.toDouble(),
      devAlt: (json['dev_alt'] as num?)?.toDouble(),
      devNumberId: json['dev_number_id'] as String?,
      devIp: json['dev_ip'] as String?,
      devPort: json['dev_port'] as String?,
      devImg: json['dev_img'] as String?,
      devSts: (json['dev_sts'] as num?)?.toInt(),
      sensors: (json['sensor'] as List<dynamic>?)
          ?.map((e) => SensorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DeviceModelImplToJson(_$DeviceModelImpl instance) =>
    <String, dynamic>{
      'dev_id': instance.devId,
      'site_id': instance.siteId,
      'user_id': instance.userId,
      'dev_name': instance.devName,
      'dev_token': instance.devToken,
      'dev_location': instance.devLocation,
      'dev_lon': instance.devLon,
      'dev_lat': instance.devLat,
      'dev_alt': instance.devAlt,
      'dev_number_id': instance.devNumberId,
      'dev_ip': instance.devIp,
      'dev_port': instance.devPort,
      'dev_img': instance.devImg,
      'dev_sts': instance.devSts,
      'sensor': instance.sensors,
    };
