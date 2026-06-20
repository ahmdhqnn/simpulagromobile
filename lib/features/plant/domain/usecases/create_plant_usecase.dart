import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plant.dart';
import '../repositories/plant_repository.dart';

/// UseCase for creating a new plant
///
/// Takes site ID and plant data map, returns the created plant entity.
/// Validates input through repository layer.
/// Handles error mapping and delegates to [PlantRepository].
class CreatePlantUseCase {
  final PlantRepository repository;

  CreatePlantUseCase(this.repository);

  Future<Either<Failure, Plant>> call(
    String siteId,
    Map<String, dynamic> data,
  ) async {
    return repository.createPlant(siteId, data);
  }
}
