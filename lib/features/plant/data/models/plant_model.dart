// ignore_for_file: invalid_annotation_target

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
    // Tangani kemungkinan plant_sts berbentuk string atau int atau format lain
    dynamic sts = json['plant_sts'];
    int? parsedSts;
    if (sts is int) {
      parsedSts = sts;
    } else if (sts is String) {
      if (sts.toLowerCase() == 'active' || sts.toLowerCase() == 'semai' || sts.toLowerCase() == 'aktif') {
        parsedSts = 1;
      } else if (sts.toLowerCase() == 'inactive' || sts.toLowerCase() == 'tidak aktif') {
        parsedSts = 0;
      } else {
        parsedSts = int.tryParse(sts);
      }
    } else if (sts is bool) {
      parsedSts = sts ? 1 : 0;
    }
    
    // Fallback if status field is used instead of plant_sts
    if (parsedSts == null && json.containsKey('status')) {
      dynamic statusAlt = json['status'];
      if (statusAlt is String) {
        if (statusAlt.toLowerCase() == 'active' || statusAlt.toLowerCase() == 'semai' || statusAlt.toLowerCase() == 'aktif') {
          parsedSts = 1;
        } else if (statusAlt.toLowerCase() == 'inactive' || statusAlt.toLowerCase() == 'tidak aktif') {
          parsedSts = 0;
        }
      } else if (statusAlt is int) {
        parsedSts = statusAlt;
      } else if (statusAlt is bool) {
        parsedSts = statusAlt ? 1 : 0;
      }
    }

    // Default to active (1) if no harvest date and no explicit inactive status, 
    // to fix active plant not showing bug if backend returns missing status
    if (parsedSts == null && json['plant_harvest'] == null) {
      parsedSts = 1;
    }
    
    // Copy the json and override plant_sts
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);
    safeJson['plant_sts'] = parsedSts;
    
    return _$PlantModelFromJson(safeJson);
  }

  /// Convert Model to Entity
  Plant toEntity() {
    final validator = PlantTypeValidator();
    
    // Validate plant type using the validator service
    CropType? cropType;
    if (plantType != null) {
      final result = validator.validatePlantType(plantType);
      cropType = result.fold(
        (failure) {
          // Log warning if fallback is used
          print('[PlantModel] Warning: Invalid plant type "$plantType". '
              'Using default PADI. Error: ${failure.message}');
          return CropType.PADI; // Fallback only at entity boundary
        },
        (type) => type,
      );
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

  /// Check if plant is currently active
  bool get isActive {
    return plantSts == 1 && plantHarvest == null;
  }

  /// Check if plant has been harvested
  bool get isHarvested => plantHarvest != null;

  /// Get standardized plant status
  PlantStatusEnum get status {
    if (plantHarvest != null) {
      return PlantStatusEnum.harvested;
    }
    if (plantSts == 1) {
      return PlantStatusEnum.active;
    }
    if (plantSts == 0) {
      return PlantStatusEnum.inactive;
    }
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
