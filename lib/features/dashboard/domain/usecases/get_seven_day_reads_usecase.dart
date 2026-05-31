import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

/// Mengambil data sensor 7 hari terakhir.
/// Endpoint: GET /sites/{siteId}/reads/seven-day
class GetSevenDayReadsUseCase {
  final DashboardRepository repository;

  GetSevenDayReadsUseCase(this.repository);

  Future<Either<Failure, List<SensorReadEntity>>> call(String siteId) async {
    return await repository.getDailyReads(siteId);
  }
}
