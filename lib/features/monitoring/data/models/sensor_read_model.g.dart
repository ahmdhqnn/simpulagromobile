// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_read_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SensorReadModelImpl _$$SensorReadModelImplFromJson(
  Map<String, dynamic> json,
) => _$SensorReadModelImpl(
  readId: json['read_id'] as String,
  dsId: json['ds_id'] as String?,
  devId: json['dev_id'] as String?,
  logRxId: json['log_rx_id'] as String?,
  readDate: json['read_date'] == null
      ? null
      : DateTime.parse(json['read_date'] as String),
  readValue: json['read_value'] as String?,
  readSts: (json['read_sts'] as num?)?.toInt(),
);

Map<String, dynamic> _$$SensorReadModelImplToJson(
  _$SensorReadModelImpl instance,
) => <String, dynamic>{
  'read_id': instance.readId,
  'ds_id': instance.dsId,
  'dev_id': instance.devId,
  'log_rx_id': instance.logRxId,
  'read_date': instance.readDate?.toIso8601String(),
  'read_value': instance.readValue,
  'read_sts': instance.readSts,
};

_$SensorReadUpdateModelImpl _$$SensorReadUpdateModelImplFromJson(
  Map<String, dynamic> json,
) => _$SensorReadUpdateModelImpl(
  readUpdateId: json['read_update_id'] as String,
  dsId: json['ds_id'] as String,
  devId: json['dev_id'] as String,
  readUpdateDate: json['read_update_date'] == null
      ? null
      : DateTime.parse(json['read_update_date'] as String),
  readUpdateValue: json['read_update_value'] as String?,
);

Map<String, dynamic> _$$SensorReadUpdateModelImplToJson(
  _$SensorReadUpdateModelImpl instance,
) => <String, dynamic>{
  'read_update_id': instance.readUpdateId,
  'ds_id': instance.dsId,
  'dev_id': instance.devId,
  'read_update_date': instance.readUpdateDate?.toIso8601String(),
  'read_update_value': instance.readUpdateValue,
};

_$SensorDailyModelImpl _$$SensorDailyModelImplFromJson(
  Map<String, dynamic> json,
) => _$SensorDailyModelImpl(
  day: DateTime.parse(json['day'] as String),
  devId: json['dev_id'] as String,
  dsId: json['ds_id'] as String,
  avgVal: (json['avg_val'] as num?)?.toDouble(),
  minVal: (json['min_val'] as num?)?.toDouble(),
  maxVal: (json['max_val'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$SensorDailyModelImplToJson(
  _$SensorDailyModelImpl instance,
) => <String, dynamic>{
  'day': instance.day.toIso8601String(),
  'dev_id': instance.devId,
  'ds_id': instance.dsId,
  'avg_val': instance.avgVal,
  'min_val': instance.minVal,
  'max_val': instance.maxVal,
};
