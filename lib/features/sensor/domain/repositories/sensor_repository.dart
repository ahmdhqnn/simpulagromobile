import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/sensor.dart';

abstract class SensorRepository {
  /// Get all sensors for a site
  Future<Either<Failure, List<Sensor>>> getSensors(String siteId);

  /// Get sensor by ID (requires siteId for scoped API)
  Future<Either<Failure, Sensor>> getSensorById(String siteId, String sensId);

  /// Create sensor for a site
  Future<Either<Failure, Sensor>> createSensor(
    String siteId,
    Map<String, dynamic> data,
  );

  /// Update sensor
  Future<Either<Failure, Sensor>> updateSensor(
    String siteId,
    String sensId,
    Map<String, dynamic> data,
  );

  /// Delete sensor
  Future<Either<Failure, void>> deleteSensor(String siteId, String sensId);
}
