import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetSensorSummaryUseCase {
  final DashboardRepository repository;

  GetSensorSummaryUseCase(this.repository);

  Future<Either<Failure, SensorSummaryEntity>> call(String siteId) async {
    return await repository.getSensorSummary(siteId);
  }
}
