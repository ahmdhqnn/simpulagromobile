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
  final IconData icon;
  final double size;
  final double iconSize;

  const CircularIconActionWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 58,
    this.iconSize = 24,
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
        icon: Icon(icon, size: iconSize),
        onPressed: onPressed,
      ),
    );
  }
}
