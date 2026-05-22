import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/monitoring_models.dart';

abstract class MonitoringRepository {
  // Realtime
  Future<Either<Failure, List<SensorReadUpdate>>> getLatestReads(String siteId);

  // History
  Future<Either<Failure, List<SensorReadModel>>> getTodayReads(String siteId);
  Future<Either<Failure, List<SensorReadModel>>> getSevenDayReads(String siteId);
  Future<Either<Failure, List<SensorReadModel>>> getDateRangeReads(
    String siteId, {
    required String startDate,
    required String endDate,
  });
  Future<Either<Failure, List<SensorReadModel>>> getPlantingDateReads(String siteId);
  Future<Either<Failure, List<SensorDailyModel>>> getDailyReads(String siteId);

  // Devices & Sensors
  Future<Either<Failure, List<DeviceModel>>> getDevices(String siteId);
  Future<Either<Failure, int>> getSensorCount(String siteId);

  // Logs
  Future<Either<Failure, List<LogModel>>> getLogs();

  // Analytics
  Future<Either<Failure, Map<String, dynamic>>> getEnvironmentalHealth(String siteId);
  Future<Either<Failure, Map<String, dynamic>>> getPlantRecommendation(String siteId);

  // Alarms
  Future<Either<Failure, List<AlarmDataModel>>> getAlarmData();

  // Monthly Rekap
  Future<Either<Failure, List<MonthlyRekapModel>>> getMonthlyReads(String siteId);
}
