import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/dashboard_repository.dart';

class GetLatestSensorReadsUseCase {
  final DashboardRepository repository;

  GetLatestSensorReadsUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(String siteId) async {
    return await repository.getLatestSensorReads(siteId);
  }
}
