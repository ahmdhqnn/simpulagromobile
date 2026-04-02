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
    @JsonKey(name: 'plant_type') String? plantType, // PADI, JAGUNG, KEDELAI
    @JsonKey(name: 'plant_species') String? plantSpecies,
    @JsonKey(name: 'plant_date') DateTime? plantDate,
    @JsonKey(name: 'plant_harvest') DateTime? plantHarvest,
    @JsonKey(name: 'plant_sts') int? plantSts,
  }) = _PlantModel;

  factory PlantModel.fromJson(Map<String, dynamic> json) =>
      _$PlantModelFromJson(json);

  /// Convert Model to Entity
  Plant toEntity() => Plant(
    plantId: plantId,
    siteId: siteId,
    varietasId: varietasId,
    plantName: plantName,
    plantType: _parseCropType(plantType),
    plantSpecies: plantSpecies,
    plantDate: plantDate,
    plantHarvest: plantHarvest,
    plantSts: plantSts,
  );

  /// Parse crop type from string safely
  CropType? _parseCropType(String? type) {
    if (type == null) return null;

    final upperType = type.toUpperCase();
    try {
      return CropType.values.firstWhere(
        (e) => e.name == upperType,
        orElse: () => CropType.PADI,
      );
    } catch (e) {
      return null;
    }
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

  bool get isActive => varietasSts == 1;
  String get displayName => varietasName ?? varietasId;
}
