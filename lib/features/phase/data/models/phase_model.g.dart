// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhaseModelImpl _$$PhaseModelImplFromJson(Map<String, dynamic> json) =>
    _$PhaseModelImpl(
      id: json['phase_id'] as String,
      cropType: json['chrop_type'] as String,
      phaseName: json['phase_name'] as String,
      phaseOrder: (json['phase_order'] as num).toInt(),
      hstMin: (json['phase_hst_min'] as num).toInt(),
      hstMax: (json['phase_hst_max'] as num).toInt(),
    );

Map<String, dynamic> _$$PhaseModelImplToJson(_$PhaseModelImpl instance) =>
    <String, dynamic>{
      'phase_id': instance.id,
      'chrop_type': instance.cropType,
      'phase_name': instance.phaseName,
      'phase_order': instance.phaseOrder,
      'phase_hst_min': instance.hstMin,
      'phase_hst_max': instance.hstMax,
    };
