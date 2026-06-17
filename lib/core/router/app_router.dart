import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/task/presentation/screens/task_list_screen.dart';
import '../../features/task/presentation/screens/task_detail_screen.dart';
import '../../features/task/presentation/screens/task_form_screen.dart';
import '../../features/recommendation/presentation/providers/recommendation_hub_provider.dart';
import '../../features/recommendation/presentation/screens/recommendation_hub_screen.dart';
import '../../features/recommendation/presentation/screens/recommendation_detail_screen.dart';
import '../../features/phase/presentation/screens/phase_list_screen.dart';
import '../../features/phase/presentation/screens/phase_detail_screen.dart';
import '../../features/phase/presentation/screens/gdd_tracking_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/site/presentation/screens/site_detail_screen.dart';
import '../../features/site/presentation/screens/site_member_invite_screen.dart';
import '../../features/site/presentation/screens/site_form_screen.dart';
import '../../features/site/presentation/screens/site_list_screen.dart';
import '../../features/plant/presentation/screens/plant_list_screen.dart';
import '../../features/plant/presentation/screens/plant_detail_screen.dart';
import '../../features/plant/presentation/screens/plant_form_screen.dart';
import '../../features/forum/presentation/screens/forum_screen.dart';
import '../../features/forum/presentation/screens/liked_posts_screen.dart';
import '../../features/forum/presentation/screens/my_posts_screen.dart';
import '../../features/forum/presentation/screens/my_comments_screen.dart';
import '../../features/forum/presentation/screens/post_form_screen.dart';
import '../../features/forum/presentation/screens/post_detail_screen.dart';
import '../../features/admin/presentation/screens/admin_menu_screen.dart';
import '../../features/admin/presentation/screens/sensors/sensor_list_screen.dart';
import '../../features/admin/presentation/screens/sensors/sensor_form_screen.dart';
import '../../features/admin/presentation/screens/sensors/sensor_detail_screen.dart';
import '../../features/admin/presentation/screens/devices/device_list_screen.dart';
import '../../features/admin/presentation/screens/devices/device_form_screen.dart';
import '../../features/admin/presentation/screens/devices/device_detail_screen.dart';
import '../../features/admin/presentation/screens/plants/plant_list_screen.dart'
    as admin_plant;
import '../../features/admin/presentation/screens/plants/plant_form_screen.dart'
    as admin_plant_form;
import '../../features/admin/presentation/screens/units/unit_list_screen.dart';
import '../../features/admin/presentation/screens/units/unit_form_screen.dart';
import '../../features/admin/presentation/screens/users/user_list_screen.dart';
import '../../features/admin/presentation/screens/users/user_form_screen.dart';
import '../../features/admin/presentation/screens/users/user_detail_screen.dart';
import '../../features/admin/presentation/screens/roles/role_list_screen.dart';
import '../../features/admin/presentation/screens/roles/role_form_screen.dart';
import '../../features/admin/presentation/screens/roles/role_detail_screen.dart';
import '../../features/admin/presentation/screens/device_sensors/device_sensor_list_screen.dart';
import '../../features/plant/presentation/screens/plant_detail_screen.dart'
    as admin_plant_detail;
import '../../features/admin/presentation/screens/device_sensors/device_sensor_form_screen.dart';
import '../../features/admin/presentation/screens/device_sensors/device_sensor_detail_screen.dart';
import '../../shared/widgets/main_shell.dart';

import '../../features/device/presentation/screens/device_list_screen.dart'
    as monitoring_device_list;
import '../../features/device/presentation/screens/device_detail_screen.dart'
    as monitoring_device_detail;
import '../../features/device/presentation/screens/device_form_screen.dart'
    as monitoring_device_form;

import '../../features/sensor/presentation/screens/sensor_list_screen.dart'
    as monitoring_sensor_list;
import '../../features/sensor/presentation/screens/sensor_detail_screen.dart'
    as monitoring_sensor_detail;
