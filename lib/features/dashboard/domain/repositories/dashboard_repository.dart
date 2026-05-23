import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';

/// Repository interface untuk fitur Dashboard
/// Domain layer — tidak boleh import dari data layer
abstract class DashboardRepository {
  /// GET /sites/{siteId}/agro/environmental-health
  Future<Either<Failure, EnvironmentalHealthEntity>> getEnvironmentalHealth(
    String siteId,
  );

  /// GET /sites/{siteId}/devices
  Future<Either<Failure, DeviceSummaryEntity>> getDeviceSummary(String siteId);

  /// GET /sites/{siteId}/sensors
  Future<Either<Failure, SensorSummaryEntity>> getSensorSummary(String siteId);

  /// GET /sites/{siteId}/plants
  Future<Either<Failure, PlantSummaryEntity>> getPlantSummary(String siteId);

  /// GET /sites/{siteId}/reads/updates
  Future<Either<Failure, List<SensorReadEntity>>> getLatestSensorReads(
    String siteId,
  );

  /// GET /sites/{siteId}/reads/daily
  Future<Either<Failure, List<SensorReadEntity>>> getDailyReads(String siteId);

  /// GET /sites/{siteId}/reads/today
  Future<Either<Failure, List<SensorReadEntity>>> getTodayReads(String siteId);
}
