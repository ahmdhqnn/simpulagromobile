import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/locale_formatters.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/admin/domain/entities/device.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_detail_widgets.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';

class AdminDeviceDetailScreen extends ConsumerWidget {
  const AdminDeviceDetailScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceAsync = ref.watch(adminDeviceDetailProvider(deviceId));
    final formState = ref.watch(adminDeviceFormProvider);

    return PermissionGuardScreen(
      permission: 'device:read',
      child: AdminScaffold(
        title: context.l10n.deviceTitle,
        action: deviceAsync.maybeWhen(
          data: (device) => _DeviceActions(device: device),
          orElse: () => null,
        ),
        body: Stack(
          children: [
            deviceAsync.when(
              skipLoadingOnReload: true,
              data: (device) => _DeviceDetailBody(device: device),
              loading: () =>
                  const AdminDetailScreenSkeleton(sectionRowCounts: [7, 2]),
              error: (error, _) => AdminErrorState(
                error: error,
                onRetry: () =>
                    ref.invalidate(adminDeviceDetailProvider(deviceId)),
              ),
            ),
            if (formState.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.25),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DeviceActions extends ConsumerWidget {
  const _DeviceActions({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PermissionGuard(
          permission: 'device:update',
          child: AdminCircleActionButton(
            svgIconPath: 'assets/icons/edit-outline-icon.svg',
            onTap: () => context.push('/admin/devices/${device.devId}/edit'),
          ),
        ),
        const SizedBox(width: 8),
        PermissionGuard(
          permission: 'device:delete',
          child: AdminCircleActionButton(
            icon: Icons.delete_outline,
            color: AppColors.error,
            onTap: () => _confirmDelete(context, ref),
          ),
        ),
      ],
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
      context.go('/admin/devices');
      return;
    }

    SnackbarHelper.showError(
      context,
      ref.read(adminDeviceFormProvider).error ??
          context.l10n.adminDeleteFailed(context.l10n.deviceTitle),
    );
  }
}

class _DeviceDetailBody extends ConsumerWidget {
  const _DeviceDetailBody({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(adminDeviceDetailProvider(device.devId));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.01),
        ),
        children: [
          AdminDetailHeaderCard(
            title: device.displayName,
            subtitle: device.devId,
            icon: Icons.device_hub,
            iconColor: const Color(0xFFFF7043),
            isActive: device.isActive,
            activeLabel: context.l10n.commonActive,
            inactiveLabel: context.l10n.commonInactive,
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminSectionCard(
            title: context.l10n.adminBasicInfoSection,
            child: Column(
              children: [
                AdminDetailRow(
                  icon: Icons.tag_outlined,
                  label: context.l10n.adminDeviceIdLabel,
                  value: device.devId,
                ),
                AdminDetailRow(
                  icon: Icons.person_outline,
                  label: 'User ID',
                  value: device.userId ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.place_outlined,
                  label: context.l10n.commonLocation,
                  value: device.devLocation ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.wifi_outlined,
                  label: context.l10n.adminIpAddressLabel,
                  value: device.devIp ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.settings_ethernet,
                  label: context.l10n.adminPortLabel,
                  value: device.devPort ?? '-',
                ),
                AdminDetailRow(
                  icon: Icons.my_location_outlined,
                  label: context.l10n.adminCoordinatesSection,
                  value: device.hasCoordinates
                      ? '${device.devLat}, ${device.devLon}'
                      : '-',
                ),
                AdminDetailRow(
                  icon: Icons.terrain_outlined,
                  label: context.l10n.adminAltitudeLabel,
                  value: device.devAlt?.toString() ?? '-',
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
                  value: _date(context, device.devCreated),
                ),
                AdminDetailRow(
                  icon: Icons.update_outlined,
                  label: 'Diubah',
                  value: _date(context, device.devUpdate),
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
