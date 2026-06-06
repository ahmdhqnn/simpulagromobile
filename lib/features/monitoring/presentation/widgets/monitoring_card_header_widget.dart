import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';

class MonitoringCardHeaderWidget extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final String? svgIconPath;
  final Color background;
  final Color? tint;
  final Widget? trailing;
  final double iconBoxSize;
  final double iconSize;
  final int titleMaxLines;
  final int descriptionMaxLines;

  const MonitoringCardHeaderWidget.icon({
    super.key,
    required this.title,
    required IconData this.icon,
    required this.background,
    this.description,
    this.tint,
    this.trailing,
    this.iconBoxSize = 50,
    this.iconSize = 20,
    this.titleMaxLines = 2,
    this.descriptionMaxLines = 2,
  }) : svgIconPath = null;

  const MonitoringCardHeaderWidget.svg({
    super.key,
    required this.title,
    required String this.svgIconPath,
    required this.background,
    this.description,
    this.tint,
    this.trailing,
    this.iconBoxSize = 50,
    this.iconSize = 20,
    this.titleMaxLines = 2,
    this.descriptionMaxLines = 2,
  }) : icon = null;

  @override
  Widget build(BuildContext context) {
    final iconPadding = EdgeInsets.all((iconBoxSize - iconSize) / 2);
    final badge = svgIconPath != null
        ? IconBadgeWidget.svg(
            svgIconPath: svgIconPath!,
            background: background,
            tint: tint,
            size: iconBoxSize,
            iconSize: iconSize,
            padding: iconPadding,
            radius: AppRadius.xs,
          )
        : IconBadgeWidget.icon(
            icon: icon!,
            background: background,
            tint: tint,
            size: iconBoxSize,
            iconSize: iconSize,
            padding: iconPadding,
            radius: AppRadius.xs,
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        badge,
        SizedBox(width: context.rw(0.02)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: titleMaxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(22),
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              if (description != null && description!.isNotEmpty) ...[
                const SizedBox(height: 1),
                Text(
                  description!,
                  maxLines: descriptionMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.hint(context),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}
