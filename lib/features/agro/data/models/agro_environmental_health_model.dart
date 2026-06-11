import '../../domain/entities/agro_entity.dart';

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString().replaceAll(',', '.') ?? '') ?? 0;
}

int _toInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class AgroSensorHealthModel {
  const AgroSensorHealthModel({
    required this.devId,
    required this.dsId,
    required this.readUpdateValue,
    required this.percentage,
  });

  final String devId;
  final String dsId;
  final String readUpdateValue;
  final double percentage;

  factory AgroSensorHealthModel.fromJson(Map<String, dynamic> json) {
    return AgroSensorHealthModel(
      devId: (json['dev_id'] ?? json['devId'] ?? '').toString(),
      dsId: (json['ds_id'] ?? json['dsId'] ?? '').toString(),
      readUpdateValue:
          (json['read_update_value'] ??
                  json['readUpdateValue'] ??
                  json['value'] ??
                  '0')
              .toString(),
      percentage: _toDouble(
        json['persentase'] ?? json['percentage'] ?? json['score'],
      ).clamp(0, 100),
    );
  }

  AgroSensorHealthEntity toEntity() {
    return AgroSensorHealthEntity(
      devId: devId,
      dsId: dsId,
      readUpdateValue: readUpdateValue,
      percentage: percentage,
    );
  }
}

class AgroEnvironmentalHealthModel {
  const AgroEnvironmentalHealthModel({
    required this.overallHealth,
    required this.totalSensors,
    required this.sensors,
  });

  final double overallHealth;
  final int totalSensors;
  final List<AgroSensorHealthModel> sensors;

  factory AgroEnvironmentalHealthModel.fromJson(Map<String, dynamic> json) {
    final sensors = (json['sensors'] as List? ?? const [])
        .whereType<Map>()
        .map(
          (item) =>
              AgroSensorHealthModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
    final total = _toInt(json['total_sensors'] ?? json['totalSensors']);
    final rawOverallHealth = json['overall_health'] ?? json['overallHealth'];
    final calculatedOverallHealth = sensors.isEmpty
        ? 0.0
        : sensors.fold<double>(0, (sum, sensor) => sum + sensor.percentage) /
              sensors.length;

    return AgroEnvironmentalHealthModel(
      overallHealth:
          (rawOverallHealth == null
                  ? calculatedOverallHealth
                  : _toDouble(rawOverallHealth))
              .clamp(0, 100),
      totalSensors: total == 0 && sensors.isNotEmpty ? sensors.length : total,
      sensors: sensors,
    );
  }

  AgroEnvironmentalHealthEntity toEntity() {
    return AgroEnvironmentalHealthEntity(
      overallHealth: overallHealth,
      totalSensors: totalSensors,
      sensors: sensors.map((sensor) => sensor.toEntity()).toList(),
    );
  }
}
