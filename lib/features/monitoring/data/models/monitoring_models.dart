library;

import 'package:flutter/material.dart';

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
    // Backend bisa mengembalikan key 'sensor' atau 'sensors'
    final rawSensors =
        (json['sensor'] as List?) ?? (json['sensors'] as List?) ?? [];
    final sensorList = rawSensors
        .whereType<Map<String, dynamic>>()
        .map(SensorModel.fromJson)
        .toList();

    // dev_sts bisa berupa int atau String dari backend
    final rawSts = json['dev_sts'];
    final parsedSts = rawSts is int
        ? rawSts
        : rawSts is String
        ? int.tryParse(rawSts)
        : null;

    return DeviceModel(
      devId: json['dev_id']?.toString() ?? '',
      siteId: json['site_id']?.toString(),
      devName: json['dev_name']?.toString(),
      devLocation: json['dev_location']?.toString(),
      devLon: (json['dev_lon'] as num?)?.toDouble(),
      devLat: (json['dev_lat'] as num?)?.toDouble(),
      devAlt: (json['dev_alt'] as num?)?.toDouble(),
      devSts: parsedSts,
      sensors: sensorList,
    );
  }

  bool get isActive => devSts == 1;
  bool get hasCoordinates => devLon != null && devLat != null;
  String get displayName => devName ?? devId;
}

// ─────────────────────────────────────────────────────────────────────────────
// SENSOR (physical sensor hardware)
// ─────────────────────────────────────────────────────────────────────────────

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
      sensId: json['sens_id']?.toString() ?? '',
      devId: json['dev_id']?.toString(),
      sensName: json['sens_name']?.toString(),
      sensAddress: json['sens_address']?.toString(),
      sensLocation: json['sens_location']?.toString(),
      sensLat: (json['sens_lat'] as num?)?.toDouble(),
      sensLon: (json['sens_lon'] as num?)?.toDouble(),
      sensAlt: (json['sens_alt'] as num?)?.toDouble(),
    );
  }

  bool get hasCoordinates => sensLat != null && sensLon != null;
  String get displayName => sensName ?? sensId;
}

// ─────────────────────────────────────────────────────────────────────────────
// SENSOR READ — latest/realtime value per ds_id
// GET /api/sites/:siteId/reads/updates
// ─────────────────────────────────────────────────────────────────────────────

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
      readUpdateId: json['read_update_id']?.toString() ?? '',
      dsId: json['ds_id']?.toString() ?? '',
      devId: json['dev_id']?.toString() ?? '',
      readUpdateDate: json['read_update_date'] != null
          ? DateTime.tryParse(json['read_update_date'].toString())
          : null,
      readUpdateValue: json['read_update_value']?.toString(),
    );
  }

  double get numericValue => double.tryParse(readUpdateValue ?? '') ?? 0.0;
  bool get hasValue => numericValue > 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// SENSOR READ — historical readings
// GET /api/sites/:siteId/reads/today|seven-day|date-range|planting-date
// ─────────────────────────────────────────────────────────────────────────────

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
    // read_sts bisa berupa int atau String
    final rawSts = json['read_sts'];
    final parsedSts = rawSts is int
        ? rawSts
        : rawSts is String
        ? int.tryParse(rawSts)
        : null;

    return SensorReadModel(
      readId: json['read_id']?.toString() ?? '',
      dsId: json['ds_id']?.toString(),
      devId: json['dev_id']?.toString(),
      readDate: json['read_date'] != null
          ? DateTime.tryParse(json['read_date'].toString())
          : null,
      readValue: json['read_value']?.toString(),
      readSts: parsedSts,
    );
  }

  double get numericValue => double.tryParse(readValue ?? '') ?? 0.0;
  bool get isValid => numericValue > 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// SENSOR DAILY — aggregated daily stats (avg/min/max)
