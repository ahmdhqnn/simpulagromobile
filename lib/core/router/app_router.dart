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
import '../../features/recommendation/presentation/screens/recommendation_list_screen.dart';
import '../../features/recommendation/presentation/screens/recommendation_detail_screen.dart';
import '../../features/phase/presentation/screens/phase_list_screen.dart';
import '../../features/phase/presentation/screens/phase_detail_screen.dart';
import '../../features/phase/presentation/screens/gdd_tracking_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/site/presentation/screens/site_detail_screen.dart';
import '../../features/site/presentation/screens/site_form_screen.dart';
import '../../features/plant/presentation/screens/plant_list_screen.dart';
import '../../features/plant/presentation/screens/plant_detail_screen.dart';
import '../../features/forum/presentation/screens/forum_screen.dart';
import '../../features/forum/presentation/screens/liked_posts_screen.dart';
import '../../features/forum/presentation/screens/my_posts_screen.dart';
import '../../features/forum/presentation/screens/my_comments_screen.dart';
import '../../features/forum/presentation/screens/post_form_screen.dart';
import '../../features/forum/presentation/screens/post_detail_screen.dart';
import '../../features/utilitas/presentation/screens/utilitas_menu_screen.dart';
import '../../features/utilitas/presentation/screens/sensors/sensor_list_screen.dart';
import '../../features/utilitas/presentation/screens/sensors/sensor_form_screen.dart';
import '../../features/utilitas/presentation/screens/devices/device_list_screen.dart';
import '../../features/utilitas/presentation/screens/devices/device_form_screen.dart';
import '../../features/utilitas/presentation/screens/plants/plant_list_screen.dart'
    as utilitas_plant;
import '../../features/utilitas/presentation/screens/plants/plant_form_screen.dart'
    as utilitas_plant_form;
import '../../features/utilitas/presentation/screens/units/unit_list_screen.dart';
import '../../features/utilitas/presentation/screens/units/unit_form_screen.dart';
import '../../features/utilitas/presentation/screens/users/user_list_screen.dart';
import '../../features/utilitas/presentation/screens/users/user_form_screen.dart';
import '../../features/utilitas/presentation/screens/roles/role_list_screen.dart';
import '../../features/utilitas/presentation/screens/roles/role_form_screen.dart';
import '../../features/utilitas/presentation/screens/permissions/permission_list_screen.dart';
import '../../features/utilitas/presentation/screens/device_sensors/device_sensor_list_screen.dart';
import '../../features/utilitas/presentation/screens/device_sensors/device_sensor_form_screen.dart';
import '../../shared/widgets/main_shell.dart';

// Monitoring Devices
import '../../features/device/presentation/screens/device_list_screen.dart' as monitoring_device_list;
import '../../features/device/presentation/screens/device_detail_screen.dart' as monitoring_device_detail;
import '../../features/device/presentation/screens/device_form_screen.dart' as monitoring_device_form;

// Monitoring Sensors
import '../../features/sensor/presentation/screens/sensor_list_screen.dart' as monitoring_sensor_list;
import '../../features/sensor/presentation/screens/sensor_detail_screen.dart' as monitoring_sensor_detail;
import '../../features/sensor/presentation/screens/sensor_form_screen.dart' as monitoring_sensor_form;

