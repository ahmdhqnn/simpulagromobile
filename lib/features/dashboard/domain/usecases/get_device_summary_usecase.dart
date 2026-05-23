import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../repositories/dashboard_repository.dart';

class GetDeviceSummaryUseCase {
  final DashboardRepository repository;

  GetDeviceSummaryUseCase(this.repository);

  Future<Either<Failure, DashboardDeviceSummary>> call(String siteId) async {
    return await repository.getDeviceSummary(siteId);
  }
}
