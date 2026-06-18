import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../utils/plant_mutation_actions.dart';
import '../utils/plant_phase_display.dart';
import 'agro_indicator_button_widget.dart';
import 'growth_phase_button_widget.dart';
import 'plant_actions_sheet_widget.dart';
import 'plant_recommendation_cards_widget.dart';

class PlantDetailCard extends ConsumerWidget {
  final Plant plant;

  const PlantDetailCard({super.key, required this.plant});

  String get _plantImage {
    return 'assets/images/padi-perkecambahan-image.png';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedSiteId = ref.watch(selectedSiteIdProvider);
    final siteId = phaseSiteIdForPlant(plant, fallbackSiteId: selectedSiteId);
    final phaseAsync = plant.isCurrentPlanting
        ? ref.watch(currentPhaseProvider(siteId))
        : null;
    final phaseLabel = phaseLabelForPlant(plant, phaseAsync, l10n);
    final gapSm = context.rh(0.012);
    final gapMd = context.rh(0.016);
    final gapLg = context.rh(0.02);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.rh(0.015)),
            _PlantCardHeader(actions: _buildActionsMenu(context, ref)),
            SizedBox(height: gapLg),
            Text(
              AppLocalizations.of(context)!.plantOverviewTitle,
              style: AppTextStyles.sectionTitle(context),
            ),
            SizedBox(height: gapMd),
            _PlantImageSection(plant: plant, image: _plantImage),
            SizedBox(height: gapMd),
            _PlantInfoSection(plant: plant, phaseLabel: phaseLabel),
            SizedBox(height: gapSm),
            PlantRecommendationCardsWidget(plant: plant),
            SizedBox(height: bottomNavigationContentSpace(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.read(authProvider).isAdmin;

    return PlantActionsMenuButton(
      tooltip: AppLocalizations.of(context)!.adminPlantActionsTooltip,
      onEdit: () => context.push('/plant/${plant.plantId}/edit'),
      onHarvest: plant.isCurrentPlanting
          ? () => PlantMutationActions.confirmAndHarvest(
              context,
              ref,
              plant: plant,
            )
          : null,
      onDelete: isAdmin
          ? () => PlantMutationActions.confirmAndDelete(
              context,
              ref,
              plant: plant,
            )
          : null,
    );
  }
}

class _PlantCardHeader extends StatelessWidget {
  final Widget actions;

  const _PlantCardHeader({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [actions]);
  }
}

class _PlantImageSection extends StatelessWidget {
  final Plant plant;
  final String image;

  const _PlantImageSection({required this.plant, required this.image});

  @override
  Widget build(BuildContext context) {
    final imageAreaHeight = context.rh(0.355).clamp(220.0, 320.0);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: imageAreaHeight,
          child: Transform.scale(
            scale: 1.2,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Center(
                child: Icon(
                  Icons.local_florist_outlined,
                  size: context.rw(0.18).clamp(64.0, 90.0),
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.rh(0.015)),
        Row(
          children: [
            GrowthPhaseButton(
              siteId: plant.siteId ?? '',
              plantName:
                  plant.plantType?.localizedLabel(
                    AppLocalizations.of(context)!,
                  ) ??
                  plant.plantName ??
                  AppLocalizations.of(context)!.plantTitle,
            ),
            const Spacer(),
            const AgroIndicatorButton(),
          ],
        ),
      ],
    );
  }
}

class _PlantInfoSection extends StatelessWidget {
  final Plant plant;
  final String phaseLabel;

  const _PlantInfoSection({required this.plant, required this.phaseLabel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = plant.isHarvested
        ? AppColors.warning
        : plant.isCurrentPlanting
        ? AppColors.success
        : AppColors.textTertiary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(0.038)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w300,
                        height: 1,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.rh(0.006)),
                    Text(
                      phaseLabel,
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
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  plant.localizedStatus(l10n),
                  style: AppTextStyles.label(
                    context,
                    size: context.sp(11),
                    color: statusColor,
                    weight: FontWeight.w700,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(0.018)),
          _DetailRow(
            label: l10n.plantTypeLabel,
            value: plant.plantType?.localizedLabel(l10n) ?? '-',
          ),
          _DetailRow(
            label: l10n.plantVarietasIdLabel,
            value: plant.varietasId ?? '-',
          ),
          _DetailRow(
            label: l10n.plantDateLabel,
            value: DateFormatter.formatDate(plant.plantDate),
          ),
          _DetailRow(
            label: l10n.plantHstLabel,
            value: plant.hst != null
                ? '${plant.hst} ${l10n.plantHstUnit}'
                : '-',
          ),
          _DetailRow(label: l10n.plantPhaseLabel, value: phaseLabel),
          if (plant.plantSpecies != null)
            _DetailRow(
              label: l10n.plantSpeciesLabel,
              value: plant.plantSpecies!,
            ),
          if (plant.plantHarvest != null)
            _DetailRow(
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: (context.sw * 0.36).clamp(104.0, 140.0),
            child: Text(
              label,
              style: AppTextStyles.label(
                context,
                size: context.sp(12),
                color: AppColors.textPrimary,
                weight: FontWeight.w600,
                height: 1.35,
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
              style: AppTextStyles.caption(
                context,
                size: context.sp(12),
                weight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
