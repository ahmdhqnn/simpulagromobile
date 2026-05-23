import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/environmental_health_model.dart';
import '../repositories/dashboard_repository.dart';

class GetEnvironmentalHealthUseCase {
  final DashboardRepository repository;

  GetEnvironmentalHealthUseCase(this.repository);

  Future<Either<Failure, EnvironmentalHealth>> call(String siteId) async {
    return await repository.getEnvironmentalHealth(siteId);
  }
}