/// GoRouter dibuat sekali dan tidak di-recreate.
/// Perubahan auth state ditangani via `refreshListenable`.
final routerProvider = Provider<GoRouter>((ref) {
  // Listenable yang trigger redirect saat auth state berubah
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

      // Splash screen menangani navigasinya sendiri — jangan redirect dari sini
      if (isSplash) return null;

      // Saat loading (misal saat proses login), jangan redirect
      if (isLoading && isLogin) return null;

      if (isLoggedIn) {
        // Sudah login — redirect dari auth screens ke home
        if (isLogin || isOnboarding) return '/';
        return null;
      }

      // Belum login
      if (!isOnboardingCompleted && !isOnboarding) {
        return '/onboarding';
      }
      if (isLogin || isOnboarding) return null;

      // Redirect ke login dengan pesan jika session expired
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
        path: '/task/:id',
        builder: (_, state) =>
            TaskDetailScreen(taskId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/task/:id/edit',
        builder: (_, state) =>
            TaskFormScreen(taskId: state.pathParameters['id']),
      ),

      // Recommendation
      GoRoute(
        path: '/recommendations',
        builder: (_, __) => const RecommendationListScreen(),
      ),
      GoRoute(
        path: '/recommendation/:id',
        builder: (_, state) => RecommendationDetailScreen(
          recommendationId: state.pathParameters['id']!,
        ),
      ),

      // Phase
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
        builder: (_, state) =>
            PhaseDetailScreen(phaseId: state.pathParameters['id']!),
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

      // Profile
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),

      // Site
      GoRoute(
        path: '/site/:id',
        builder: (_, state) =>
            SiteDetailScreen(siteId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/site/create', builder: (_, __) => const SiteFormScreen()),
      GoRoute(
        path: '/site/:id/edit',
        builder: (_, state) =>
            SiteFormScreen(siteId: state.pathParameters['id']),
      ),

      // Plant
      GoRoute(path: '/plants', builder: (_, __) => const PlantListScreen()),
      GoRoute(
        path: '/plant/:id',
        builder: (_, state) =>
            PlantDetailScreen(plantId: state.pathParameters['id']!),
      ),

      // Forum
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

      // Monitoring Devices
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

      // Monitoring Sensors
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

      // Utilitas
      GoRoute(
        path: '/utilitas',
        builder: (_, __) => const UtilitasMenuScreen(),
      ),
      GoRoute(
        path: '/utilitas/sensors',
        builder: (_, __) => const SensorListScreen(),
      ),
      GoRoute(
        path: '/utilitas/sensors/create',
        builder: (_, __) => const SensorFormScreen(),
      ),
      GoRoute(
        path: '/utilitas/sensors/:id/edit',
        builder: (_, state) =>
            SensorFormScreen(sensorId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/sensors/:id',
        builder: (_, state) =>
            SensorFormScreen(sensorId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/devices',
        builder: (_, __) => const DeviceListScreen(),
      ),
      GoRoute(
        path: '/utilitas/devices/create',
        builder: (_, __) => const DeviceFormScreen(),
      ),
      GoRoute(
        path: '/utilitas/devices/:id/edit',
        builder: (_, state) =>
            DeviceFormScreen(deviceId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/devices/:id',
        builder: (_, state) =>
            DeviceFormScreen(deviceId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/plants',
        builder: (_, __) => const utilitas_plant.PlantListScreen(),
      ),
      GoRoute(
        path: '/utilitas/plants/create',
        builder: (_, __) => const utilitas_plant_form.PlantFormScreen(),
      ),
      GoRoute(
        path: '/utilitas/plants/:id/edit',
        builder: (_, state) => utilitas_plant_form.PlantFormScreen(
          plantId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/utilitas/plants/:id',
        builder: (_, state) => utilitas_plant_form.PlantFormScreen(
          plantId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/utilitas/units',
        builder: (_, __) => const UnitListScreen(),
      ),
      GoRoute(
        path: '/utilitas/units/create',
        builder: (_, __) => const UnitFormScreen(),
      ),
      GoRoute(
        path: '/utilitas/units/:id/edit',
        builder: (_, state) =>
            UnitFormScreen(unitId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/units/:id',
        builder: (_, state) =>
            UnitFormScreen(unitId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/users',
        builder: (_, __) => const UserListScreen(),
      ),
      GoRoute(
        path: '/utilitas/users/create',
        builder: (_, __) => const UserFormScreen(),
      ),
      GoRoute(
        path: '/utilitas/users/:id/edit',
        builder: (_, state) =>
            UserFormScreen(userId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/users/:id',
        builder: (_, state) =>
            UserFormScreen(userId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/roles',
        builder: (_, __) => const RoleListScreen(),
      ),
      GoRoute(
        path: '/utilitas/roles/create',
        builder: (_, __) => const RoleFormScreen(),
      ),
      GoRoute(
        path: '/utilitas/roles/:id/edit',
        builder: (_, state) =>
            RoleFormScreen(roleId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/roles/:id',
        builder: (_, state) =>
            RoleFormScreen(roleId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/permissions',
        builder: (_, __) => const PermissionListScreen(),
      ),
      GoRoute(
        path: '/utilitas/device-sensors',
        builder: (_, __) => const DeviceSensorListScreen(),
      ),
      GoRoute(
        path: '/utilitas/device-sensors/create',
        builder: (_, __) => const DeviceSensorFormScreen(),
      ),
      GoRoute(
        path: '/utilitas/device-sensors/:id/edit',
        builder: (_, state) =>
            DeviceSensorFormScreen(dsId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/utilitas/device-sensors/:id',
        builder: (_, state) =>
            DeviceSensorFormScreen(dsId: state.pathParameters['id']),
      ),
    ],
  );

  // Dispose listenable saat provider di-dispose
  ref.onDispose(authNotifier.dispose);

  return router;
});

/// ChangeNotifier yang listen ke authProvider dan notify GoRouter
/// saat auth state berubah — ini best practice untuk GoRouter + Riverpod
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
