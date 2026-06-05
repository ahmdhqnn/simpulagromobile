import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import 'monitoring_card_header_widget.dart';

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
          MonitoringCardHeaderWidget.icon(
            icon: Icons.local_florist_outlined,
            title: l10n.monitoringNoActivePlantTitle,
            description: l10n.monitoringNoActivePlantMessage,
            background: AppColors.surface,
            tint: AppColors.warning,
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
