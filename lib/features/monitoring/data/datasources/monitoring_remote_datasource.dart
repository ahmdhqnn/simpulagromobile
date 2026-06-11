import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
import '../models/monitoring_models.dart';

Iterable<Map<String, dynamic>> _dataMaps(dynamic responseData) {
  return ResponseParser.extractDataList(
    responseData,
  ).whereType<Map>().map((item) => Map<String, dynamic>.from(item));
}

Iterable<Map<String, dynamic>> _siteDataMaps(
  dynamic responseData,
  String siteId,
) {
  return _dataMaps(responseData).where((item) => _matchesSite(item, siteId));
}

bool _matchesSite(Map<String, dynamic> item, String siteId) {
  final rawSiteId = item['site_id'] ?? item['siteId'];
  if (rawSiteId == null) return true;
  return rawSiteId.toString() == siteId;
}

bool _isExpectedEmptyResponse(DioException e) {
  final status = e.response?.statusCode;
  if (status == 400 || status == 404 || status == 422) return true;
  if (status != 500) return false;
  final body = e.response?.data;
  final message = body is Map
      ? [body['message'], body['error']]
            .whereType<Object>()
            .map((value) => value.toString())
            .join(' ')
            .toLowerCase()
      : body?.toString().toLowerCase() ?? '';
  return message.contains('no data') ||
      message.contains('plant recommendation') ||
      message.contains('recommend-plant') ||
      message.contains('not found') ||
      message.contains('tidak ada') ||
      message.contains('belum ada');
}

bool _isRecoverableDailyRecapError(DioException e) {
  final status = e.response?.statusCode ?? 0;
  if (status != 500 && status != 502 && status != 503 && status != 504) {
    return false;
  }
  final body = e.response?.data;
  final message = body is Map
      ? [
          body['message'],
          body['error'],
          body['details'],
        ].whereType<Object>().map((value) => value.toString()).join(' ')
      : body?.toString() ?? '';
  final normalized = message.toLowerCase();
  if (normalized.isEmpty) return true;
  return normalized.contains('database') ||
      normalized.contains('db') ||
      normalized.contains('query') ||
      normalized.contains('server') ||
      normalized.contains('timeout') ||
      normalized.contains('connection');
}

String _todayString() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

String _monthKey(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}';
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

class MonitoringRemoteDataSource {
  final Dio _dio;

  const MonitoringRemoteDataSource(this._dio);

  // ── Realtime ────────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/reads/updates
  /// Nilai sensor terkini per ds_id.
  Future<List<SensorReadUpdate>> getLatestReads(
    String siteId, {
    String? sensId,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (sensId != null && sensId.isNotEmpty) {
      queryParameters['sens_id'] = sensId;
    }

    final res = await _dio.get(
      ApiEndpoints.readsUpdates(siteId),
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    return _siteDataMaps(
      res.data,
      siteId,
    ).map(SensorReadUpdate.fromJson).toList();
  }

  // ── History ─────────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/reads?today=true
  Future<List<SensorReadModel>> getTodayReads(String siteId) async {
    return _getRawReads(siteId, queryParameters: const {'today': 'true'});
  }

  /// GET /api/sites/:siteId/reads/seven-day
  Future<List<SensorReadModel>> getSevenDayReads(String siteId) async {
    final res = await _dio.get(ApiEndpoints.readsSevenDay(siteId));
    return _siteDataMaps(
      res.data,
      siteId,
    ).map(SensorReadModel.fromJson).toList();
  }

  /// GET /api/sites/:siteId/reads?startDate=&endDate=
  Future<List<SensorReadModel>> getDateRangeReads(
    String siteId, {
    required String startDate,
    required String endDate,
  }) async {
    return _getRawReads(
      siteId,
      queryParameters: {'startDate': startDate, 'endDate': endDate},
    );
  }

  /// GET /api/sites/:siteId/reads?date=YYYY-MM-DD
  Future<List<SensorReadModel>> getReadsByDate(
    String siteId,
    String date,
  ) async {
    return _getRawReads(siteId, queryParameters: {'date': date});
  }

  Future<List<SensorReadModel>> _getRawReads(
    String siteId, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final res = await _dio.get(
      ApiEndpoints.reads(siteId),
      queryParameters: queryParameters,
    );
    return _siteDataMaps(
      res.data,
      siteId,
    ).map(SensorReadModel.fromJson).toList();
  }

  /// GET /api/sites/:siteId/reads/planting-date
  Future<List<SensorReadModel>> getPlantingDateReads(String siteId) async {
    final res = await _dio.get(ApiEndpoints.readsPlantingDate(siteId));
    return _siteDataMaps(
      res.data,
      siteId,
    ).map(SensorReadModel.fromJson).toList();
  }

  /// GET /api/sites/:siteId/reads/daily
  /// Agregasi harian (avg/min/max) per ds_id.
  Future<List<SensorDailyModel>> getDailyReads(String siteId) async {
    final res = await _dio.get(ApiEndpoints.readsDaily(siteId));
    return _siteDataMaps(
      res.data,
      siteId,
    ).map(SensorDailyModel.fromJson).toList();
  }

  // ── Devices & Sensors ───────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/devices
  /// Device beserta nested sensor list (key 'sensor' atau 'sensors').
  Future<List<DeviceModel>> getDevices(String siteId) async {
    final res = await _dio.get(ApiEndpoints.devices(siteId));
    final devices = _siteDataMaps(
      res.data,
      siteId,
    ).map(DeviceModel.fromJson).toList();
    if (devices.isEmpty ||
        devices.every((device) => device.sensors.isNotEmpty)) {
      return devices;
    }

    try {
      final sensors = await _loadSiteSensors(siteId);
      return _mergeDevicesWithSiteSensors(devices, sensors);
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e)) return devices;
      rethrow;
    }
  }

