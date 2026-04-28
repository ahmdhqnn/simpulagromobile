import '../entities/sensor.dart';

abstract class SensorRepository {
  Future<List<Sensor>> getSensorsBySite(String siteId);
  Future<List<Sensor>> getAllSensors(String siteId);
  Future<Sensor> getSensorById(String siteId, String sensorId);
  Future<Sensor> createSensor(String siteId, Sensor sensor);
  Future<Sensor> updateSensor(String siteId, String sensorId, Sensor sensor);
  Future<void> deleteSensor(String siteId, String sensorId);
}
