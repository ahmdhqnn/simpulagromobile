import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDeviceSummaryUseCase {
  final DashboardRepository repository;

  GetDeviceSummaryUseCase(this.repository);

  Future<Either<Failure, DeviceSummaryEntity>> call(String siteId) async {
    return await repository.getDeviceSummary(siteId);
  }
}
