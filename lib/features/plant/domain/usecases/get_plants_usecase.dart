import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plant.dart';
import '../repositories/plant_repository.dart';

/// UseCase for fetching all plants in a site
/// 
/// Returns a list of plants for the given site ID.
/// Handles error mapping and delegates to [PlantRepository].
class GetPlantsUseCase {
  final PlantRepository repository;

  GetPlantsUseCase(this.repository);

  Future<Either<Failure, List<Plant>>> call(String siteId) async {
    return repository.getPlants(siteId);
  }
}
