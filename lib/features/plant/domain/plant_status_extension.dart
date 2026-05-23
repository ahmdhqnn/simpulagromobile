// Plant Status Extension
// 
// Standardizes plant status code comparisons across the application.
// Handles both int (1, 0) and string ('1', '0') comparisons.
// 
// Status Codes:
// - 1 / '1': Active plant
// - 0 / '0': Inactive plant
// - null: Unknown status
// 
// Harvest Status:
// - null: Not harvested (still active)
// - DateTime: Harvested on that date

extension PlantStatusX on dynamic {
  /// Check if plant is active
  /// 
  /// Active = plant_sts == 1 and harvest date is null
  bool isPlantActive() {
    if (this is! Map<String, dynamic>) return false;
    
    final map = this as Map<String, dynamic>;
    final sts = map['plant_sts'];
    final harvest = map['plant_harvest'];
    
    return (sts == 1 || sts == '1') && harvest == null;
  }

  /// Check if plant is harvested
  /// 
  /// Harvested = plant_harvest is not null
  bool isPlantHarvested() {
    if (this is! Map<String, dynamic>) return false;
    
    final map = this as Map<String, dynamic>;
    final harvest = map['plant_harvest'];
    
    return harvest != null;
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
    final sts = map['plant_sts'];
    final harvest = map['plant_harvest'];
    
    // Harvested status takes precedence
    if (harvest != null) {
      return PlantStatusEnum.harvested;
    }
    
    // Check active status
    if (sts == 1 || sts == '1') {
      return PlantStatusEnum.active;
    }
    
    // Check inactive status
    if (sts == 0 || sts == '0') {
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
