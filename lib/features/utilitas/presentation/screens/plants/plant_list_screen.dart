import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/plant_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/plant.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class PlantListScreen extends ConsumerWidget {
  const PlantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantListAsync = ref.watch(utilitasPlantListProvider);

    return PermissionGuardScreen(
      permission: 'plant:read',
      child: UtilitasScaffold(
        title: 'Tanaman',
        action: PermissionGuard(
          permission: 'plant:create',
          child: UtilitasAddButton(
            onTap: () => context.push('/utilitas/plants/create'),
          ),
        ),
        body: plantListAsync.when(
          data: (plants) {
            if (plants.isEmpty) {
              return const UtilitasEmptyState(
                icon: Icons.grass_outlined,
                title: 'Belum ada tanaman',
                message: 'Tambahkan tanaman untuk memulai monitoring',
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(utilitasPlantListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _PlantCard(plant: plant),
                  );
                },
              ),
            );
          },
          loading: () => const UtilitasLoadingState(),
          error: (error, _) => UtilitasErrorState(
            error: error,
            onRetry: () => ref.invalidate(utilitasPlantListProvider),
          ),
        ),
      ),
    );
  }
}

class _PlantCard extends ConsumerWidget {
  final Plant plant;

  const _PlantCard({required this.plant});

  Color _cropColor(CropType? type) {
    switch (type) {
      case CropType.padi:
        return const Color(0xFF4CAF50);
      case CropType.jagung:
        return const Color(0xFFFFA726);
      case CropType.kedelai:
        return const Color(0xFF795548);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconColor = plant.isHarvested
        ? const Color(0xFFFFA726)
        : (plant.isActive ? const Color(0xFF4CAF50) : Colors.grey);

    return UtilitasListItem(
      title: plant.displayName,
      subtitle: 'ID: ${plant.plantId}',
      icon: Icons.grass,
      iconColor: iconColor,
      isActive: plant.isActive,
      onTap: () => _showOptions(context, ref),
      badges: [
        UtilitasBadge(
          label: plant.cropTypeDisplay,
          color: _cropColor(plant.plantType),
          icon: Icons.eco,
        ),
        if (plant.hst != null)
          UtilitasBadge(
            label: 'HST ${plant.hst}',
            color: const Color(0xFF42A5F5),
            icon: Icons.calendar_today,
          ),
        if (plant.isHarvested)
          const UtilitasBadge(
            label: 'Sudah Panen',
            color: Color(0xFFFFA726),
            icon: Icons.agriculture,
          ),
      ],
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
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
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                plant.displayName,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            if (!plant.isHarvested) ...[
              PermissionGuard(
                permission: 'plant:update',
                child: ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text(
                    'Edit',
                    style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/utilitas/plants/${plant.plantId}/edit');
                  },
                ),
              ),
              PermissionGuard(
                permission: 'plant:update',
                child: ListTile(
                  leading: const Icon(
                    Icons.agriculture,
                    color: Color(0xFFFFA726),
                  ),
                  title: const Text(
                    'Panen',
                    style: TextStyle(
                      color: Color(0xFFFFA726),
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmHarvest(context, ref);
                  },
                ),
              ),
            ],
            PermissionGuard(
              permission: 'plant:delete',
              child: ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, ref);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmHarvest(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Panen Tanaman?',
      message:
          '"${plant.displayName}" akan ditandai sebagai sudah dipanen. Aksi ini tidak dapat dibatalkan.',
      confirmText: 'Panen',
      confirmColor: const Color(0xFFFFA726),
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(plantFormProvider.notifier)
        .harvestPlant(plant.plantId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, 'Tanaman berhasil dipanen');
    } else {
      final error = ref.read(plantFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal memanen tanaman');
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: 'Tanaman "${plant.displayName}"',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(plantFormProvider.notifier)
        .deletePlant(plant.plantId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, 'Tanaman berhasil dihapus');
    } else {
      final error = ref.read(plantFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menghapus tanaman');
    }
  }
}
