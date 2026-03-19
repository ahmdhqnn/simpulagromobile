/// Enum for plant types based on backend
enum CropType { PADI, JAGUNG, KEDELAI }

extension CropTypeExtension on CropType {
  String get displayName {
    switch (this) {
      case CropType.PADI:
        return 'PADI';
      case CropType.JAGUNG:
        return 'JAGUNG';
      case CropType.KEDELAI:
        return 'KEDELAI';
    }
  }

  static CropType fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'PADI':
        return CropType.PADI;
      case 'JAGUNG':
        return CropType.JAGUNG;
      case 'KEDELAI':
        return CropType.KEDELAI;
      default:
        return CropType.PADI;
    }
  }
}

class Plant {
  final String plantId;
  final String? siteId;
  final String? varietasId;
  final String? plantName;
  final CropType? plantType;
  final String? plantSpecies;
  final DateTime? plantDate;
  final DateTime? plantHarvest;
  final int? plantSts;

  const Plant({
    required this.plantId,
    this.siteId,
    this.varietasId,
    this.plantName,
    this.plantType,
    this.plantSpecies,
    this.plantDate,
    this.plantHarvest,
    this.plantSts,
  });

  /// Calculate HST (Hari Sesudah Tanam - Days After Planting)
  int get hst {
    if (plantDate == null) return 0;
    return DateTime.now().difference(plantDate!).inDays;
  }

  /// Check if plant is active (not harvested)
  bool get isActive => plantSts == 1 && plantHarvest == null;

  /// Get growth phase based on HST and crop type
  String get growthPhase {
    final days = hst;
    if (plantType == null) return 'Unknown';

    switch (plantType!) {
      case CropType.PADI:
        if (days < 7) return 'Germination';
        if (days < 21) return 'Vegetatif Awal';
        if (days < 35) return 'Vegetatif';
        if (days < 50) return 'Generatif (Pembungaan)';
        if (days < 70) return 'Pengisian Bulir';
        return 'Maturity (Panen)';
      case CropType.JAGUNG:
        if (days < 10) return 'Germination';
        if (days < 25) return 'Vegetatif';
        if (days < 45) return 'Pembungaan';
        if (days < 65) return 'Pengisian Biji';
        return 'Maturity (Panen)';
      case CropType.KEDELAI:
        if (days < 7) return 'Germination';
        if (days < 25) return 'Vegetatif';
        if (days < 40) return 'Pembungaan';
        if (days < 60) return 'Pembentukan Polong';
        return 'Maturity (Panen)';
    }
  }
}
