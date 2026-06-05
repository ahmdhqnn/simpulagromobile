import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
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
    this.titleMaxLines = 1,
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
    this.titleMaxLines = 1,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        badge,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: titleMaxLines,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle(context, 16),
              ),
              if (description != null && description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  description!,
                  maxLines: descriptionMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(
                    context,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
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
