import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/responsive.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_detail_card.dart';
import '../widgets/plant_empty_state.dart';
import '../widgets/plant_input_form.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';

/// Screen utama fitur tanaman di dashboard.
/// Menampilkan salah satu dari 4 state:
///   - [PlantScreenState.loading]  → skeleton
///   - [PlantScreenState.empty]    → [PlantEmptyState]
///   - [PlantScreenState.input]    → [PlantInputForm]
///   - [PlantScreenState.hasData]  → [PlantDetailCard]
class PlantScreen extends ConsumerWidget {
  const PlantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);
    final plantsAsync = ref.watch(plantsProvider);
    final screenState = ref.watch(plantScreenStateProvider);

    if (siteId == null) {
      return const Scaffold(
        body: Center(
          child: DetailScreenSkeleton(
            infoRowCount: 3,
            hasDescription: false,
            headerHeight: 120,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      body: SafeArea(
        child: plantsAsync.when(
          loading: () => const Center(
            child: DetailScreenSkeleton(
              infoRowCount: 3,
              hasDescription: false,
              headerHeight: 120,
            ),
          ),
          error: (error, _) => _ErrorState(
            error: error.toString(),
            onRetry: () => ref.invalidate(plantsProvider),
          ),
          data: (plants) => _PlantContent(
            plants: plants,
            siteId: siteId,
            screenState: screenState,
          ),
        ),
      ),
    );
  }
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

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
      case PlantScreenState.empty:
        return PlantEmptyState(
          onAddPlant: () => ref.read(plantScreenStateProvider.notifier).state =
              PlantScreenState.input,
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

      case PlantScreenState.loading:
        return const Center(
          child: DetailScreenSkeleton(
            infoRowCount: 3,
            hasDescription: false,
            headerHeight: 120,
          ),
        );
    }
  }

  PlantScreenState _resolveState(PlantScreenState requested, bool hasActive) {
    if (requested == PlantScreenState.input && !hasActive) {
      return PlantScreenState.input;
    }
    return hasActive ? PlantScreenState.hasData : PlantScreenState.empty;
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
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
              AppLocalizations.of(context)!.plantErrorTitle,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(14),
                color: AppColors.textSecondary,
              ),
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
                AppLocalizations.of(context)!.retry,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
