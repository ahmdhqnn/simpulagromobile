import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';

class CircularBackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final String svgIconPath;

  const CircularBackButtonWidget({
    super.key,
    required this.onPressed,
    this.size = 58,
    this.svgIconPath = 'assets/icons/chevron-left-icon.svg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: IconButton(
        icon: SvgPicture.asset(svgIconPath, width: 28, height: 28),
        onPressed: onPressed,
      ),
    );
  }
}

class CircularIconActionWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? svgIconPath;
  final double size;
  final double iconSize;

  const CircularIconActionWidget({
    super.key,
    required this.onPressed,
    this.icon,
    this.svgIconPath,
    this.size = 58,
    this.iconSize = 24,
  }) : assert(icon != null || svgIconPath != null);

  @override
  Widget build(BuildContext context) {
    final iconWidget = svgIconPath != null
        ? SvgPicture.asset(
            svgIconPath!,
            width: iconSize,
            height: iconSize,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          )
        : Icon(icon, size: iconSize);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: IconButton(icon: iconWidget, onPressed: onPressed),
    );
  }
}
