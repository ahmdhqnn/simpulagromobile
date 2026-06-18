import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/permission_guard_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_list_item.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/domain/entities/device.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/shared/widgets/action_popup_menu_button.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class DeviceListScreen extends ConsumerWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceListAsync = ref.watch(adminDeviceListProvider);

    return PermissionGuardScreen(
      permission: 'device:read',
      child: AdminScaffold(
        title: context.l10n.deviceTitle,
        action: PermissionGuard(
          permission: 'device:create',
          child: AdminAddButton(
            onTap: () => context.push('/admin/devices/create'),
          ),
        ),
        body: deviceListAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (devices) {
            if (devices.isEmpty) {
              return RefreshIndicator(
                color: const Color(0xFF1B5E20),
                onRefresh: () async {
                  ref.invalidate(adminDeviceListProvider);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rw(0.051),
                    vertical: context.rh(0.01),
                  ),
                  children: [
                    AdminEmptyState(
                      icon: Icons.device_hub_outlined,
                      title: context.l10n.adminNoDevices,
                      message: context.l10n.adminNoDevicesMessage,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(adminDeviceListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: devices.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.014)),
                      child: Text(
                        context.l10n.deviceTitle,
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
                  final device = devices[index - 1];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _DeviceCard(device: device),
                  );
                },
              ),
            );
          },
          loading: () => const AdminLoadingState(),
          error: (error, _) => AdminErrorState(
            error: error,
            onRetry: () => ref.invalidate(adminDeviceListProvider),
          ),
        ),
      ),
    );
  }
}

class _DeviceCard extends ConsumerWidget {
  final Device device;

  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canUpdate = ref.watch(hasPermissionProvider('device:update'));
    final canDelete = ref.watch(hasPermissionProvider('device:delete'));
    final items = <ActionPopupMenuItem<String>>[
      if (canUpdate)
        ActionPopupMenuItem(
          value: 'edit',
          icon: Icons.edit_outlined,
          label: context.l10n.commonEdit,
          iconColor: const Color(0xFF1D1D1D),
        ),
      if (canDelete)
        ActionPopupMenuItem(
          value: 'delete',
          icon: Icons.delete_outline,
          label: context.l10n.commonDelete,
          iconColor: Colors.red,
          labelColor: Colors.red,
        ),
    ];

    return AdminListItem(
      title: device.displayName,
      subtitle: context.l10n.adminIdPrefix(device.devId),
      icon: Icons.device_hub,
      iconColor: device.isActive ? const Color(0xFFFF7043) : Colors.grey,
      isActive: device.isActive,
      onTap: () => context.push('/admin/devices/${device.devId}'),
      trailing: items.isEmpty ? null : _buildActionsMenu(context, ref, items),
      badges: [
        if (device.connectionInfo != null)
          AdminBadge(
            label: device.connectionInfo!,
            color: const Color(0xFF42A5F5),
            icon: Icons.wifi,
          ),
        if (device.devLocation != null)
          AdminBadge(
            label: device.devLocation!,
            color: Colors.purple,
            icon: Icons.location_on,
          ),
        AdminBadge(
          label: device.isActive
              ? context.l10n.commonActive
              : context.l10n.commonInactive,
          color: device.isActive ? const Color(0xFF4CAF50) : Colors.grey,
          icon: device.isActive ? Icons.check_circle : Icons.cancel,
        ),
      ],
    );
  }

  Widget _buildActionsMenu(
    BuildContext context,
    WidgetRef ref,
    List<ActionPopupMenuItem<String>> items,
  ) {
    return MorePopupMenuButton<String>(
      tooltip: MaterialLocalizations.of(context).showMenuTooltip,
      useSvgIcon: false,
      size: 40,
      iconSize: 22,
      backgroundColor: null,
      iconColor: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      items: items,
      onSelected: (value) {
        if (value == 'edit') {
          context.push('/admin/devices/${device.devId}/edit');
        } else if (value == 'delete') {
          _confirmDelete(context, ref);
        }
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: 'Device "${device.displayName}"',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(adminDeviceFormProvider.notifier)
        .deleteDevice(device.devId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        context.l10n.adminDeleteSuccess(context.l10n.deviceTitle),
      );
    } else {
      final error = ref.read(adminDeviceFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.adminDeleteFailed(context.l10n.deviceTitle),
      );
    }
  }
}
