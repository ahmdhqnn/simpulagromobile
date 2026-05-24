import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/plant_repository.dart';

/// UseCase for marking a plant as harvested
/// 
/// Takes site ID and plant ID, marks the plant as harvested by setting harvest date.
/// Returns void on success.
/// Handles error mapping and delegates to [PlantRepository].
class HarvestPlantUseCase {
  final PlantRepository repository;

  HarvestPlantUseCase(this.repository);

  Future<Either<Failure, void>> call(String siteId, String plantId) async {
    return repository.harvestPlant(siteId, plantId);
  }
}
