/// Domain entities untuk fitur Dashboard
/// Sesuai kontrak API:
///   GET /sites/{siteId}/agro/environmental-health
///   GET /sites/{siteId}/devices
///   GET /sites/{siteId}/sensors
///   GET /sites/{siteId}/plants
///   GET /sites/{siteId}/reads/updates
///   GET /sites/{siteId}/reads/daily
library;

// ─── Sensor Health Entity ─────────────────────────────────
/// Data kesehatan per sensor
/// API response item: { "dev_id": "DEV_001", "ds_id": "DS_001",
///                      "read_update_value": "25.3", "persentase": 85 }
class SensorHealthEntity {
  final String devId;
  final String dsId;
  final String readUpdateValue;
  final double persentase;

  const SensorHealthEntity({
    required this.devId,
    required this.dsId,
    required this.readUpdateValue,
    required this.persentase,
  });

  /// Label tampilan berdasarkan ds_id
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
      case 'soil_hum':
        return 'Kelembaban Tanah';
      case 'soil_temp':
        return 'Suhu Tanah';
      case 'water_lvl':
        return 'Level Air';
      case 'light_lux':
        return 'Cahaya';
      case 'rain_rate':
        return 'Curah Hujan';
      case 'wind_spd':
        return 'Kecepatan Angin';
      default:
        return dsId;
    }
  }

  /// Satuan berdasarkan ds_id
  String get unit {
    switch (dsId) {
      case 'env_temp':
      case 'soil_temp':
      case 'water_temp':
        return '°C';
      case 'env_hum':
      case 'soil_hum':
        return '%';
      case 'soil_nitro':
      case 'soil_phos':
      case 'soil_pot':
        return 'mg/kg';
      case 'water_lvl':
        return 'cm';
      case 'light_lux':
        return 'lux';
      case 'rain_rate':
        return 'mm/h';
      case 'wind_spd':
        return 'm/s';
      case 'wind_dir':
        return '°';
      default:
        return '';
    }
  }
}

// ─── Environmental Health Entity ─────────────────────────
/// Kesehatan lingkungan keseluruhan
/// API response: { "overall_health": 88.5, "total_sensors": 12, "sensors": [...] }
class EnvironmentalHealthEntity {
  final double overallHealth;
  final int totalSensors;
  final List<SensorHealthEntity> sensors;

  const EnvironmentalHealthEntity({
    required this.overallHealth,
    required this.totalSensors,
    required this.sensors,
  });

  factory EnvironmentalHealthEntity.empty() {
    return const EnvironmentalHealthEntity(
      overallHealth: 0,
      totalSensors: 0,
      sensors: [],
    );
  }

  bool get isEmpty => totalSensors == 0 && sensors.isEmpty;
}

// ─── Device Summary Entity ────────────────────────────────
/// Ringkasan perangkat
class DeviceSummaryEntity {
  final int total;
  final int active;

  const DeviceSummaryEntity({required this.total, required this.active});

  int get inactive => total - active;
}

// ─── Sensor Summary Entity ────────────────────────────────
/// Ringkasan sensor
class SensorSummaryEntity {
  final int total;
  final int active;

  const SensorSummaryEntity({required this.total, required this.active});

  int get inactive => total - active;
}

// ─── Plant Summary Entity ─────────────────────────────────
/// Ringkasan tanaman
class PlantSummaryEntity {
  final int total;
  final int active;

  const PlantSummaryEntity({required this.total, required this.active});
}

// ─── Sensor Read Entity ───────────────────────────────────
/// Data bacaan sensor terbaru
/// API response item dari /reads/updates:
/// { "dev_id": "...", "ds_id": "...", "read_update_value": "...", ... }
class SensorReadEntity {
  final String devId;
  final String dsId;
  final String value;
  final DateTime? readAt;

  const SensorReadEntity({
    required this.devId,
    required this.dsId,
    required this.value,
    this.readAt,
  });

  /// Label tampilan berdasarkan ds_id
  String get label {
    switch (dsId) {
      case 'env_temp':
        return 'Suhu Lingkungan';
      case 'env_hum':
        return 'Kelembaban Lingkungan';
      case 'soil_nitro':
        return 'Nitrogen Tanah';
      case 'soil_phos':
        return 'Fosfor Tanah';
      case 'soil_pot':
        return 'Kalium Tanah';
      case 'soil_ph':
        return 'pH Tanah';
      case 'soil_hum':
        return 'Kelembaban Tanah';
      case 'soil_temp':
        return 'Suhu Tanah';
      case 'water_temp':
        return 'Suhu Air';
      case 'water_lvl':
        return 'Level Air';
      case 'light_lux':
        return 'Intensitas Cahaya';
      case 'rain_rate':
        return 'Curah Hujan';
      case 'wind_dir':
        return 'Arah Angin';
      case 'wind_spd':
        return 'Kecepatan Angin';
      default:
        return dsId;
    }
  }

  /// Satuan berdasarkan ds_id
  String get unit {
    switch (dsId) {
      case 'env_temp':
      case 'soil_temp':
      case 'water_temp':
        return '°C';
      case 'env_hum':
      case 'soil_hum':
        return '%';
      case 'soil_nitro':
      case 'soil_phos':
      case 'soil_pot':
        return 'mg/kg';
      case 'water_lvl':
        return 'cm';
      case 'light_lux':
        return 'lux';
      case 'rain_rate':
        return 'mm/h';
      case 'wind_spd':
        return 'm/s';
      case 'wind_dir':
        return '°';
      case 'soil_ph':
        return '';
      default:
        return '';
    }
  }
}