  /// GET /api/sites/:siteId/sensors
  /// Jumlah total sensor yang terdaftar di site.
  Future<int> getSensorCount(String siteId) async {
    final res = await _dio.get(ApiEndpoints.sensors(siteId));
    return _siteDataMaps(res.data, siteId).length;
  }

  Future<List<SensorModel>> _loadSiteSensors(String siteId) async {
    final res = await _dio.get(ApiEndpoints.sensors(siteId));
    return _siteDataMaps(res.data, siteId)
        .map((item) => SensorModel.fromJson(item, fallbackSiteId: siteId))
        .toList();
  }

  List<DeviceModel> _mergeDevicesWithSiteSensors(
    List<DeviceModel> devices,
    List<SensorModel> sensors,
  ) {
    if (sensors.isEmpty) return devices;

    final sensorsByDevice = <String, List<SensorModel>>{};
    for (final sensor in sensors) {
      final devId = sensor.devId;
      if (devId == null || devId.isEmpty) continue;
      sensorsByDevice.putIfAbsent(devId, () => []).add(sensor);
    }

    return devices.map((device) {
      final siteSensors =
          sensorsByDevice[device.devId] ?? const <SensorModel>[];
      if (siteSensors.isEmpty) return device;
      if (device.sensors.isEmpty) {
        return device.copyWith(sensors: siteSensors);
      }

      final merged = <String, SensorModel>{
        for (final sensor in device.sensors) sensor.sensId: sensor,
      };
      for (final sensor in siteSensors) {
        merged.putIfAbsent(sensor.sensId, () => sensor);
      }
      return device.copyWith(sensors: merged.values.toList());
    }).toList();
  }

