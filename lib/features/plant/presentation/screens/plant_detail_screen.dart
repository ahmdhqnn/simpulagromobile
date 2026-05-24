import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';
import '../utils/plant_mutation_actions.dart';
import '../widgets/plant_actions_sheet.dart';
import '../widgets/plant_detail_content_widget.dart';

class PlantDetailScreen extends ConsumerWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsync = ref.watch(plantDetailProvider(plantId));

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      body: SafeArea(
        child: plantAsync.when(
          loading: () => const DetailScreenSkeleton(
            infoRowCount: 4,
            hasDescription: false,
            headerHeight: 160,
          ),
          error: (error, _) => _buildErrorState(context, ref, error),
          data: (plant) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await refreshPlantCache(ref, plantId: plantId);
            },
            child: Column(
              children: [
                _buildHeader(context, ref, plant),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rw(0.051),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.rh(0.01)),
                        PlantHeaderCardWidget(plant: plant),
                        SizedBox(height: context.rh(0.024)),
                        PlantGrowthCardWidget(plant: plant),
                        SizedBox(height: context.rh(0.024)),
                        PlantInfoCardWidget(plant: plant),
                        SizedBox(height: context.rh(0.024)),
                        PlantActionButtonsWidget(
                          plant: plant,
                          onHarvest: () => PlantMutationActions.confirmAndHarvest(
                            context,
                            ref,
                            plant: plant,
                          ),
                        ),
                        SizedBox(height: context.rh(0.02)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, Plant plant) {
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
            onPressed: () => _showMoreActions(context, ref, plant),
            svgIconPath: 'assets/icons/more-icon.svg',
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

    return Column(
      children: [
        _buildHeaderLoading(context, ref),
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
                    onPressed: () =>
                        ref.invalidate(plantDetailProvider(plantId)),
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
                      style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
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

  // ─── More Actions Bottom Sheet ────────────────────────────────────────────

  void _showMoreActions(BuildContext context, WidgetRef ref, Plant plant) {
    final isAdmin = ref.read(authProvider).isAdmin;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  popOnSuccess: true,
                );
              }
            : null,
      ),
    );
  }
}
