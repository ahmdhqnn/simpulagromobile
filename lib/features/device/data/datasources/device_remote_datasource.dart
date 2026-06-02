import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/response_parser.dart';
import '../../domain/entities/device.dart';
import '../models/device_model.dart';

class DeviceRemoteDataSource {
  final Dio _dio;

  DeviceRemoteDataSource(this._dio);

  /// Get all devices for a site
  /// GET /api/sites/:siteId/devices
  Future<List<DeviceModel>> getDevices(String siteId) async {
    final response = await _dio.get(ApiEndpoints.devices(siteId));
    final data = ResponseParser.extractDataList(response.data);
    return data
        .whereType<Map>()
        .map(
          (json) => DeviceModel.fromJson(
            _normalizeDevice(Map<String, dynamic>.from(json)),
          ),
        )
        .toList();
  }

  /// Normalize device JSON — API sometimes returns dev_sts as String
  Map<String, dynamic> _normalizeDevice(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    final sts = normalized['dev_sts'];
    if (sts is String) normalized['dev_sts'] = int.tryParse(sts);
    return normalized;
  }

  /// Get device by ID
  Future<DeviceModel> getDeviceById(String siteId, String devId) async {
    final response = await _dio.get(ApiEndpoints.deviceById(siteId, devId));
    return DeviceModel.fromJson(
      _normalizeDevice(ResponseParser.extractDataMap(response.data)),
    );
  }

  /// Get device coordinates
  Future<List<DeviceModel>> getDeviceCoordinates(String siteId) async {
    final response = await _dio.get(ApiEndpoints.deviceCoordinates(siteId));
    final data = ResponseParser.extractDataList(response.data);
    return data.whereType<Map>().map((json) {
      return DeviceModel.fromJson(
        _normalizeDevice(Map<String, dynamic>.from(json)),
      );
    }).toList();
  }

  /// Create new device
  Future<DeviceModel> createDevice(String siteId, Device device) async {
    final response = await _dio.post(
      ApiEndpoints.addDevice(siteId),
      data: {
        'dev_id': device.devId,
        'dev_name': device.devName,
        'dev_location': device.devLocation,
        'dev_lon': device.devLon,
        'dev_lat': device.devLat,
        'dev_alt': device.devAlt,
        'dev_number_id': device.devNumberId,
        'dev_ip': device.devIp,
        'dev_port': device.devPort,
        'dev_sts': device.devSts ?? 1,
      },
    );
    return DeviceModel.fromJson(
      _normalizeDevice(ResponseParser.extractDataMap(response.data)),
    );
  }

  /// Update device
  Future<DeviceModel> updateDevice(
    String siteId,
    String devId,
    Device device,
  ) async {
    final response = await _dio.put(
      ApiEndpoints.deviceById(siteId, devId),
      data: {
        'dev_name': device.devName,
        'dev_location': device.devLocation,
        'dev_lon': device.devLon,
        'dev_lat': device.devLat,
        'dev_alt': device.devAlt,
        'dev_number_id': device.devNumberId,
        'dev_ip': device.devIp,
        'dev_port': device.devPort,
        'dev_sts': device.devSts,
      },
    );
    return DeviceModel.fromJson(
      _normalizeDevice(ResponseParser.extractDataMap(response.data)),
    );
  }

  /// Delete device
  Future<void> deleteDevice(String siteId, String devId) async {
    await _dio.delete(ApiEndpoints.deviceById(siteId, devId));
  }
}
