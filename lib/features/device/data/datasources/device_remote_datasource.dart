import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../domain/entities/device.dart';
import '../models/device_model.dart';

class DeviceRemoteDataSource {
  final Dio _dio;

  DeviceRemoteDataSource(this._dio);

  /// Get all devices for a site
  Future<List<DeviceModel>> getDevices(String siteId) async {
    // TODO: Replace with real API when backend is ready
    // Uncomment when ready:
    // final response = await _dio.get(ApiEndpoints.devices(siteId));
    // final data = response.data['data'] as List;
    // return data.map((json) => DeviceModel.fromJson(json)).toList();

    // MOCK DATA - Remove when backend is ready
    await Future.delayed(const Duration(seconds: 1));
    return [
      DeviceModel(
        devId: 'TELU0300',
        siteId: siteId,
        devName: 'Device Sensor 1',
        devLocation: 'Area Sawah A',
        devLon: 107.630332,
        devLat: -6.973123,
        devAlt: 28.0,
        devNumberId: 'D001',
        devIp: '192.168.1.100',
        devPort: '8080',
        devSts: 1,
      ),
      DeviceModel(
        devId: 'TELU0301',
        siteId: siteId,
        devName: 'Device Sensor 2',
        devLocation: 'Area Sawah B',
        devLon: 107.631000,
        devLat: -6.974000,
        devAlt: 30.0,
        devNumberId: 'D002',
        devIp: '192.168.1.101',
        devPort: '8080',
        devSts: 1,
      ),
    ];
  }

  /// Get device by ID
  Future<DeviceModel> getDeviceById(String siteId, String devId) async {
    final response = await _dio.get(ApiEndpoints.deviceById(siteId, devId));
    return DeviceModel.fromJson(response.data['data']);
  }

  /// Get device coordinates
  Future<List<DeviceModel>> getDeviceCoordinates(String siteId) async {
    final response = await _dio.get(ApiEndpoints.deviceCoordinates(siteId));
    final data = response.data['data'] as List;
    return data.map((json) => DeviceModel.fromJson(json)).toList();
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
    return DeviceModel.fromJson(response.data['data']);
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
    return DeviceModel.fromJson(response.data['data']);
  }

  /// Delete device
  Future<void> deleteDevice(String siteId, String devId) async {
    await _dio.delete(ApiEndpoints.deviceById(siteId, devId));
  }
}
