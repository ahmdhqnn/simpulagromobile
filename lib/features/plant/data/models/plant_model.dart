// ignore_for_file: invalid_annotation_target

import 'dart:developer' as developer;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/plant.dart';
import '../../domain/plant_status_extension.dart';
import '../../domain/plant_type_validator.dart';

part 'plant_model.freezed.dart';

void _debugLog(String message) {
  assert(() {
    developer.log(message, name: 'PlantModel');
    return true;
  }());
}

/// Format tanggal untuk request API: `YYYY-MM-DD` (PlantCreateRequest).
String formatPlantDateForApi(DateTime date) {
  return DateFormatter.formatApiDate(DateTime(date.year, date.month, date.day));
}

/// Body POST/PUT plant — hanya field yang diizinkan Swagger `PlantCreateRequest`.
class PlantWritePayload {
  const PlantWritePayload({
    required this.plantName,
    required this.varietasId,
    required this.plantDate,
    this.plantType,
  });

  final String plantName;
  final String varietasId;
  final DateTime plantDate;
  final String? plantType;

  /// Normalisasi map dari UI/provider ke payload aman sebelum dikirim ke API.
  factory PlantWritePayload.fromMap(Map<String, dynamic> raw) {
    final name = (raw['plant_name'] as String?)?.trim() ?? '';
    final varietas = (raw['varietas_id'] as String?)?.trim() ?? '';
    final type = (raw['plant_type'] as String?)?.trim();

    final dateRaw = raw['plant_date'];
    final DateTime? parsedDate = dateRaw is DateTime
        ? dateRaw
        : parsePlantDateValue(dateRaw);

    if (name.isEmpty) {
      throw const FormatException('plant_name wajib diisi');
    }
    if (varietas.isEmpty) {
      throw const FormatException('varietas_id wajib diisi');
    }
    if (parsedDate == null) {
      throw const FormatException(
        'plant_date wajib dan harus valid (YYYY-MM-DD)',
      );
    }

    return PlantWritePayload(
      plantName: name,
      varietasId: varietas,
      plantDate: parsedDate,
      plantType: type?.isNotEmpty == true ? type : null,
    );
  }

  factory PlantWritePayload.fromEntity(Plant entity) {
    final name = entity.plantName?.trim() ?? '';
    final varietas = entity.varietasId?.trim() ?? '';
    final date = entity.plantDate;

    if (name.isEmpty || varietas.isEmpty || date == null) {
      throw const FormatException(
        'Plant entity tidak lengkap untuk request create/update',
      );
    }

    return PlantWritePayload(
      plantName: name,
      varietasId: varietas,
      plantDate: date,
      plantType: entity.plantType?.name,
    );
  }

  /// Hanya kirim field yang diterima backend; hindari `plant_id`, `site_id`, dll.
  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{
      'plant_name': plantName,
      'varietas_id': varietasId,
      'plant_date': formatPlantDateForApi(plantDate),
    };

    final type = plantType?.trim();
    if (type != null && type.isNotEmpty) {
      body['plant_type'] = type.toUpperCase();
    }

    return body;
  }
}

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

  /// Parse response backend — aman untuk ISO (`2026-05-01T00:00:00.000Z`) dan `YYYY-MM-DD`.
  factory PlantModel.fromJson(Map<String, dynamic> json) {
    var parsedSts = parsePlantStatusCode(json['plant_sts']);
    if (parsedSts == null && json.containsKey('status')) {
      parsedSts = parsePlantStatusCode(json['status']);
    }

    return PlantModel(
      plantId: (json['plant_id'] ?? json['plantId'] ?? json['id'] ?? '')
          .toString(),
      siteId: (json['site_id'] ?? json['siteId'])?.toString(),
      varietasId: (json['varietas_id'] ?? json['varietasId'])?.toString(),
      plantName: (json['plant_name'] ?? json['plantName'] ?? json['name'])
          ?.toString(),
      plantType: (json['plant_type'] ?? json['plantType'] ?? json['type'])
          ?.toString(),
      plantSpecies: (json['plant_species'] ?? json['plantSpecies'])?.toString(),
      plantDate: parsePlantDateValue(json['plant_date'] ?? json['plantDate']),
      plantHarvest: parsePlantDateValue(
        json['plant_harvest'] ?? json['plantHarvest'],
      ),
      plantSts: parsedSts,
    );
  }

  /// Serialisasi model — `plant_date` / `plant_harvest` dikirim sebagai `YYYY-MM-DD`.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (plantId.isNotEmpty) 'plant_id': plantId,
      if (siteId != null) 'site_id': siteId,
      if (varietasId != null) 'varietas_id': varietasId,
      if (plantName != null) 'plant_name': plantName,
      if (plantType != null) 'plant_type': plantType,
      if (plantSpecies != null) 'plant_species': plantSpecies,
      if (plantDate != null) 'plant_date': formatPlantDateForApi(plantDate!),
      if (plantHarvest != null)
        'plant_harvest': formatPlantDateForApi(plantHarvest!),
      if (plantSts != null) 'plant_sts': plantSts,
    };
  }

  /// Payload create/update sesuai Swagger dari model ini.
  PlantWritePayload toWritePayload() =>
      PlantWritePayload.fromEntity(toEntity());

  /// Convert Model to Entity
  Plant toEntity() {
    final validator = PlantTypeValidator();

    CropType? cropType;
    if (plantType != null) {
      final result = validator.validatePlantType(plantType);
      cropType = result.fold((failure) {
        _debugLog(
          '[PlantModel] Invalid plant type "$plantType" -> default PADI: '
          '${failure.message}',
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
