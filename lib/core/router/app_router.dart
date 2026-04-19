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
import '../../features/forum/presentation/screens/my_posts_screen.dart';
import '../../features/forum/presentation/screens/post_form_screen.dart';
import '../../shared/widgets/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final isOnboardingCompleted = ref.watch(onboardingProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (authState.status == AuthStatus.initial) {
        return isSplash ? null : '/splash';
      }

      if (authState.status == AuthStatus.loading && isLogin) {
        return null;
      }

      if (isLoggedIn) {
        if (isSplash || isLogin || isOnboarding) {
          return '/';
        }
        return null;
      }

      if (!isLoggedIn) {
        if (!isOnboardingCompleted && !isOnboarding) {
          return '/onboarding';
        }

        if (isLogin || isOnboarding) {
          return null;
        }

        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/', builder: (_, __) => const MainShell()),

      // Task routes
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

      // Recommendation routes
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

      // Phase routes
      GoRoute(
        path: '/phases/:plantId/:plantName',
        builder: (_, state) => PhaseListScreen(
          plantId: state.pathParameters['plantId']!,
          plantName: state.pathParameters['plantName']!,
        ),
      ),
      GoRoute(
        path: '/phase/:id',
        builder: (_, state) =>
            PhaseDetailScreen(phaseId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/gdd-tracking/:plantId/:plantName',
        builder: (_, state) => GddTrackingScreen(
          plantId: state.pathParameters['plantId']!,
          plantName: state.pathParameters['plantName']!,
        ),
      ),

      // Profile routes
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),

      // Site routes
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

      // Plant routes
      GoRoute(path: '/plants', builder: (_, __) => const PlantListScreen()),
      GoRoute(
        path: '/plant/:id',
        builder: (_, state) =>
            PlantDetailScreen(plantId: state.pathParameters['id']!),
      ),

      // Forum routes
      GoRoute(path: '/forum', builder: (_, __) => const ForumScreen()),
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
    ],
  );
});
