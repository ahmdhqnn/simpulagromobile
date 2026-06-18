import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_theme.dart';

class ActionPopupMenuItem<T> {
  final T value;
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color? labelColor;
  final bool enabled;

  const ActionPopupMenuItem({
    required this.value,
    required this.icon,
    required this.label,
    this.iconColor = AppColors.textSecondary,
    this.labelColor,
    this.enabled = true,
  });
}

class ActionPopupMenuButton<T> extends StatelessWidget {
  final List<ActionPopupMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final Widget child;
  final String? tooltip;
  final Offset offset;

  const ActionPopupMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    required this.child,
    this.tooltip,
    this.offset = const Offset(0, 8),
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      padding: EdgeInsets.zero,
      tooltip: tooltip,
      color: AppColors.surface,
      elevation: 0,
      offset: offset,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      onSelected: onSelected,
      itemBuilder: (_) => items
          .map(
            (item) => PopupMenuItem<T>(
              value: item.value,
              enabled: item.enabled,
              child: Row(
                children: [
                  Icon(item.icon, size: 18, color: item.iconColor),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label(
                        context,
                        size: 13,
                        weight: FontWeight.w500,
                        height: 1.2,
                        color: item.labelColor ?? AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: child,
    );
  }
}

class MorePopupMenuButton<T> extends StatelessWidget {
  final List<ActionPopupMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final String? tooltip;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color iconColor;
  final bool useSvgIcon;
  final IconData icon;
  final Offset offset;

  const MorePopupMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    this.tooltip,
    this.size = 58,
    this.iconSize = 28,
    this.backgroundColor = AppColors.surface,
    this.iconColor = AppColors.textPrimary,
    this.useSvgIcon = true,
    this.icon = Icons.more_vert,
    this.offset = const Offset(0, 8),
  });

  @override
  Widget build(BuildContext context) {
    return ActionPopupMenuButton<T>(
      items: items,
      onSelected: onSelected,
      tooltip: tooltip,
      offset: offset,
      child: Container(
        width: size,
        height: size,
        decoration: backgroundColor == null
            ? null
            : BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(size / 2),
              ),
        child: Center(
          child: useSvgIcon
              ? SvgPicture.asset(
                  'assets/icons/more-icon.svg',
                  width: iconSize,
                  height: iconSize,
                  colorFilter: iconColor == AppColors.textPrimary
                      ? null
                      : ColorFilter.mode(iconColor, BlendMode.srcIn),
                )
              : Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }
}
