import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/agro_model.dart';
import '../repositories/agro_repository.dart';

/// UseCase for retrieving Evapotranspiration (ETC) data
///
/// ETC represents the amount of water lost from soil and plants to the atmosphere.
/// It includes both evaporation from soil and transpiration from plants.
/// Critical for irrigation management and water conservation planning.
class GetEtcUseCase {
  final AgroRepository repository;

  GetEtcUseCase(this.repository);

  /// Execute the use case to get ETC data
  /// 
  /// Parameters:
  ///   - siteId: The unique identifier of the site
  /// 
  /// Returns:
  ///   - [Right<List<EtcDailyModel>>] if successful containing daily ETC values
  ///   - [Left<Failure>] if an error occurs (data not available or network error)
  Future<Either<Failure, List<EtcDailyModel>>> call(String siteId) async {
    return repository.getEtcData(siteId);
  }
}
