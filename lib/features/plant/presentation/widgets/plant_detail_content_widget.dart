import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../domain/entities/plant.dart';

class PlantHeaderCardWidget extends StatelessWidget {
  final Plant plant;
  const PlantHeaderCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              plant.plantType?.icon ?? '🌱',
              style: const TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.displayName,
                  style: AppTextStyles.cardTitle(context, context.sp(18)),
                ),
                const SizedBox(height: 4),
                Text(
                  plant.plantType?.displayName ?? l10n.plantTypeHint,
                  style: AppTextStyles.hint(context, size: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: plant.isCurrentPlanting
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.textTertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    plant.statusText,
                    style: AppTextStyles.label(
                      context,
                      size: context.sp(12),
                      color: plant.isCurrentPlanting
                          ? AppColors.success
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlantGrowthCardWidget extends StatelessWidget {
  final Plant plant;
  const PlantGrowthCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hst = plant.hst ?? 0;
    final phase = plant.growthPhase ?? '-';

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.plantGrowthTitle, style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _GrowthStat(
                  label: l10n.plantHstLabel,
                  value: '$hst',
                  subtitle: l10n.plantHstSubtitle,
                  icon: Icons.calendar_today,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GrowthStat(
                  label: l10n.plantPhaseLabel,
                  value: phase,
                  subtitle: l10n.plantPhaseSubtitle,
                  icon: Icons.eco,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GrowthStat extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _GrowthStat({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.metric(context, size: context.sp(20), color: color),
          ),
          Text(
            label,
            style: AppTextStyles.label(context, size: context.sp(12), color: color),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.caption(context, size: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PlantInfoCardWidget extends StatelessWidget {
  final Plant plant;
  const PlantInfoCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.plantInfoTitle, style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 16),
          if (plant.plantSpecies != null) ...[
            _PlantInfoRow(
              icon: Icons.science,
              label: l10n.plantSpeciesLabel,
              value: plant.plantSpecies!,
            ),
            const SizedBox(height: 12),
          ],
          if (plant.plantDate != null) ...[
            _PlantInfoRow(
              icon: Icons.event,
              label: l10n.plantPlantDateLabel,
              value: DateFormatter.formatDate(plant.plantDate),
            ),
            const SizedBox(height: 12),
          ],
          if (plant.plantHarvest != null)
            _PlantInfoRow(
              icon: Icons.agriculture,
              label: plant.isHarvested
                  ? l10n.plantHarvestDateLabel
                  : l10n.plantTargetHarvestLabel,
              value: DateFormatter.formatDate(plant.plantHarvest),
            ),
        ],
      ),
    );
  }
}

class _PlantInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PlantInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textPrimary.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption(context, size: 12)),
              Text(
                value,
                style: AppTextStyles.label(context, size: context.sp(14)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Action buttons for phase list, GDD tracking, and harvest.
class PlantActionButtonsWidget extends StatelessWidget {
  final Plant plant;
  final VoidCallback onHarvest;

  const PlantActionButtonsWidget({
    super.key,
    required this.plant,
    required this.onHarvest,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.push(
              '/phases/${plant.siteId ?? plant.plantId}/${Uri.encodeComponent(plant.displayName)}',
            ),
            icon: const Icon(Icons.timeline),
            label: Text(
              l10n.plantViewPhases,
              style: AppTextStyles.label(context, size: context.sp(14)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),
        SizedBox(height: context.rh(0.014)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.push(
              '/gdd-tracking/${plant.siteId ?? plant.plantId}/${Uri.encodeComponent(plant.displayName)}',
            ),
            icon: const Icon(Icons.thermostat),
            label: Text(
              l10n.plantGddTracking,
              style: AppTextStyles.label(context, size: context.sp(14)),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),
        if (plant.isCurrentPlanting) ...[
          SizedBox(height: context.rh(0.014)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onHarvest,
              icon: const Icon(Icons.agriculture),
              label: Text(
                l10n.plantMarkHarvested,
                style: AppTextStyles.label(context, size: context.sp(14)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
