import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/locale_formatters.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/domain/entities/device_sensor.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/device_sensor_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_detail_widgets.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/l10n/l10n.dart';

class DeviceSensorDetailScreen extends ConsumerWidget {
  const DeviceSensorDetailScreen({super.key, required this.dsId, this.devId});

  final String dsId;
  final String? devId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookupKey = adminDeviceSensorLookupKey(dsId, devId: devId);
    final dsAsync = ref.watch(adminDeviceSensorDetailProvider(lookupKey));

    return PermissionGuardScreen(
      permission: 'ds:read',
      child: AdminScaffold(
        title: context.l10n.adminDeviceSensorTitle,
        action: dsAsync.maybeWhen(
          data: (deviceSensor) => PermissionGuard(
            permission: 'ds:update',
            child: AdminCircleActionButton(
              svgIconPath: 'assets/icons/edit-outline-icon.svg',
              onTap: () => context.push(_editRoute(deviceSensor)),
            ),
          ),
          orElse: () => null,
        ),
        body: dsAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (deviceSensor) =>
              _DeviceSensorDetailBody(deviceSensor: deviceSensor),
          loading: () =>
              const AdminDetailScreenSkeleton(sectionRowCounts: [6, 4, 2]),
          error: (error, _) => AdminErrorState(
            error: error,
            onRetry: () =>
                ref.invalidate(adminDeviceSensorDetailProvider(lookupKey)),
          ),
        ),
      ),
    );
  }
}

class _DeviceSensorDetailBody extends ConsumerWidget {
  const _DeviceSensorDetailBody({required this.deviceSensor});

  final DeviceSensor deviceSensor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(
          adminDeviceSensorDetailProvider(
            adminDeviceSensorLookupKey(
              deviceSensor.dsId,
              devId: deviceSensor.devId,
            ),
          ),
        );
        ref.invalidate(deviceSensorThresholdValuesProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.01),
        ),
        children: [
          AdminDetailHeaderCard(
            title: deviceSensor.displayName,
            subtitle: '${deviceSensor.dsId} - ${deviceSensor.devId}',
            icon: Icons.cable,
            iconColor: AppColors.ph,
            isActive: deviceSensor.isActive,
            activeLabel: context.l10n.commonActive,
            inactiveLabel: context.l10n.commonInactive,
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminSectionCard(
            title: context.l10n.adminMappingInfoSection,
            child: Column(
              children: [
                AdminDetailRow(
                  icon: Icons.tag_outlined,
                  label: context.l10n.adminDsIdLabel,
                  value: deviceSensor.dsId,
                ),
                AdminDetailRow(
                  icon: Icons.device_hub_outlined,
                  label: context.l10n.adminDeviceLabel,
                  value: deviceSensor.devId,
                ),
                AdminDetailRow(
                  icon: Icons.sensors_outlined,
                  label: context.l10n.adminSensorLabel,
                  value:
                      _text(deviceSensor.sensId) ??
                      _text(deviceSensor.dsName) ??
                      '-',
                ),
                AdminDetailRow(
                  icon: Icons.straighten,
                  label: context.l10n.adminUnitLabel,
                  value: deviceSensor.unitId ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.location_searching,
                  label: context.l10n.adminAddressLabel,
                  value: deviceSensor.dsAddress ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.format_list_numbered,
                  label: context.l10n.adminSequenceLabel,
                  value: deviceSensor.dsSeq?.toString() ?? '-',
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminSectionCard(
            title: context.l10n.adminThresholdSection,
            child: Column(
              children: [
                AdminDetailRow(
                  icon: Icons.adjust_outlined,
                  label: context.l10n.adminNormalValueLabel,
                  value: _number(deviceSensor.dcNormalValue),
                ),
                AdminDetailRow(
                  icon: Icons.check_circle_outline,
                  label: 'Normal Min - Max',
                  value:
                      '${_number(deviceSensor.dsMinNormValue)} - ${_number(deviceSensor.dsMaxNormValue)}',
                ),
                AdminDetailRow(
                  icon: Icons.warning_amber_outlined,
                  label: 'Warning Min - Max',
                  value:
                      '${_number(deviceSensor.dsMinValWarn)} - ${_number(deviceSensor.dsMaxValWarn)}',
                ),
                AdminDetailRow(
                  icon: Icons.unfold_more,
                  label: 'Absolute Min - Max',
                  value:
                      '${_number(deviceSensor.dsMinValue)} - ${_number(deviceSensor.dsMaxValue)}',
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminSectionCard(
            title: 'Metadata',
            child: Column(
              children: [
                AdminDetailRow(
                  icon: Icons.event_outlined,
                  label: 'Dibuat',
                  value: _date(context, deviceSensor.dsCreated),
                ),
                AdminDetailRow(
                  icon: Icons.update_outlined,
                  label: 'Diubah',
                  value: _date(context, deviceSensor.dsUpdate),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _number(double? value) => value?.toString() ?? '-';

  String? _text(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }

  String _date(BuildContext context, DateTime? date) {
    if (date == null) return '-';
    return context.dateFormat('dd MMM yyyy HH:mm').format(date.toLocal());
  }
}

String _editRoute(DeviceSensor deviceSensor) {
  final dsId = Uri.encodeComponent(deviceSensor.dsId);
  final devId = Uri.encodeQueryComponent(deviceSensor.devId);
  return '/admin/device-sensors/$dsId/edit?devId=$devId';
}
