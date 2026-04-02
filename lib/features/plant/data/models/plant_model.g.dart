// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantModelImpl _$$PlantModelImplFromJson(Map<String, dynamic> json) =>
    _$PlantModelImpl(
      plantId: json['plant_id'] as String,
      siteId: json['site_id'] as String?,
      varietasId: json['varietas_id'] as String?,
      plantName: json['plant_name'] as String?,
      plantType: json['plant_type'] as String?,
      plantSpecies: json['plant_species'] as String?,
      plantDate: json['plant_date'] == null
          ? null
          : DateTime.parse(json['plant_date'] as String),
      plantHarvest: json['plant_harvest'] == null
          ? null
          : DateTime.parse(json['plant_harvest'] as String),
      plantSts: (json['plant_sts'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PlantModelImplToJson(_$PlantModelImpl instance) =>
    <String, dynamic>{
      'plant_id': instance.plantId,
      'site_id': instance.siteId,
      'varietas_id': instance.varietasId,
      'plant_name': instance.plantName,
      'plant_type': instance.plantType,
      'plant_species': instance.plantSpecies,
      'plant_date': instance.plantDate?.toIso8601String(),
      'plant_harvest': instance.plantHarvest?.toIso8601String(),
      'plant_sts': instance.plantSts,
    };

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
