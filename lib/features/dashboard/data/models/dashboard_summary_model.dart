/// Summary models untuk dashboard cards
/// Data layer — hanya digunakan di dalam data layer
library;

import '../../domain/entities/dashboard_entity.dart';

class DashboardDeviceSummaryModel {
  final int total;
  final int active;

  const DashboardDeviceSummaryModel({
    required this.total,
    required this.active,
  });

  DeviceSummaryEntity toEntity() =>
      DeviceSummaryEntity(total: total, active: active);
}

class DashboardSensorSummaryModel {
  final int total;
  final int active;

  const DashboardSensorSummaryModel({
    required this.total,
    required this.active,
  });

  SensorSummaryEntity toEntity() =>
      SensorSummaryEntity(total: total, active: active);
}

class DashboardPlantSummaryModel {
  final int total;
  final int active;

  const DashboardPlantSummaryModel({required this.total, required this.active});

  PlantSummaryEntity toEntity() =>
      PlantSummaryEntity(total: total, active: active);
}

/// Model untuk satu item bacaan sensor dari /reads/updates atau /reads/daily
class SensorReadModel {
  final String devId;
  final String dsId;
  final String value;
  final DateTime? readAt;

  const SensorReadModel({
    required this.devId,
    required this.dsId,
    required this.value,
    this.readAt,
  });

  factory SensorReadModel.fromJson(Map<String, dynamic> json) {
    // Coba parse timestamp dari berbagai field yang mungkin ada
    DateTime? parsedDate;
    final rawDate =
        json['read_at'] ??
        json['created_at'] ??
        json['read_update_at'] ??
        json['timestamp'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate);
    }

    return SensorReadModel(
      devId: (json['dev_id'] ?? '').toString(),
      dsId: (json['ds_id'] ?? '').toString(),
      value: (json['read_update_value'] ?? json['value'] ?? '0').toString(),
      readAt: parsedDate,
    );
  }

  SensorReadEntity toEntity() =>
      SensorReadEntity(devId: devId, dsId: dsId, value: value, readAt: readAt);
}
