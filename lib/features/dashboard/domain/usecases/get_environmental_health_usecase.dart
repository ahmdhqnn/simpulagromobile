import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetEnvironmentalHealthUseCase {
  final DashboardRepository repository;

  GetEnvironmentalHealthUseCase(this.repository);

  Future<Either<Failure, EnvironmentalHealthEntity>> call(String siteId) async {
    return await repository.getEnvironmentalHealth(siteId);
  }
}
