import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device.dart';

abstract class DeviceRepository {
  /// Get all devices for a specific site
  Future<Either<Failure, List<Device>>> getDevices(String siteId);

  /// Get device by ID
  Future<Either<Failure, Device>> getDeviceById(String siteId, String devId);

  /// Get device coordinates
  Future<Either<Failure, List<Device>>> getDeviceCoordinates(String siteId);

  /// Create new device
  Future<Either<Failure, Device>> createDevice(String siteId, Device device);

  /// Update existing device
  Future<Either<Failure, Device>> updateDevice(String siteId, String devId, Device device);

  /// Delete device
  Future<Either<Failure, void>> deleteDevice(String siteId, String devId);
}
