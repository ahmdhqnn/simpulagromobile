import '../../domain/entities/sensor.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../datasources/sensor_remote_datasource.dart';
import '../models/sensor_model.dart';

/// Implementation of SensorRepository
/// Converts between domain entities and data models
class SensorRepositoryImpl implements SensorRepository {
  final SensorRemoteDatasource remoteDatasource;

  SensorRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Sensor>> getSensorsBySite(String siteId) async {
    try {
      final models = await remoteDatasource.getSensorsBySite(siteId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Sensor>> getAllSensors(String siteId) async {
    try {
      final models = await remoteDatasource.getAllSensors(siteId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Sensor> getSensorById(String siteId, String sensorId) async {
    try {
      final model = await remoteDatasource.getSensorById(siteId, sensorId);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Sensor> createSensor(String siteId, Sensor sensor) async {
    try {
      // Convert entity to model, then to JSON
      final model = SensorModel.fromEntity(sensor);
      final data = model.toJson();

      // Remove null values and fields that shouldn't be sent on create
      data.removeWhere(
        (key, value) =>
            value == null || key == 'sens_created' || key == 'sens_update',
      );

      final createdModel = await remoteDatasource.createSensor(siteId, data);
      return createdModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Sensor> updateSensor(
    String siteId,
    String sensorId,
    Sensor sensor,
  ) async {
    try {
      // Convert entity to model, then to JSON
      final model = SensorModel.fromEntity(sensor);
      final data = model.toJson();

      // Remove null values and fields that shouldn't be sent on update
      data.removeWhere(
        (key, value) =>
            value == null ||
            key == 'sens_id' ||
            key == 'sens_created' ||
            key == 'sens_update',
      );

      final updatedModel = await remoteDatasource.updateSensor(
        siteId,
        sensorId,
        data,
      );
      return updatedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSensor(String siteId, String sensorId) async {
    try {
      await remoteDatasource.deleteSensor(siteId, sensorId);
    } catch (e) {
      rethrow;
    }
  }
}
