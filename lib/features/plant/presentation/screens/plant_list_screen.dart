import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../utils/plant_mutation_actions.dart';
import '../widgets/plant_actions_sheet_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';
import '../utils/plant_phase_display.dart';

class PlantListScreen extends ConsumerWidget {
  const PlantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);
    final plantsAsync = ref.watch(plantsProvider);

    if (siteId == null) {
      return Scaffold(
        backgroundColor: AppColors.surfaceVariant,
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.emptySite,
            style: AppTextStyles.caption(context, size: 14),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      body: SafeArea(
        child: plantsAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => Column(
            children: [
              const _ListHeader(),
              Expanded(child: buildListSkeleton(count: 5, type: 'plant')),
            ],
          ),
          error: (error, _) => _ListErrorState(error: error),
          data: (plants) => plants.isEmpty
              ? const Column(
                  children: [
                    _ListHeader(),
                    Expanded(child: _EmptyState()),
                  ],
                )
              : _PlantList(plants: plants),
        ),
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          CircularBackButtonWidget(
            onPressed: () => context.push('/plant/create'),
            svgIconPath: 'assets/icons/plus-outline-icon.svg',
          ),
        ],
      ),
    );
  }
}

class _PlantList extends ConsumerWidget {
  final List<Plant> plants;

  const _PlantList({required this.plants});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final siteId = ref.read(selectedSiteIdProvider);
        if (siteId != null) {
          ref.invalidate(currentPhaseProvider(siteId));
          ref.invalidate(phaseListProvider(siteId));
          ref.invalidate(phaseHistoryProvider(siteId));
          ref.invalidate(phaseStatsProvider(siteId));
          ref.invalidate(phasesForSelectedSiteProvider);
        }
        await refreshPlantCache(ref);
      },
      child: Column(
        children: [
          const _ListHeader(),
          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.01),
              ),
              itemCount: plants.length,
              separatorBuilder: (_, __) => SizedBox(height: context.rh(0.014)),
              itemBuilder: (_, index) => _PlantCard(plant: plants[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlantCard extends ConsumerWidget {
  final Plant plant;

  const _PlantCard({required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(plant);
    final selectedSiteId = ref.watch(selectedSiteIdProvider);
    final siteId = phaseSiteIdForPlant(plant, fallbackSiteId: selectedSiteId);
    final phaseAsync = plant.isCurrentPlanting
        ? ref.watch(currentPhaseProvider(siteId))
        : null;
    final phaseLabel = phaseLabelForPlant(
      plant,
      phaseAsync,
      AppLocalizations.of(context)!,
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        onTap: () => context.push('/plant/${plant.plantId}'),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardTopRow(
                plant: plant,
                statusColor: statusColor,
                onMoreTap: () => _showActions(context, ref),
              ),
              const SizedBox(height: 16),
              _CardChipRow(plant: plant, phaseLabel: phaseLabel),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(Plant p) {
    if (p.isHarvested) return AppColors.warning;
    if (p.isCurrentPlanting) return AppColors.success;
    return AppColors.textTertiary;
  }

  void _showActions(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.read(authProvider).isAdmin;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => PlantActionsSheet(
        plant: plant,
        onEdit: () {
          Navigator.pop(sheetCtx);
          context.push('/plant/${plant.plantId}/edit');
        },
        onHarvest: plant.isCurrentPlanting
            ? () {
                Navigator.pop(sheetCtx);
                PlantMutationActions.confirmAndHarvest(
                  context,
                  ref,
                  plant: plant,
                );
              }
            : null,
        onDelete: isAdmin
            ? () {
                Navigator.pop(sheetCtx);
                PlantMutationActions.confirmAndDelete(
                  context,
                  ref,
                  plant: plant,
                );
              }
            : null,
      ),
    );
  }
}

class _CardTopRow extends StatelessWidget {
  final Plant plant;
  final Color statusColor;
  final VoidCallback onMoreTap;

  const _CardTopRow({
    required this.plant,
    required this.statusColor,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            plant.plantType?.icon ?? '🌱',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.displayName,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                plant.plantType?.localizedLabel(l10n) ?? l10n.commonUnknown,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),

        IconButton(
          tooltip: l10n.adminPlantActionsTooltip,
          onPressed: onMoreTap,
          icon: const Icon(Icons.more_vert),
          color: AppColors.textPrimary.withValues(alpha: 0.7),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            plant.localizedStatus(l10n),
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(12),
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardChipRow extends StatelessWidget {
  final Plant plant;
  final String phaseLabel;

  const _CardChipRow({required this.plant, required this.phaseLabel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _InfoChip(
            label: l10n.plantHstLabel,
            value: l10n.commonDays(plant.hst ?? 0),
            icon: Icons.calendar_today,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _InfoChip(
            label: l10n.plantPhaseLabel,
            value: phaseLabel,
            icon: Icons.eco,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(10),
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco,
            size: context.rw(0.205).clamp(60.0, 80.0),
            color: AppColors.textPrimary.withValues(alpha: 0.3),
          ),
          SizedBox(height: context.rh(0.02)),
          Text(
            l10n.plantListEmpty,
            style: AppTextStyles.cardTitle(context, context.sp(16)),
          ),
          SizedBox(height: context.rh(0.01)),
          Text(
            l10n.plantListEmptyHint,
            style: AppTextStyles.caption(context, size: context.sp(14)),
          ),
        ],
      ),
    );
  }
}

class _ListErrorState extends ConsumerWidget {
  final Object error;

  const _ListErrorState({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const _ListHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(context.rw(0.061)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: context.rw(0.164).clamp(48.0, 72.0),
                    color: AppColors.error,
                  ),
                  SizedBox(height: context.rh(0.02)),
                  Text(
                    l10n.plantLoadFailed,
                    style: AppTextStyles.cardTitle(context, context.sp(18)),
                  ),
                  SizedBox(height: context.rh(0.01)),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption(context, size: context.sp(14)),
                  ),
                  SizedBox(height: context.rh(0.03)),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(plantsProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: Text(
                      l10n.retry,
                      style: AppTextStyles.label(context, size: context.sp(14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
