import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/environmental_health_model.dart';
import '../repositories/dashboard_repository.dart';

/// UseCase untuk mendapatkan metrik kesehatan lingkungan (environmental health)
///
/// Mengambil data kesehatan lingkungan dari repository yang mencakup:
/// - Overall health score
/// - Sensor readings untuk temperature, humidity, NPK, pH
/// - Persentase kesehatan untuk setiap sensor
class GetEnvironmentalHealthUseCase {
  final DashboardRepository repository;

  GetEnvironmentalHealthUseCase(this.repository);

  /// Mendapatkan metrik kesehatan lingkungan berdasarkan siteId
  ///
  /// [siteId] - ID dari site yang akan diambil environmental health-nya
  ///
  /// Returns [Either<Failure, EnvironmentalHealth>] yang berisi:
  /// - Left: Failure jika terjadi error (ServerFailure, NetworkFailure, dll)
  /// - Right: EnvironmentalHealth dengan overall health score dan sensor details
  Future<Either<Failure, EnvironmentalHealth>> call(String siteId) async {
    try {
      return await repository.getEnvironmentalHealth(siteId);
    } catch (e) {
      return Left(
        UnknownFailure('Failed to get environmental health: ${e.toString()}'),
      );
    }
  }
}
