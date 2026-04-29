import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

// ═══════════════════════════════════════════════════════════
// UTILITAS SCAFFOLD
// Header pattern: 2 tombol bulat putih (kiri: back, kanan: action)
// TANPA title teks — persis seperti agro_indicator_screen
// dan phase_list_screen
// ═══════════════════════════════════════════════════════════
class UtilitasScaffold extends StatelessWidget {
  final String title; // dipakai sebagai section title di dalam body
  final Widget body;
  final Widget? action; // tombol kanan (add, more, dll)
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
          // Kiri: back button atau spacer
          if (showBack)
            _CircleButton(
              onTap: () => context.pop(),
              child: SvgPicture.asset(
                'assets/icons/chevron-left-icon.svg',
                width: 28,
                height: 28,
              ),
            )
          else
            const SizedBox(width: 58),

          // Kanan: action button (add/more) atau spacer
          if (action != null)
            action!
          else if (onRefresh != null)
            _CircleButton(
              onTap: onRefresh!,
              child: SvgPicture.asset(
                'assets/icons/more-icon.svg',
                width: 28,
                height: 28,
              ),
            )
          else
            const SizedBox(width: 58),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// UTILITAS FORM SCAFFOLD
// Header: kiri back button, kanan spacer — TANPA title teks
// Persis seperti agro_indicator_screen._buildHeader
// ═══════════════════════════════════════════════════════════
class UtilitasFormScaffold extends StatelessWidget {
  final String title; // tidak ditampilkan di header, bisa dipakai di body
  final Widget body;
  final bool isLoading;
  final String? loadingMessage;

  const UtilitasFormScaffold({
    super.key,
    required this.title,
    required this.body,
    this.isLoading = false,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Stack(
                children: [
                  body,
                  if (isLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.35),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                              if (loadingMessage != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  loadingMessage!,
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: context.sp(14),
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xFF1D1D1D),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
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
          // Kiri: back button
          _CircleButton(
            onTap: () => context.pop(),
            child: SvgPicture.asset(
              'assets/icons/chevron-left-icon.svg',
              width: 28,
              height: 28,
            ),
          ),
          // Kanan: spacer (simetris seperti agro/phase)
          const SizedBox(width: 58),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// CIRCLE BUTTON — 58×58 putih, radius 32
// Identik dengan agro_indicator_screen & phase_list_screen
// ═══════════════════════════════════════════════════════════
class _CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _CircleButton({required this.onTap, required this.child});

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
        child: Center(child: child),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ADD BUTTON — 58×58 putih, plus-outline-icon primary
// Mengikuti task_list_screen.dart
// ═══════════════════════════════════════════════════════════
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/plus-outline-icon.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// LOADING STATE
// ═══════════════════════════════════════════════════════════
class UtilitasLoadingState extends StatelessWidget {
  const UtilitasLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ERROR STATE — mengikuti agro_indicator_screen._buildErrorState
// ═══════════════════════════════════════════════════════════
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
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: context.rh(0.03)),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════
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
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SECTION TITLE — sp(22), w400, height 1.0
// Identik dengan _SectionTitle di agro_indicator_screen
// ═══════════════════════════════════════════════════════════
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

// ═══════════════════════════════════════════════════════════
// SECTION CARD — white card, borderRadius: 20, padding: 12
// ═══════════════════════════════════════════════════════════
class UtilitasSectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final EdgeInsets? padding;

  const UtilitasSectionCard({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(16),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SUBMIT BUTTON — mengikuti Signout button di profile_screen
// height: 60, borderRadius: 100, white bg, text hitam
// ═══════════════════════════════════════════════════════════
class UtilitasSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const UtilitasSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.22,
                  ),
                ),
        ),
      ),
    );
  }
}
