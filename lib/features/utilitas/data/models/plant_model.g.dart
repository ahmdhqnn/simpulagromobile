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
      plantType: $enumDecodeNullable(_$CropTypeEnumMap, json['plant_type']),
      plantSpecies: json['plant_species'] as String?,
      plantDate: json['plant_date'] == null
          ? null
          : DateTime.parse(json['plant_date'] as String),
      plantHarvest: json['plant_harvest'] == null
          ? null
          : DateTime.parse(json['plant_harvest'] as String),
      plantSts: (json['plant_sts'] as num?)?.toInt(),
      plantCreated: json['plant_created'] == null
          ? null
          : DateTime.parse(json['plant_created'] as String),
      plantUpdate: json['plant_update'] == null
          ? null
          : DateTime.parse(json['plant_update'] as String),
    );

Map<String, dynamic> _$$PlantModelImplToJson(_$PlantModelImpl instance) =>
    <String, dynamic>{
      'plant_id': instance.plantId,
      'site_id': instance.siteId,
      'varietas_id': instance.varietasId,
      'plant_name': instance.plantName,
      'plant_type': _$CropTypeEnumMap[instance.plantType],
      'plant_species': instance.plantSpecies,
      'plant_date': instance.plantDate?.toIso8601String(),
      'plant_harvest': instance.plantHarvest?.toIso8601String(),
      'plant_sts': instance.plantSts,
      'plant_created': instance.plantCreated?.toIso8601String(),
      'plant_update': instance.plantUpdate?.toIso8601String(),
    };

const _$CropTypeEnumMap = {
  CropType.padi: 'PADI',
  CropType.jagung: 'JAGUNG',
  CropType.kedelai: 'KEDELAI',
};
