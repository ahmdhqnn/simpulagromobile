import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/device_sensor_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/device_sensor_threshold_tab.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_list_item.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/domain/entities/device_sensor.dart';
import 'package:simpulagromobile/l10n/l10n.dart';

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
      child: AdminScaffold(
        title: context.l10n.adminDeviceSensorTitle,
        action: PermissionGuard(
          permission: 'ds:create',
          child: AdminAddButton(
            onTap: () => context.push('/admin/device-sensors/create'),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
              child: _DeviceSensorTabSwitcher(controller: _tabController),
            ),
            SizedBox(height: context.rh(0.014)),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_MappingTab(), const DeviceSensorThresholdTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceSensorTabSwitcher extends StatelessWidget {
  const _DeviceSensorTabSwitcher({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Row(
            children: [
              _DeviceSensorTabPill(
                label: context.l10n.adminMappingTab,
                isSelected: controller.index == 0,
                onTap: () => controller.animateTo(0),
              ),
              const SizedBox(width: 4),
              _DeviceSensorTabPill(
                label: context.l10n.adminThresholdValuesTab,
                isSelected: controller.index == 1,
                onTap: () => controller.animateTo(1),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DeviceSensorTabPill extends StatelessWidget {
  const _DeviceSensorTabPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFEFEF) : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MappingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dsListAsync = ref.watch(adminDeviceSensorListProvider);

    return dsListAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (deviceSensors) {
        if (deviceSensors.isEmpty) {
          return RefreshIndicator(
            color: const Color(0xFF1B5E20),
            onRefresh: () async {
              ref.invalidate(adminDeviceSensorListProvider);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.01),
              ),
              children: [
                AdminEmptyState(
                  icon: Icons.cable_outlined,
                  title: context.l10n.adminNoMappings,
                  message: context.l10n.adminNoMappingsMessage,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF1B5E20),
          onRefresh: () async {
            ref.invalidate(adminDeviceSensorListProvider);
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
      loading: () => const AdminLoadingState(),
      error: (error, _) => AdminErrorState(
        error: error,
        onRetry: () => ref.invalidate(adminDeviceSensorListProvider),
      ),
    );
  }
}

class _DeviceSensorCard extends ConsumerWidget {
  final DeviceSensor deviceSensor;

  const _DeviceSensorCard({required this.deviceSensor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdminListItem(
      title: deviceSensor.displayName,
      subtitle: context.l10n.adminDsDevSubtitle(deviceSensor.dsId, deviceSensor.devId),
      icon: Icons.cable,
      iconColor: deviceSensor.isActive ? const Color(0xFF26C6DA) : Colors.grey,
      isActive: deviceSensor.isActive,
      onTap: () => context.push('/admin/device-sensors/${deviceSensor.dsId}'),
      trailing: IconButton(
        tooltip: MaterialLocalizations.of(context).showMenuTooltip,
        onPressed: () => _showOptions(context, ref),
        icon: const Icon(Icons.more_vert),
        color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      ),
      badges: [
        if (deviceSensor.sensId != null)
          AdminBadge(
            label: context.l10n.adminSensIdBadge(deviceSensor.sensId!),
            color: Colors.purple,
            icon: Icons.sensors,
          ),
        if (deviceSensor.unitId != null)
          AdminBadge(
            label: context.l10n.adminUnitBadge(deviceSensor.unitId!),
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
                title: Text(context.l10n.adminEditMapping),
                onTap: () {
                  Navigator.pop(context);
                  context.push(
                    '/admin/device-sensors/${deviceSensor.dsId}/edit',
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
