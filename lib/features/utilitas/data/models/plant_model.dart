// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/plant.dart';

part 'plant_model.freezed.dart';
part 'plant_model.g.dart';

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

  factory PlantModel.fromJson(Map<String, dynamic> json) =>
      _$PlantModelFromJson(json);

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
