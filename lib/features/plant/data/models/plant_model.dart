// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/plant.dart';
import '../../domain/entities/varietas.dart';
import '../../domain/plant_type_validator.dart';
import '../../domain/plant_status_extension.dart';

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

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    // Semantik plant_sts dari API:
    //   1 = tanaman aktif (sedang tumbuh)
    //   0 = tanaman sudah panen (harvest)
    // plant_harvest TIDAK ada di response API — hanya plant_sts yang digunakan.
    dynamic sts = json['plant_sts'];
    int? parsedSts;

    if (sts is int) {
      parsedSts = sts;
    } else if (sts is String) {
      if (sts.toLowerCase() == 'active' ||
          sts.toLowerCase() == 'semai' ||
          sts.toLowerCase() == 'aktif') {
        parsedSts = 1;
      } else if (sts.toLowerCase() == 'inactive' ||
          sts.toLowerCase() == 'tidak aktif' ||
          sts.toLowerCase() == 'harvest' ||
          sts.toLowerCase() == 'panen') {
        parsedSts = 0;
      } else {
        parsedSts = int.tryParse(sts);
      }
    } else if (sts is bool) {
      parsedSts = sts ? 1 : 0;
    }

    // Fallback ke field 'status' jika plant_sts tidak ada
    if (parsedSts == null && json.containsKey('status')) {
      dynamic statusAlt = json['status'];
      if (statusAlt is String) {
        if (statusAlt.toLowerCase() == 'active' ||
            statusAlt.toLowerCase() == 'semai' ||
            statusAlt.toLowerCase() == 'aktif') {
          parsedSts = 1;
        } else if (statusAlt.toLowerCase() == 'inactive' ||
            statusAlt.toLowerCase() == 'tidak aktif') {
          parsedSts = 0;
        }
      } else if (statusAlt is int) {
        parsedSts = statusAlt;
      } else if (statusAlt is bool) {
        parsedSts = statusAlt ? 1 : 0;
      }
    }

    // Jika plant_sts benar-benar tidak ada di response, default ke 1 (aktif)
    // PENTING: null ≠ 0. plant_sts = 0 berarti harvest, null berarti tidak diketahui → default aktif
    parsedSts ??= 1;

    // Parse dates safely (plant_harvest mungkin ada di beberapa response)
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return PlantModel(
      plantId: (json['plant_id'] as String?) ?? '',
      siteId: json['site_id'] as String?,
      varietasId: json['varietas_id'] as String?,
      plantName: json['plant_name'] as String?,
      plantType: json['plant_type'] as String?,
      plantSpecies: json['plant_species'] as String?,
      plantDate: parseDate(json['plant_date']),
      plantHarvest: parseDate(json['plant_harvest']),
      plantSts: parsedSts,
    );
  }

  /// Convert Model to Entity
  Plant toEntity() {
    final validator = PlantTypeValidator();

    // Validate plant type using the validator service
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

  /// Tanaman aktif: plant_sts = 1
  bool get isActive => plantSts == 1;

  /// Tanaman sudah panen: plant_sts = 0
  bool get isHarvested => plantSts == 0;

  /// Get standardized plant status
  PlantStatusEnum get status {
    if (plantSts == 0) return PlantStatusEnum.harvested;
    if (plantSts == 1) return PlantStatusEnum.active;
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
