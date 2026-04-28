import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/sensor.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class SensorListScreen extends ConsumerWidget {
  const SensorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorListAsync = ref.watch(utilitasSensorListProvider);

    return PermissionGuardScreen(
      permission: 'sensor:read',
      child: UtilitasScaffold(
        title: 'Sensor',
        action: PermissionGuard(
          permission: 'sensor:create',
          child: UtilitasAddButton(
            onTap: () => context.push('/utilitas/sensors/create'),
          ),
        ),
        body: sensorListAsync.when(
          data: (sensors) {
            if (sensors.isEmpty) {
              return const UtilitasEmptyState(
                icon: Icons.sensors_off_outlined,
                title: 'Belum ada sensor',
                message: 'Tambahkan sensor untuk memulai monitoring',
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(utilitasSensorListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: sensors.length,
                itemBuilder: (context, index) {
                  final sensor = sensors[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _SensorCard(sensor: sensor),
                  );
                },
              ),
            );
          },
          loading: () => const UtilitasLoadingState(),
          error: (error, _) => UtilitasErrorState(
            error: error,
            onRetry: () => ref.invalidate(utilitasSensorListProvider),
          ),
        ),
      ),
    );
  }
}

class _SensorCard extends ConsumerWidget {
  final Sensor sensor;

  const _SensorCard({required this.sensor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UtilitasListItem(
      title: sensor.displayName,
      subtitle: 'ID: ${sensor.sensId}',
      icon: Icons.sensors,
      iconColor: sensor.isActive ? const Color(0xFF42A5F5) : Colors.grey,
      isActive: sensor.isActive,
      onTap: () => _showOptions(context, ref),
      badges: [
        if (sensor.devId != null)
          UtilitasBadge(
            label: 'Device: ${sensor.devId}',
            color: const Color(0xFF42A5F5),
            icon: Icons.device_hub,
          ),
        if (sensor.sensAddress != null)
          UtilitasBadge(
            label: sensor.sensAddress!,
            color: Colors.purple,
            icon: Icons.location_searching,
          ),
        UtilitasBadge(
          label: sensor.isActive ? 'Aktif' : 'Nonaktif',
          color: sensor.isActive ? const Color(0xFF4CAF50) : Colors.grey,
          icon: sensor.isActive ? Icons.check_circle : Icons.cancel,
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
                    sensor.displayName,
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
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text(
                'Edit',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
              ),
              onTap: () {
                Navigator.pop(context);
                context.push('/utilitas/sensors/${sensor.sensId}/edit');
              },
            ),
            PermissionGuard(
              permission: 'sensor:delete',
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
      itemName: 'Sensor "${sensor.displayName}"',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(sensorFormProvider.notifier)
        .deleteSensor(sensor.sensId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, 'Sensor berhasil dihapus');
    } else {
      final error = ref.read(sensorFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menghapus sensor');
    }
  }
}
