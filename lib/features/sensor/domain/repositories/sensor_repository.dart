import '../entities/sensor.dart';

abstract class SensorRepository {
  /// Get all sensors for a site
  Future<List<Sensor>> getSensors(String siteId);

  /// Get sensor by ID (requires siteId for scoped API)
  Future<Sensor> getSensorById(String siteId, String sensId);

  /// Create sensor for a site
  Future<Sensor> createSensor(String siteId, Map<String, dynamic> data);

  /// Update sensor
  Future<Sensor> updateSensor(
    String siteId,
    String sensId,
    Map<String, dynamic> data,
  );

  /// Delete sensor
  Future<void> deleteSensor(String siteId, String sensId);
}
