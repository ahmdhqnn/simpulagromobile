import '../entities/sensor.dart';

abstract class SensorRepository {
  Future<List<Sensor>> getSensors(String deviceId);
  Future<Sensor> getSensorById(String id);
  Future<Sensor> createSensor(String deviceId, Map<String, dynamic> data);
  Future<Sensor> updateSensor(String id, Map<String, dynamic> data);
  Future<void> deleteSensor(String id);
}
