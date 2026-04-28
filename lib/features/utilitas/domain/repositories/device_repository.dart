import '../entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevicesBySite(String siteId);
  Future<Device> getDeviceById(String siteId, String deviceId);
  Future<Device> createDevice(String siteId, Device device);
  Future<Device> updateDevice(String siteId, String deviceId, Device device);
  Future<void> deleteDevice(String siteId, String deviceId);
}
