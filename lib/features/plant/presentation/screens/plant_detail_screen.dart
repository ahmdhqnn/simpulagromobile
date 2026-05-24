import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_detail_content_widget.dart';

class PlantDetailScreen extends ConsumerWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsync = ref.watch(plantDetailProvider(plantId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: plantAsync.when(
          loading: () => const DetailScreenSkeleton(infoRowCount: 4, hasDescription: false, headerHeight: 160),
          error: (error, _) => _buildErrorState(context, ref, error),
          data: (plant) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(plantDetailProvider(plantId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Column(
              children: [
                _buildHeader(context, ref),
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
                          onHarvest: () => _showHarvestDialog(context, ref, plant),
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

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
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
    return Column(
      children: [
        _buildHeader(context, ref),
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
                    'Gagal memuat data',
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
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(fontFamily: AppTextStyles.fontFamily),
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

  void _showHarvestDialog(BuildContext context, WidgetRef ref, dynamic plant) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Konfirmasi Panen',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Tandai tanaman "${plant.displayName}" sudah dipanen?',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await _doHarvest(context, ref, plant);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: Text(
              'Ya, Sudah Panen',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _doHarvest(BuildContext context, WidgetRef ref, dynamic plant) async {
    final siteId = plant.siteId as String?;
    final plantId = plant.plantId as String?;
    
    if (siteId == null || plantId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tidak dapat memproses panen: ID tidak valid',
              style: TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    try {
      final useCase = ref.read(harvestPlantUseCaseProvider);
      final result = await useCase(siteId, plantId);
      
      if (!context.mounted) return;
      
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal memproses panen: ${failure.message}',
                style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (success) {
          ref.invalidate(plantDetailProvider(plantId));
          ref.invalidate(plantsProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tanaman "${plant.displayName}" berhasil ditandai sudah panen',
                style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Terjadi kesalahan: $e',
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
