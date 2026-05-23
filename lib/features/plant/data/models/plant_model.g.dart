// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VarietasModelImpl _$$VarietasModelImplFromJson(Map<String, dynamic> json) =>
    _$VarietasModelImpl(
      varietasId: json['varietas_id'] as String,
      varietasName: json['varietas_name'] as String?,
      varietasDesc: json['varietas_desc'] as String?,
      varietasSts: (json['varietas_sts'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$VarietasModelImplToJson(_$VarietasModelImpl instance) =>
    <String, dynamic>{
      'varietas_id': instance.varietasId,
      'varietas_name': instance.varietasName,
      'varietas_desc': instance.varietasDesc,
      'varietas_sts': instance.varietasSts,
    };
