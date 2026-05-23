import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetLatestSensorReadsUseCase {
  final DashboardRepository repository;

  GetLatestSensorReadsUseCase(this.repository);

  Future<Either<Failure, List<SensorReadEntity>>> call(String siteId) async {
    return await repository.getLatestSensorReads(siteId);
  }
}
