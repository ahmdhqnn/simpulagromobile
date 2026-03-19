import '../../domain/entities/plant.dart';

class PlantModel extends Plant {
  const PlantModel({
    required super.plantId,
    super.siteId,
    super.varietasId,
    super.plantName,
    super.plantType,
    super.plantSpecies,
    super.plantDate,
    super.plantHarvest,
    super.plantSts,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      plantId: json['plant_id'] ?? '',
      siteId: json['site_id'],
      varietasId: json['varietas_id'],
      plantName: json['plant_name'],
      plantType: CropTypeExtension.fromString(json['plant_type']),
      plantSpecies: json['plant_species'],
      plantDate: json['plant_date'] != null
          ? DateTime.tryParse(json['plant_date'])
          : null,
      plantHarvest: json['plant_harvest'] != null
          ? DateTime.tryParse(json['plant_harvest'])
          : null,
      plantSts: json['plant_sts'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_name': plantName,
      'plant_type': plantType?.displayName,
      'plant_species': plantSpecies,
      'varietas_id': varietasId,
      'plant_date': plantDate?.toIso8601String().split('T').first,
    };
  }
}

/// Model for varietas (plant varieties)
class VarietasModel {
  final String varietasId;
  final String? varietasName;
  final String? varietasDesc;
  final int? varietasSts;

  const VarietasModel({
    required this.varietasId,
    this.varietasName,
    this.varietasDesc,
    this.varietasSts,
  });

  factory VarietasModel.fromJson(Map<String, dynamic> json) {
    return VarietasModel(
      varietasId: json['varietas_id'] ?? '',
      varietasName: json['varietas_name'],
      varietasDesc: json['varietas_desc'],
      varietasSts: json['varietas_sts'] as int?,
    );
  }
}
