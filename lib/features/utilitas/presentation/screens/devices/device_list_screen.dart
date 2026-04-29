import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/device.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class DeviceListScreen extends ConsumerWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceListAsync = ref.watch(utilitasDeviceListProvider);

    return PermissionGuardScreen(
      permission: 'device:read',
      child: UtilitasScaffold(
        title: 'Device',
        action: PermissionGuard(
          permission: 'device:create',
          child: UtilitasAddButton(
            onTap: () => context.push('/utilitas/devices/create'),
          ),
        ),
        body: deviceListAsync.when(
          data: (devices) {
            if (devices.isEmpty) {
              return const UtilitasEmptyState(
                icon: Icons.device_hub_outlined,
                title: 'Belum ada device',
                message: 'Tambahkan device untuk memulai monitoring',
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(utilitasDeviceListProvider);
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
                        'Device',
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
          loading: () => const UtilitasLoadingState(),
          error: (error, _) => UtilitasErrorState(
            error: error,
            onRetry: () => ref.invalidate(utilitasDeviceListProvider),
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
    return UtilitasListItem(
      title: device.displayName,
      subtitle: 'ID: ${device.devId}',
      icon: Icons.device_hub,
      iconColor: device.isActive ? const Color(0xFFFF7043) : Colors.grey,
      isActive: device.isActive,
      onTap: () => _showOptions(context, ref),
      badges: [
        if (device.connectionInfo != null)
          UtilitasBadge(
            label: device.connectionInfo!,
            color: const Color(0xFF42A5F5),
            icon: Icons.wifi,
          ),
        if (device.devLocation != null)
          UtilitasBadge(
            label: device.devLocation!,
            color: Colors.purple,
            icon: Icons.location_on,
          ),
        UtilitasBadge(
          label: device.isActive ? 'Aktif' : 'Nonaktif',
          color: device.isActive ? const Color(0xFF4CAF50) : Colors.grey,
          icon: device.isActive ? Icons.check_circle : Icons.cancel,
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
              child: Row(
                children: [
                  Text(
                    device.displayName,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            PermissionGuard(
              permission: 'device:update',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text(
                  'Edit',
                  style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/utilitas/devices/${device.devId}/edit');
                },
              ),
            ),
            PermissionGuard(
              permission: 'device:delete',
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: 'Device "${device.displayName}"',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(deviceFormProvider.notifier)
        .deleteDevice(device.devId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, 'Device berhasil dihapus');
    } else {
      final error = ref.read(deviceFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menghapus device');
    }
  }
}
