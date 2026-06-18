import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/permission_guard_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_list_item.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/domain/entities/sensor.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/shared/widgets/action_popup_menu_button.dart';

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
    final canUpdate = ref.watch(hasPermissionProvider('sensor:update'));

    return AdminListItem(
      title: sensor.displayName,
      subtitle: context.l10n.adminIdPrefix(sensor.sensId),
      icon: Icons.sensors,
      iconColor: sensor.isActive ? const Color(0xFF42A5F5) : Colors.grey,
      isActive: sensor.isActive,
      onTap: () => context.push('/admin/sensors/${sensor.sensId}'),
      trailing: canUpdate ? _buildActionsMenu(context) : null,
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

  Widget _buildActionsMenu(BuildContext context) {
    return MorePopupMenuButton<String>(
      tooltip: MaterialLocalizations.of(context).showMenuTooltip,
      useSvgIcon: false,
      size: 40,
      iconSize: 22,
      backgroundColor: null,
      iconColor: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      items: [
        ActionPopupMenuItem(
          value: 'edit',
          icon: Icons.edit_outlined,
          label: context.l10n.commonEdit,
          iconColor: const Color(0xFF1D1D1D),
        ),
      ],
      onSelected: (_) => context.push('/admin/sensors/${sensor.sensId}/edit'),
    );
  }
}
