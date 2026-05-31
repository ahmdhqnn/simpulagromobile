import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';

class NoActivePlantCardWidget extends StatelessWidget {
  const NoActivePlantCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCardWidget(
      radius: AppRadius.lg,
      color: AppColors.softOrange,
      border: Border.all(color: AppColors.warning.withValues(alpha: 0.24)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBadgeWidget.icon(
                icon: Icons.local_florist_outlined,
                background: AppColors.surface,
                tint: AppColors.warning,
                radius: AppRadius.sm,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.monitoringNoActivePlantTitle,
                      style: AppTextStyles.cardTitle(context, 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.monitoringNoActivePlantMessage,
                      style: AppTextStyles.caption(
                        context,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(0.014)),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/plant/create'),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.monitoringAddPlant),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                tooltip: l10n.monitoringViewPlantList,
                onPressed: () => context.push('/plants'),
                icon: const Icon(Icons.list_alt_rounded),
                color: AppColors.primary,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  fixedSize: const Size(46, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
