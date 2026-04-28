import '../../domain/entities/device_sensor.dart';
import '../../domain/repositories/device_sensor_repository.dart';
import '../datasources/device_sensor_remote_datasource.dart';
import '../models/device_sensor_model.dart';

class DeviceSensorRepositoryImpl implements DeviceSensorRepository {
  final DeviceSensorRemoteDatasource remoteDatasource;

  DeviceSensorRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<DeviceSensor>> getAllDeviceSensors() async {
    try {
      final models = await remoteDatasource.getAllDeviceSensors();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DeviceSensor>> getDeviceSensorsByDevice(String deviceId) async {
    try {
      final all = await getAllDeviceSensors();
      return all.where((ds) => ds.devId == deviceId).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensor> getDeviceSensorById(String dsId) async {
    try {
      final model = await remoteDatasource.getDeviceSensorById(dsId);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensor> createDeviceSensor(DeviceSensor deviceSensor) async {
    try {
      final model = DeviceSensorModel.fromEntity(deviceSensor);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null || key == 'ds_created' || key == 'ds_update',
      );

      final createdModel = await remoteDatasource.createDeviceSensor(data);
      return createdModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensor> updateDeviceSensor(
    String dsId,
    DeviceSensor deviceSensor,
  ) async {
    try {
      final model = DeviceSensorModel.fromEntity(deviceSensor);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'ds_id' ||
            key == 'ds_created' ||
            key == 'ds_update',
      );

      final updatedModel = await remoteDatasource.updateDeviceSensor(
        dsId,
        deviceSensor.devId,
        data,
      );
      return updatedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDeviceSensor(String dsId) async {
    try {
      // Need devId — fetch first
      final ds = await getDeviceSensorById(dsId);
      await remoteDatasource.deleteDeviceSensor(dsId, ds.devId);
    } catch (e) {
      rethrow;
    }
  }
}
