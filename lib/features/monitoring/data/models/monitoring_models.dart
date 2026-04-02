/// Models for monitoring feature
library;

// ─── Device with coordinates ────────────────────────────
class DeviceModel {
  final String devId;
  final String? siteId;
  final String? devName;
  final String? devLocation;
  final double? devLon;
  final double? devLat;
  final double? devAlt;
  final int? devSts;
  final List<SensorModel> sensors;

  const DeviceModel({
    required this.devId,
    this.siteId,
    this.devName,
    this.devLocation,
    this.devLon,
    this.devLat,
    this.devAlt,
    this.devSts,
    this.sensors = const [],
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    final sensorList = (json['sensor'] as List? ?? [])
        .map((s) => SensorModel.fromJson(s as Map<String, dynamic>))
        .toList();
    return DeviceModel(
      devId: json['dev_id'] ?? '',
      siteId: json['site_id'],
      devName: json['dev_name'],
      devLocation: json['dev_location'],
      devLon: (json['dev_lon'] as num?)?.toDouble(),
      devLat: (json['dev_lat'] as num?)?.toDouble(),
      devAlt: (json['dev_alt'] as num?)?.toDouble(),
      devSts: json['dev_sts'] as int?,
      sensors: sensorList,
    );
  }

  bool get isActive => devSts == 1;
}

// ─── Sensor ─────────────────────────────────────────────
class SensorModel {
  final String sensId;
  final String? devId;
  final String? sensName;
  final String? sensAddress;
  final String? sensLocation;
  final double? sensLat;
  final double? sensLon;
  final double? sensAlt;

  const SensorModel({
    required this.sensId,
    this.devId,
    this.sensName,
    this.sensAddress,
    this.sensLocation,
    this.sensLat,
    this.sensLon,
    this.sensAlt,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      sensId: json['sens_id'] ?? '',
      devId: json['dev_id'],
      sensName: json['sens_name'],
      sensAddress: json['sens_address'],
      sensLocation: json['sens_location'],
      sensLat: (json['sens_lat'] as num?)?.toDouble(),
      sensLon: (json['sens_lon'] as num?)?.toDouble(),
      sensAlt: (json['sens_alt'] as num?)?.toDouble(),
    );
  }
}

// ─── Sensor Read (latest) ────────────────────────────────
class SensorReadUpdate {
  final String readUpdateId;
  final String dsId;
  final String devId;
  final DateTime? readUpdateDate;
  final String? readUpdateValue;

  const SensorReadUpdate({
    required this.readUpdateId,
    required this.dsId,
    required this.devId,
    this.readUpdateDate,
    this.readUpdateValue,
  });

  factory SensorReadUpdate.fromJson(Map<String, dynamic> json) {
    return SensorReadUpdate(
      readUpdateId: json['read_update_id'] ?? '',
      dsId: json['ds_id'] ?? '',
      devId: json['dev_id'] ?? '',
      readUpdateDate: json['read_update_date'] != null
          ? DateTime.tryParse(json['read_update_date'])
          : null,
      readUpdateValue: json['read_update_value']?.toString(),
    );
  }

  double get numericValue => double.tryParse(readUpdateValue ?? '') ?? 0.0;
}

// ─── Sensor Read (history) ───────────────────────────────
class SensorReadModel {
  final String readId;
  final String? dsId;
  final String? devId;
  final DateTime? readDate;
  final String? readValue;
  final int? readSts;

  const SensorReadModel({
    required this.readId,
    this.dsId,
    this.devId,
    this.readDate,
    this.readValue,
    this.readSts,
  });

  factory SensorReadModel.fromJson(Map<String, dynamic> json) {
    return SensorReadModel(
      readId: json['read_id'] ?? '',
      dsId: json['ds_id'],
      devId: json['dev_id'],
      readDate: json['read_date'] != null
          ? DateTime.tryParse(json['read_date'])
          : null,
      readValue: json['read_value']?.toString(),
      readSts: json['read_sts'] as int?,
    );
  }

  double get numericValue => double.tryParse(readValue ?? '') ?? 0.0;
}

// ─── Daily Sensor Recap ──────────────────────────────────
class SensorDailyModel {
  final DateTime? day;
  final String devId;
  final String dsId;
  final double? avgVal;
  final double? minVal;
  final double? maxVal;

  const SensorDailyModel({
    this.day,
    required this.devId,
    required this.dsId,
    this.avgVal,
    this.minVal,
    this.maxVal,
  });

  factory SensorDailyModel.fromJson(Map<String, dynamic> json) {
    return SensorDailyModel(
      day: json['day'] != null ? DateTime.tryParse(json['day']) : null,
      devId: json['dev_id'] ?? '',
      dsId: json['ds_id'] ?? '',
      avgVal: (json['avg_val'] as num?)?.toDouble(),
      minVal: (json['min_val'] as num?)?.toDouble(),
      maxVal: (json['max_val'] as num?)?.toDouble(),
    );
  }
}

// ─── Log MQTT ────────────────────────────────────────────
class LogModel {
  final String logRxId;
  final DateTime? logRxDate;
  final String? logRxPayload;

  const LogModel({required this.logRxId, this.logRxDate, this.logRxPayload});

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      logRxId: json['log_rx_id'] ?? '',
      logRxDate: json['log_rx_date'] != null
          ? DateTime.tryParse(json['log_rx_date'])
          : null,
      logRxPayload: json['log_rx_payload']?.toString(),
    );
  }
}

// ─── Sensor metadata helpers ─────────────────────────────
class SensorMeta {
  static String label(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return 'Suhu Udara';
      case 'env_hum':
        return 'Kelembaban Udara';
      case 'soil_nitro':
        return 'Nitrogen Tanah';
      case 'soil_phos':
        return 'Fosfor Tanah';
      case 'soil_pot':
        return 'Kalium Tanah';
      case 'soil_ph':
        return 'pH Tanah';
      default:
        return dsId;
    }
  }

  static String unit(String dsId) {
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

  static const List<String> standardIds = [
    'env_temp',
    'env_hum',
    'soil_nitro',
    'soil_phos',
    'soil_pot',
    'soil_ph',
  ];
}
