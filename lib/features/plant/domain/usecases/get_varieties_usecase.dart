import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/plant_repository.dart';
import '../entities/varietas.dart';

/// UseCase for fetching all plant varieties
/// 
/// Returns a list of available plant varieties/seeds.
/// Suitable for dropdown selections and caching.
/// Handles error mapping and delegates to [PlantRepository].
class GetVarietiesUseCase {
  final PlantRepository repository;

  GetVarietiesUseCase(this.repository);

  Future<Either<Failure, List<Varietas>>> call() async {
    return repository.getVarietas();
  }
}
