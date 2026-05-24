import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/device_sensor_threshold_tab.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/device_sensor.dart';

class DeviceSensorListScreen extends ConsumerStatefulWidget {
  const DeviceSensorListScreen({super.key});

  @override
  ConsumerState<DeviceSensorListScreen> createState() =>
      _DeviceSensorListScreenState();
}

class _DeviceSensorListScreenState extends ConsumerState<DeviceSensorListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Mapping'),
                Tab(text: 'Nilai Ambang'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _MappingTab(),
                  const DeviceSensorThresholdTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MappingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dsListAsync = ref.watch(utilitasDeviceSensorListProvider);

    return dsListAsync.when(
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
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            itemCount: deviceSensors.length,
            itemBuilder: (context, index) {
              final ds = deviceSensors[index];
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
      subtitle: 'ds_id: ${deviceSensor.dsId} · dev_id: ${deviceSensor.devId}',
      icon: Icons.cable,
      iconColor: deviceSensor.isActive ? const Color(0xFF26C6DA) : Colors.grey,
      isActive: deviceSensor.isActive,
      onTap: () => _showOptions(context, ref),
      badges: [
        if (deviceSensor.sensId != null)
          UtilitasBadge(
            label: 'sens_id: ${deviceSensor.sensId}',
            color: Colors.purple,
            icon: Icons.sensors,
          ),
        if (deviceSensor.unitId != null)
          UtilitasBadge(
            label: 'unit: ${deviceSensor.unitId}',
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
            PermissionGuard(
              permission: 'ds:update',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Mapping'),
                onTap: () {
                  Navigator.pop(context);
                  context.push(
                    '/utilitas/device-sensors/${deviceSensor.dsId}/edit',
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
