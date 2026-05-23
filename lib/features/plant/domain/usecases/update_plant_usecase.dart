import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plant.dart';
import '../repositories/plant_repository.dart';

/// UseCase for updating an existing plant
/// 
/// Takes site ID, plant ID, and updated data map, returns the updated plant entity.
/// Validates input through repository layer.
/// Handles error mapping and delegates to [PlantRepository].
class UpdatePlantUseCase {
  final PlantRepository repository;

  UpdatePlantUseCase(this.repository);

  Future<Either<Failure, Plant>> call(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) async {
    return repository.updatePlant(siteId, plantId, data);
  }
}
