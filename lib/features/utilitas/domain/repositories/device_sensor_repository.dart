import '../entities/device_sensor.dart';

abstract class DeviceSensorRepository {
  Future<List<DeviceSensor>> getDeviceSensorsByDevice(String deviceId);
  Future<List<DeviceSensor>> getAllDeviceSensors();
  Future<DeviceSensor> getDeviceSensorById(String dsId);
  Future<DeviceSensor> createDeviceSensor(DeviceSensor deviceSensor);
  Future<DeviceSensor> updateDeviceSensor(
    String dsId,
    DeviceSensor deviceSensor,
  );
  Future<void> deleteDeviceSensor(String dsId);
}
