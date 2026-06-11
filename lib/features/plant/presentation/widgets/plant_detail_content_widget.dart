import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../shared/widgets/status_chip_widget.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../utils/plant_phase_display.dart';

class PlantHeaderCardWidget extends StatelessWidget {
  final Plant plant;
  const PlantHeaderCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = _statusColor(plant);
    final typeLabel =
        plant.plantType?.localizedLabel(l10n) ?? l10n.plantTypeHint;
    final subtitle = plant.varietasId?.isNotEmpty == true
        ? '$typeLabel - ${plant.varietasId}'
        : typeLabel;

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      radius: AppRadius.lg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadgeWidget.icon(
            icon: Icons.local_florist_outlined,
            background: AppColors.softGreen,
            tint: AppColors.primary,
            size: 50,
            iconSize: 22,
            radius: AppRadius.sm,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle(context, context.sp(17)),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(
                    context,
                    size: context.sp(12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StatusChipWidget(
            label: plant.localizedStatus(l10n),
            color: statusColor,
            radius: AppRadius.xs,
            fontSize: 11,
            horizontalPadding: 10,
            verticalPadding: 6,
          ),
        ],
      ),
    );
  }
}

class PlantGrowthCardWidget extends ConsumerWidget {
  final Plant plant;
  const PlantGrowthCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedSiteId = ref.watch(selectedSiteIdProvider);
    final siteId = phaseSiteIdForPlant(plant, fallbackSiteId: selectedSiteId);
    final phaseAsync = plant.isCurrentPlanting
        ? ref.watch(currentPhaseProvider(siteId))
        : null;
    final phase = phaseAsync?.valueOrNull;
    final phaseLabel = phaseLabelForPlant(plant, phaseAsync, l10n);
    final hst = plant.hst;

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadgeWidget.icon(
                icon: Icons.trending_up_rounded,
                background: AppColors.softBlue,
                tint: AppColors.infoDeep,
                size: 38,
                iconSize: 18,
                padding: EdgeInsets.all(10),
                radius: AppRadius.sm,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.plantGrowthTitle,
                style: AppTextStyles.cardTitle(context, context.sp(16)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _GrowthStat(
                  label: l10n.plantHstLabel,
                  value: hst == null ? '-' : '$hst',
                  subtitle: l10n.plantHstSubtitle,
                  icon: Icons.calendar_today_outlined,
                  color: AppColors.primary,
                ),
              ),
              Container(
                width: 1,
                height: 58,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.divider,
              ),
              Expanded(
                child: _GrowthStat(
                  label: l10n.plantPhaseLabel,
                  value: phaseLabel,
                  subtitle: phase == null
                      ? l10n.plantPhaseSubtitle
                      : '${l10n.plantHstLabel} ${phase.hstMin}-${phase.hstMax}',
                  icon: Icons.eco_outlined,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          if (phase != null) ...[
            const SizedBox(height: 14),
            _PhaseProgress(phaseProgress: phase.progressPercentage),
          ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption(
                  context,
                  size: context.sp(11),
                  color: AppColors.textSecondary,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.metric(
                  context,
                  size: context.sp(18),
                  color: color,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption(context, size: context.sp(10)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhaseProgress extends StatelessWidget {
  final double phaseProgress;

  const _PhaseProgress({required this.phaseProgress});

  @override
  Widget build(BuildContext context) {
    final percent = phaseProgress.clamp(0, 100).round();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.phaseDetailProgressTitle,
              style: AppTextStyles.caption(
                context,
                size: context.sp(11),
                color: AppColors.textSecondary,
                weight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '$percent%',
              style: AppTextStyles.caption(
                context,
                size: context.sp(11),
                color: AppColors.textPrimary,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
          ),
        ),
      ],
    );
  }
}

class PlantInfoCardWidget extends StatelessWidget {
  final Plant plant;
  const PlantInfoCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = _statusColor(plant);
    final rows = [
      _PlantInfoData(
        icon: Icons.tag_outlined,
        label: l10n.adminPlantIdLabel,
        value: plant.plantId,
      ),
      _PlantInfoData(
        icon: Icons.grass_outlined,
        label: l10n.plantTypeLabel,
        value: plant.plantType?.localizedLabel(l10n) ?? '-',
      ),
      _PlantInfoData(
        icon: Icons.badge_outlined,
        label: l10n.plantVarietasIdLabel,
        value: plant.varietasId ?? '-',
      ),
      _PlantInfoData(
        icon: Icons.science_outlined,
        label: l10n.plantSpeciesLabel,
        value: plant.plantSpecies ?? '-',
      ),
      _PlantInfoData(
        icon: Icons.event_outlined,
        label: l10n.plantPlantDateLabel,
        value: DateFormatter.formatDate(plant.plantDate),
      ),
      if (plant.plantHarvest != null)
        _PlantInfoData(
          icon: Icons.agriculture_outlined,
          label: plant.isHarvested
              ? l10n.plantHarvestDateLabel
              : l10n.plantTargetHarvestLabel,
          value: DateFormatter.formatDate(plant.plantHarvest),
        ),
      _PlantInfoData(
        icon: Icons.verified_outlined,
        label: l10n.plantStatusLabel,
        value: plant.localizedStatus(l10n),
        valueColor: statusColor,
      ),
    ];

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.plantInfoTitle, style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++) ...[
            _PlantInfoRow(data: rows[i]),
            if (i != rows.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _PlantInfoData {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _PlantInfoData({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
}

class _PlantInfoRow extends StatelessWidget {
  final _PlantInfoData data;

  const _PlantInfoRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            data.icon,
            size: 18,
            color: AppColors.textPrimary.withValues(alpha: 0.54),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: AppTextStyles.caption(
                    context,
                    size: context.sp(11),
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label(
                    context,
                    size: context.sp(13),
                    color: data.valueColor ?? AppColors.textPrimary,
                    weight: FontWeight.w600,
                    height: 1.35,
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
          child: FilledButton.icon(
            onPressed: () => context.push(
              '/phases/${plant.siteId ?? plant.plantId}/${Uri.encodeComponent(plant.displayName)}',
            ),
            icon: const Icon(Icons.timeline_outlined, size: 18),
            label: Text(l10n.plantViewPhases),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              textStyle: AppTextStyles.label(
                context,
                size: context.sp(14),
                weight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(height: context.rh(0.012)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.push(
              '/gdd-tracking/${plant.siteId ?? plant.plantId}/${Uri.encodeComponent(plant.displayName)}',
            ),
            icon: const Icon(Icons.thermostat_outlined, size: 18),
            label: Text(l10n.plantGddTracking),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              textStyle: AppTextStyles.label(
                context,
                size: context.sp(14),
                weight: FontWeight.w700,
              ),
            ),
          ),
        ),
        if (plant.isCurrentPlanting) ...[
          SizedBox(height: context.rh(0.012)),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onHarvest,
              icon: const Icon(Icons.agriculture_outlined, size: 18),
              label: Text(l10n.plantMarkHarvested),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                textStyle: AppTextStyles.label(
                  context,
                  size: context.sp(14),
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

Color _statusColor(Plant plant) {
  if (plant.isHarvested) return AppColors.warning;
  if (plant.isCurrentPlanting) return AppColors.success;
  return AppColors.textTertiary;
}
