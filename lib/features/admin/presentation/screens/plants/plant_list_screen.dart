import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/permission_guard_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/plant_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_list_item.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/domain/entities/plant.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/l10n/localized_labels.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class PlantListScreen extends ConsumerWidget {
  const PlantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantListAsync = ref.watch(adminPlantListProvider);

    return PermissionGuardScreen(
      permission: 'plant:read',
      child: AdminScaffold(
        title: context.l10n.plantTitle,
        action: PermissionGuard(
          permission: 'plant:create',
          child: AdminAddButton(
            onTap: () => context.push('/admin/plants/create'),
          ),
        ),
        body: plantListAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (plants) {
            if (plants.isEmpty) {
              return AdminEmptyState(
                icon: Icons.grass_outlined,
                title: context.l10n.adminNoPlants,
                message: context.l10n.adminNoPlantsMessage,
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                await refreshAdminPlantCache(ref);
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: plants.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.014)),
                      child: Text(
                        context.l10n.plantTitle,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(22),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1D1D1D),
                          height: 1.0,
                        ),
                      ),
                    );
                  }
                  final plant = plants[index - 1];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _PlantCard(plant: plant),
                  );
                },
              ),
            );
          },
          loading: () => const AdminLoadingState(),
          error: (error, _) => AdminErrorState(
            error: error,
            onRetry: () => ref.invalidate(adminPlantListProvider),
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

    return AdminListItem(
      title: plant.displayName,
      subtitle: context.l10n.adminIdPrefix(plant.plantId),
      icon: Icons.grass,
      iconColor: iconColor,
      isActive: plant.isActive,
      onTap: () => _showOptions(context, ref),
      trailing: IconButton(
        tooltip: context.l10n.adminPlantActionsTooltip,
        onPressed: () => _showOptions(context, ref),
        icon: const Icon(Icons.more_vert),
        color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      ),
      badges: [
        AdminBadge(
          label: plant.plantType?.localizedLabel(context.l10n) ?? '-',
          color: _cropColor(plant.plantType),
          icon: Icons.eco,
        ),
        if (plant.hst != null)
          AdminBadge(
            label: context.l10n.recommendationHstLabel(plant.hst!),
            color: const Color(0xFF42A5F5),
            icon: Icons.calendar_today,
          ),
        if (plant.isHarvested)
          AdminBadge(
            label: context.l10n.plantStatusHarvested,
            color: const Color(0xFFFFA726),
            icon: Icons.agriculture,
          ),
      ],
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.read(isAdminProvider);

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
            PermissionGuard(
              permission: 'plant:update',
              child: ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF1B5E20),
                ),
                title: Text(
                  context.l10n.plantActionEdit,
                  style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/admin/plants/${plant.plantId}/edit');
                },
              ),
            ),
            if (plant.isCurrentPlanting) ...[
              PermissionGuard(
                permission: 'plant:update',
                child: ListTile(
                  leading: const Icon(
                    Icons.agriculture,
                    color: Color(0xFFFFA726),
                  ),
                  title: Text(
                    context.l10n.plantActionHarvest,
                    style: const TextStyle(
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
            // Delete: hanya Admin
            if (isAdmin)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  context.l10n.plantActionDelete,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, ref);
                },
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
      title: context.l10n.plantHarvestDialogTitle,
      message: context.l10n.plantHarvestDialogMessage(plant.displayName),
      confirmText: context.l10n.plantHarvestConfirm,
      confirmColor: const Color(0xFFFFA726),
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(adminPlantFormProvider.notifier)
        .harvestPlant(plant.plantId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        context.l10n.plantHarvestSuccess(plant.displayName),
      );
    } else {
      final error = ref.read(adminPlantFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.plantHarvestFailed,
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: context.l10n.plantTitle,
      additionalMessage: context.l10n.plantDeleteDialogMessage(
        plant.displayName,
      ),
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(adminPlantFormProvider.notifier)
        .deletePlant(plant.plantId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        context.l10n.plantDeleteSuccess(plant.displayName),
      );
    } else {
      final error = ref.read(adminPlantFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.plantDeleteFailed,
      );
    }
  }
}