// GET /api/sites/:siteId/reads/daily
// ─────────────────────────────────────────────────────────────────────────────

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
      day: json['day'] != null
          ? DateTime.tryParse(json['day'].toString())
          : null,
      devId: json['dev_id']?.toString() ?? '',
      dsId: json['ds_id']?.toString() ?? '',
      avgVal: (json['avg_val'] as num?)?.toDouble(),
      minVal: (json['min_val'] as num?)?.toDouble(),
      maxVal: (json['max_val'] as num?)?.toDouble(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOG — MQTT raw payload log
// GET /api/sites/logs
// ─────────────────────────────────────────────────────────────────────────────

class LogModel {
  final String logRxId;
  final DateTime? logRxDate;
  final String? logRxPayload;

  const LogModel({required this.logRxId, this.logRxDate, this.logRxPayload});

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      logRxId: json['log_rx_id']?.toString() ?? '',
      logRxDate: json['log_rx_date'] != null
          ? DateTime.tryParse(json['log_rx_date'].toString())
          : null,
      logRxPayload: json['log_rx_payload']?.toString(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SENSOR META — label, unit, color helpers
// ─────────────────────────────────────────────────────────────────────────────

class SensorMeta {
  SensorMeta._();

  static String label(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return 'Suhu Udara';
      case 'env_hum':
        return 'Kelembaban Udara';
      case 'soil_temp':
        return 'Suhu Tanah';
      case 'soil_hum':
        return 'Kelembaban Tanah';
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
      case 'soil_temp':
        return '°C';
      case 'env_hum':
      case 'soil_hum':
        return '%';
      case 'soil_nitro':
      case 'soil_phos':
      case 'soil_pot':
        return 'mg/kg';
      case 'soil_ph':
        return '';
      default:
        return '';
    }
  }

  static Color color(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return const Color(0xFFFF8A65);
      case 'env_hum':
        return const Color(0xFF42A5F5);
      case 'soil_nitro':
        return const Color(0xFF66BB6A);
      case 'soil_phos':
        return const Color(0xFFAB47BC);
      case 'soil_pot':
        return const Color(0xFFFF7043);
      case 'soil_ph':
        return const Color(0xFF26C6DA);
      case 'soil_temp':
        return const Color(0xFF8BC34A);
      case 'soil_hum':
        return const Color(0xFF29B6F6);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  static String shortLabel(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return 'Suhu Udara';
      case 'env_hum':
        return 'Kel. Udara';
      case 'soil_temp':
        return 'Suhu Tanah';
      case 'soil_hum':
        return 'Kel. Tanah';
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

  /// Semua ds_id standar yang dikenal
  static const List<String> standardIds = [
    'env_temp',
    'env_hum',
    'soil_temp',
    'soil_hum',
    'soil_nitro',
    'soil_phos',
    'soil_pot',
    'soil_ph',
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// ALARM DATA — alarm lengkap dengan join kode alarm
// GET /api/sites/alarms/data
// ─────────────────────────────────────────────────────────────────────────────

class AlarmDataModel {
  final String almId;
  final String? alcodeId;
  final String? alcodeNote;
  final String? readId;
  final DateTime? almDate;

  const AlarmDataModel({
    required this.almId,
    this.alcodeId,
    this.alcodeNote,
    this.readId,
    this.almDate,
  });

  factory AlarmDataModel.fromJson(Map<String, dynamic> json) {
    return AlarmDataModel(
      almId: json['alm_id']?.toString() ?? '',
      alcodeId: json['alcode_id']?.toString(),
      alcodeNote: json['alcode_note']?.toString(),
      readId: json['read_id']?.toString(),
      almDate: json['alm_date'] != null
          ? DateTime.tryParse(json['alm_date'].toString())
          : null,
    );
  }

  bool get isRecent {
    if (almDate == null) return false;
    return DateTime.now().difference(almDate!).inHours < 24;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTHLY REKAP — agregasi bulanan sensor
// GET /api/sites/:siteId/reads/mounth
// ─────────────────────────────────────────────────────────────────────────────

class MonthlyRekapModel {
  final String month;
  final String devId;
  final String dsId;
  final double? avgVal;
  final double? minVal;
  final double? maxVal;

  const MonthlyRekapModel({
    required this.month,
    required this.devId,
    required this.dsId,
    this.avgVal,
    this.minVal,
    this.maxVal,
  });

  factory MonthlyRekapModel.fromJson(Map<String, dynamic> json) {
    return MonthlyRekapModel(
      month: json['month']?.toString() ?? '',
      devId: json['dev_id']?.toString() ?? '',
      dsId: json['ds_id']?.toString() ?? '',
      avgVal: (json['avg_val'] as num?)?.toDouble(),
      minVal: (json['min_val'] as num?)?.toDouble(),
      maxVal: (json['max_val'] as num?)?.toDouble(),
    );
  }
}
