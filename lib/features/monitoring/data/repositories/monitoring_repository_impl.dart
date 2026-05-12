import '../../domain/repositories/monitoring_repository.dart';
import '../datasources/monitoring_remote_datasource.dart';
import '../models/monitoring_models.dart';

class MonitoringRepositoryImpl implements MonitoringRepository {
  final MonitoringRemoteDataSource remoteDataSource;

  MonitoringRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SensorReadUpdate>> getLatestReads(String siteId) {
    return remoteDataSource.getLatestReads(siteId);
  }

  @override
  Future<List<SensorReadModel>> getTodayReads(String siteId) {
    return remoteDataSource.getTodayReads(siteId);
  }

  @override
  Future<List<SensorReadModel>> getSevenDayReads(String siteId) {
    return remoteDataSource.getSevenDayReads(siteId);
  }

  @override
  Future<List<SensorReadModel>> getDateRangeReads(
    String siteId, {
    required String startDate,
    required String endDate,
  }) {
    return remoteDataSource.getDateRangeReads(
      siteId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<SensorReadModel>> getPlantingDateReads(String siteId) {
    return remoteDataSource.getPlantingDateReads(siteId);
  }

  @override
  Future<List<SensorDailyModel>> getDailyReads(String siteId) {
    return remoteDataSource.getDailyReads(siteId);
  }

  @override
  Future<List<DeviceModel>> getDevices(String siteId) {
    return remoteDataSource.getDevices(siteId);
  }

  @override
  Future<int> getSensorCount(String siteId) {
    return remoteDataSource.getSensorCount(siteId);
  }

  @override
  Future<List<LogModel>> getLogs() {
    return remoteDataSource.getLogs();
  }

  @override
  Future<Map<String, dynamic>> getEnvironmentalHealth(String siteId) {
    return remoteDataSource.getEnvironmentalHealth(siteId);
  }

  @override
  Future<Map<String, dynamic>> getPlantRecommendation(String siteId) {
    return remoteDataSource.getPlantRecommendation(siteId);
  }

  @override
  Future<List<AlarmDataModel>> getAlarmData() {
    return remoteDataSource.getAlarmData();
  }

  @override
  Future<List<MonthlyRekapModel>> getMonthlyReads(String siteId) {
    return remoteDataSource.getMonthlyReads(siteId);
  }
}