import '../../features/sensor/presentation/screens/sensor_form_screen.dart'
    as monitoring_sensor_form;

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthStateListenable(ref);

  final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isOnboardingCompleted = ref.read(onboardingProvider);

      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoading = authState.status == AuthStatus.loading;

      final loc = state.matchedLocation;
      final isSplash = loc == '/splash';
      final isLogin = loc == '/login';
      final isOnboarding = loc == '/onboarding';

      if (isSplash) return null;

      if (isLoading && isLogin) return null;

      if (isLoggedIn) {
        if (isLogin || isOnboarding) return '/';
        return null;
      }

      if (!isOnboardingCompleted && !isOnboarding) {
        return '/onboarding';
      }
      if (isLogin || isOnboarding) return null;

      final error = authState.error;
      if (error != null && error.contains('Sesi')) {
        return '/login?reason=session_expired';
      }
      return '/login';
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, state) {
          final reason = state.uri.queryParameters['reason'];
          return LoginScreen(
            sessionExpiredMessage: reason == 'session_expired',
          );
        },
      ),
      GoRoute(path: '/', builder: (_, __) => const MainShell()),

      // Task
      GoRoute(path: '/tasks', builder: (_, __) => const TaskListScreen()),
      GoRoute(path: '/task/create', builder: (_, __) => const TaskFormScreen()),
      GoRoute(
        path: '/task/:id/edit',
        builder: (_, state) =>
            TaskFormScreen(taskId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/task/:id',
        builder: (_, state) =>
            TaskDetailScreen(taskId: state.pathParameters['id']!),
      ),

      GoRoute(
        path: '/recommendations',
        builder: (_, state) {
          final scope = recommendationScopeFromQuery(
            state.uri.queryParameters['scope'],
          );
          return RecommendationHubScreen(initialScope: scope);
        },
      ),
      GoRoute(
        path: '/recommendation/:id',
        builder: (_, state) => RecommendationDetailScreen(
          recommendationId: state.pathParameters['id']!,
        ),
      ),

      GoRoute(
        path: '/phases/:siteId/:plantName',
        builder: (_, state) => PhaseListScreen(
          plantId: state.pathParameters['siteId']!,
          plantName: Uri.decodeComponent(
            state.pathParameters['plantName'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '/phase/:id',
        builder: (_, state) => PhaseDetailScreen(
          phaseId: state.pathParameters['id']!,
          siteId: state.uri.queryParameters['siteId'],
        ),
      ),
      GoRoute(
        path: '/gdd-tracking/:siteId/:plantName',
        builder: (_, state) => GddTrackingScreen(
          plantId: state.pathParameters['siteId']!,
          plantName: Uri.decodeComponent(
            state.pathParameters['plantName'] ?? '',
          ),
        ),
      ),

      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(
        path: '/settings/change-password',
        builder: (_, __) => const ChangePasswordScreen(),
      ),

      GoRoute(path: '/site/create', builder: (_, __) => const SiteFormScreen()),
      GoRoute(
        path: '/site/:id/edit',
        builder: (_, state) =>
            SiteFormScreen(siteId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/site/:id',
        builder: (_, state) =>
            SiteDetailScreen(siteId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/site/:id/invite',
        builder: (_, state) =>
            SiteMemberInviteScreen(siteId: state.pathParameters['id']!),
      ),

      GoRoute(path: '/plants', builder: (_, __) => const PlantListScreen()),
      GoRoute(
        path: '/plant/create',
        builder: (_, __) => const PlantFormScreen(),
      ),
      GoRoute(
        path: '/plant/:id/edit',
        builder: (_, state) =>
            PlantFormScreen(plantId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/plant/:id',
        builder: (_, state) =>
            PlantDetailScreen(plantId: state.pathParameters['id']!),
      ),

      GoRoute(path: '/forum', builder: (_, __) => const ForumScreen()),
      GoRoute(
        path: '/forum/post/:id',
        builder: (_, state) =>
            PostDetailScreen(postId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/forum/create',
        builder: (_, __) => const PostFormScreen(),
      ),
      GoRoute(
        path: '/forum/edit/:id',
        builder: (_, state) =>
            PostFormScreen(postId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/forum/my-posts',
        builder: (_, __) => const MyPostsScreen(),
      ),
      GoRoute(
        path: '/forum/liked-posts',
        builder: (_, __) => const LikedPostsScreen(),
      ),
      GoRoute(
        path: '/forum/my-comments',
        builder: (_, __) => const MyCommentsScreen(),
      ),

      GoRoute(
        path: '/site-devices/:siteId/:siteName',
        builder: (_, state) => monitoring_device_list.DeviceListScreen(
          siteId: state.pathParameters['siteId']!,
          siteName: Uri.decodeComponent(state.pathParameters['siteName'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/site-device/:siteId/:devId',
        builder: (_, state) => monitoring_device_detail.DeviceDetailScreen(
          siteId: state.pathParameters['siteId']!,
          devId: state.pathParameters['devId']!,
        ),
      ),
      GoRoute(
        path: '/site-device-create/:siteId',
        builder: (_, state) => monitoring_device_form.DeviceFormScreen(
          siteId: state.pathParameters['siteId']!,
        ),
      ),
      GoRoute(
        path: '/site-device-edit/:siteId',
        builder: (_, state) => monitoring_device_form.DeviceFormScreen(
          siteId: state.pathParameters['siteId']!,
          device: state.extra as dynamic,
        ),
      ),

      GoRoute(
        path: '/site-sensors/:siteId/:siteName',
        builder: (_, state) => monitoring_sensor_list.SensorListScreen(
          siteId: state.pathParameters['siteId']!,
          siteName: Uri.decodeComponent(state.pathParameters['siteName'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/site-sensor/:siteId/:sensorId',
        builder: (_, state) => monitoring_sensor_detail.SensorDetailScreen(
          siteId: state.pathParameters['siteId']!,
          sensorId: state.pathParameters['sensorId']!,
        ),
      ),
      GoRoute(
        path: '/site-sensor-create/:siteId',
        builder: (_, state) => monitoring_sensor_form.SensorFormScreen(
          siteId: state.pathParameters['siteId']!,
        ),
      ),
      GoRoute(
        path: '/site-sensor-edit/:siteId/:sensorId',
        builder: (_, state) => monitoring_sensor_form.SensorFormScreen(
          siteId: state.pathParameters['siteId']!,
          sensorId: state.pathParameters['sensorId']!,
        ),
      ),

      GoRoute(path: '/admin', builder: (_, __) => const AdminMenuScreen()),
      GoRoute(
        path: '/admin/sites',
        builder: (_, __) => const SiteListScreen(managementMode: true),
      ),
      GoRoute(
        path: '/admin/sensors',
        builder: (_, __) => const SensorListScreen(),
      ),
      GoRoute(
        path: '/admin/sensors/create',
        builder: (_, __) => const SensorFormScreen(),
      ),
      GoRoute(
        path: '/admin/sensors/:id/edit',
        builder: (_, state) =>
            SensorFormScreen(sensorId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/admin/sensors/:id',
        builder: (_, state) =>
            AdminSensorDetailScreen(sensorId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/admin/devices',
        builder: (_, __) => const DeviceListScreen(),
      ),
      GoRoute(
        path: '/admin/devices/create',
        builder: (_, __) => const DeviceFormScreen(),
      ),
      GoRoute(
        path: '/admin/devices/:id/edit',
        builder: (_, state) =>
            DeviceFormScreen(deviceId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/admin/devices/:id',
        builder: (_, state) =>
            AdminDeviceDetailScreen(deviceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/admin/plants',
        builder: (_, __) => const admin_plant.PlantListScreen(),
      ),
      GoRoute(
        path: '/admin/plants/create',
        builder: (_, __) => const admin_plant_form.PlantFormScreen(),
      ),
      GoRoute(
        path: '/admin/plants/:id/edit',
        builder: (_, state) => admin_plant_form.PlantFormScreen(
          plantId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/admin/plants/:id',
        builder: (_, state) => admin_plant_detail.PlantDetailScreen(
          plantId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(path: '/admin/units', builder: (_, __) => const UnitListScreen()),
      GoRoute(
        path: '/admin/units/create',
        builder: (_, __) => const UnitFormScreen(),
      ),
      GoRoute(path: '/admin/users', builder: (_, __) => const UserListScreen()),
      GoRoute(
        path: '/admin/users/create',
        builder: (_, __) => const UserFormScreen(),
      ),
      GoRoute(
        path: '/admin/users/:id/edit',
        builder: (_, state) =>
            UserFormScreen(userId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/admin/users/:id',
        builder: (_, state) =>
            UserDetailScreen(userId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/admin/roles', builder: (_, __) => const RoleListScreen()),
      GoRoute(
        path: '/admin/roles/create',
        builder: (_, __) => const RoleFormScreen(),
      ),
      GoRoute(
        path: '/admin/roles/:id/edit',
        builder: (_, state) =>
            RoleFormScreen(roleId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/admin/roles/:id',
        builder: (_, state) =>
            RoleDetailScreen(roleId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/admin/device-sensors',
        builder: (_, __) => const DeviceSensorListScreen(),
      ),
      GoRoute(
        path: '/admin/device-sensors/create',
        builder: (_, __) => const DeviceSensorFormScreen(),
      ),
      GoRoute(
        path: '/admin/device-sensors/:id/edit',
        builder: (_, state) =>
            DeviceSensorFormScreen(dsId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/admin/device-sensors/:id',
        builder: (_, state) =>
            DeviceSensorDetailScreen(dsId: state.pathParameters['id']!),
      ),

      GoRoute(path: '/utilitas', redirect: (_, __) => '/admin'),
      GoRoute(path: '/utilitas/sensors', redirect: (_, __) => '/admin/sensors'),
      GoRoute(
        path: '/utilitas/sensors/create',
        redirect: (_, __) => '/admin/sensors/create',
      ),
      GoRoute(
        path: '/utilitas/sensors/:id/edit',
        redirect: (_, state) =>
            "/admin/sensors/${state.pathParameters['id']}/edit",
      ),
      GoRoute(
        path: '/utilitas/sensors/:id',
        redirect: (_, state) => "/admin/sensors/${state.pathParameters['id']}",
      ),
      GoRoute(path: '/utilitas/devices', redirect: (_, __) => '/admin/devices'),
      GoRoute(
        path: '/utilitas/devices/create',
        redirect: (_, __) => '/admin/devices/create',
      ),
      GoRoute(
        path: '/utilitas/devices/:id/edit',
        redirect: (_, state) =>
            "/admin/devices/${state.pathParameters['id']}/edit",
      ),
      GoRoute(
        path: '/utilitas/devices/:id',
        redirect: (_, state) => "/admin/devices/${state.pathParameters['id']}",
      ),
      GoRoute(path: '/utilitas/plants', redirect: (_, __) => '/admin/plants'),
      GoRoute(
        path: '/utilitas/plants/create',
        redirect: (_, __) => '/admin/plants/create',
      ),
      GoRoute(
        path: '/utilitas/plants/:id/edit',
        redirect: (_, state) =>
            "/admin/plants/${state.pathParameters['id']}/edit",
      ),
      GoRoute(
        path: '/utilitas/plants/:id',
        redirect: (_, state) => "/admin/plants/${state.pathParameters['id']}",
      ),
      GoRoute(path: '/utilitas/units', redirect: (_, __) => '/admin/units'),
      GoRoute(
        path: '/utilitas/units/create',
        redirect: (_, __) => '/admin/units/create',
      ),
      GoRoute(path: '/utilitas/users', redirect: (_, __) => '/admin/users'),
      GoRoute(
        path: '/utilitas/users/create',
        redirect: (_, __) => '/admin/users/create',
      ),
      GoRoute(
        path: '/utilitas/users/:id/edit',
        redirect: (_, state) =>
            "/admin/users/${state.pathParameters['id']}/edit",
      ),
      GoRoute(
        path: '/utilitas/users/:id',
        redirect: (_, state) => "/admin/users/${state.pathParameters['id']}",
      ),
      GoRoute(path: '/utilitas/roles', redirect: (_, __) => '/admin/roles'),
      GoRoute(
        path: '/utilitas/roles/create',
        redirect: (_, __) => '/admin/roles/create',
      ),
      GoRoute(
        path: '/utilitas/roles/:id/edit',
        redirect: (_, state) =>
            "/admin/roles/${state.pathParameters['id']}/edit",
      ),
      GoRoute(
        path: '/utilitas/roles/:id',
        redirect: (_, state) => "/admin/roles/${state.pathParameters['id']}",
      ),
      GoRoute(
        path: '/utilitas/device-sensors',
        redirect: (_, __) => '/admin/device-sensors',
      ),
      GoRoute(
        path: '/utilitas/device-sensors/create',
        redirect: (_, __) => '/admin/device-sensors/create',
      ),
      GoRoute(
        path: '/utilitas/device-sensors/:id/edit',
        redirect: (_, state) =>
            "/admin/device-sensors/${state.pathParameters['id']}/edit",
      ),
      GoRoute(
        path: '/utilitas/device-sensors/:id',
        redirect: (_, state) =>
            "/admin/device-sensors/${state.pathParameters['id']}",
      ),
    ],
  );

  ref.onDispose(authNotifier.dispose);

  return router;
});

class _AuthStateListenable extends ChangeNotifier {
  late final ProviderSubscription<AuthState> _subscription;

  _AuthStateListenable(Ref ref) {
    _subscription = ref.listen<AuthState>(authProvider, (_, __) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
