import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/locale_formatters.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/domain/entities/sensor.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_detail_widgets.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/l10n/l10n.dart';

class AdminSensorDetailScreen extends ConsumerWidget {
  const AdminSensorDetailScreen({super.key, required this.sensorId});

  final String sensorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorAsync = ref.watch(adminSensorDetailProvider(sensorId));

    return PermissionGuardScreen(
      permission: 'sensor:read',
      child: AdminScaffold(
        title: context.l10n.sensorTitle,
        action: sensorAsync.maybeWhen(
          data: (sensor) => PermissionGuard(
            permission: 'sensor:update',
            child: AdminCircleActionButton(
              svgIconPath: 'assets/icons/edit-outline-icon.svg',
              onTap: () => context.push('/admin/sensors/${sensor.sensId}/edit'),
            ),
          ),
          orElse: () => null,
        ),
        body: sensorAsync.when(
          skipLoadingOnReload: true,
          data: (sensor) => _SensorDetailBody(sensor: sensor),
          loading: () => const AdminDetailScreenSkeleton(),
          error: (error, _) => AdminErrorState(
            error: error,
            onRetry: () => ref.invalidate(adminSensorDetailProvider(sensorId)),
          ),
        ),
      ),
    );
  }
}

class _SensorDetailBody extends ConsumerWidget {
  const _SensorDetailBody({required this.sensor});

  final Sensor sensor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(adminSensorDetailProvider(sensor.sensId));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.01),
        ),
        children: [
          AdminDetailHeaderCard(
            title: sensor.displayName,
            subtitle: sensor.sensId,
            icon: Icons.sensors,
            iconColor: const Color(0xFF42A5F5),
            isActive: sensor.isActive,
            activeLabel: context.l10n.commonActive,
            inactiveLabel: context.l10n.commonInactive,
          ),
          SizedBox(height: context.rh(0.014)),
          AdminSectionCard(
            title: context.l10n.adminBasicInfoSection,
            child: Column(
              children: [
                AdminDetailRow(
                  icon: Icons.tag_outlined,
                  label: context.l10n.adminSensorIdLabel,
                  value: sensor.sensId,
                ),
                AdminDetailRow(
                  icon: Icons.device_hub_outlined,
                  label: context.l10n.adminDeviceLabel,
                  value: sensor.devId ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.location_searching,
                  label: context.l10n.adminSensorAddressLabel,
                  value: sensor.sensAddress ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.place_outlined,
                  label: context.l10n.commonLocation,
                  value: sensor.sensLocation ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.my_location_outlined,
                  label: context.l10n.adminCoordinatesSection,
                  value: sensor.hasCoordinates
                      ? '${sensor.sensLat}, ${sensor.sensLon}'
                      : '-',
                ),
                AdminDetailRow(
                  icon: Icons.terrain_outlined,
                  label: context.l10n.adminAltitudeLabel,
                  value: sensor.sensAlt?.toString() ?? '-',
                  showDivider: false,
                ),
              ],
            ),
          ),
          SizedBox(height: context.rh(0.014)),
          AdminSectionCard(
            title: 'Metadata',
            child: Column(
              children: [
                AdminDetailRow(
                  icon: Icons.event_outlined,
                  label: 'Dibuat',
                  value: _date(context, sensor.sensCreated),
                ),
                AdminDetailRow(
                  icon: Icons.update_outlined,
                  label: 'Diubah',
                  value: _date(context, sensor.sensUpdate),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _date(BuildContext context, DateTime? date) {
    if (date == null) return '-';
    return context.dateFormat('dd MMM yyyy HH:mm').format(date.toLocal());
  }
}
