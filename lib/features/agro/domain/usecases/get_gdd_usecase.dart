import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/agro_entity.dart';
import '../repositories/agro_repository.dart';

/// UseCase for retrieving Growing Degree Days (GDD) data
///
/// GDD is a weather-based indicator for predicting crop development and maturity.
/// It represents the amount of heat accumulated above a base temperature (usually 10°C).
/// Useful for planning crop management activities and predicting harvest dates.
class GetGddUseCase {
  final AgroRepository repository;

  GetGddUseCase(this.repository);

  /// Execute the use case to get GDD data
  /// 
  /// Parameters:
  ///   - siteId: The unique identifier of the site
  /// 
  /// Returns:
  ///   - [Right<GddEntity>] if successful containing total GDD and daily breakdown
  ///   - [Left<Failure>] if an error occurs (data not available or network error)
  Future<Either<Failure, GddEntity>> call(String siteId) async {
    return repository.getGddData(siteId);
  }
}
