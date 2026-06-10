import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../core/utils/locale_formatters.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../l10n/localized_labels.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../phase/presentation/providers/phase_provider.dart';
import '../../../../plant/domain/entities/plant.dart';
import '../../../../plant/presentation/utils/plant_phase_display.dart';
import '../monitoring_card_header_widget.dart';

class GrowthPhaseCardWidget extends ConsumerWidget {
  final Plant plant;
  const GrowthPhaseCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final phaseAsync = plant.isCurrentPlanting
        ? ref.watch(currentPhaseProvider(phaseSiteIdForPlant(plant)))
        : null;
    final phase = phaseAsync?.valueOrNull;
    final phaseLabel = phaseLabelForPlant(plant, phaseAsync, l10n);

    return AppCardWidget.elevated(
      boxShadow: null,
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonitoringCardHeaderWidget.icon(
            icon: Icons.grass_outlined,
            title: l10n.monitoringCurrentGrowthPhase,
            description: phaseLabel,
            background: AppColors.softBlue,
            tint: AppColors.infoDeep,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            label: l10n.plantTypeLabel,
            value: plant.plantType?.localizedLabel(l10n) ?? '-',
          ),
          _InfoRow(
            label: l10n.plantPlantDateLabel,
            value: DateFormatter.formatDate(
              plant.plantDate,
              locale: context.localeTag,
            ),
          ),
          _InfoRow(
            label: l10n.plantHstLabel,
            value: plant.hst != null
                ? '${plant.hst} ${l10n.plantHstUnit}'
                : '-',
          ),
          _InfoRow(label: l10n.plantPhaseLabel, value: phaseLabel),
          _InfoRow(
            label: l10n.plantStatusLabel,
            value: _plantStatusLabel(context, plant),
          ),
          if (phase != null) ...[
            const SizedBox(height: 6),
            _PhaseProgress(
              progress: phase.progressPercentage,
              range: '${l10n.plantHstUnit} ${phase.hstMin}-${phase.hstMax}',
            ),
          ],
        ],
      ),
    );
  }

  String _plantStatusLabel(BuildContext context, Plant plant) {
    if (plant.isHarvested) return context.l10n.plantStatusHarvested;
    if (plant.isCurrentPlanting) return context.l10n.plantStatusGrowing;
    return context.l10n.commonInactive;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption(
                context,
                size: context.sp(11),
                color: AppColors.textSecondary,
                weight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label(
                context,
                size: context.sp(12),
                weight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseProgress extends StatelessWidget {
  final double progress;
  final String range;

  const _PhaseProgress({required this.progress, required this.range});

  @override
  Widget build(BuildContext context) {
    final percent = progress.clamp(0, 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              range,
              style: AppTextStyles.caption(context, size: context.sp(11)),
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
