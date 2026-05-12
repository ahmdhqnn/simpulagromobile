import '../../data/models/monitoring_models.dart';

abstract class MonitoringRepository {
  // Realtime
  Future<List<SensorReadUpdate>> getLatestReads(String siteId);

  // History
  Future<List<SensorReadModel>> getTodayReads(String siteId);
  Future<List<SensorReadModel>> getSevenDayReads(String siteId);
  Future<List<SensorReadModel>> getDateRangeReads(
    String siteId, {
    required String startDate,
    required String endDate,
  });
  Future<List<SensorReadModel>> getPlantingDateReads(String siteId);
  Future<List<SensorDailyModel>> getDailyReads(String siteId);

  // Devices & Sensors
  Future<List<DeviceModel>> getDevices(String siteId);
  Future<int> getSensorCount(String siteId);

  // Logs
  Future<List<LogModel>> getLogs();

  // Analytics
  Future<Map<String, dynamic>> getEnvironmentalHealth(String siteId);
  Future<Map<String, dynamic>> getPlantRecommendation(String siteId);

  // Alarms
  Future<List<AlarmDataModel>> getAlarmData();

  // Monthly Rekap
  Future<List<MonthlyRekapModel>> getMonthlyReads(String siteId);
}
