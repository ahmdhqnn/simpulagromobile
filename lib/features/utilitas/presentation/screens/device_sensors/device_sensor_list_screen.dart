import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/device_sensor.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class DeviceSensorListScreen extends ConsumerWidget {
  const DeviceSensorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dsListAsync = ref.watch(utilitasDeviceSensorListProvider);

    return PermissionGuardScreen(
      permission: 'ds:read',
      child: UtilitasScaffold(
        title: 'Device Sensor',
        action: PermissionGuard(
          permission: 'ds:create',
          child: UtilitasAddButton(
            onTap: () => context.push('/utilitas/device-sensors/create'),
          ),
        ),
        body: dsListAsync.when(
          data: (deviceSensors) {
            if (deviceSensors.isEmpty) {
              return const UtilitasEmptyState(
                icon: Icons.cable_outlined,
                title: 'Belum ada mapping',
                message: 'Tambahkan mapping device-sensor untuk monitoring',
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(utilitasDeviceSensorListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: deviceSensors.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.014)),
                      child: Text(
                        'Device Sensor',
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
                  final ds = deviceSensors[index - 1];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _DeviceSensorCard(deviceSensor: ds),
                  );
                },
              ),
            );
          },
          loading: () => const UtilitasLoadingState(),
          error: (error, _) => UtilitasErrorState(
            error: error,
            onRetry: () => ref.invalidate(utilitasDeviceSensorListProvider),
          ),
        ),
      ),
    );
  }
}

class _DeviceSensorCard extends ConsumerWidget {
  final DeviceSensor deviceSensor;

  const _DeviceSensorCard({required this.deviceSensor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UtilitasListItem(
      title: deviceSensor.displayName,
      subtitle: 'ID: ${deviceSensor.dsId}',
      icon: Icons.cable,
      iconColor: deviceSensor.isActive ? const Color(0xFF26C6DA) : Colors.grey,
      isActive: deviceSensor.isActive,
      onTap: () => _showOptions(context, ref),
      badges: [
        UtilitasBadge(
          label: 'Device: ${deviceSensor.devId}',
          color: const Color(0xFF42A5F5),
          icon: Icons.device_hub,
        ),
        if (deviceSensor.sensId != null)
          UtilitasBadge(
            label: 'Sensor: ${deviceSensor.sensId}',
            color: Colors.purple,
            icon: Icons.sensors,
          ),
        if (deviceSensor.unitId != null)
          UtilitasBadge(
            label: 'Unit: ${deviceSensor.unitId}',
            color: Colors.teal,
            icon: Icons.straighten,
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
                deviceSensor.displayName,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            PermissionGuard(
              permission: 'ds:update',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text(
                  'Edit',
                  style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(
                    '/utilitas/device-sensors/${deviceSensor.dsId}/edit',
                  );
                },
              ),
            ),
            PermissionGuard(
              permission: 'ds:delete',
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
      itemName: 'Mapping "${deviceSensor.displayName}"',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(deviceSensorFormProvider.notifier)
        .deleteDeviceSensor(deviceSensor.dsId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, 'Mapping berhasil dihapus');
    } else {
      final error = ref.read(deviceSensorFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menghapus mapping');
    }
  }
}
