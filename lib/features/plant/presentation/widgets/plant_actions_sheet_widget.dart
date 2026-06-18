import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/action_popup_menu_button.dart';

enum _PlantAction { edit, harvest, delete }

/// Popup menu aksi tanaman, dipakai di list, detail card, dan detail screen.
class PlantActionsMenuButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback? onHarvest;
  final VoidCallback? onDelete;
  final bool useSvgIcon;
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color iconColor;
  final String? tooltip;

  const PlantActionsMenuButton({
    super.key,
    required this.onEdit,
    this.onHarvest,
    this.onDelete,
    this.useSvgIcon = true,
    this.icon = Icons.more_vert,
    this.size = 58,
    this.iconSize = 28,
    this.backgroundColor = AppColors.surface,
    this.iconColor = AppColors.textPrimary,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = <ActionPopupMenuItem<_PlantAction>>[
      ActionPopupMenuItem(
        value: _PlantAction.edit,
        icon: Icons.edit_outlined,
        label: l10n.plantActionEdit,
        iconColor: AppColors.textPrimary,
      ),
      if (onHarvest != null)
        ActionPopupMenuItem(
          value: _PlantAction.harvest,
          icon: Icons.agriculture,
          label: l10n.plantActionHarvest,
          iconColor: AppColors.warning,
          labelColor: AppColors.warning,
        ),
      if (onDelete != null)
        ActionPopupMenuItem(
          value: _PlantAction.delete,
          icon: Icons.delete_outline,
          label: l10n.plantActionDelete,
          iconColor: AppColors.error,
          labelColor: AppColors.error,
        ),
    ];

    return MorePopupMenuButton<_PlantAction>(
      items: items,
      tooltip: tooltip,
      useSvgIcon: useSvgIcon,
      icon: icon,
      size: size,
      iconSize: iconSize,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      onSelected: (action) {
        switch (action) {
          case _PlantAction.edit:
            onEdit();
            break;
          case _PlantAction.harvest:
            onHarvest?.call();
            break;
          case _PlantAction.delete:
            onDelete?.call();
            break;
        }
      },
    );
  }
}
