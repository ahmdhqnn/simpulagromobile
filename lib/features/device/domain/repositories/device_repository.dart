import '../entities/device.dart';

abstract class DeviceRepository {
  /// Get all devices for a specific site
  Future<List<Device>> getDevices(String siteId);

  /// Get device by ID
  Future<Device> getDeviceById(String siteId, String devId);

  /// Get device coordinates
  Future<List<Device>> getDeviceCoordinates(String siteId);

  /// Create new device
  Future<Device> createDevice(String siteId, Device device);

  /// Update existing device
  Future<Device> updateDevice(String siteId, String devId, Device device);

  /// Delete device
  Future<void> deleteDevice(String siteId, String devId);
}
