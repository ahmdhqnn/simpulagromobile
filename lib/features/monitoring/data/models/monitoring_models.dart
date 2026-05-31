library;

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.replaceAll(',', '.'));
  return null;
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is num) {
    final raw = value.toInt();
    final millis = raw > 1000000000000 ? raw : raw * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }
  return DateTime.tryParse(value.toString());
}

dynamic _firstOf(Map<String, dynamic> json, Iterable<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value != null) return value;
  }
  return null;
}

String _monthLabel(dynamic value) {
  if (value == null) return '';
  if (value is DateTime) {
    return '${value.year}-${value.month.toString().padLeft(2, '0')}';
  }
  if (value is Map) {
    final year = value['year'] ?? value['y'];
    final month = value['month'] ?? value['m'];
    final monthInt = _toInt(month);
    if (year != null && monthInt != null) {
      return '${year.toString()}-${monthInt.toString().padLeft(2, '0')}';
    }
    for (final key in ['value', 'label', 'date', 'start']) {
      final candidate = value[key];
      if (candidate != null) return _monthLabel(candidate);
    }
  }
  final text = value.toString();
  if (text.length >= 7 && RegExp(r'^\d{4}-\d{2}').hasMatch(text)) {
    return text.substring(0, 7);
  }
  return text;
}

double? _average(Iterable<double?> values) {
  final parsed = values.whereType<double>().toList();
  if (parsed.isEmpty) return null;
  return parsed.reduce((a, b) => a + b) / parsed.length;
}

double? _minValue(Iterable<double?> values) {
  final parsed = values.whereType<double>().toList();
  if (parsed.isEmpty) return null;
  return parsed.reduce((a, b) => a < b ? a : b);
}

double? _maxValue(Iterable<double?> values) {
  final parsed = values.whereType<double>().toList();
  if (parsed.isEmpty) return null;
  return parsed.reduce((a, b) => a > b ? a : b);
}

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
        .whereType<Map>()
        .map((item) => SensorModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    return DeviceModel(
      devId: json['dev_id']?.toString() ?? '',
      siteId: json['site_id']?.toString(),
      devName: json['dev_name']?.toString(),
      devLocation: json['dev_location']?.toString(),
      devLon: _toDouble(json['dev_lon']),
      devLat: _toDouble(json['dev_lat']),
      devAlt: _toDouble(json['dev_alt']),
      devSts: _toInt(json['dev_sts']),
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
      sensLat: _toDouble(json['sens_lat']),
      sensLon: _toDouble(json['sens_lon']),
      sensAlt: _toDouble(json['sens_alt']),
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
    final dsId =
        _firstOf(json, ['ds_id', 'dsId', 'device_sensor_id'])?.toString() ?? '';
    final devId =
        _firstOf(json, ['dev_id', 'devId', 'device_id'])?.toString() ?? '';
    final readUpdateId =
        _firstOf(json, ['read_update_id', 'readUpdateId', 'id'])?.toString() ??
        (devId.isNotEmpty && dsId.isNotEmpty ? '$devId-$dsId' : '');

    return SensorReadUpdate(
      readUpdateId: readUpdateId,
      dsId: dsId,
      devId: devId,
      readUpdateDate: _toDateTime(
        _firstOf(json, [
          'read_update_date',
          'readUpdateDate',
          'read_update_at',
          'readUpdateAt',
          'read_update_time',
          'read_date',
          'readDate',
          'updated_at',
          'updatedAt',
          'created_at',
          'timestamp',
          'date',
          'time',
        ]),
      ),
      readUpdateValue: _firstOf(json, [
        'read_update_value',
        'readUpdateValue',
        'read_value',
        'readValue',
        'value',
        'val',
      ])?.toString(),
    );
  }

  double? get parsedValue => _toDouble(readUpdateValue);
  double get numericValue => parsedValue ?? 0.0;
  bool get hasNumericValue => parsedValue != null;
  bool get hasValue => readUpdateValue != null && readUpdateValue!.isNotEmpty;
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
    final dsId = _firstOf(json, [
      'ds_id',
      'dsId',
      'device_sensor_id',
    ])?.toString();
    final devId = _firstOf(json, ['dev_id', 'devId', 'device_id'])?.toString();
    final date = _toDateTime(
      _firstOf(json, [
        'read_date',
        'readDate',
        'read_update_date',
        'readUpdateDate',
        'read_at',
        'readAt',
        'read_time',
        'created_at',
        'createdAt',
        'timestamp',
        'date',
        'time',
        'day',
      ]),
    );
    final readId =
        _firstOf(json, ['read_id', 'readId', 'id', 'log_rx_id'])?.toString() ??
        [
          if (devId != null && devId.isNotEmpty) devId,
          if (dsId != null && dsId.isNotEmpty) dsId,
          if (date != null) date.toIso8601String(),
        ].join('-');

    return SensorReadModel(
      readId: readId,
      dsId: dsId,
      devId: devId,
      readDate: date,
      readValue: _firstOf(json, [
        'read_value',
        'readValue',
        'read_update_value',
        'readUpdateValue',
        'value',
        'val',
        'avg_val',
        'avgValue',
        'average',
        'avg',
      ])?.toString(),
      readSts: _toInt(_firstOf(json, ['read_sts', 'readStatus', 'status'])),
    );
  }

  double? get parsedValue => _toDouble(readValue);
  double get numericValue => parsedValue ?? 0.0;
  bool get hasNumericValue => parsedValue != null;
  bool get isValid => hasNumericValue;
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
      day: _toDateTime(
        _firstOf(json, ['day', 'date', 'read_date', 'created_at']),
      ),
      devId: _firstOf(json, ['dev_id', 'devId', 'device_id'])?.toString() ?? '',
      dsId:
          _firstOf(json, ['ds_id', 'dsId', 'device_sensor_id'])?.toString() ??
          '',
      avgVal: _toDouble(
        _firstOf(json, [
          'avg_val',
          'avgVal',
          'avgValue',
          'avg_value',
          'average',
          'avg',
        ]),
      ),
      minVal: _toDouble(
        _firstOf(json, [
          'min_val',
          'minVal',
          'minValue',
          'min_value',
          'minimum',
          'min',
        ]),
      ),
      maxVal: _toDouble(
        _firstOf(json, [
          'max_val',
          'maxVal',
          'maxValue',
          'max_value',
          'maximum',
          'max',
        ]),
      ),
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

