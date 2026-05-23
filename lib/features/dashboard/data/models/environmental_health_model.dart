/// Model untuk response GET /sites/{siteId}/agro/environmental-health
/// Data layer — hanya digunakan di dalam data layer
library;

import '../../domain/entities/dashboard_entity.dart';

class SensorHealthModel {
  final String devId;
  final String dsId;
  final String readUpdateValue;
  final double persentase;

  const SensorHealthModel({
    required this.devId,
    required this.dsId,
    required this.readUpdateValue,
    required this.persentase,
  });

  factory SensorHealthModel.fromJson(Map<String, dynamic> json) {
    return SensorHealthModel(
      devId: (json['dev_id'] ?? '').toString(),
      dsId: (json['ds_id'] ?? '').toString(),
      readUpdateValue: (json['read_update_value'] ?? '0').toString(),
      persentase: (json['persentase'] as num?)?.toDouble() ?? 0.0,
    );
  }

  SensorHealthEntity toEntity() => SensorHealthEntity(
    devId: devId,
    dsId: dsId,
    readUpdateValue: readUpdateValue,
    persentase: persentase,
  );
}

class EnvironmentalHealthModel {
  final double overallHealth;
  final int totalSensors;
  final List<SensorHealthModel> sensors;

  const EnvironmentalHealthModel({
    required this.overallHealth,
    required this.totalSensors,
    required this.sensors,
  });

  factory EnvironmentalHealthModel.empty() {
    return const EnvironmentalHealthModel(
      overallHealth: 0,
      totalSensors: 0,
      sensors: [],
    );
  }

  factory EnvironmentalHealthModel.fromJson(Map<String, dynamic> json) {
    final health =
        (json['overall_health'] as num?)?.toDouble() ??
        (json['overallHealth'] as num?)?.toDouble() ??
        0.0;

    final total =
        (json['total_sensors'] as num?)?.toInt() ??
        (json['totalSensors'] as num?)?.toInt() ??
        0;

    final sensorList = (json['sensors'] as List? ?? [])
        .map((s) => SensorHealthModel.fromJson(s as Map<String, dynamic>))
        .toList();

    return EnvironmentalHealthModel(
      overallHealth: health,
      totalSensors: total,
      sensors: sensorList,
    );
  }

  EnvironmentalHealthEntity toEntity() => EnvironmentalHealthEntity(
    overallHealth: overallHealth,
    totalSensors: totalSensors,
    sensors: sensors.map((s) => s.toEntity()).toList(),
  );
}

// ─── Backward-compatibility alias ────────────────────────
// Monitoring feature masih menggunakan nama 'EnvironmentalHealth'.
// Alias ini memastikan monitoring tetap compile tanpa perubahan.
// TODO: Migrate monitoring feature ke EnvironmentalHealthEntity pada Prioritas 2.
typedef EnvironmentalHealth = EnvironmentalHealthModel;
