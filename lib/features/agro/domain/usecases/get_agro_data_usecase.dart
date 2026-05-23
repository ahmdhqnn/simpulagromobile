import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/agro_model.dart';
import '../repositories/agro_repository.dart';

/// UseCase for retrieving complete Agro data (VDP, GDD, ETC combined)
/// 
/// This use case retrieves all agricultural monitoring data for a given site,
/// including Vapor Pressure Deficit (VDP), Growing Degree Days (GDD), and
/// Evapotranspiration (ETC) information in a single call.
class GetAgroDataUseCase {
  final AgroRepository repository;

  GetAgroDataUseCase(this.repository);

  /// Execute the use case to get agro data
  /// 
  /// Parameters:
  ///   - siteId: The unique identifier of the site
  /// 
  /// Returns:
  ///   - [Right<AgroModel>] if successful
  ///   - [Left<Failure>] if an error occurs
  Future<Either<Failure, AgroModel>> call(String siteId) async {
    return repository.getAgroData(siteId);
  }
}