class DeviceSensorThresholdModel {
  final String dsId;
  final String? devId;
  final String? sensId;
  final String? dsName;
  final String? sensName;
  final String? unitId;
  final String? unitSymbol;
  final String? unitName;
  final double? dsMaxNormValue;
  final double? dsMinNormValue;
  final double? dsMaxValWarn;
  final double? dsMinValWarn;
  final double? dsMaxValue;
  final double? dsMinValue;

  const DeviceSensorThresholdModel({
    required this.dsId,
    this.devId,
    this.sensId,
    this.dsName,
    this.sensName,
    this.unitId,
    this.unitSymbol,
    this.unitName,
    this.dsMaxNormValue,
    this.dsMinNormValue,
    this.dsMaxValWarn,
    this.dsMinValWarn,
    this.dsMaxValue,
    this.dsMinValue,
  });

  factory DeviceSensorThresholdModel.fromJson(Map<String, dynamic> json) {
    final unit = json['unit'];
    final sensor = json['sensor'];
    final unitMap = unit is Map<String, dynamic> ? unit : null;
    final sensorMap = sensor is Map<String, dynamic> ? sensor : null;

    return DeviceSensorThresholdModel(
      dsId: json['ds_id']?.toString() ?? '',
      devId: json['dev_id']?.toString(),
      sensId: json['sens_id']?.toString() ?? sensorMap?['sens_id']?.toString(),
      dsName: json['ds_name']?.toString(),
      sensName:
          json['sens_name']?.toString() ?? sensorMap?['sens_name']?.toString(),
      unitId: json['unit_id']?.toString() ?? unitMap?['unit_id']?.toString(),
      unitSymbol:
          json['unit_symbol']?.toString() ??
          unitMap?['unit_symbol']?.toString(),
      unitName:
          json['unit_name']?.toString() ?? unitMap?['unit_name']?.toString(),
      dsMaxNormValue: _toDouble(json['ds_max_norm_value']),
      dsMinNormValue: _toDouble(json['ds_min_norm_value']),
      dsMaxValWarn: _toDouble(json['ds_max_val_warn']),
      dsMinValWarn: _toDouble(json['ds_min_val_warn']),
      dsMaxValue: _toDouble(json['ds_max_value']),
      dsMinValue: _toDouble(json['ds_min_value']),
    );
  }

