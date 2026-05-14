import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'icon_badge_widget.dart';

class StatItemWidget extends StatelessWidget {
  final String label;
  final String value;
  final String? svgIconPath;
  final IconData? icon;
  final Color background;
  final Color? iconTint;
  final double labelTopGap;

  const StatItemWidget({
    super.key,
    required this.label,
    required this.value,
    required this.background,
    this.svgIconPath,
    this.icon,
    this.iconTint,
    this.labelTopGap = 4,
  }) : assert(
         svgIconPath != null || icon != null,
         'Either svgIconPath or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        svgIconPath != null
            ? IconBadgeWidget.svg(
                svgIconPath: svgIconPath!,
                background: background,
                tint: iconTint,
                padding: const EdgeInsets.only(
                  top: 11,
                  left: 10,
                  right: 10,
                  bottom: 9,
                ),
              )
            : IconBadgeWidget.icon(
                icon: icon!,
                background: background,
                tint: iconTint,
              ),
        const SizedBox(width: 11),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.0,
              ),
            ),
            SizedBox(height: labelTopGap),
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.83,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
