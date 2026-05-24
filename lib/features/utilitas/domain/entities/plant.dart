import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../plant/domain/plant_status_extension.dart';

part 'plant.freezed.dart';

enum CropType {
  @JsonValue('PADI')
  padi,
  @JsonValue('JAGUNG')
  jagung,
  @JsonValue('KEDELAI')
  kedelai,
}

@freezed
class Plant with _$Plant {
  const Plant._();

  const factory Plant({
    required String plantId,
    String? siteId,
    String? varietasId,
    String? plantName,
    CropType? plantType,
    String? plantSpecies,
    DateTime? plantDate,
    DateTime? plantHarvest,
    int? plantSts,
    DateTime? plantCreated,
    DateTime? plantUpdate,
  }) = _Plant;

  /// Tanaman aktif secara status record: plant_sts = 1.
  bool get isActive => isActivePlantStatus(plantSts: plantSts);

  /// Siklus tanam sudah selesai jika tanggal panen terisi.
  bool get isHarvested => isHarvestedPlantLifecycle(plantHarvest: plantHarvest);

  /// Siklus tanam yang sedang berjalan.
  bool get isCurrentPlanting => isCurrentPlantingLifecycle(
    plantSts: plantSts,
    plantHarvest: plantHarvest,
  );

  /// Get display name (fallback to ID if name is null)
  String get displayName => plantName ?? plantId;

  /// Get days after planting (HST - Hari Setelah Tanam)
  int? get hst {
    if (plantDate == null) return null;
    return DateTime.now().difference(plantDate!).inDays;
  }

  /// Get crop type display name
  String get cropTypeDisplay {
    switch (plantType) {
      case CropType.padi:
        return 'Padi';
      case CropType.jagung:
        return 'Jagung';
      case CropType.kedelai:
        return 'Kedelai';
      default:
        return '-';
    }
  }
}