  String get compositeKey => '${devId ?? ''}|$dsId';
  bool get hasNormalRange => dsMinNormValue != null || dsMaxNormValue != null;
  bool get hasWarnRange => dsMinValWarn != null || dsMaxValWarn != null;
  bool get hasAbsoluteRange => dsMinValue != null || dsMaxValue != null;
}

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

  static int colorValue(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return 0xFFFF8A65;
      case 'env_hum':
        return 0xFF42A5F5;
      case 'soil_nitro':
        return 0xFF66BB6A;
      case 'soil_phos':
        return 0xFFAB47BC;
      case 'soil_pot':
        return 0xFFFF7043;
      case 'soil_ph':
        return 0xFF26C6DA;
      case 'soil_temp':
        return 0xFF8BC34A;
      case 'soil_hum':
        return 0xFF29B6F6;
      default:
        return 0xFF4CAF50;
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
      month: _monthLabel(_firstOf(json, ['month', 'day', 'date'])),
      devId: _firstOf(json, ['dev_id', 'devId', 'device_id'])?.toString() ?? '',
      dsId:
          _firstOf(json, ['ds_id', 'dsId', 'device_sensor_id'])?.toString() ??
          '',
      avgVal: _toDouble(
        _firstOf(json, [
          'avg_val',
          'avgVal',
          'avgValue',
          'avg_value',
          'average',
          'avg',
        ]),
      ),
      minVal: _toDouble(
        _firstOf(json, [
          'min_val',
          'minVal',
          'minValue',
          'min_value',
          'minimum',
          'min',
        ]),
      ),
      maxVal: _toDouble(
        _firstOf(json, [
          'max_val',
          'maxVal',
          'maxValue',
          'max_value',
          'maximum',
          'max',
        ]),
      ),
    );
  }

  static List<MonthlyRekapModel> fromBackendJson(Map<String, dynamic> json) {
    final dayReads =
        json['day_reads'] ??
        json['dayReads'] ??
        json['reads'] ??
        json['items'] ??
        json['rows'];
    if (dayReads is! List) return [MonthlyRekapModel.fromJson(json)];

    final rows = dayReads
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
    if (rows.isEmpty) return [];

    final month = _monthLabel(
      _firstOf(json, ['month', 'date']) ??
          _firstOf(rows.first, ['day', 'date', 'read_date']),
    );
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final row in rows) {
      final devId =
          _firstOf(row, ['dev_id', 'devId', 'device_id'])?.toString() ?? '';
      final dsId =
          _firstOf(row, ['ds_id', 'dsId', 'device_sensor_id'])?.toString() ??
          '';
      if (dsId.isEmpty) continue;
      final key = '$devId|$dsId';
      grouped.putIfAbsent(key, () => []).add(row);
    }

    return grouped.entries.map((entry) {
      final first = entry.value.first;
      return MonthlyRekapModel(
        month: month,
        devId:
            _firstOf(first, ['dev_id', 'devId', 'device_id'])?.toString() ?? '',
        dsId:
            _firstOf(first, [
              'ds_id',
              'dsId',
              'device_sensor_id',
            ])?.toString() ??
            '',
        avgVal: _average(
          entry.value.map(
            (row) => _toDouble(
              _firstOf(row, [
                'avg_val',
                'avgVal',
                'avgValue',
                'avg_value',
                'average',
                'avg',
              ]),
            ),
          ),
        ),
        minVal: _minValue(
          entry.value.map(
            (row) => _toDouble(
              _firstOf(row, [
                'min_val',
                'minVal',
                'minValue',
                'min_value',
                'minimum',
                'min',
              ]),
            ),
          ),
        ),
        maxVal: _maxValue(
          entry.value.map(
            (row) => _toDouble(
              _firstOf(row, [
                'max_val',
                'maxVal',
                'maxValue',
                'max_value',
                'maximum',
                'max',
              ]),
            ),
          ),
        ),
      );
    }).toList();
  }
}
