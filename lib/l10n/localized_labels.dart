import '../features/plant/domain/entities/plant.dart';
import '../features/recommendation/domain/entities/recommendation.dart';
import '../features/recommendation/presentation/providers/recommendation_hub_provider.dart';
import '../features/recommendation/presentation/providers/recommendation_provider.dart';
import '../features/task/domain/entities/task.dart';
import '../features/task/presentation/providers/task_provider.dart';
import '../features/sensor/domain/entities/sensor.dart';
import '../features/device/domain/entities/device.dart';
import '../features/admin/domain/entities/plant.dart' as admin_plant;
import 'app_localizations.dart';

extension TaskTypeLocalizations on TaskType {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TaskType.planting:
        return l10n.taskTypePlanting;
      case TaskType.fertilizing:
        return l10n.taskTypeFertilizing;
      case TaskType.harvesting:
        return l10n.taskTypeHarvesting;
      case TaskType.watering:
        return l10n.taskTypeWatering;
      case TaskType.pestControl:
        return l10n.taskTypePestControl;
      case TaskType.monitoring:
        return l10n.taskTypeMonitoring;
      case TaskType.maintenance:
        return l10n.taskTypeMaintenance;
      case TaskType.other:
        return l10n.commonOther;
    }
  }
}

extension TaskStatusLocalizations on TaskStatus {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TaskStatus.pending:
        return l10n.commonPending;
      case TaskStatus.progress:
        return l10n.commonInProgress;
      case TaskStatus.complite:
        return l10n.commonCompleted;
      case TaskStatus.failed:
        return l10n.commonFailed;
    }
  }
}

extension TaskPriorityLocalizations on TaskPriority {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TaskPriority.low:
        return l10n.commonLow;
      case TaskPriority.medium:
        return l10n.commonMedium;
      case TaskPriority.high:
        return l10n.commonHigh;
    }
  }
}

extension TaskFilterLocalizations on TaskFilter {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TaskFilter.all:
        return l10n.commonAll;
      case TaskFilter.pending:
        return l10n.commonPending;
      case TaskFilter.progress:
        return l10n.commonInProgress;
      case TaskFilter.complite:
        return l10n.commonCompleted;
      case TaskFilter.failed:
        return l10n.commonFailed;
    }
  }
}

extension CropTypeLocalizations on CropType {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case CropType.PADI:
        return l10n.cropRice;
      case CropType.JAGUNG:
        return l10n.cropCorn;
      case CropType.KEDELAI:
        return l10n.cropSoybean;
    }
  }
}

extension RecommendationTypeLocalizations on RecommendationType {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case RecommendationType.npk:
        return l10n.recommendationTypeNpk;
      case RecommendationType.ph:
        return l10n.recommendationTypePh;
      case RecommendationType.watering:
        return l10n.taskTypeWatering;
      case RecommendationType.pestControl:
        return l10n.taskTypePestControl;
      case RecommendationType.harvesting:
        return l10n.taskTypeHarvesting;
      case RecommendationType.planting:
        return l10n.taskTypePlanting;
      case RecommendationType.general:
        return l10n.commonGeneral;
    }
  }
}

extension RecommendationPriorityLocalizations on RecommendationPriority {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case RecommendationPriority.low:
        return l10n.commonLow;
      case RecommendationPriority.medium:
        return l10n.commonMedium;
      case RecommendationPriority.high:
        return l10n.commonHigh;
      case RecommendationPriority.critical:
        return l10n.commonCritical;
    }
  }
}

extension RecommendationStatusLocalizations on RecommendationStatus {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case RecommendationStatus.pending:
        return l10n.commonPending;
      case RecommendationStatus.applied:
        return l10n.commonApplied;
      case RecommendationStatus.dismissed:
        return l10n.commonDismissed;
      case RecommendationStatus.expired:
        return l10n.commonExpired;
    }
  }
}

extension RecommendationFilterLocalizations on RecommendationFilter {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case RecommendationFilter.all:
        return l10n.commonAll;
      case RecommendationFilter.pending:
        return l10n.commonPending;
      case RecommendationFilter.applied:
        return l10n.commonApplied;
      case RecommendationFilter.highPriority:
        return l10n.commonHighPriority;
      case RecommendationFilter.actionable:
        return l10n.commonActionRequired;
    }
  }
}

extension RecommendationScopeLocalizations on RecommendationScope {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case RecommendationScope.all:
        return l10n.commonAll;
      case RecommendationScope.site:
        return l10n.siteTitle;
      case RecommendationScope.plant:
        return l10n.plantTitle;
      case RecommendationScope.phase:
        return l10n.plantPhaseLabel;
    }
  }
}

extension RecommendationStatusFilterLocalizations
    on RecommendationStatusFilter {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case RecommendationStatusFilter.all:
        return l10n.recommendationAllStatuses;
      case RecommendationStatusFilter.pending:
        return l10n.commonPending;
      case RecommendationStatusFilter.applied:
        return l10n.commonApplied;
      case RecommendationStatusFilter.highPriority:
        return l10n.commonHighPriority;
      case RecommendationStatusFilter.actionable:
        return l10n.commonActionRequired;
    }
  }
}

extension PlantLocalizations on Plant {
  String localizedStatus(AppLocalizations l10n) {
    if (isHarvested) return l10n.plantStatusHarvested;
    if (isCurrentPlanting) return l10n.plantStatusGrowing;
    return l10n.commonInactive;
  }
}

extension DeviceLocalizations on Device {
  String localizedStatus(AppLocalizations l10n) {
    return isActive ? l10n.commonActive : l10n.commonInactive;
  }
}

extension SensorLocalizations on Sensor {
  String localizedStatus(AppLocalizations l10n) {
    return isActive ? l10n.commonActive : l10n.commonInactive;
  }

  String localizedType(AppLocalizations l10n) {
    switch (type.toLowerCase()) {
      case 'temperature':
      case 'env_temp':
        return l10n.sensorTypeAirTemperature;
      case 'humidity':
      case 'env_hum':
        return l10n.sensorTypeAirHumidity;
      case 'soil_moisture':
      case 'soil_hum':
        return l10n.sensorTypeSoilMoisture;
      case 'ph':
      case 'soil_ph':
        return l10n.sensorTypeSoilPh;
      case 'soil_nitro':
        return l10n.sensorTypeSoilNitrogen;
      case 'soil_phos':
        return l10n.sensorTypeSoilPhosphorus;
      case 'soil_pot':
        return l10n.sensorTypeSoilPotassium;
      case 'light':
        return l10n.sensorTypeLightIntensity;
      case 'pressure':
        return l10n.sensorTypeAtmosphericPressure;
      case 'wind_speed':
        return l10n.sensorTypeWindSpeed;
      default:
        return type;
    }
  }
}

extension AdminCropTypeLocalizations on admin_plant.CropType {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case admin_plant.CropType.padi:
        return l10n.cropRice;
      case admin_plant.CropType.jagung:
        return l10n.cropCorn;
      case admin_plant.CropType.kedelai:
        return l10n.cropSoybean;
    }
  }
}

extension AdminPlantLocalizations on admin_plant.Plant {
  String localizedStatus(AppLocalizations l10n) {
    if (isHarvested) return l10n.plantStatusHarvested;
    if (isActive) return l10n.plantStatusGrowing;
    return l10n.commonInactive;
  }
}
