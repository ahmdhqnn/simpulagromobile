import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/models/plant_model.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_empty_state.dart';
import '../widgets/plant_input_form.dart';
import '../widgets/plant_detail_card.dart';

class PlantScreen extends ConsumerStatefulWidget {
  const PlantScreen({super.key});

  @override
  ConsumerState<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends ConsumerState<PlantScreen> {
  @override
  Widget build(BuildContext context) {
    final siteId = ref.watch(selectedSiteIdProvider);
    final plantsAsync = ref.watch(plantsProvider);
    final screenState = ref.watch(plantScreenStateProvider);

    if (siteId == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: plantsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stack) => _buildErrorState(error.toString()),
          data: (plants) => _buildContent(plants, screenState, siteId),
        ),
      ),
    );
  }

  Widget _buildContent(
    List<PlantModel> plants,
    PlantScreenState screenState,
    String siteId,
  ) {
    PlantScreenState actualState;
    if (screenState != PlantScreenState.input) {
      actualState = plants.isEmpty
          ? PlantScreenState.empty
          : PlantScreenState.hasData;
    } else {
      actualState = PlantScreenState.input;
    }

    switch (actualState) {
      case PlantScreenState.empty:
        return PlantEmptyState(
          onAddPlant: () {
            ref.read(plantScreenStateProvider.notifier).state =
                PlantScreenState.input;
          },
        );
      case PlantScreenState.input:
        return PlantInputForm(
          siteId: siteId,
          onCancel: () {
            ref.read(plantScreenStateProvider.notifier).state = plants.isEmpty
                ? PlantScreenState.empty
                : PlantScreenState.hasData;
          },
          onSuccess: () {
            ref.read(plantScreenStateProvider.notifier).state =
                PlantScreenState.hasData;
          },
        );
      case PlantScreenState.hasData:
        final plant = plants.first;
        return PlantDetailCard(
          plant: plant,
          onAddNew: () {
            ref.read(plantScreenStateProvider.notifier).state =
                PlantScreenState.input;
          },
        );
      case PlantScreenState.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
    }
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Terjadi kesalahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.invalidate(plantsProvider),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
