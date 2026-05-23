/// API Endpoint Constants
/// Centralized endpoint definitions matching backend API documentation
class ApiEndpoints {
  // ═══════════════════════════════════════════════════════════
  // AUTH ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String register = '/sites/users/new-users';

  // ═══════════════════════════════════════════════════════════

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
  static String addDevice(String siteId) => '/sites/$siteId/devices';

  // ═══════════════════════════════════════════════════════════
  // SENSOR ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String sensors(String siteId) => '/sites/$siteId/sensors';
  static String unsupportedSensorsAll(String siteId) => '/sites/$siteId/sensors/all';
  static String sensorById(String siteId, String sensId) =>
      '/sites/$siteId/sensors/$sensId';

  // ═══════════════════════════════════════════════════════════
  // DEVICE-SENSOR ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static String deviceSensors(String siteId) => '/sites/$siteId/device-sensors';
  static String deviceSensorValues(String siteId) =>
      '/sites/$siteId/device-sensors/values';
  static String deviceSensorById(String siteId, String dsId, String devId) =>
      '/sites/$siteId/device-sensors/$dsId/$devId';

  // ═══════════════════════════════════════════════════════════
  // SENSOR READS ENDPOINTS (Site-scoped)
  // ═══════════════════════════════════════════════════════════
  static String reads(String siteId) => '/sites/$siteId/reads';
  static String readsSevenDay(String siteId) =>
      '/sites/$siteId/reads/seven-day';
  static String readsPlantingDate(String siteId) =>
      '/sites/$siteId/reads/planting-date';
  static String updateRead(String siteId, String id) =>
      '/sites/$siteId/reads/$id';

  // Reads - Daily
  static String readsDaily(String siteId) => '/sites/$siteId/reads/daily';
  static String readsDailyToday(String siteId) =>
      '/sites/$siteId/reads/daily/today';
  static String readsRekapDaily(String siteId) =>
      '/sites/$siteId/reads/daily/rekap';
  static String readsDailyByDay(String siteId) =>
      '/sites/$siteId/reads/daily/by-day';

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

  /// POST /sites/{siteId}/plants/{plantId} — harvest action
  /// Sesuai dokumentasi: POST ke plantById adalah harvest operation
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
  static String phasesByHst(String siteId) => '/fase/phases-by-hst/$siteId';

  // Removed CONFIG MQTT ENDPOINTS as they are not in swagger live

  // ═══════════════════════════════════════════════════════════
  // TASK ENDPOINTS  (site-scoped, see Swagger contract)
  //   GET    /sites/{siteId}/tasks
  //   POST   /sites/{siteId}/tasks
  //   GET    /sites/{siteId}/tasks/{id}
  //   PUT    /sites/{siteId}/tasks/{id}
  //   DELETE /sites/{siteId}/tasks/{id}
  // ═══════════════════════════════════════════════════════════
  static String tasksBySite(String siteId) => '/sites/$siteId/tasks';
  static String taskBySiteAndId(String siteId, String taskId) =>
      '/sites/$siteId/tasks/$taskId';

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
  // FORUM ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String forumPosts = '/forum/posts';
  static String forumPostById(String postId) => '/forum/posts/$postId';
  static String forumPostLike(String postId) => '/forum/posts/$postId/like';
  static String forumPostShare(String postId) => '/forum/posts/$postId/share';
  static String forumPostComments(String postId) =>
      '/forum/posts/$postId/comments';
  static String forumPostReactions(String postId) =>
      '/forum/posts/$postId/reactions';
  static String forumDeleteComment(String postId, String commentId) =>
      '/forum/posts/$postId/comments/$commentId';
  static const String forumMyPosts = '/forum/posts/my-posts';
  static const String forumLikedPosts = '/forum/posts/liked-posts';
  static const String forumMyComments = '/forum/my-comments';

  // Removed LOG ENDPOINTS as they are not in swagger live

  // ═══════════════════════════════════════════════════════════
  // UNIT ENDPOINTS
  // ═══════════════════════════════════════════════════════════
  static const String units = '/sites/units';
  static const String createUnits = '/sites/units/create-units';
  static String unsupportedUnitById(String id) => '/sites/units/$id';
  static String unsupportedUpdateUnit(String id) => '/sites/units/update-unit/$id';

  // ═══════════════════════════════════════════════════════════
  // UNSUPPORTED PERMISSION ENDPOINTS (Not in Swagger live)
  // ═══════════════════════════════════════════════════════════
  static const String unsupportedPermissions = '/permissions';
  static String unsupportedPermissionsByRole(String roleId) => '/permissions/role/$roleId';
  static const String unsupportedNewRolePermission = '/permissions/new-role-permission';
  static String unsupportedDeleteRolePermission(String permId, String roleId) => '/permissions/$permId';
}
