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
      devId: json['dev_id'] ?? '',
      dsId: json['ds_id'] ?? '',
      readUpdateValue: (json['read_update_value'] ?? '0').toString(),
      persentase: (json['persentase'] as num?)?.toDouble() ?? 0,
    );
  }

  String get label {
    switch (dsId) {
      case 'env_temp': return 'Suhu';
      case 'env_hum': return 'Kelembaban';
      case 'soil_nitro': return 'Nitrogen';
      case 'soil_phos': return 'Fosfor';
      case 'soil_pot': return 'Kalium';
      case 'soil_ph': return 'pH Tanah';
      default: return dsId;
    }
  }

  String get unit {
    switch (dsId) {
      case 'env_temp': return '°C';
      case 'env_hum': return '%';
      case 'soil_nitro': return 'mg/kg';
      case 'soil_phos': return 'mg/kg';
      case 'soil_pot': return 'mg/kg';
      case 'soil_ph': return '';
      default: return '';
    }
  }

  String get icon {
    switch (dsId) {
      case 'env_temp': return '🌡️';
      case 'env_hum': return '💧';
      case 'soil_nitro': return '🌿';
      case 'soil_phos': return '🟣';
      case 'soil_pot': return '🟠';
      case 'soil_ph': return '⚗️';
      default: return '📊';
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

  factory EnvironmentalHealth.fromJson(Map<String, dynamic> json) {
    final sensorList = (json['sensors'] as List? ?? [])
        .map((s) => SensorHealth.fromJson(s))
        .toList();
    return EnvironmentalHealth(
      overallHealth: (json['overall_health'] as num?)?.toDouble() ?? 0,
      totalSensors: json['total_sensors'] ?? 0,
      sensors: sensorList,
    );
  }
}
