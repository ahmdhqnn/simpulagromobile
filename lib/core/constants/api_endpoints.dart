/// API endpoint constants centralized from backend contract.
class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String register = '/sites/users/new-users';
  static const String authChangePassword = '/auth/change-password';

  // Profile
  static const String profileMe = '/profile/me';
  static const String profilePermissions = '/profile/permissions';
  static const String profileDebugToken = '/profile/debug-token';

  // Sites
  static const String sites = '/sites';
  static String siteById(String id) => '/sites/$id';
  static String siteMemberInvite(String siteId) =>
      '/sites/$siteId/members/invite';

  // Notes (site scoped)
  static String siteNotes(String siteId) => '/sites/$siteId/notes';

  // Devices (site scoped)
  static String devices(String siteId) => '/sites/$siteId/devices';
  static String deviceById(String siteId, String devId) =>
      '/sites/$siteId/devices/$devId';
  static String deviceCoordinates(String siteId) =>
      '/sites/$siteId/devices/coordinates';
  static String addDevice(String siteId) => '/sites/$siteId/devices';

  // Sensors (site scoped)
  static String sensors(String siteId) => '/sites/$siteId/sensors';
  static String unsupportedSensorsAll(String siteId) =>
      '/sites/$siteId/sensors/all';
  static String sensorDetail(String siteId, String sensId) =>
      '/sites/$siteId/sensors/detail/$sensId';
  static String sensorById(String siteId, String sensId) =>
      '/sites/$siteId/sensors/$sensId';

  // Device sensors (site scoped)
  static String deviceSensors(String siteId) => '/sites/$siteId/device-sensors';
  static String deviceSensorValues(String siteId) =>
      '/sites/$siteId/device-sensors/values';
  static String deviceSensorById(String siteId, String dsId, String devId) =>
      '/sites/$siteId/device-sensors/$dsId/$devId';

  // Sensor reads (site scoped)
  static String reads(String siteId) => '/sites/$siteId/reads';
  static String readsSevenDay(String siteId) =>
      '/sites/$siteId/reads/seven-day';
  static String readsPlantingDate(String siteId) =>
      '/sites/$siteId/reads/planting-date';
  static String updateRead(String siteId, String id) =>
      '/sites/$siteId/reads/$id';
  static String readsDaily(String siteId) => '/sites/$siteId/reads/daily';
  static String readsDailyToday(String siteId) =>
      '/sites/$siteId/reads/daily/today';
  static String readsRekapDaily(String siteId) =>
      '/sites/$siteId/reads/daily/rekap';
  static String readsDailyByDay(String siteId) =>
      '/sites/$siteId/reads/daily/by-day';
  static String readsMonthly(String siteId) => '/sites/$siteId/reads/mounth';
  static String readsUpdates(String siteId) => '/sites/$siteId/reads/updates';

  // Plants (site scoped)
  static String plants(String siteId) => '/sites/$siteId/plants';
  static String plantById(String siteId, String plantId) =>
      '/sites/$siteId/plants/$plantId';
  static String harvestPlant(String siteId, String plantId) =>
      '/sites/$siteId/plants/$plantId/harvest';

  // Recommendations (site scoped)
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
  static String recPreviewDummy(String siteId) =>
      '/sites/$siteId/recommendations/preview-dummy';
  static String recSaveDummy(String siteId) =>
      '/sites/$siteId/recommendations/save-dummy';

  // Agro
  static String agro(String siteId) => '/sites/$siteId/agro';
  static String envHealth(String siteId) =>
      '/sites/$siteId/agro/environmental-health';

  // Fase / GDD
  static const String phasesList = '/fase/phases-list';
  static String phasesByType(String type) => '/fase/phases-list/$type';
  static String phasesByHst(String siteId) => '/fase/phases-by-hst/$siteId';

  // Tasks (site scoped)
  static String tasksBySite(String siteId) => '/sites/$siteId/tasks';
  static String taskBySiteAndId(String siteId, String taskId) =>
      '/sites/$siteId/tasks/$taskId';

  // Users
  static const String users = '/sites/users';
  static String userById(String userId) => '/sites/users/$userId';

  // Roles
  static const String roles = '/roles';
  static String roleById(String roleId) => '/roles/$roleId';

  // Permissions
  static const String permissionsAll = '/permissions/all-permissions';
  static const String permissionsRolePermissions =
      '/permissions/role-permissions';
  static String permissionsByRole(String roleId) => '/permissions/role/$roleId';
  static const String permissionsNewPermission = '/permissions/new-permission';
  static const String permissionsNewRolePermission =
      '/permissions/new-role-permission';
  static const String permissionsUpdateRolePermission =
      '/permissions/update-role-permission/';
  static const String permissionsUpdatePermission =
      '/permissions/update-permission';
  static String permissionsDeleteRolePermission(String permId, String roleId) =>
      '/permissions/delete-role-permission/$permId/$roleId';

  // Varietas
  static const String varietas = '/varietas';
  static String varietasById(String id) => '/varietas/$id';

  // Forum
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

  // Global comments
  static const String updateComment = '/comments';
  static String deleteComment(String commentId) => '/comments/$commentId';

  // Units
  static const String units = '/sites/units';
  static const String createUnits = '/sites/units/create-units';
  static String unsupportedUnitById(String id) => '/sites/units/$id';
  static String unsupportedUpdateUnit(String id) =>
      '/sites/units/update-unit/$id';
}