  /// GET /api/sites/:siteId/device-sensors/values
  /// Metadata threshold canonical untuk status sensor.
  Future<List<DeviceSensorThresholdModel>> getDeviceSensorThresholdValues(
    String siteId,
  ) async {
    try {
      final res = await _dio.get(ApiEndpoints.deviceSensorValues(siteId));
      return _siteDataMaps(
        res.data,
        siteId,
      ).map(DeviceSensorThresholdModel.fromJson).toList();
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e)) return [];
      rethrow;
    }
  }

  // ── Logs ────────────────────────────────────────────────────────────────────

  /// GET /api/sites/logs
  /// Log payload MQTT terbaru.
  Future<List<LogModel>> getLogs() async {
    throw const UnsupportedBackendEndpointException();
  }

  // ── Analytics ───────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/agro/environmental-health
  Future<Map<String, dynamic>> getEnvironmentalHealth(String siteId) async {
    final res = await _dio.get(ApiEndpoints.envHealth(siteId));
    return ResponseParser.extractDataMap(res.data);
  }

  /// GET /api/sites/:siteId/recommendations/plant-by-site
  Future<Map<String, dynamic>> getPlantRecommendation(String siteId) async {
    try {
      final res = await _dio.get(ApiEndpoints.plantRecBySite(siteId));
      final data = _siteDataMap(res.data, siteId);
      return data;
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e)) return <String, dynamic>{};
      rethrow;
    }
  }

  Map<String, dynamic> _siteDataMap(dynamic responseData, String siteId) {
    final data = ResponseParser.extractDataMap(responseData);
    return _matchesSite(data, siteId) ? data : <String, dynamic>{};
  }

  // ── Alarms ──────────────────────────────────────────────────────────────────

  /// GET /api/sites/alarms/data
  /// Alarm lengkap beserta kode alarm (join).
  Future<List<AlarmDataModel>> getAlarmData() async {
    throw const UnsupportedBackendEndpointException();
  }

  // ── Monthly Rekap ────────────────────────────────────────────────────────────

  /// GET /api/sites/:siteId/reads/mounth
  /// Rekap bulanan sensor (avg/min/max) per ds_id.
  Future<List<MonthlyRekapModel>> getMonthlyReads(String siteId) async {
    try {
      final res = await _dio.get(ApiEndpoints.readsMonthly(siteId));
      return _siteDataMaps(
        res.data,
        siteId,
      ).expand(MonthlyRekapModel.fromBackendJson).toList();
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e)) return [];
      if (_isRecoverableDailyRecapError(e)) {
        return _loadMonthlyFromDailyReads(siteId);
      }
      rethrow;
    }
  }

  Future<List<MonthlyRekapModel>> _loadMonthlyFromDailyReads(
    String siteId,
  ) async {
    try {
      final dailyReads = await getDailyReads(siteId);
      return _aggregateMonthlyFromDailyReads(dailyReads);
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e) || _isRecoverableDailyRecapError(e)) {
        return [];
      }
      rethrow;
    }
  }

  List<MonthlyRekapModel> _aggregateMonthlyFromDailyReads(
    List<SensorDailyModel> dailyReads,
  ) {
    final grouped = <String, List<SensorDailyModel>>{};
    for (final item in dailyReads) {
      final day = item.day;
      if (day == null || item.dsId.isEmpty) continue;
      final key = '${_monthKey(day)}|${item.devId}|${item.dsId}';
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final rows =
        grouped.entries.map((entry) {
          final first = entry.value.first;
          final month = _monthKey(first.day!);
          return MonthlyRekapModel(
            month: month,
            devId: first.devId,
            dsId: first.dsId,
            avgVal: _average(entry.value.map((row) => row.avgVal)),
            minVal: _minValue(entry.value.map((row) => row.minVal)),
            maxVal: _maxValue(entry.value.map((row) => row.maxVal)),
          );
        }).toList()..sort((a, b) {
          final monthCompare = a.month.compareTo(b.month);
          if (monthCompare != 0) return monthCompare;
          final devCompare = a.devId.compareTo(b.devId);
          if (devCompare != 0) return devCompare;
          return a.dsId.compareTo(b.dsId);
        });

    return rows;
  }

  // ── Daily recap (today / by-day) ─────────────────────────────────────────────

  /// GET /sites/{siteId}/reads/daily/today
  Future<List<SensorDailyModel>> getDailyToday(String siteId) async {
    final day = _todayString();
    try {
      final res = await _dio.get(ApiEndpoints.readsDailyToday(siteId));
      return _siteDataMaps(
        res.data,
        siteId,
      ).map(SensorDailyModel.fromJson).toList();
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e)) return [];
      if (_isRecoverableDailyRecapError(e)) {
        return _loadDailyTodayFallback(siteId, day);
      }
      rethrow;
    }
  }

  /// GET /sites/{siteId}/reads/daily/by-day?day=YYYY-MM-DD
  Future<List<SensorDailyModel>> getDailyByDay(
    String siteId,
    String day,
  ) async {
    try {
      return _loadDailyByDay(siteId, day);
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e)) return [];
      rethrow;
    }
  }

  Future<List<SensorDailyModel>> _loadDailyTodayFallback(
    String siteId,
    String day,
  ) async {
    try {
      return await _loadDailyByDay(siteId, day);
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e)) return [];
      if (!_isRecoverableDailyRecapError(e)) rethrow;
    }

    try {
      final allDaily = await getDailyReads(siteId);
      return allDaily.where((item) => _isSameDay(item.day, day)).toList();
    } on DioException catch (e) {
      if (_isExpectedEmptyResponse(e)) return [];
      if (_isRecoverableDailyRecapError(e)) return [];
      rethrow;
    }
  }

  Future<List<SensorDailyModel>> _loadDailyByDay(
    String siteId,
    String day,
  ) async {
    final res = await _dio.get(
      ApiEndpoints.readsDailyByDay(siteId),
      queryParameters: {'day': day},
    );
    return _siteDataMaps(
      res.data,
      siteId,
    ).map(SensorDailyModel.fromJson).toList();
  }

  bool _isSameDay(DateTime? date, String day) {
    if (date == null) return false;
    final itemDay =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return itemDay == day;
  }

  /// POST /sites/{siteId}/reads/daily/rekap  body: { "day": "YYYY-MM-DD" }
  Future<void> triggerDailyRekap(String siteId, String day) async {
    await _dio.post(ApiEndpoints.readsRekapDaily(siteId), data: {'day': day});
  }

  /// PUT /sites/{siteId}/reads/{id}
  Future<SensorReadModel> updateRead(
    String siteId,
    String readId, {
    double? readValue,
    String? readSts,
  }) async {
    final body = <String, dynamic>{};
    if (readValue != null) body['read_value'] = readValue;
    if (readSts != null) body['read_sts'] = readSts;
    final res = await _dio.put(
      ApiEndpoints.updateRead(siteId, readId),
      data: body,
    );
    final data = ResponseParser.extractDataMap(res.data);
    return SensorReadModel.fromJson(data);
  }
}
