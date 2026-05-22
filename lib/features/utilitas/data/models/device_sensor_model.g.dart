// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_sensor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceSensorModelImpl _$$DeviceSensorModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeviceSensorModelImpl(
  dsId: json['ds_id'] as String,
  devId: json['dev_id'] as String,
  unitId: json['unit_id'] as String?,
  sensId: json['sens_id'] as String?,
  dcNormalValue: const SafeDoubleConverter().fromJson(json['dc_normal_value']),
  dsMinNormValue: const SafeDoubleConverter().fromJson(
    json['ds_min_norm_value'],
  ),
  dsMaxNormValue: const SafeDoubleConverter().fromJson(
    json['ds_max_norm_value'],
  ),
  dsMinValue: const SafeDoubleConverter().fromJson(json['ds_min_value']),
  dsMaxValue: const SafeDoubleConverter().fromJson(json['ds_max_value']),
  dsMinValWarn: const SafeDoubleConverter().fromJson(json['ds_min_val_warn']),
  dsMaxValWarn: const SafeDoubleConverter().fromJson(json['ds_max_val_warn']),
  dsName: json['ds_name'] as String?,
  dsAddress: json['ds_address'] as String?,
  dsSeq: (json['ds_seq'] as num?)?.toInt(),
  dsSts: (json['ds_sts'] as num?)?.toInt(),
  dsCreated: json['ds_created'] == null
      ? null
      : DateTime.parse(json['ds_created'] as String),
  dsUpdate: json['ds_update'] == null
      ? null
      : DateTime.parse(json['ds_update'] as String),
);

Map<String, dynamic> _$$DeviceSensorModelImplToJson(
  _$DeviceSensorModelImpl instance,
) => <String, dynamic>{
  'ds_id': instance.dsId,
  'dev_id': instance.devId,
  'unit_id': instance.unitId,
  'sens_id': instance.sensId,
  'dc_normal_value': const SafeDoubleConverter().toJson(instance.dcNormalValue),
  'ds_min_norm_value': const SafeDoubleConverter().toJson(
    instance.dsMinNormValue,
  ),
  'ds_max_norm_value': const SafeDoubleConverter().toJson(
    instance.dsMaxNormValue,
  ),
  'ds_min_value': const SafeDoubleConverter().toJson(instance.dsMinValue),
  'ds_max_value': const SafeDoubleConverter().toJson(instance.dsMaxValue),
  'ds_min_val_warn': const SafeDoubleConverter().toJson(instance.dsMinValWarn),
  'ds_max_val_warn': const SafeDoubleConverter().toJson(instance.dsMaxValWarn),
  'ds_name': instance.dsName,
  'ds_address': instance.dsAddress,
  'ds_seq': instance.dsSeq,
  'ds_sts': instance.dsSts,
  'ds_created': instance.dsCreated?.toIso8601String(),
  'ds_update': instance.dsUpdate?.toIso8601String(),
};
