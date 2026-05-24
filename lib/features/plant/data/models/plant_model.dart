// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/plant.dart';
import '../../domain/entities/varietas.dart';
import '../../domain/plant_status_extension.dart';
import '../../domain/plant_type_validator.dart';

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
    @JsonKey(name: 'plant_type') String? plantType,
    @JsonKey(name: 'plant_species') String? plantSpecies,
    @JsonKey(name: 'plant_date') DateTime? plantDate,
    @JsonKey(name: 'plant_harvest') DateTime? plantHarvest,
    @JsonKey(name: 'plant_sts') int? plantSts,
  }) = _PlantModel;

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    var parsedSts = parsePlantStatusCode(json['plant_sts']);
    if (parsedSts == null && json.containsKey('status')) {
      parsedSts = parsePlantStatusCode(json['status']);
    }

    return PlantModel(
      plantId: (json['plant_id'] as String?) ?? '',
      siteId: json['site_id'] as String?,
      varietasId: json['varietas_id'] as String?,
      plantName: json['plant_name'] as String?,
      plantType: json['plant_type'] as String?,
      plantSpecies: json['plant_species'] as String?,
      plantDate: parsePlantDateValue(json['plant_date']),
      plantHarvest: parsePlantDateValue(json['plant_harvest']),
      plantSts: parsedSts,
    );
  }

  /// Convert Model to Entity
  Plant toEntity() {
    final validator = PlantTypeValidator();

    CropType? cropType;
    if (plantType != null) {
      final result = validator.validatePlantType(plantType);
      cropType = result.fold((failure) {
        debugPrint(
          '[PlantModel] Warning: Invalid plant type "$plantType". '
          'Using default PADI. Error: ${failure.message}',
        );
        return CropType.PADI;
      }, (type) => type);
    }

    return Plant(
      plantId: plantId,
      siteId: siteId,
      varietasId: varietasId,
      plantName: plantName,
      plantType: cropType,
      plantSpecies: plantSpecies,
      plantDate: plantDate,
      plantHarvest: plantHarvest,
      plantSts: plantSts,
    );
  }

  /// Convert Entity to Model
  factory PlantModel.fromEntity(Plant entity) => PlantModel(
    plantId: entity.plantId,
    siteId: entity.siteId,
    varietasId: entity.varietasId,
    plantName: entity.plantName,
    plantType: entity.plantType?.name,
    plantSpecies: entity.plantSpecies,
    plantDate: entity.plantDate,
    plantHarvest: entity.plantHarvest,
    plantSts: entity.plantSts,
  );

  /// Validates that the plant type is valid
  bool isValidType() {
    final validator = PlantTypeValidator();
    return validator.isValidType(plantType);
  }

  /// Active record: plant_sts = 1.
  bool get isActive => isActivePlantStatus(plantSts: plantSts);

  /// Harvested plant: harvest date exists.
  bool get isHarvested => isHarvestedPlantLifecycle(plantHarvest: plantHarvest);

  /// Current planting cycle: active record and harvest date is still null.
  bool get isCurrentPlanting => isCurrentPlantingLifecycle(
    plantSts: plantSts,
    plantHarvest: plantHarvest,
  );

  /// Get standardized plant status.
  PlantStatusEnum get status {
    if (isHarvested) return PlantStatusEnum.harvested;
    if (isActive) return PlantStatusEnum.active;
    return PlantStatusEnum.unknown;
  }
}

@freezed
class VarietasModel with _$VarietasModel {
  const VarietasModel._();

  const factory VarietasModel({
    @JsonKey(name: 'varietas_id') required String varietasId,
    @JsonKey(name: 'varietas_name') String? varietasName,
    @JsonKey(name: 'varietas_desc') String? varietasDesc,
    @JsonKey(name: 'varietas_sts') int? varietasSts,
  }) = _VarietasModel;

  factory VarietasModel.fromJson(Map<String, dynamic> json) =>
      _$VarietasModelFromJson(json);

  /// Convert Model to Entity
  Varietas toEntity() {
    return Varietas(
      varietasId: varietasId,
      varietasName: varietasName,
      varietasDesc: varietasDesc,
      varietasStatus: varietasSts ?? 0,
    );
  }

  bool get isActive => varietasSts == 1;
  String get displayName => varietasName ?? varietasId;
}
