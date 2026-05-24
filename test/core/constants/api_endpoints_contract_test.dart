import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';

void main() {
  group('ApiEndpoints Contract Tests', () {
    test('Auth Endpoints', () {
      expect(ApiEndpoints.login, equals('/auth/login'));
      expect(ApiEndpoints.refreshToken, equals('/auth/refresh'));
      expect(ApiEndpoints.logout, equals('/auth/logout'));
      expect(ApiEndpoints.register, equals('/sites/users/new-users'));
    });

    test('Profile Endpoints', () {
      expect(ApiEndpoints.profileMe, equals('/profile/me'));
      expect(ApiEndpoints.profilePermissions, equals('/profile/permissions'));
      expect(ApiEndpoints.profileDebugToken, equals('/profile/debug-token'));
    });

    test('Site Endpoints', () {
      expect(ApiEndpoints.sites, equals('/sites'));
      expect(ApiEndpoints.siteById('SITE001'), equals('/sites/SITE001'));
      expect(
        ApiEndpoints.siteMemberInvite('SITE001'),
        equals('/sites/SITE001/members/invite'),
      );
      expect(ApiEndpoints.siteNotes('SITE001'), equals('/sites/SITE001/notes'));
    });

    test('Device Endpoints', () {
      expect(ApiEndpoints.devices('SITE001'), equals('/sites/SITE001/devices'));
      expect(ApiEndpoints.deviceById('SITE001', 'DEV002'), equals('/sites/SITE001/devices/DEV002'));
      expect(ApiEndpoints.deviceCoordinates('SITE001'), equals('/sites/SITE001/devices/coordinates'));
      expect(ApiEndpoints.addDevice('SITE001'), equals('/sites/SITE001/devices'));
    });

    test('Sensor Endpoints', () {
      expect(ApiEndpoints.sensors('SITE001'), equals('/sites/SITE001/sensors'));
      expect(ApiEndpoints.sensorDetail('SITE001', 'SENS002'), equals('/sites/SITE001/sensors/detail/SENS002'));
      expect(ApiEndpoints.sensorById('SITE001', 'SENS002'), equals('/sites/SITE001/sensors/SENS002'));
    });

    test('Device Sensor Endpoints', () {
      expect(ApiEndpoints.deviceSensors('SITE001'), equals('/sites/SITE001/device-sensors'));
      expect(ApiEndpoints.deviceSensorValues('SITE001'), equals('/sites/SITE001/device-sensors/values'));
      expect(ApiEndpoints.deviceSensorById('SITE001', 'DS002', 'DEV003'), equals('/sites/SITE001/device-sensors/DS002/DEV003'));
    });

    test('Sensor Reads Endpoints', () {
      expect(ApiEndpoints.reads('SITE001'), equals('/sites/SITE001/reads'));
      expect(ApiEndpoints.readsSevenDay('SITE001'), equals('/sites/SITE001/reads/seven-day'));
      expect(ApiEndpoints.readsPlantingDate('SITE001'), equals('/sites/SITE001/reads/planting-date'));
      expect(ApiEndpoints.updateRead('SITE001', 'READ002'), equals('/sites/SITE001/reads/READ002'));
      expect(ApiEndpoints.readsDaily('SITE001'), equals('/sites/SITE001/reads/daily'));
      expect(ApiEndpoints.readsDailyToday('SITE001'), equals('/sites/SITE001/reads/daily/today'));
      expect(ApiEndpoints.readsRekapDaily('SITE001'), equals('/sites/SITE001/reads/daily/rekap'));
      expect(ApiEndpoints.readsDailyByDay('SITE001'), equals('/sites/SITE001/reads/daily/by-day'));
      expect(ApiEndpoints.readsMonthly('SITE001'), equals('/sites/SITE001/reads/mounth'));
      expect(ApiEndpoints.readsUpdates('SITE001'), equals('/sites/SITE001/reads/updates'));
    });

    test('Plant Endpoints', () {
      expect(ApiEndpoints.plants('SITE001'), equals('/sites/SITE001/plants'));
      expect(ApiEndpoints.plantById('SITE001', 'PLANT002'), equals('/sites/SITE001/plants/PLANT002'));
      expect(ApiEndpoints.harvestPlant('SITE001', 'PLANT002'), equals('/sites/SITE001/plants/PLANT002/harvest'));
    });

    test('Recommendation Endpoints', () {
      expect(ApiEndpoints.recommendations('SITE001'), equals('/sites/SITE001/recommendations'));
      expect(ApiEndpoints.plantRecommendations('SITE001'), equals('/sites/SITE001/recommendations/plant'));
      expect(ApiEndpoints.plantRecBySite('SITE001'), equals('/sites/SITE001/recommendations/plant-by-site'));
      expect(ApiEndpoints.recHistory('SITE001'), equals('/sites/SITE001/recommendations/history'));
      expect(ApiEndpoints.recByPhase('SITE001', 'PHASE002'), equals('/sites/SITE001/recommendations/by-phase/PHASE002'));
      expect(ApiEndpoints.recPreviewDummy('SITE001'), equals('/sites/SITE001/recommendations/preview-dummy'));
      expect(ApiEndpoints.recSaveDummy('SITE001'), equals('/sites/SITE001/recommendations/save-dummy'));
    });

    test('Comment Endpoints', () {
      expect(ApiEndpoints.updateComment, equals('/comments'));
      expect(ApiEndpoints.deleteComment('COM001'), equals('/comments/COM001'));
    });

    test('Agro Endpoints', () {
      expect(ApiEndpoints.agro('SITE001'), equals('/sites/SITE001/agro'));
      expect(ApiEndpoints.envHealth('SITE001'), equals('/sites/SITE001/agro/environmental-health'));
    });

    test('Phase Endpoints', () {
      expect(ApiEndpoints.phasesList, equals('/fase/phases-list'));
      expect(ApiEndpoints.phasesByType('paddy'), equals('/fase/phases-list/paddy'));
      expect(ApiEndpoints.phasesByHst('SITE001'), equals('/fase/phases-by-hst/SITE001'));
    });

    test('Task Endpoints', () {
      expect(ApiEndpoints.tasksBySite('SITE001'), equals('/sites/SITE001/tasks'));
      expect(ApiEndpoints.taskBySiteAndId('SITE001', 'TASK002'), equals('/sites/SITE001/tasks/TASK002'));
    });

    test('User Endpoints', () {
      expect(ApiEndpoints.users, equals('/sites/users'));
      expect(ApiEndpoints.userById('USR001'), equals('/sites/users/USR001'));
    });

    test('Role Endpoints', () {
      expect(ApiEndpoints.roles, equals('/roles'));
      expect(ApiEndpoints.roleById('ROLE001'), equals('/roles/ROLE001'));
    });

    test('Forum Endpoints', () {
      expect(ApiEndpoints.forumPosts, equals('/forum/posts'));
      expect(ApiEndpoints.forumPostById('POST001'), equals('/forum/posts/POST001'));
      expect(ApiEndpoints.forumPostLike('POST001'), equals('/forum/posts/POST001/like'));
      expect(ApiEndpoints.forumPostShare('POST001'), equals('/forum/posts/POST001/share'));
      expect(ApiEndpoints.forumPostComments('POST001'), equals('/forum/posts/POST001/comments'));
      expect(ApiEndpoints.forumPostReactions('POST001'), equals('/forum/posts/POST001/reactions'));
      expect(ApiEndpoints.forumDeleteComment('POST001', 'COM002'), equals('/forum/posts/POST001/comments/COM002'));
      expect(ApiEndpoints.forumMyPosts, equals('/forum/posts/my-posts'));
      expect(ApiEndpoints.forumLikedPosts, equals('/forum/posts/liked-posts'));
      expect(ApiEndpoints.forumMyComments, equals('/forum/my-comments'));
    });

    test('Unit Endpoints', () {
      expect(ApiEndpoints.units, equals('/sites/units'));
      expect(ApiEndpoints.createUnits, equals('/sites/units/create-units'));
    });

    test('Unsupported Endpoints', () {
      expect(ApiEndpoints.unsupportedSensorsAll('SITE001'), equals('/sites/SITE001/sensors/all'));
      expect(ApiEndpoints.unsupportedUnitById('UNIT001'), equals('/sites/units/UNIT001'));
      expect(ApiEndpoints.unsupportedUpdateUnit('UNIT001'), equals('/sites/units/update-unit/UNIT001'));
      expect(ApiEndpoints.unsupportedPermissions, equals('/permissions'));
      expect(ApiEndpoints.unsupportedPermissionsByRole('ROLE001'), equals('/permissions/role/ROLE001'));
      expect(ApiEndpoints.unsupportedNewRolePermission, equals('/permissions/new-role-permission'));
      expect(ApiEndpoints.unsupportedDeleteRolePermission('PERM001', 'ROLE002'), equals('/permissions/PERM001'));
    });
  });
}
