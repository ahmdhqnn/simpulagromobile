import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../repositories/dashboard_repository.dart';

class GetSensorSummaryUseCase {
  final DashboardRepository repository;

  GetSensorSummaryUseCase(this.repository);

  Future<Either<Failure, DashboardSensorSummary>> call(String siteId) async {
    return await repository.getSensorSummary(siteId);
  }
}
