import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../repositories/dashboard_repository.dart';

class GetPlantSummaryUseCase {
  final DashboardRepository repository;

  GetPlantSummaryUseCase(this.repository);

  Future<Either<Failure, DashboardPlantSummary>> call(String siteId) async {
    return await repository.getPlantSummary(siteId);
  }
}
