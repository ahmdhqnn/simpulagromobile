import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plant.dart';
import '../repositories/plant_repository.dart';

/// UseCase for fetching a single plant by ID
/// 
/// Returns a single plant entity for the given site and plant ID.
/// Handles error mapping and delegates to [PlantRepository].
class GetPlantDetailUseCase {
  final PlantRepository repository;

  GetPlantDetailUseCase(this.repository);

  Future<Either<Failure, Plant>> call(String siteId, String plantId) async {
    return repository.getPlantById(siteId, plantId);
  }
}
