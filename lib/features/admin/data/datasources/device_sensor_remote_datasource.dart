import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/response_parser.dart';
import '../models/device_sensor_model.dart';

abstract class DeviceSensorRemoteDatasource {
  Future<List<DeviceSensorModel>> getAllDeviceSensors(String siteId);
  Future<List<Map<String, dynamic>>> getThresholdValues(String siteId);
  Future<DeviceSensorModel> getDeviceSensorById(
    String siteId,
    String dsId, {
    String? devId,
  });
  Future<DeviceSensorModel> createDeviceSensor(
    String siteId,
    Map<String, dynamic> data,
  );
  Future<DeviceSensorModel> updateDeviceSensor(
    String siteId,
    String dsId,
    String devId,
    Map<String, dynamic> data,
  );
  Future<void> deleteDeviceSensor(String siteId, String dsId, String devId);
}

class DeviceSensorRemoteDatasourceImpl implements DeviceSensorRemoteDatasource {
  final Dio dio;

  DeviceSensorRemoteDatasourceImpl(this.dio);

  @override
  Future<List<DeviceSensorModel>> getAllDeviceSensors(String siteId) async {
    try {
      final response = await dio.get(ApiEndpoints.deviceSensors(siteId));
      final data = response.data;
      if (data == null) throw Exception('Response data is null');

      // API returns {"message":"...", "data":[]} — handle empty gracefully
      final dsData = ResponseParser.extractDataList(data);

      return dsData
          .whereType<Map>()
          .map(
            (json) => DeviceSensorModel.fromJson(
              _normalizeDs(Map<String, dynamic>.from(json)),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get device sensors: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getThresholdValues(String siteId) async {
    List<Map<String, dynamic>> rows = const [];
    try {
      final response = await dio.get(ApiEndpoints.deviceSensorValues(siteId));
      rows = _extractRows(response.data)
          .whereType<Map>()
          .map((json) => Map<String, dynamic>.from(json))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) {
        throw _handleDioError(e);
      }
    }

    try {
      final mappings = await getAllDeviceSensors(siteId);
      if (rows.isEmpty) {
        return mappings
            .map(_mappingToThresholdRow)
            .where(_hasThreshold)
            .toList();
      }
      return _mergeThresholdRows(rows, mappings);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (_) {
      return rows;
    }
  }

  @override
  Future<DeviceSensorModel> getDeviceSensorById(
    String siteId,
    String dsId, {
    String? devId,
  }) async {
    try {
      // Fetch all and filter — avoids "not found" on single endpoint
      final all = await getAllDeviceSensors(siteId);
      final found = all
          .where(
            (ds) => ds.dsId == dsId && (devId == null || ds.devId == devId),
          )
          .firstOrNull;
      if (found == null) throw Exception('Device Sensor tidak ditemukan');
      return _mergeThresholdValues(siteId, found);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensorModel> createDeviceSensor(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.deviceSensors(siteId),
        data: data,
      );
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      return DeviceSensorModel.fromJson(
        _normalizeDs(ResponseParser.extractDataMap(responseData)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to create device sensor: $e');
    }
  }

  @override
  Future<DeviceSensorModel> updateDeviceSensor(
    String siteId,
    String dsId,
    String devId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.put(
        ApiEndpoints.deviceSensorById(siteId, dsId, devId),
        data: data,
      );
      final responseData = response.data;
      if (responseData == null) throw Exception('Response data is null');

      return DeviceSensorModel.fromJson(
        _normalizeDs(ResponseParser.extractDataMap(responseData)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update device sensor: $e');
    }
  }

  @override
  Future<void> deleteDeviceSensor(
    String siteId,
    String dsId,
    String devId,
  ) async {
    throw const UnsupportedBackendEndpointException(
      'Hapus device sensor belum didukung oleh server',
    );
  }

  /// Normalize device sensor JSON — API sometimes returns sts/seq as String
  Map<String, dynamic> _normalizeDs(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    const stringKeys = [
      'ds_id',
      'dev_id',
      'unit_id',
      'sens_id',
      'ds_name',
      'ds_address',
    ];
    for (final key in stringKeys) {
      final value = normalized[key];
      if (value != null && value is! String) {
        normalized[key] = value.toString();
      }
    }
    normalized['ds_sts'] = _toInt(normalized['ds_sts']);
    normalized['ds_seq'] = _toInt(normalized['ds_seq']);
    normalized['ds_seq'] ??= _toInt(normalized['ds_sequence']);
    return normalized;
  }

  Future<DeviceSensorModel> _mergeThresholdValues(
    String siteId,
    DeviceSensorModel mapping,
  ) async {
    try {
      final rows = await getThresholdValues(siteId);
      final thresholdRow = rows.where((row) {
        final dsId = _stringValue(
          row['ds_id'] ??
              row['dsId'] ??
              row['device_sensor_id'] ??
              row['deviceSensorId'],
        );
        final devId = _stringValue(
          row['dev_id'] ?? row['devId'] ?? row['device_id'] ?? row['deviceId'],
        );
        if (dsId != mapping.dsId) return false;
        return devId == null || devId == mapping.devId;
      }).firstOrNull;

      if (thresholdRow == null) return mapping;

      final merged = Map<String, dynamic>.from(mapping.toJson());
      for (final entry in thresholdRow.entries) {
        if (entry.value != null) merged[entry.key] = entry.value;
      }
      merged['ds_id'] = mapping.dsId;
      merged['dev_id'] = mapping.devId;
      merged['unit_id'] ??= mapping.unitId;
      merged['sens_id'] ??= mapping.sensId;
      merged['ds_name'] ??= mapping.dsName;
      merged['ds_address'] ??= mapping.dsAddress;
      merged['ds_seq'] ??= mapping.dsSeq;
      merged['ds_sts'] ??= mapping.dsSts;
      merged['ds_created'] ??= mapping.dsCreated?.toIso8601String();
      merged['ds_update'] ??= mapping.dsUpdate?.toIso8601String();

      return DeviceSensorModel.fromJson(_normalizeDs(merged));
    } catch (_) {
      return mapping;
    }
  }

  List<Map<String, dynamic>> _mergeThresholdRows(
    List<Map<String, dynamic>> rows,
    List<DeviceSensorModel> mappings,
  ) {
    final byCompositeKey = <String, DeviceSensorModel>{};
    final byDsId = <String, DeviceSensorModel>{};
    final duplicateDsIds = <String>{};

    for (final mapping in mappings) {
      byCompositeKey[_thresholdKey(mapping.dsId, mapping.devId)] = mapping;
      if (byDsId.containsKey(mapping.dsId)) {
        duplicateDsIds.add(mapping.dsId);
      } else {
        byDsId[mapping.dsId] = mapping;
      }
    }

    return rows.map((row) {
      final dsId = _stringValue(
        row['ds_id'] ??
            row['dsId'] ??
            row['device_sensor_id'] ??
            row['deviceSensorId'],
      );
      final devId = _stringValue(
        row['dev_id'] ?? row['devId'] ?? row['device_id'] ?? row['deviceId'],
      );
      final mapping = dsId == null
          ? null
          : devId != null
          ? byCompositeKey[_thresholdKey(dsId, devId)]
          : duplicateDsIds.contains(dsId)
          ? null
          : byDsId[dsId];

      if (mapping == null) return row;

      final merged = _mappingToThresholdRow(mapping);
      for (final entry in row.entries) {
        if (entry.value != null) merged[entry.key] = entry.value;
      }
      return merged;
    }).toList();
  }

  Map<String, dynamic> _mappingToThresholdRow(DeviceSensorModel mapping) {
    final row = <String, dynamic>{};
    void put(String key, Object? value) {
      if (value != null) row[key] = value;
    }

    put('ds_id', mapping.dsId);
    put('dev_id', mapping.devId);
    put('unit_id', mapping.unitId);
    put('sens_id', mapping.sensId);
    put('dc_normal_value', mapping.dcNormalValue);
    put('ds_min_norm_value', mapping.dsMinNormValue);
    put('ds_max_norm_value', mapping.dsMaxNormValue);
    put('ds_min_value', mapping.dsMinValue);
    put('ds_max_value', mapping.dsMaxValue);
    put('ds_min_val_warn', mapping.dsMinValWarn);
    put('ds_max_val_warn', mapping.dsMaxValWarn);
    put('ds_name', mapping.dsName);
    put('ds_address', mapping.dsAddress);
    put('ds_seq', mapping.dsSeq);
    put('ds_sts', mapping.dsSts);
    put('ds_created', mapping.dsCreated?.toIso8601String());
    put('ds_update', mapping.dsUpdate?.toIso8601String());
    return row;
  }

  bool _hasThreshold(Map<String, dynamic> row) {
    const keys = [
      'dc_normal_value',
      'ds_min_norm_value',
      'ds_max_norm_value',
      'ds_min_value',
      'ds_max_value',
      'ds_min_val_warn',
      'ds_max_val_warn',
    ];
    return keys.any((key) => row[key] != null);
  }

  String _thresholdKey(String dsId, String devId) => '$dsId\x1F$devId';

  List<dynamic> _extractRows(dynamic data) {
    if (data is Map) {
      const keys = [
        'data',
        'values',
        'threshold_values',
        'thresholdValues',
        'thresholds',
        'ranges',
        'device_sensor_values',
        'deviceSensorValues',
        'device_sensors',
        'deviceSensors',
        'rows',
        'items',
        'results',
      ];
      for (final key in keys) {
        final value = data[key];
        if (value is List) return value;
        if (value is Map) {
          final nested = _extractRows(value);
          if (nested.isNotEmpty) return nested;
        }
      }

      if (_stringValue(data['ds_id'] ?? data['dsId']) != null) {
        return [data];
      }
    }

    final parsed = ResponseParser.extractDataList(data);
    if (parsed.isNotEmpty) return parsed;

    return [];
  }

  String? _stringValue(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is bool) return value ? 1 : 0;
    if (value is String) {
      final text = value.trim().toLowerCase();
      if (text == 'active' ||
          text == 'aktif' ||
          text == 'enabled' ||
          text == 'true') {
        return 1;
      }
      if (text == 'inactive' ||
          text == 'nonaktif' ||
          text == 'disabled' ||
          text == 'false') {
        return 0;
      }
      return int.tryParse(text);
    }
    return null;
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Koneksi timeout. Periksa koneksi internet Anda.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = ResponseParser.extractMessage(
          error.response?.data,
          'Terjadi kesalahan: $statusCode',
        );
        switch (statusCode) {
          case 400:
            return Exception(message);
          case 401:
            return Exception(
              'Sesi Anda telah berakhir. Silakan login kembali.',
            );
          case 403:
            return Exception(
              'Anda tidak memiliki izin untuk melakukan aksi ini',
            );
          case 404:
            return Exception('Device Sensor tidak ditemukan');
          case 409:
            return Exception('Mapping ini sudah ada');
          case 500:
            return Exception('Terjadi kesalahan pada server');
          default:
            return Exception(message);
        }
      case DioExceptionType.connectionError:
        return Exception('Tidak dapat terhubung ke server.');
      default:
        return Exception('Terjadi kesalahan: ${error.message}');
    }
  }
}
