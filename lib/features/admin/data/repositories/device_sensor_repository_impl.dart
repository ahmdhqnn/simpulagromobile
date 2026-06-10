import '../../domain/entities/device_sensor.dart';
import '../../domain/repositories/device_sensor_repository.dart';
import '../datasources/device_sensor_remote_datasource.dart';
import '../models/device_sensor_model.dart';

class DeviceSensorRepositoryImpl implements DeviceSensorRepository {
  final DeviceSensorRemoteDatasource remoteDatasource;

  DeviceSensorRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<DeviceSensor>> getAllDeviceSensors(String siteId) async {
    try {
      final models = await remoteDatasource.getAllDeviceSensors(siteId);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DeviceSensor>> getDeviceSensorsByDevice(
    String siteId,
    String deviceId,
  ) async {
    try {
      final all = await getAllDeviceSensors(siteId);
      return all.where((ds) => ds.devId == deviceId).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensor> getDeviceSensorById(String siteId, String dsId) async {
    try {
      final model = await remoteDatasource.getDeviceSensorById(siteId, dsId);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensor> createDeviceSensor(
    String siteId,
    DeviceSensor deviceSensor,
  ) async {
    try {
      final model = DeviceSensorModel.fromEntity(deviceSensor);
      final data = model.toJson();

      data.removeWhere(
        (key, value) =>
            value == null || key == 'ds_created' || key == 'ds_update',
      );

      final createdModel = await remoteDatasource.createDeviceSensor(
        siteId,
        data,
      );
      return createdModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceSensor> updateDeviceSensor(
    String siteId,
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
        siteId,
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
  Future<void> deleteDeviceSensor(String siteId, String dsId) async {
    try {
      // Need devId — fetch first
      final ds = await getDeviceSensorById(siteId, dsId);
      await remoteDatasource.deleteDeviceSensor(siteId, dsId, ds.devId);
    } catch (e) {
      rethrow;
    }
  }
}
