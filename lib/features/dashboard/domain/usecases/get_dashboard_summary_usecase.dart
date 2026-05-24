import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

/// UseCase untuk mengagregasi ringkasan dashboard
/// 
/// Menggabungkan data device, sensor, dan plant untuk menampilkan
/// summary di dashboard. Dapat mengagregasi multiple repository calls
/// jika diperlukan orchestration logic.
class GetDashboardSummaryUseCase {
  final DashboardRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  /// Mendapatkan ringkasan dashboard berdasarkan siteId
  ///
  /// [siteId] - ID dari site yang akan diambil summarynya
  ///
  /// Returns [Either<Failure, DashboardSummary>] yang berisi:
  /// - Left: Failure jika terjadi error (ServerFailure, NetworkFailure, dll)
  /// - Right: DashboardSummary yang berisi device, sensor, dan plant counts
  Future<Either<Failure, DashboardSummary>> call(String siteId) async {
    try {
      // Orchestrate multiple repository calls
      final deviceSummaryResult = await repository.getDeviceSummary(siteId);
      final sensorSummaryResult = await repository.getSensorSummary(siteId);
      final plantSummaryResult = await repository.getPlantSummary(siteId);

      // Combine results using fold pattern
      return deviceSummaryResult.fold(
        (failure) => Left(failure),
        (deviceSummary) {
          return sensorSummaryResult.fold(
            (failure) => Left(failure),
            (sensorSummary) {
              return plantSummaryResult.fold(
                (failure) => Left(failure),
                (plantSummary) {
                  return Right(
                    DashboardSummary(
                      deviceSummary: deviceSummary,
                      sensorSummary: sensorSummary,
                      plantSummary: plantSummary,
                    ),
                  );
                },
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(UnknownFailure('Failed to get dashboard summary: ${e.toString()}'));
    }
  }
}

/// Entity that aggregates dashboard summary
/// 
/// Combines summary from device, sensor, and plant
/// to be displayed in dashboard screen.
class DashboardSummary {
  final DeviceSummaryEntity deviceSummary;
  final SensorSummaryEntity sensorSummary;
  final PlantSummaryEntity plantSummary;

  const DashboardSummary({
    required this.deviceSummary,
    required this.sensorSummary,
    required this.plantSummary,
  });
}
