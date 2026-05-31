// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnitModelImpl _$$UnitModelImplFromJson(Map<String, dynamic> json) =>
    _$UnitModelImpl(
      unitId: json['unit_id'] as String,
      unitName: json['unit_name'] as String?,
      unitSymbol: json['unit_symbol'] as String?,
      unitDesc: json['unit_desc'] as String?,
      unitSts: (json['unit_sts'] as num?)?.toInt(),
      unitCreated: json['unit_created'] == null
          ? null
          : DateTime.parse(json['unit_created'] as String),
      unitUpdate: json['unit_update'] == null
          ? null
          : DateTime.parse(json['unit_update'] as String),
    );

Map<String, dynamic> _$$UnitModelImplToJson(_$UnitModelImpl instance) =>
    <String, dynamic>{
      'unit_id': instance.unitId,
      'unit_name': instance.unitName,
      'unit_symbol': instance.unitSymbol,
      'unit_desc': instance.unitDesc,
      'unit_sts': instance.unitSts,
      'unit_created': instance.unitCreated?.toIso8601String(),
      'unit_update': instance.unitUpdate?.toIso8601String(),
    };
