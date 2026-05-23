import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetTodayReadsUseCase {
  final DashboardRepository repository;

  GetTodayReadsUseCase(this.repository);

  Future<Either<Failure, List<SensorReadEntity>>> call(String siteId) async {
    return await repository.getTodayReads(siteId);
  }
}
