/// API Endpoint Constants
/// Centralized endpoint definitions matching backend API documentation
class ApiEndpoints {
  // ═══════════════════════════════════════════════════════════
  // AUTH ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String login = '/auth/login';
  static const String register = '/auth/new-users';

  // ═══════════════════════════════════════════════════════════
  // PROFILE ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String profileMe = '/profile/me';
  static const String profilePermissions = '/profile/permissions';
  static const String profileDebugToken = '/profile/debug-token';

  // ═══════════════════════════════════════════════════════════
  // SITE ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String sites = '/sites';
  static String siteById(String id) => '/sites/$id';

  // ═══════════════════════════════════════════════════════════
  // DEVICE ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String devices(String siteId) => '/sites/$siteId/devices';
  static String deviceById(String siteId, String devId) =>
      '/sites/$siteId/devices/$devId';
  static String deviceCoordinates(String siteId) =>
      '/sites/$siteId/devices/coordinates';
  static String addDevice(String siteId) => '/sites/$siteId/devices/add';

  // ═══════════════════════════════════════════════════════════
  // SENSOR ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String sensors(String siteId) => '/sites/$siteId/sensors';
  static String sensorsAll(String siteId) => '/sites/$siteId/sensors/all';
  static String sensorDetail(String siteId, String sensId) =>
      '/sites/$siteId/sensors/detail/$sensId';
  static String sensorById(String siteId, String sensId) =>
      '/sites/$siteId/sensors/$sensId';

  // ═══════════════════════════════════════════════════════════
  // DEVICE-SENSOR ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String deviceSensors = '/sites/device-sensors';
  static String deviceSensorBySensor(String sensId) =>
      '/sites/device-sensors/sensor/$sensId';
  static String deviceSensorById(String dsId, String devId) =>
      '/sites/device-sensors/$dsId/$devId';
  static const String deviceSensorValues = '/sites/device-sensors/values';

  // ═══════════════════════════════════════════════════════════
  // SENSOR READS ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String reads(String siteId) => '/sites/$siteId/reads';
  static String readsToday(String siteId) => '/sites/$siteId/reads/today';
  static String readsSevenDay(String siteId) =>
      '/sites/$siteId/reads/seven-day';
  static String readsDateRange(String siteId) =>
      '/sites/$siteId/reads/date-range';
  static String readsPlantingDate(String siteId) =>
      '/sites/$siteId/reads/planting-date';
  static String updateRead(String siteId, String id) =>
      '/sites/$siteId/reads/update-read/$id';

  // Reads - Daily
  static String readsDaily(String siteId) => '/sites/$siteId/reads/daily';
  static String readsDailyToday(String siteId) =>
      '/sites/$siteId/reads/daily/today';
  static String readsRekapDaily(String siteId) =>
      '/sites/$siteId/reads/daily/rekap-daily';
  static String readsDailyByDay(String siteId) =>
      '/sites/$siteId/reads/daily/daily-by-day';

  // Reads - Monthly
  static String readsMonthly(String siteId) => '/sites/$siteId/reads/mounth';

  // Reads - Updates (Latest/Real-time)
  static String readsUpdates(String siteId) => '/sites/$siteId/reads/updates';

  // ═══════════════════════════════════════════════════════════
  // PLANT ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String plants(String siteId) => '/sites/$siteId/plants';
  static String plantById(String siteId, String plantId) =>
      '/sites/$siteId/plants/$plantId';
  static String harvestPlant(String siteId, String plantId) =>
      '/sites/$siteId/plants/$plantId/harvest';

  // ═══════════════════════════════════════════════════════════
  // RECOMMENDATION ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String recommendations(String siteId) =>
      '/sites/$siteId/recommendations';
  static String plantRecommendations(String siteId) =>
      '/sites/$siteId/recommendations/plant';
  static String plantRecBySite(String siteId) =>
      '/sites/$siteId/recommendations/plant-by-site';
  static String recHistory(String siteId) =>
      '/sites/$siteId/recommendations/history';
  static String recByPhase(String siteId, String phaseId) =>
      '/sites/$siteId/recommendations/by-phase/$phaseId';

  // ═══════════════════════════════════════════════════════════
  // AGRO DATA ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String agro(String siteId) => '/sites/$siteId/agro';
  static String envHealth(String siteId) =>
      '/sites/$siteId/agro/environmental-health';

  // ═══════════════════════════════════════════════════════════
  // FASE / GDD ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String phasesList = '/fase/phases-list';
  static String phasesByType(String type) => '/fase/phases-list/$type';
  static const String gddStandards = '/fase/gdd-standards';
  static const String gddKumulatif = '/fase/gdd-kumulatif';
  static String phasesByHst(String siteId) => '/fase/phases-by-hst/$siteId';

  // ═══════════════════════════════════════════════════════════
  // CONFIG MQTT ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String configMqtt(String siteId) => '/sites/$siteId/config';
  static String configMqttById(String siteId, String id) =>
      '/sites/$siteId/config/$id';

  // ═══════════════════════════════════════════════════════════
  // TASK ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String tasks = '/tasks';

  // ═══════════════════════════════════════════════════════════
  // USER MANAGEMENT ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String users = '/sites/users';
  static String userById(String userId) => '/sites/users/$userId';

  // ═══════════════════════════════════════════════════════════
  // ROLE ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String roles = '/roles';
  static String roleById(String roleId) => '/roles/$roleId';

  // ═══════════════════════════════════════════════════════════
  // PERMISSION ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String permissions = '/permissions/all-permissions';
  static const String rolePermissions = '/permissions/role-permissions';
  static String permissionsByRole(String roleId) => '/permissions/role/$roleId';
  static const String newPermission = '/permissions/new-permission';
  static const String newRolePermission = '/permissions/new-role-permission';
  static const String updateRolePermission =
      '/permissions/update-role-permission';
  static const String updatePermission = '/permissions/update-permission';
  static String deleteRolePermission(String permId, String roleId) =>
      '/permissions/delete-role-permission/$permId/$roleId';

  // ═══════════════════════════════════════════════════════════
  // ALARM ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String alarms = '/sites/alarms';
  static const String alarmCodes = '/sites/alarms/codes';
  static const String alarmData = '/sites/alarms/data';

  // ═══════════════════════════════════════════════════════════
  // LOG ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String logs = '/sites/logs';

  // ═══════════════════════════════════════════════════════════
  // UNIT ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String units = '/sites/units';
  static String unitById(String id) => '/sites/units/$id';
  static const String createUnits = '/sites/units/create-units';
  static String updateUnit(String id) => '/sites/units/update-unit/$id';
}
