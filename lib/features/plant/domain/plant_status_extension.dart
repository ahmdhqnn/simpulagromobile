import '../../../core/utils/date_formatter.dart';

// Plant Status Extension
//
// Standardizes plant status code comparisons across the application.
// Handles both int (1, 0) and string ('1', '0') comparisons.
//
// Status Codes:
// - 1 / '1': Active plant
// - 0 / '0': Inactive plant
// - null/other: Unknown status
//
// Harvest Status:
// - null: Planting cycle is still open
// - DateTime/string: Harvested on that date

int? parsePlantStatusCode(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is bool) return value ? 1 : 0;

  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    if (normalized == 'active' ||
        normalized == 'semai' ||
        normalized == 'aktif') {
      return 1;
    }
    if (normalized == 'inactive' ||
        normalized == 'tidak aktif' ||
        normalized == 'harvest' ||
        normalized == 'harvested' ||
        normalized == 'panen') {
      return 0;
    }
    return int.tryParse(normalized);
  }

  return null;
}

DateTime? parsePlantDateValue(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is! String) return null;

  final raw = value.trim();
  if (raw.isEmpty) return null;

  final isoParsed = DateTime.tryParse(raw);
  if (isoParsed != null) return isoParsed;

  final apiDate = DateFormatter.parseApiDate(raw);
  if (apiDate != null) return apiDate;

  final apiDateTime = DateFormatter.parseApiDateTime(raw);
  if (apiDateTime != null) return apiDateTime;

  final match = RegExp(
    r'^(\d{1,2})/(\d{1,2})/(\d{4})(?:\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?)?$',
  ).firstMatch(raw);
  if (match == null) return null;

  final day = int.tryParse(match.group(1)!);
  final month = int.tryParse(match.group(2)!);
  final year = int.tryParse(match.group(3)!);
  final hour = int.tryParse(match.group(4) ?? '0') ?? 0;
  final minute = int.tryParse(match.group(5) ?? '0') ?? 0;
  final second = int.tryParse(match.group(6) ?? '0') ?? 0;

  if (day == null || month == null || year == null) return null;
  if (month < 1 || month > 12 || day < 1 || day > 31) return null;

  return DateTime(year, month, day, hour, minute, second);
}

bool hasPlantHarvestValue(dynamic value) => parsePlantDateValue(value) != null;

bool isActivePlantStatus({required int? plantSts}) {
  return plantSts == 1;
}

bool isHarvestedPlantLifecycle({required DateTime? plantHarvest}) {
  return plantHarvest != null;
}

bool isCurrentPlantingLifecycle({
  required int? plantSts,
  required DateTime? plantHarvest,
}) {
  return isActivePlantStatus(plantSts: plantSts) &&
      !isHarvestedPlantLifecycle(plantHarvest: plantHarvest);
}

extension PlantStatusX on dynamic {
  /// Check if plant is active
  ///
  /// Active = plant_sts == 1
  bool isPlantActive() {
    if (this is! Map<String, dynamic>) return false;

    final map = this as Map<String, dynamic>;
    final sts = parsePlantStatusCode(map['plant_sts']);

    return isActivePlantStatus(plantSts: sts);
  }

  /// Check if plant is harvested
  ///
  /// Harvested = plant_harvest is not null
  bool isPlantHarvested() {
    if (this is! Map<String, dynamic>) return false;

    final map = this as Map<String, dynamic>;
    final harvest = parsePlantDateValue(map['plant_harvest']);

    return isHarvestedPlantLifecycle(plantHarvest: harvest);
  }

  /// Get plant status as enum
  ///
  /// Returns:
  /// - PlantStatusEnum.active: plant_sts == 1 and harvest == null
  /// - PlantStatusEnum.harvested: harvest != null
  /// - PlantStatusEnum.inactive: plant_sts == 0 or plant_sts == '0'
  /// - PlantStatusEnum.unknown: no status info or invalid state
  PlantStatusEnum getPlantStatus() {
    if (this is! Map<String, dynamic>) return PlantStatusEnum.unknown;

    final map = this as Map<String, dynamic>;
    final sts = parsePlantStatusCode(map['plant_sts']);
    final harvest = parsePlantDateValue(map['plant_harvest']);

    // Harvested status takes precedence
    if (isHarvestedPlantLifecycle(plantHarvest: harvest)) {
      return PlantStatusEnum.harvested;
    }

    // Check active status
    if (isActivePlantStatus(plantSts: sts)) {
      return PlantStatusEnum.active;
    }

    // Check inactive status
    if (sts == 0) {
      return PlantStatusEnum.inactive;
    }

    return PlantStatusEnum.unknown;
  }
}

/// Plant Status Enum
///
/// Represents the different states a plant can be in
enum PlantStatusEnum {
  /// Plant is actively growing (plant_sts == 1 and harvest == null)
  active,

  /// Plant has been harvested (plant_harvest != null)
  harvested,

  /// Plant is inactive (plant_sts == 0)
  inactive,

  /// Plant status is unknown or invalid
  unknown,
}

extension PlantStatusEnumX on PlantStatusEnum {
  /// Get human-readable label for status
  String get label {
    switch (this) {
      case PlantStatusEnum.active:
        return 'Active';
      case PlantStatusEnum.harvested:
        return 'Harvested';
      case PlantStatusEnum.inactive:
        return 'Inactive';
      case PlantStatusEnum.unknown:
        return 'Unknown';
    }
  }

  /// Check if status represents an active plant
  bool get isActive => this == PlantStatusEnum.active;
}
