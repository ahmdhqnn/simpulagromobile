/// Summary models untuk dashboard cards
/// Data layer — hanya digunakan di dalam data layer
library;

import '../../domain/entities/dashboard_entity.dart';

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

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
    final rawDate =
        json['read_update_date'] ??
        json['read_date'] ??
        json['day'] ??
        json['read_at'] ??
        json['read_update_at'] ??
        json['created_at'] ??
        json['updated_at'] ??
        json['timestamp'];

    return SensorReadModel(
      devId: (json['dev_id'] ?? '').toString(),
      dsId: (json['ds_id'] ?? '').toString(),
      value:
          (json['read_update_value'] ??
                  json['read_value'] ??
                  json['avg_val'] ??
                  json['value'] ??
                  '0')
              .toString(),
      readAt: _toDateTime(rawDate),
    );
  }

  SensorReadEntity toEntity() =>
      SensorReadEntity(devId: devId, dsId: dsId, value: value, readAt: readAt);
}
