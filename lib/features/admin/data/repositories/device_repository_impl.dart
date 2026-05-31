import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_datasource.dart';
import '../models/device_model.dart';

/// Implementation of DeviceRepository
/// Converts between domain entities and data models
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDatasource remoteDatasource;

  DeviceRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Device>> getDevicesBySite(String siteId) async {
    try {
      final models = await remoteDatasource.getDevicesBySite(siteId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Device> getDeviceById(String siteId, String deviceId) async {
    try {
      final model = await remoteDatasource.getDeviceById(siteId, deviceId);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Device> createDevice(String siteId, Device device) async {
    try {
      final model = DeviceModel.fromEntity(device);
      final data = model.toJson();

      // Remove null values and fields that shouldn't be sent on create
      data.removeWhere(
        (key, value) =>
            value == null || key == 'dev_created' || key == 'dev_update',
      );

      final createdModel = await remoteDatasource.createDevice(siteId, data);
      return createdModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Device> updateDevice(
    String siteId,
    String deviceId,
    Device device,
  ) async {
    try {
      final model = DeviceModel.fromEntity(device);
      final data = model.toJson();

      // Remove null values and fields that shouldn't be sent on update
      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'dev_id' ||
            key == 'dev_created' ||
            key == 'dev_update',
      );

      final updatedModel = await remoteDatasource.updateDevice(
        siteId,
        deviceId,
        data,
      );
      return updatedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDevice(String siteId, String deviceId) async {
    try {
      await remoteDatasource.deleteDevice(siteId, deviceId);
    } catch (e) {
      rethrow;
    }
  }
}
