import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/agro_entity.dart';
import '../repositories/agro_repository.dart';

/// UseCase for retrieving Vapor Pressure Deficit (VDP) data
///
/// VDP is a measure of the difference between the amount of moisture in the air
/// and the maximum amount of moisture the air can hold at that temperature.
/// It is important for crop health monitoring and disease prediction.
class GetVdpUseCase {
  final AgroRepository repository;

  GetVdpUseCase(this.repository);

  /// Execute the use case to get VDP data
  ///
  /// Parameters:
  ///   - siteId: The unique identifier of the site
  ///
  /// Returns:
  ///   - [Right<VdpEntity>] if successful
  ///   - [Left<Failure>] if an error occurs (data not available or network error)
  Future<Either<Failure, VdpEntity>> call(String siteId) async {
    return repository.getVdpData(siteId);
  }
}
