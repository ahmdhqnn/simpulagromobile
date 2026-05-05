/// Model untuk response GET /api/sites/:siteId/agro/environmental-health
///
/// API Response structure:
/// {
///   "overall_health": 75.5,
///   "total_sensors": 6,
///   "sensors": [
///     {
///       "dev_id": "DEV001",
///       "ds_id": "env_temp",
///       "read_update_value": "28.5",
///       "persentase": 85.0
///     }
///   ]
/// }
library;

class SensorHealth {
  final String devId;
  final String dsId;
  final String readUpdateValue;
  final double persentase;

  const SensorHealth({
    required this.devId,
    required this.dsId,
    required this.readUpdateValue,
    required this.persentase,
  });

  factory SensorHealth.fromJson(Map<String, dynamic> json) {
    return SensorHealth(
      devId: (json['dev_id'] ?? '').toString(),
      dsId: (json['ds_id'] ?? '').toString(),
      readUpdateValue: (json['read_update_value'] ?? '0').toString(),
      persentase: (json['persentase'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get label {
    switch (dsId) {
      case 'env_temp':
        return 'Suhu';
      case 'env_hum':
        return 'Kelembaban';
      case 'soil_nitro':
        return 'Nitrogen';
      case 'soil_phos':
        return 'Fosfor';
      case 'soil_pot':
        return 'Kalium';
      case 'soil_ph':
        return 'pH Tanah';
      default:
        return dsId;
    }
  }

  String get unit {
    switch (dsId) {
      case 'env_temp':
        return '°C';
      case 'env_hum':
        return '%';
      case 'soil_nitro':
        return 'mg/kg';
      case 'soil_phos':
        return 'mg/kg';
      case 'soil_pot':
        return 'mg/kg';
      case 'soil_ph':
        return '';
      default:
        return '';
    }
  }
}

class EnvironmentalHealth {
  final double overallHealth;
  final int totalSensors;
  final List<SensorHealth> sensors;

  const EnvironmentalHealth({
    required this.overallHealth,
    required this.totalSensors,
    required this.sensors,
  });

  /// Empty state — digunakan saat site belum dipilih atau error
  factory EnvironmentalHealth.empty() {
    return const EnvironmentalHealth(
      overallHealth: 0,
      totalSensors: 0,
      sensors: [],
    );
  }

  factory EnvironmentalHealth.fromJson(Map<String, dynamic> json) {
    // API mengembalikan overall_health (snake_case)
    final health =
        (json['overall_health'] as num?)?.toDouble() ??
        (json['overallHealth'] as num?)?.toDouble() ??
        0.0;

    final total =
        (json['total_sensors'] as num?)?.toInt() ??
        (json['totalSensors'] as num?)?.toInt() ??
        0;

    final sensorList = (json['sensors'] as List? ?? [])
        .map((s) => SensorHealth.fromJson(s as Map<String, dynamic>))
        .toList();

    return EnvironmentalHealth(
      overallHealth: health,
      totalSensors: total,
      sensors: sensorList,
    );
  }
}
