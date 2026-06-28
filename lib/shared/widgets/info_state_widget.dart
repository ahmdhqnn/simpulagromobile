import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/ui_error_message.dart';
import '../../l10n/l10n.dart';
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
  final Object message;
  final VoidCallback onRetry;
  final double? height;
  final double? width;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final IconData icon;
  final String? svgIconPath;

  const ErrorStateCardWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.height,
    this.width = double.infinity,
    this.radius = AppRadius.lg,
    this.padding,
    this.icon = Icons.error_outline_rounded,
    this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    final retryIcon = SvgPicture.asset(
      'assets/icons/arrow-rotate-left.svg',
      width: 16,
      height: 16,
      colorFilter: const ColorFilter.mode(AppColors.error, BlendMode.srcIn),
    );

    final leading = svgIconPath == null
        ? Icon(icon, color: AppColors.error, size: 24)
        : SvgPicture.asset(
            svgIconPath!,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.error,
              BlendMode.srcIn,
            ),
          );

    return AppCardWidget(
      height: height,
      width: width,
      radius: radius,
      color: AppColors.surface,
      border: Border.all(color: AppColors.error.withValues(alpha: 0.18)),
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: context.rw(0.04).clamp(14.0, 20.0),
            vertical: 14,
          ),
      child: Column(
        mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: leading,
          ),
          const SizedBox(height: 10),
          Text(
            toUiErrorMessage(message, context.l10n),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.label(
              context,
              size: context.sp(12),
              weight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: retryIcon,
            label: Text(context.l10n.commonRetry),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
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
