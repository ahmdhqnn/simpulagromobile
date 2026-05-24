import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/plant_repository.dart';

/// UseCase for deleting a plant (Admin only).
///
/// Takes site ID and plant ID, permanently removes the plant record.
/// Returns void on success.
/// Handles error mapping and delegates to [PlantRepository].
class DeletePlantUseCase {
  final PlantRepository repository;

  DeletePlantUseCase(this.repository);

  Future<Either<Failure, void>> call(String siteId, String plantId) async {
    return repository.deletePlant(siteId, plantId);
  }
}
