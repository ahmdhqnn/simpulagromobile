import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/ui_error_message.dart';
import 'app_card_widget.dart';

class InfoStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final String? svgIconPath;
  final Color? iconColor;
  final double height;
  final double radius;

  const InfoStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.svgIconPath,
    this.iconColor,
    this.height = 73,
    this.radius = AppRadius.xl,
  });

  const InfoStateWidget.svg({
    super.key,
    required this.message,
    required String this.svgIconPath,
    this.iconColor,
    this.height = 73,
    this.radius = AppRadius.xl,
  }) : icon = null;

  const InfoStateWidget.icon({
    super.key,
    required this.message,
    required IconData this.icon,
    this.iconColor,
    this.height = 73,
    this.radius = AppRadius.xl,
  }) : svgIconPath = null;

  @override
  Widget build(BuildContext context) {
    final mutedColor =
        iconColor ?? AppColors.textPrimary.withValues(alpha: 0.3);

    Widget iconWidget;
    if (svgIconPath != null) {
      iconWidget = SvgPicture.asset(
        svgIconPath!,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(mutedColor, BlendMode.srcIn),
      );
    } else if (icon != null) {
      iconWidget = Icon(icon, size: 28, color: mutedColor);
    } else {
      iconWidget = const SizedBox.shrink();
    }

    return AppCardWidget(
      height: height,
      radius: radius,
      padding: EdgeInsets.zero,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(height: context.rh(0.005)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                color: AppColors.textPrimary,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorStateCardWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateCardWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 28),
          SizedBox(height: context.rh(0.01)),
          Text(
            toUiErrorMessage(message),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(12),
              color: AppColors.error,
            ),
          ),
          SizedBox(height: context.rh(0.01)),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text(
              'Coba Lagi',
              style: TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }
}

class LoadingCardWidget extends StatelessWidget {
  final double height;
  final double radius;

  const LoadingCardWidget({
    super.key,
    this.height = 120,
    this.radius = AppRadius.xl,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
