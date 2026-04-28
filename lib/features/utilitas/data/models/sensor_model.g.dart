// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SensorModelImpl _$$SensorModelImplFromJson(Map<String, dynamic> json) =>
    _$SensorModelImpl(
      sensId: json['sens_id'] as String,
      devId: json['dev_id'] as String?,
      sensName: json['sens_name'] as String?,
      sensAddress: json['sens_address'] as String?,
      sensLocation: json['sens_location'] as String?,
      sensLat: (json['sens_lat'] as num?)?.toDouble(),
      sensLon: (json['sens_lon'] as num?)?.toDouble(),
      sensAlt: (json['sens_alt'] as num?)?.toDouble(),
      sensSts: (json['sens_sts'] as num?)?.toInt(),
      sensCreated: json['sens_created'] == null
          ? null
          : DateTime.parse(json['sens_created'] as String),
      sensUpdate: json['sens_update'] == null
          ? null
          : DateTime.parse(json['sens_update'] as String),
    );

Map<String, dynamic> _$$SensorModelImplToJson(_$SensorModelImpl instance) =>
    <String, dynamic>{
      'sens_id': instance.sensId,
      'dev_id': instance.devId,
      'sens_name': instance.sensName,
      'sens_address': instance.sensAddress,
      'sens_location': instance.sensLocation,
      'sens_lat': instance.sensLat,
      'sens_lon': instance.sensLon,
      'sens_alt': instance.sensAlt,
      'sens_sts': instance.sensSts,
      'sens_created': instance.sensCreated?.toIso8601String(),
      'sens_update': instance.sensUpdate?.toIso8601String(),
    };
