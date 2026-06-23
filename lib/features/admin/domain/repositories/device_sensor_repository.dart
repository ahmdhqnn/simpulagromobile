import '../entities/device_sensor.dart';

abstract class DeviceSensorRepository {
  Future<List<DeviceSensor>> getDeviceSensorsByDevice(
    String siteId,
    String deviceId,
  );
  Future<List<DeviceSensor>> getAllDeviceSensors(String siteId);
  Future<DeviceSensor> getDeviceSensorById(
    String siteId,
    String dsId, {
    String? devId,
  });
  Future<DeviceSensor> createDeviceSensor(
    String siteId,
    DeviceSensor deviceSensor,
  );
  Future<DeviceSensor> updateDeviceSensor(
    String siteId,
    String dsId,
    DeviceSensor deviceSensor,
  );
  Future<void> deleteDeviceSensor(String siteId, String dsId);
}
