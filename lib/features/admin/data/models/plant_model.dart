// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../plant/domain/plant_status_extension.dart';
import '../../domain/entities/plant.dart';

part 'plant_model.freezed.dart';

@freezed
class PlantModel with _$PlantModel {
  const PlantModel._();

  const factory PlantModel({
    @JsonKey(name: 'plant_id') required String plantId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'varietas_id') String? varietasId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'plant_type') CropType? plantType,
    @JsonKey(name: 'plant_species') String? plantSpecies,
    @JsonKey(name: 'plant_date') DateTime? plantDate,
    @JsonKey(name: 'plant_harvest') DateTime? plantHarvest,
    @JsonKey(name: 'plant_sts') int? plantSts,
    @JsonKey(name: 'plant_created') DateTime? plantCreated,
    @JsonKey(name: 'plant_update') DateTime? plantUpdate,
  }) = _PlantModel;

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    CropType? parseCropType(dynamic value) {
      if (value is! String) return null;
      final normalized = value.trim().toUpperCase();
      return switch (normalized) {
        'PADI' => CropType.padi,
        'JAGUNG' => CropType.jagung,
        'KEDELAI' => CropType.kedelai,
        _ => null,
      };
    }

    return PlantModel(
      plantId: _stringValue(json['plant_id']),
      siteId: _nullableString(json['site_id']),
      varietasId: _nullableString(json['varietas_id']),
      plantName: _nullableString(json['plant_name']),
      plantType: parseCropType(json['plant_type']),
      plantSpecies: _nullableString(json['plant_species']),
      plantDate: parsePlantDateValue(json['plant_date']),
      plantHarvest: parsePlantDateValue(json['plant_harvest']),
      plantSts: parsePlantStatusCode(json['plant_sts']),
      plantCreated: parsePlantDateValue(json['plant_created']),
      plantUpdate: parsePlantDateValue(json['plant_update']),
    );
  }

  /// Convert Model to Entity
  Plant toEntity() => Plant(
    plantId: plantId,
    siteId: siteId,
    varietasId: varietasId,
    plantName: plantName,
    plantType: plantType,
    plantSpecies: plantSpecies,
    plantDate: plantDate,
    plantHarvest: plantHarvest,
    plantSts: plantSts,
    plantCreated: plantCreated,
    plantUpdate: plantUpdate,
  );

  /// Convert Entity to Model
  factory PlantModel.fromEntity(Plant entity) => PlantModel(
    plantId: entity.plantId,
    siteId: entity.siteId,
    varietasId: entity.varietasId,
    plantName: entity.plantName,
    plantType: entity.plantType,
    plantSpecies: entity.plantSpecies,
    plantDate: entity.plantDate,
    plantHarvest: entity.plantHarvest,
    plantSts: entity.plantSts,
    plantCreated: entity.plantCreated,
    plantUpdate: entity.plantUpdate,
  );
}

String _stringValue(dynamic value) => value?.toString().trim() ?? '';

String? _nullableString(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
