import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

/// Shared scaffold untuk semua screen Utilitas
/// Mengikuti design pattern dari agro_indicator_screen.dart & phase_list_screen.dart
class UtilitasScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? action; // tombol di kanan header (misal: add button)
  final bool showBack;
  final VoidCallback? onRefresh;

  const UtilitasScaffold({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.showBack = true,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBack)
            _CircleButton(
              icon: SvgPicture.asset(
                'assets/icons/chevron-left-icon.svg',
                width: 28,
                height: 28,
              ),
              onTap: () => context.pop(),
            )
          else
            const SizedBox(width: 58),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
            ),
          ),
          if (action != null)
            action!
          else if (onRefresh != null)
            _CircleButton(
              icon: const Icon(
                Icons.refresh,
                size: 24,
                color: Color(0xFF1D1D1D),
              ),
              onTap: onRefresh!,
            )
          else
            const SizedBox(width: 58),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(child: icon),
      ),
    );
  }
}

/// Add button untuk header kanan
class UtilitasAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const UtilitasAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

/// Loading state konsisten
class UtilitasLoadingState extends StatelessWidget {
  const UtilitasLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

/// Error state konsisten — mengikuti pattern agro_indicator_screen
class UtilitasErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const UtilitasErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: context.rw(0.164).clamp(48.0, 72.0),
              color: AppColors.error,
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              'Gagal memuat data',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state konsisten
class UtilitasEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const UtilitasEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: context.rw(0.164).clamp(48.0, 72.0),
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.2),
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section title — mengikuti _SectionTitle dari agro_indicator_screen
class UtilitasSectionTitle extends StatelessWidget {
  final String title;

  const UtilitasSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(22),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF1D1D1D),
        height: 1.0,
      ),
    );
  }
}
