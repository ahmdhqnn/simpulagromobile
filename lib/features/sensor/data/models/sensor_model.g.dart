// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SensorModelImpl _$$SensorModelImplFromJson(Map<String, dynamic> json) =>
    _$SensorModelImpl(
      id: json['_id'] as String,
      deviceId: json['device_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      unit: json['unit'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SensorModelImplToJson(_$SensorModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'device_id': instance.deviceId,
      'name': instance.name,
      'type': instance.type,
      'unit': instance.unit,
      'description': instance.description,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
