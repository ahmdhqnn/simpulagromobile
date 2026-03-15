import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
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
    ],
  );
});
