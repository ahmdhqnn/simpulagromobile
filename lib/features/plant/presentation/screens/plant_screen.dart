import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../recommendation/presentation/providers/recommendation_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';
import '../utils/plant_phase_display.dart';
import '../widgets/plant_detail_card_widget.dart';
import '../widgets/plant_empty_state_widget.dart';
import '../widgets/plant_input_form_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';

class PlantScreen extends ConsumerWidget {
  const PlantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);
    final sitesAsync = ref.watch(sitesProvider);
    final plantsAsync = ref.watch(plantsProvider);
    final screenState = ref.watch(plantScreenStateProvider);

    if (siteId == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.rw(0.061)),
            child: sitesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const CenteredInfoStateSkeleton(),
              error: (error, _) => Center(
                child: ErrorStateCardWidget(
                  message: 'Gagal memuat site. ${error.toString()}',
                  onRetry: () => ref.invalidate(sitesProvider),
                ),
              ),
              data: (_) => Center(
                child: InfoStateWidget.icon(
                  icon: Icons.location_on_outlined,
                  message: AppLocalizations.of(context)!.emptySite,
                  height: 120,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: plantsAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => const PlantOverviewSkeleton(),
          error: (error, _) => _PlantErrorState(
            error: error.toString(),
            onRetry: () => ref.read(plantsProvider.notifier).refresh(),
          ),
          data: (plants) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              Plant? activePlant;
              for (final plant in plants) {
                if (plant.isCurrentPlanting) {
                  activePlant = plant;
                  break;
                }
              }

              if (activePlant != null) {
                final recommendationSiteId = phaseSiteIdForPlant(activePlant);
                final activePhase = ref
                    .read(currentPhaseProvider(recommendationSiteId))
                    .valueOrNull;
                ref.invalidate(
                  recommendationsByPlantForSiteProvider((
                    siteId: recommendationSiteId,
                    plantId: activePlant.plantId,
                  )),
                );
                if (activePhase != null) {
                  ref.invalidate(
                    recommendationsBySitePhaseProvider((
                      siteId: recommendationSiteId,
                      phaseId: activePhase.id,
                    )),
                  );
                }
              }

              ref.invalidate(currentPhaseProvider(siteId));
              ref.invalidate(phaseListProvider(siteId));
              ref.invalidate(phaseHistoryProvider(siteId));
              ref.invalidate(phaseStatsProvider(siteId));
              ref.invalidate(phasesForSelectedSiteProvider);
              await ref.read(plantsProvider.notifier).refresh();
            },
            child: _PlantContent(
              plants: plants,
              siteId: siteId,
              screenState: screenState,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlantContent extends ConsumerWidget {
  final List<Plant> plants;
  final String siteId;
  final PlantScreenState screenState;

  const _PlantContent({
    required this.plants,
    required this.siteId,
    required this.screenState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasActivePlant = plants.any((p) => p.isCurrentPlanting);
    final actualState = _resolveState(screenState, hasActivePlant);

    switch (actualState) {
      case PlantScreenState.loading:
        return const PlantOverviewSkeleton();

      case PlantScreenState.empty:
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: PlantEmptyState(
            onAddPlant: () =>
                ref.read(plantScreenStateProvider.notifier).state =
                    PlantScreenState.input,
          ),
        );

      case PlantScreenState.input:
        return PlantInputForm(
          siteId: siteId,
          onCancel: () =>
              ref.read(plantScreenStateProvider.notifier).state = hasActivePlant
              ? PlantScreenState.hasData
              : PlantScreenState.empty,
          onSuccess: () => ref.read(plantScreenStateProvider.notifier).state =
              PlantScreenState.hasData,
        );

      case PlantScreenState.hasData:
        final activePlant = plants.firstWhere((p) => p.isCurrentPlanting);
        return PlantDetailCard(plant: activePlant);
    }
  }

  PlantScreenState _resolveState(PlantScreenState requested, bool hasActive) {
    if (requested == PlantScreenState.input) return PlantScreenState.input;

    return hasActive ? PlantScreenState.hasData : PlantScreenState.empty;
  }
}

class _PlantErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _PlantErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
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
              l10n.plantErrorTitle,
              style: AppTextStyles.cardTitle(context, context.sp(18)),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context, size: context.sp(14)),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton(
              onPressed: onRetry,
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
    );
  }
}
