import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant.freezed.dart';

/// Crop Type Enum
///
/// Valid plant types in the system:
/// - PADI: Rice (default fallback)
/// - JAGUNG: Corn
/// - KEDELAI: Soybean
// ignore: constant_identifier_names
enum CropType { PADI, JAGUNG, KEDELAI }

extension CropTypeExtension on CropType {
  String get displayName {
    switch (this) {
      case CropType.PADI:
        return 'Padi';
      case CropType.JAGUNG:
        return 'Jagung';
      case CropType.KEDELAI:
        return 'Kedelai';
    }
  }

  String get icon {
    switch (this) {
      case CropType.PADI:
        return '🌾';
      case CropType.JAGUNG:
        return '🌽';
      case CropType.KEDELAI:
        return '🫘';
    }
  }
}

@freezed
class Plant with _$Plant {
  const Plant._();

  /// Plant entity representing crop data
  ///
  /// [plantType] is validated during model-to-entity conversion.
  /// If an invalid type is provided, it defaults to PADI (rice) with a warning.
  /// Valid types: PADI, JAGUNG, KEDELAI
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
  }) = _Plant;

  /// Tanaman aktif: plant_sts = 1
  /// (plant_harvest tidak ada di API response, hanya plant_sts yang digunakan)
  bool get isActive => plantSts == 1;

  /// Tanaman sudah panen: plant_sts = 0
  bool get isHarvested => plantSts == 0;

  /// Get display name (fallback to ID if name is null)
  String get displayName => plantName ?? plantId;

  /// Calculate days since planting (HST - Hari Setelah Tanam)
  int? get daysSincePlanting {
    if (plantDate == null) return null;
    return DateTime.now().difference(plantDate!).inDays;
  }

  /// Alias for daysSincePlanting (HST)
  int? get hst => daysSincePlanting;

  /// Get growth phase based on HST
  String? get growthPhase {
    final days = hst;
    if (days == null) return null;

    // Default phases for rice (adjust based on crop type)
    if (days < 20) return 'Vegetatif Awal';
    if (days < 40) return 'Vegetatif';
    if (days < 60) return 'Reproduktif Awal';
    if (days < 80) return 'Reproduktif';
    if (days < 100) return 'Pemasakan';
    return 'Siap Panen';
  }

  /// Calculate days until harvest (if not harvested yet)
  int? get daysUntilHarvest {
    if (plantHarvest == null || isHarvested) return null;
    return plantHarvest!.difference(DateTime.now()).inDays;
  }

  /// Get planting status text
  String get statusText {
    if (isHarvested) return 'Sudah Panen';
    if (isActive) return 'Sedang Tumbuh';
    return 'Tidak Aktif';
  }
}
