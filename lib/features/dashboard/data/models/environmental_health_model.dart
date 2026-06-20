/// Model untuk response GET /sites/{siteId}/agro/environmental-health
/// Data layer — hanya digunakan di dalam data layer
library;

import '../../domain/entities/dashboard_entity.dart';

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }
  return 0.0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

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
      devId: (json['dev_id'] ?? json['devId'] ?? '').toString(),
      dsId: (json['ds_id'] ?? json['dsId'] ?? json['sensor_id'] ?? '')
          .toString(),
      readUpdateValue:
          (json['read_update_value'] ??
                  json['readUpdateValue'] ??
                  json['read_value'] ??
                  json['value'] ??
                  '0')
              .toString(),
      persentase: _toDouble(
        json['persentase'] ??
            json['percentage'] ??
            json['health_percentage'] ??
            json['healthPercentage'] ??
            json['score'],
      ),
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
    final health = _toDouble(
      json['overall_health'] ??
          json['overallHealth'] ??
          json['overall_score'] ??
          json['overallScore'] ??
          json['health'] ??
          json['score'],
    );
    final total = _toInt(json['total_sensors'] ?? json['totalSensors']);

    final sensorList = ((json['sensors'] ?? json['sensor']) as List? ?? [])
        .whereType<Map>()
        .map(
          (item) => SensorHealthModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();

    return EnvironmentalHealthModel(
      overallHealth: health,
      totalSensors: total == 0 && sensorList.isNotEmpty
          ? sensorList.length
          : total,
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
typedef EnvironmentalHealth = EnvironmentalHealthModel;
