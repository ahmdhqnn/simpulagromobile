import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/plant.dart';

/// Bottom sheet aksi tanaman — dipakai di list, detail card, dan detail screen.
class PlantActionsSheet extends StatelessWidget {
  final Plant plant;
  final VoidCallback onEdit;
  final VoidCallback? onHarvest;
  final VoidCallback? onDelete;

  const PlantActionsSheet({
    super.key,
    required this.plant,
    required this.onEdit,
    this.onHarvest,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: context.rh(0.015)),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rw(0.051),
              context.rh(0.02),
              context.rw(0.051),
              context.rh(0.01),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                plant.displayName,
                style: AppTextStyles.cardTitle(context),
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.divider),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.primary),
            title: Text(
              l10n.plantActionEdit,
              style: AppTextStyles.label(context, size: context.sp(14)),
            ),
            onTap: onEdit,
          ),
          if (onHarvest != null)
            ListTile(
              leading: const Icon(Icons.agriculture, color: AppColors.warning),
              title: Text(
                l10n.plantActionHarvest,
                style: AppTextStyles.label(
                  context,
                  size: context.sp(14),
                  color: AppColors.warning,
                ),
              ),
              onTap: onHarvest,
            ),
          if (onDelete != null)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                l10n.plantActionDelete,
                style: AppTextStyles.label(
                  context,
                  size: context.sp(14),
                  color: AppColors.error,
                ),
              ),
              onTap: onDelete,
            ),
          SizedBox(height: context.rh(0.01)),
        ],
      ),
    );
  }
}
