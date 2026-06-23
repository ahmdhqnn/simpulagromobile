import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/monitoring_provider.dart';
import '../widgets/analytics/sensor_by_type_card_widget.dart';
import '../widgets/maps/maps_stats_bar_widget.dart';
import '../widgets/maps/maps_webview_widget.dart';

class MapsTab extends ConsumerWidget {
  const MapsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(devicesProvider);
    final selectedSite = ref.watch(selectedSiteProvider);
    final sensorCountAsync = ref.watch(monitoringSensorCountProvider);
    final sectionGap = context.rh(0.024);
    final contentGap = context.rh(0.012);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await runSpacedInvalidations([
          () => ref.invalidate(devicesProvider),
          () => ref.invalidate(monitoringSensorCountProvider),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          context.rw(0.051),
          0,
          context.rw(0.051),
          bottomNavigationContentSpace(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Bar
            devicesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              data: (devices) {
                final sensorCount = sensorCountAsync.when(
                  skipLoadingOnReload: true,
                  skipLoadingOnRefresh: true,
                  skipError: true,
                  data: (c) => c,
                  loading: () =>
                      devices.fold<int>(0, (s, d) => s + d.sensors.length),
                  error: (_, __) =>
                      devices.fold<int>(0, (s, d) => s + d.sensors.length),
                );
                return MapsStatsBarWidget(
                  devices: devices,
                  totalSensors: sensorCount,
                );
              },
              loading: () => const CompactStatsCardSkeleton(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: sectionGap),

            // Map
            SectionHeaderWidget(title: context.l10n.monitoringTabMaps),
            SizedBox(height: contentGap),
            devicesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const MapCardSkeleton(),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(devicesProvider),
              ),
              data: (devices) {
                final mappedDevices = devices
                    .where((device) => device.hasCoordinates)
                    .toList();
                if (mappedDevices.isEmpty) {
                  return InfoStateWidget.svg(
                    svgIconPath: 'assets/icons/maps-dot-filled-icon.svg',
                    message: context.l10n.monitoringMapsNoDeviceLocations,
                    height: 195,
                  );
                }
                final lat =
                    selectedSite?.siteLat ??
                    mappedDevices.first.devLat ??
                    -6.9731;
                final lon =
                    selectedSite?.siteLon ??
                    mappedDevices.first.devLon ??
                    107.6338;
                return MapsWebviewWidget(
                  centerLat: lat,
                  centerLon: lon,
                  devices: mappedDevices,
                  l10n: context.l10n,
                );
              },
            ),
            SizedBox(height: sectionGap),

            // Device List (reuse SensorByTypeCardWidget from analytics)
            SectionHeaderWidget(title: context.l10n.monitoringDeviceSensorList),
            SizedBox(height: contentGap),
            devicesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const SimpleRowsCardSkeleton(rowCount: 2),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) => devices.isEmpty
                  ? InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/device-filled-icon.svg',
                      message: context.l10n.monitoringNoDevicesAvailable,
                      height: 73,
                    )
                  : SensorByTypeCardWidget(devices: devices, showHeader: false),
            ),
          ],
        ),
      ),
    );
  }
}
