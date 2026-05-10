import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/auth_provider.dart';

/// Splash screen — tampilkan animasi logo, lalu navigasi ke screen yang tepat.
/// Auth state sudah diset dari preloaded data di main() tanpa I/O,
/// sehingga navigasi bisa langsung dilakukan setelah animasi selesai.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Mulai animasi, lalu navigasi setelah selesai
    _controller.forward().then((_) => _navigateNext());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Navigasi ke screen berikutnya berdasarkan auth state.
  /// Auth state sudah tersedia dari preloaded data — tidak ada delay I/O.
  void _navigateNext() {
    if (!mounted) return;

    final authState = ref.read(authProvider);
    final isOnboardingCompleted = ref.read(onboardingProvider);

    switch (authState.status) {
      case AuthStatus.authenticated:
        context.go('/');
        break;
      case AuthStatus.unauthenticated:
        if (!isOnboardingCompleted) {
          context.go('/onboarding');
        } else {
          // Tampilkan pesan session expired jika ada
          final error = authState.error;
          if (error != null && error.contains('Sesi')) {
            context.go('/login?reason=session_expired');
          } else {
            context.go('/login');
          }
        }
        break;
      case AuthStatus.initial:
      case AuthStatus.loading:
        // Fallback — seharusnya tidak terjadi karena preloaded
        context.go('/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D503F),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SvgPicture.asset(
              'assets/images/simpulagro_logo.svg',
              width: (context.sw * 0.46).clamp(120.0, 220.0),
            ),
          ),
        ),
      ),
    );
  }
}
