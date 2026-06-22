import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../providers/device_provider.dart';
import 'package:go_router/go_router.dart';

class DeviceDetailScreen extends ConsumerWidget {
  final String siteId;
  final String devId;

  const DeviceDetailScreen({
    super.key,
    required this.siteId,
    required this.devId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceAsync = ref.watch(
      deviceDetailProvider((siteId: siteId, devId: devId)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.deviceDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              deviceAsync.whenData((device) {
                context.push('/site-device-edit/$siteId', extra: device);
              });
            },
          ),
        ],
      ),
      body: deviceAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        data: (device) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: device.isActive
                            ? Colors.green.shade100
                            : Colors.grey.shade300,
                        child: Icon(
                          Icons.router,
                          size: 32,
                          color: device.isActive ? Colors.green : Colors.grey,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device.displayName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Gap(4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: device.isActive
                                    ? Colors.green.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                device.isActive
                                    ? context.l10n.commonActive
                                    : context.l10n.commonInactive,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: device.isActive
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),

              // Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.deviceInformationTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Gap(16),
                      _buildInfoRow(context.l10n.deviceIdLabel, device.devId),
                      _buildInfoRow(
                        context.l10n.commonLocation,
                        device.locationDisplay,
                      ),
                      if (device.devNumberId != null)
                        _buildInfoRow(
                          context.l10n.deviceNumberIdLabel,
                          device.devNumberId!,
                        ),
                      if (device.devIp != null)
                        _buildInfoRow(
                          context.l10n.commonIpAddress,
                          device.devIp!,
                        ),
                      if (device.devPort != null)
                        _buildInfoRow(context.l10n.commonPort, device.devPort!),
                    ],
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),

              // Coordinates Card
              if (device.hasCoordinates)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.commonCoordinates,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Gap(16),
                        _buildInfoRow(
                          context.l10n.commonLongitude,
                          device.devLon.toString(),
                        ),
                        _buildInfoRow(
                          context.l10n.commonLatitude,
                          device.devLat.toString(),
                        ),
                        if (device.devAlt != null)
                          _buildInfoRow(
                            context.l10n.commonAltitude,
                            '${device.devAlt} m',
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        loading: () => const EntityDetailContentSkeleton(
          infoRowCount: 5,
          secondaryRowCount: 3,
          circularIcon: true,
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ErrorStateCardWidget(
              message: error.toString(),
              onRetry: () => ref.invalidate(
                deviceDetailProvider((siteId: siteId, devId: devId)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
