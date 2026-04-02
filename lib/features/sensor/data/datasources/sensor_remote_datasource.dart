import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../models/sensor_model.dart';

class SensorRemoteDataSource {
  // ignore: unused_field
  final Dio _dio;

  SensorRemoteDataSource(this._dio);

  Future<List<SensorModel>> getSensors(String deviceId) async {
    // TODO: Replace with real API when backend is ready
    // MOCK DATA for development
    await Future.delayed(const Duration(seconds: 1));

    return [
      SensorModel(
        id: 'sensor1',
        deviceId: deviceId,
        name: 'Temperature Sensor 1',
        type: 'temperature',
        unit: '°C',
        description: 'Main temperature sensor',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      SensorModel(
        id: 'sensor2',
        deviceId: deviceId,
        name: 'Humidity Sensor 1',
        type: 'humidity',
        unit: '%',
        description: 'Main humidity sensor',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
      SensorModel(
        id: 'sensor3',
        deviceId: deviceId,
        name: 'Soil Moisture Sensor',
        type: 'soil_moisture',
        unit: '%',
        description: 'Soil moisture monitoring',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      SensorModel(
        id: 'sensor4',
        deviceId: deviceId,
        name: 'pH Sensor',
        type: 'ph',
        unit: 'pH',
        description: 'Soil pH level sensor',
        isActive: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
    ];

    /* Real API implementation:
    final response = await _dio.get(ApiEndpoints.sensors(deviceId));
    final data = response.data['data'] as List;
    return data.map((json) => SensorModel.fromJson(json)).toList();
    */
  }

  Future<SensorModel> getSensorById(String id) async {
    // TODO: Replace with real API
    await Future.delayed(const Duration(milliseconds: 500));

    return SensorModel(
      id: id,
      deviceId: 'device1',
      name: 'Temperature Sensor 1',
      type: 'temperature',
      unit: '°C',
      description: 'Main temperature sensor',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );

    /* Real API:
    final response = await _dio.get(ApiEndpoints.sensorDetail(id));
    return SensorModel.fromJson(response.data['data']);
    */
  }

  Future<SensorModel> createSensor(
    String deviceId,
    Map<String, dynamic> data,
  ) async {
    // TODO: Replace with real API
    await Future.delayed(const Duration(seconds: 1));

    return SensorModel(
      id: 'sensor_${DateTime.now().millisecondsSinceEpoch}',
      deviceId: deviceId,
      name: data['name'] as String,
      type: data['type'] as String,
      unit: data['unit'] as String,
      description: data['description'] as String?,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    /* Real API:
    final response = await _dio.post(
      ApiEndpoints.sensors(deviceId),
      data: data,
    );
    return SensorModel.fromJson(response.data['data']);
    */
  }

  Future<SensorModel> updateSensor(String id, Map<String, dynamic> data) async {
    // TODO: Replace with real API
    await Future.delayed(const Duration(seconds: 1));

    final current = await getSensorById(id);
    return current.copyWith(
      name: data['name'] as String? ?? current.name,
      type: data['type'] as String? ?? current.type,
      unit: data['unit'] as String? ?? current.unit,
      description: data['description'] as String? ?? current.description,
      isActive: data['is_active'] as bool? ?? current.isActive,
      updatedAt: DateTime.now(),
    );

    /* Real API:
    final response = await _dio.put(
      ApiEndpoints.sensorDetail(id),
      data: data,
    );
    return SensorModel.fromJson(response.data['data']);
    */
  }

  Future<void> deleteSensor(String id) async {
    // TODO: Replace with real API
    await Future.delayed(const Duration(milliseconds: 500));

    /* Real API:
    await _dio.delete(ApiEndpoints.sensorDetail(id));
    */
  }
}

final sensorRemoteDataSourceProvider = Provider<SensorRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SensorRemoteDataSource(dioClient.dio);
});
