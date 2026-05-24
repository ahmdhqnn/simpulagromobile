import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
                          onHarvest: () =>
                              _showHarvestDialog(context, ref, plant),
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

  Widget _buildHeader(BuildContext context, WidgetRef ref, dynamic plant) {
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

  // ─── More Actions Bottom Sheet ────────────────────────────────────────────

  void _showMoreActions(BuildContext context, WidgetRef ref, dynamic plant) {
    final authState = ref.read(authProvider);
    final isAdmin = authState.isAdmin;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  plant.displayName,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
              ),
            ),
            const Divider(height: 1),

            // Edit
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
              ),
              title: const Text(
                'Edit Tanaman',
                style: TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
              onTap: () {
                Navigator.pop(sheetCtx);
                context.push('/plant/${plant.plantId}/edit');
              },
            ),

            // Harvest (only if currently planting)
            if (plant.isCurrentPlanting)
              ListTile(
                leading: const Icon(Icons.agriculture, color: Colors.orange),
                title: const Text(
                  'Panen Tanaman',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.orange,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _showHarvestDialog(context, ref, plant);
                },
              ),

            // Delete (admin only)
            if (isAdmin)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Hapus Tanaman',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _confirmDelete(context, ref, plant);
                },
              ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── Harvest ─────────────────────────────────────────────────────────────

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

  Future<void> _doHarvest(
    BuildContext context,
    WidgetRef ref,
    dynamic plant,
  ) async {
    final siteId = plant.siteId as String?;
    final currentPlantId = plant.plantId as String?;

    if (siteId == null || currentPlantId == null) {
      if (context.mounted) {
        SnackbarHelper.showError(
          context,
          'Tidak dapat memproses panen: ID tidak valid',
        );
      }
      return;
    }

    try {
      final useCase = ref.read(harvestPlantUseCaseProvider);
      final result = await useCase(siteId, currentPlantId);

      if (!context.mounted) return;

      await result.fold<Future<void>>(
        (failure) async {
          SnackbarHelper.showError(
            context,
            'Gagal memproses panen: ${failure.message}',
          );
        },
        (_) async {
          await refreshPlantCache(ref, plantId: currentPlantId);
          if (!context.mounted) return;
          SnackbarHelper.showSuccess(
            context,
            'Tanaman "${plant.displayName}" berhasil ditandai sudah panen',
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Terjadi kesalahan: $e');
      }
    }
  }

  // ─── Delete ───────────────────────────────────────────────────────────────

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    dynamic plant,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: 'Tanaman',
      additionalMessage:
          '"${plant.displayName}" akan dihapus secara permanen. Aksi ini tidak dapat dibatalkan.',
    );

    if (!confirmed || !context.mounted) return;

    await _doDelete(context, ref, plant);
  }

  Future<void> _doDelete(
    BuildContext context,
    WidgetRef ref,
    dynamic plant,
  ) async {
    final siteId = plant.siteId as String?;
    final currentPlantId = plant.plantId as String?;

    if (siteId == null || currentPlantId == null) {
      if (context.mounted) {
        SnackbarHelper.showError(
          context,
          'Tidak dapat menghapus: ID tidak valid',
        );
      }
      return;
    }

    try {
      // Use utilitas plant provider for delete (it has deletePlant support)
      // We call the repository directly via the plant feature's provider chain
      final useCase = ref.read(deletePlantUseCaseProvider);
      final result = await useCase(siteId, currentPlantId);

      if (!context.mounted) return;

      await result.fold<Future<void>>(
        (failure) async {
          SnackbarHelper.showError(
            context,
            'Gagal menghapus tanaman: ${failure.message}',
          );
        },
        (_) async {
          await refreshPlantCache(
            ref,
            plantId: currentPlantId,
            refreshDetail: false,
          );
          if (!context.mounted) return;
          SnackbarHelper.showSuccess(
            context,
            'Tanaman "${plant.displayName}" berhasil dihapus',
          );
          context.pop();
        },
      );
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Terjadi kesalahan: $e');
      }
    }
  }
}
