import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/environmental_health_model.dart';
import '../../data/models/dashboard_summary_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, EnvironmentalHealth>> getEnvironmentalHealth(String siteId);
  Future<Either<Failure, DashboardDeviceSummary>> getDeviceSummary(String siteId);
  Future<Either<Failure, DashboardSensorSummary>> getSensorSummary(String siteId);
  Future<Either<Failure, DashboardPlantSummary>> getPlantSummary(String siteId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getLatestSensorReads(String siteId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getSevenDayReads(String siteId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getTodayReads(String siteId);
}
