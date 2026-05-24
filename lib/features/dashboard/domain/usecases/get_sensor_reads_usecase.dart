import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

/// UseCase untuk mendapatkan sensor readings (pembacaan sensor)
///
/// Menyediakan akses ke berbagai jenis sensor readings:
/// - Latest readings: pembacaan sensor terkini
/// - Today's readings: data historis untuk hari ini
/// - Seven-day readings: data historis 7 hari terakhir
class GetSensorReadsUseCase {
  final DashboardRepository repository;

  GetSensorReadsUseCase(this.repository);

  /// Mendapatkan latest sensor readings berdasarkan siteId
  ///
  /// [siteId] - ID dari site
  ///
  /// Returns [Either<Failure, List<SensorReadEntity>>] yang berisi:
  /// - Left: Failure jika terjadi error
  /// - Right: List of latest sensor readings
  Future<Either<Failure, List<SensorReadEntity>>> getLatestReads(
    String siteId,
  ) async {
    try {
      return await repository.getLatestSensorReads(siteId);
    } catch (e) {
      return Left(
        UnknownFailure('Failed to get latest sensor reads: ${e.toString()}'),
      );
    }
  }

  /// Mendapatkan sensor readings untuk hari ini
  ///
  /// [siteId] - ID dari site
  ///
  /// Returns [Either<Failure, List<SensorReadEntity>>] yang berisi:
  /// - Left: Failure jika terjadi error
  /// - Right: List of sensor readings untuk hari ini
  Future<Either<Failure, List<SensorReadEntity>>> getTodayReads(
    String siteId,
  ) async {
    try {
      return await repository.getTodayReads(siteId);
    } catch (e) {
      return Left(
        UnknownFailure('Failed to get today sensor reads: ${e.toString()}'),
      );
    }
  }

  /// Mendapatkan sensor readings untuk 7 hari terakhir
  ///
  /// [siteId] - ID dari site
  ///
  /// Returns [Either<Failure, List<SensorReadEntity>>] yang berisi:
  /// - Left: Failure jika terjadi error
  /// - Right: List of sensor readings untuk 7 hari terakhir (menggunakan daily reads)
  Future<Either<Failure, List<SensorReadEntity>>> getSevenDayReads(
    String siteId,
  ) async {
    try {
      return await repository.getDailyReads(siteId);
    } catch (e) {
      return Left(
        UnknownFailure('Failed to get seven day sensor reads: ${e.toString()}'),
      );
    }
  }
}
