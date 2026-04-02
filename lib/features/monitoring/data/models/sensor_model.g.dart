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
    };

_$DeviceSensorModelImpl _$$DeviceSensorModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeviceSensorModelImpl(
  dsId: json['ds_id'] as String,
  devId: json['dev_id'] as String,
  unitId: json['unit_id'] as String?,
  sensId: json['sens_id'] as String?,
  dcNormalValue: (json['dc_normal_value'] as num?)?.toDouble(),
  dsMinNormValue: (json['ds_min_norm_value'] as num?)?.toDouble(),
  dsMaxNormValue: (json['ds_max_norm_value'] as num?)?.toDouble(),
  dsMinValue: (json['ds_min_value'] as num?)?.toDouble(),
  dsMaxValue: (json['ds_max_value'] as num?)?.toDouble(),
  dsMinValWarn: (json['ds_min_val_warn'] as num?)?.toDouble(),
  dsMaxValWarn: (json['ds_max_val_warn'] as num?)?.toDouble(),
  dsName: json['ds_name'] as String?,
  dsAddress: json['ds_address'] as String?,
  dsSeq: (json['ds_seq'] as num?)?.toInt(),
  dsSts: (json['ds_sts'] as num?)?.toInt(),
);

Map<String, dynamic> _$$DeviceSensorModelImplToJson(
  _$DeviceSensorModelImpl instance,
) => <String, dynamic>{
  'ds_id': instance.dsId,
  'dev_id': instance.devId,
  'unit_id': instance.unitId,
  'sens_id': instance.sensId,
  'dc_normal_value': instance.dcNormalValue,
  'ds_min_norm_value': instance.dsMinNormValue,
  'ds_max_norm_value': instance.dsMaxNormValue,
  'ds_min_value': instance.dsMinValue,
  'ds_max_value': instance.dsMaxValue,
  'ds_min_val_warn': instance.dsMinValWarn,
  'ds_max_val_warn': instance.dsMaxValWarn,
  'ds_name': instance.dsName,
  'ds_address': instance.dsAddress,
  'ds_seq': instance.dsSeq,
  'ds_sts': instance.dsSts,
};
