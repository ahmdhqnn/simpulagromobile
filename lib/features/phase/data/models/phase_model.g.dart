// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhaseModelImpl _$$PhaseModelImplFromJson(Map<String, dynamic> json) =>
    _$PhaseModelImpl(
      id: json['id'] as String,
      plantId: json['plant_id'] as String,
      plantName: json['plant_name'] as String,
      phaseName: json['phase_name'] as String,
      description: json['description'] as String,
      startHst: (json['start_hst'] as num).toInt(),
      endHst: (json['end_hst'] as num).toInt(),
      currentHst: (json['current_hst'] as num).toInt(),
      requiredGdd: (json['required_gdd'] as num).toDouble(),
      currentGdd: (json['current_gdd'] as num).toDouble(),
      progress: (json['progress'] as num).toDouble(),
      status: json['status'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PhaseModelImplToJson(_$PhaseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plant_id': instance.plantId,
      'plant_name': instance.plantName,
      'phase_name': instance.phaseName,
      'description': instance.description,
      'start_hst': instance.startHst,
      'end_hst': instance.endHst,
      'current_hst': instance.currentHst,
      'required_gdd': instance.requiredGdd,
      'current_gdd': instance.currentGdd,
      'progress': instance.progress,
      'status': instance.status,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
