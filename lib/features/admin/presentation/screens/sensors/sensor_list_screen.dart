import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_list_item.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/domain/entities/sensor.dart';
import 'package:simpulagromobile/l10n/l10n.dart';

class SensorListScreen extends ConsumerWidget {
  const SensorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorListAsync = ref.watch(adminSensorListProvider);

    return PermissionGuardScreen(
      permission: 'sensor:read',
      child: AdminScaffold(
        title: context.l10n.sensorTitle,
        action: PermissionGuard(
          permission: 'sensor:create',
          child: AdminAddButton(
            onTap: () => context.push('/admin/sensors/create'),
          ),
        ),
        body: sensorListAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (sensors) {
            if (sensors.isEmpty) {
              return RefreshIndicator(
                color: const Color(0xFF1B5E20),
                onRefresh: () async {
                  ref.invalidate(adminSensorListProvider);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rw(0.051),
                    vertical: context.rh(0.01),
                  ),
                  children: [
                    AdminEmptyState(
                      icon: Icons.sensors_off_outlined,
                      title: context.l10n.adminNoSensors,
                      message: context.l10n.adminNoSensorsMessage,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(adminSensorListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: sensors.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.014)),
                      child: Text(
                        context.l10n.sensorTitle,
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
                  final sensor = sensors[index - 1];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _SensorCard(sensor: sensor),
                  );
                },
              ),
            );
          },
          loading: () => const AdminLoadingState(),
          error: (error, _) => AdminErrorState(
            error: error,
            onRetry: () => ref.invalidate(adminSensorListProvider),
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
    return AdminListItem(
      title: sensor.displayName,
      subtitle: context.l10n.adminIdPrefix(sensor.sensId),
      icon: Icons.sensors,
      iconColor: sensor.isActive ? const Color(0xFF42A5F5) : Colors.grey,
      isActive: sensor.isActive,
      onTap: () => context.push('/admin/sensors/${sensor.sensId}'),
      trailing: IconButton(
        tooltip: MaterialLocalizations.of(context).showMenuTooltip,
        onPressed: () => _showOptions(context, ref),
        icon: const Icon(Icons.more_vert),
        color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      ),
      badges: [
        if (sensor.devId != null)
          AdminBadge(
            label: context.l10n.adminDevicePrefix(sensor.devId!),
            color: const Color(0xFF42A5F5),
            icon: Icons.device_hub,
          ),
        if (sensor.sensAddress != null)
          AdminBadge(
            label: sensor.sensAddress!,
            color: Colors.purple,
            icon: Icons.location_searching,
          ),
        AdminBadge(
          label: sensor.isActive
              ? context.l10n.commonActive
              : context.l10n.commonInactive,
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
            PermissionGuard(
              permission: 'sensor:update',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(
                  context.l10n.commonEdit,
                  style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/admin/sensors/${sensor.sensId}/edit');
                },
              ),
            ),
            // Delete option hidden as it is unsupported on the backend
            const SizedBox.shrink(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
