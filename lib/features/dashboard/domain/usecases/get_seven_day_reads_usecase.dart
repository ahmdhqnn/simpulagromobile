import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

/// Mengambil data reads harian (daily)
/// Endpoint: GET /sites/{siteId}/reads/daily
/// Catatan: endpoint /reads/seven-day tidak ada di Swagger — diganti ke /reads/daily
class GetSevenDayReadsUseCase {
  final DashboardRepository repository;

  GetSevenDayReadsUseCase(this.repository);

  Future<Either<Failure, List<SensorReadEntity>>> call(String siteId) async {
    return await repository.getDailyReads(siteId);
  }
}
