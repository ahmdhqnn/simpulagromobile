import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../admin/presentation/widgets/admin_scaffold.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';
import '../utils/plant_phase_display.dart';
import '../utils/plant_mutation_actions.dart';
import '../widgets/plant_actions_sheet_widget.dart';
import '../widgets/plant_detail_content_widget.dart';

class PlantDetailScreen extends ConsumerWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsync = ref.watch(plantDetailProvider(plantId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            plantAsync.maybeWhen(
              data: (plant) => _buildHeader(context, ref, plant),
              orElse: () => _buildHeaderLoading(context, ref),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    AdminSectionTitle(l10n.plantDetailTitle),
                    const Gap(14),
                    Expanded(
                      child: plantAsync.when(
                        skipLoadingOnReload: true,
                        skipLoadingOnRefresh: true,
                        skipError: true,
                        loading: () => const PlantDetailSkeleton(),
                        error: (error, _) => _buildErrorState(context, ref, error),
                        data: (plant) => RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            final siteId = phaseSiteIdForPlant(
                              plant,
                              fallbackSiteId: ref.read(selectedSiteIdProvider),
                            );
                            if (plant.isCurrentPlanting) {
                              ref.invalidate(currentPhaseProvider(siteId));
                            }
                            await refreshPlantCache(ref, plantId: plantId);
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PlantHeaderCardWidget(plant: plant),
                                const Gap(14),
                                if (plant.isCurrentPlanting) ...[
                                  PlantGrowthCardWidget(plant: plant),
                                  const Gap(14),
                                ],
                                PlantInfoCardWidget(plant: plant),
                                if (plant.isCurrentPlanting) ...[
                                  const Gap(16),
                                  PlantActionButtonsWidget(
                                    plant: plant,
                                    onHarvest: () =>
                                        PlantMutationActions.confirmAndHarvest(
                                      context,
                                      ref,
                                      plant: plant,
                                    ),
                                  ),
                                ],
                                const Gap(20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, Plant plant) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          PlantActionsMenuButton(
            tooltip: l10n.adminPlantActionsTooltip,
            onEdit: () => context.push('/plant/${plant.plantId}/edit'),
            onHarvest: plant.isCurrentPlanting
                ? () => PlantMutationActions.confirmAndHarvest(
                    context,
                    ref,
                    plant: plant,
                  )
                : null,
            onDelete: ref.read(authProvider).isAdmin
                ? () => PlantMutationActions.confirmAndDelete(
                    context,
                    ref,
                    plant: plant,
                    popOnSuccess: true,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLoading(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
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
              l10n.plantLoadFailed,
              style: AppTextStyles.cardTitle(context, 18),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.hint(context, size: 14),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton(
              onPressed: () => ref.invalidate(plantDetailProvider(plantId)),
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
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantDetailSkeleton extends StatelessWidget {
  const PlantDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlantHeaderCardSkeleton(),
          Gap(14),
          PlantGrowthCardSkeleton(),
          Gap(14),
          PlantInfoCardSkeleton(),
        ],
      ),
    );
  }
}
