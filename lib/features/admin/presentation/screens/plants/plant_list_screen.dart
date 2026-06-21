import 'package:flutter/material.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
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
import 'package:simpulagromobile/shared/widgets/action_popup_menu_button.dart';
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
        return AppColors.success;
      case CropType.jagung:
        return AppColors.warning;
      case CropType.kedelai:
        return AppColors.secondary;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconColor = plant.isHarvested
        ? AppColors.warning
        : (plant.isActive ? AppColors.success : Colors.grey);

    return AdminListItem(
      title: plant.displayName,
      subtitle: context.l10n.adminIdPrefix(plant.plantId),
      icon: Icons.grass,
      iconColor: iconColor,
      isActive: plant.isActive,
      onTap: () => context.push('/admin/plants/${plant.plantId}'),
      trailing: _buildActionsMenu(context, ref),
      badges: [
        AdminBadge(
          label: plant.plantType?.localizedLabel(context.l10n) ?? '-',
          color: _cropColor(plant.plantType),
          icon: Icons.eco,
        ),
        if (plant.hst != null)
          AdminBadge(
            label: context.l10n.recommendationHstLabel(plant.hst!),
            color: AppColors.info,
            icon: Icons.calendar_today,
          ),
        if (plant.isHarvested)
          AdminBadge(
            label: context.l10n.plantStatusHarvested,
            color: AppColors.warning,
            icon: Icons.agriculture,
          ),
      ],
    );
  }

  Widget _buildActionsMenu(BuildContext context, WidgetRef ref) {
    final canUpdate = ref.watch(hasPermissionProvider('plant:update'));
    final isAdmin = ref.read(isAdminProvider);
    final items = <ActionPopupMenuItem<String>>[
      if (canUpdate)
        ActionPopupMenuItem(
          value: 'edit',
          icon: Icons.edit_outlined,
          label: context.l10n.plantActionEdit,
          iconColor: AppColors.primary,
        ),
      if (canUpdate && plant.isCurrentPlanting)
        ActionPopupMenuItem(
          value: 'harvest',
          icon: Icons.agriculture,
          label: context.l10n.plantActionHarvest,
          iconColor: AppColors.warning,
          labelColor: AppColors.warning,
        ),
      if (isAdmin)
        ActionPopupMenuItem(
          value: 'delete',
          icon: Icons.delete_outline,
          label: context.l10n.plantActionDelete,
          iconColor: Colors.red,
          labelColor: Colors.red,
        ),
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return MorePopupMenuButton<String>(
      tooltip: context.l10n.adminPlantActionsTooltip,
      useSvgIcon: false,
      size: 40,
      iconSize: 22,
      backgroundColor: null,
      iconColor: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      items: items,
      onSelected: (value) {
        if (value == 'edit') {
          context.push('/admin/plants/${plant.plantId}/edit');
        } else if (value == 'harvest') {
          _confirmHarvest(context, ref);
        } else if (value == 'delete') {
          _confirmDelete(context, ref);
        }
      },
    );
  }

  Future<void> _confirmHarvest(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: context.l10n.plantHarvestDialogTitle,
      message: context.l10n.plantHarvestDialogMessage(plant.displayName),
      confirmText: context.l10n.plantHarvestConfirm,
      confirmColor: AppColors.warning,
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
