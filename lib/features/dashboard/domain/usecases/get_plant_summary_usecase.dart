import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetPlantSummaryUseCase {
  final DashboardRepository repository;

  GetPlantSummaryUseCase(this.repository);

  Future<Either<Failure, PlantSummaryEntity>> call(String siteId) async {
    return await repository.getPlantSummary(siteId);
  }
}
