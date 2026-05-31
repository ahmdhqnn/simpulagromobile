import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
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

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(devicesProvider);
        ref.invalidate(monitoringSensorCountProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.015),
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
              loading: () => const LoadingCardWidget(height: 70),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: context.rh(0.024)),

            // Map
            const SectionHeaderWidget(title: 'Maps'),
            SizedBox(height: context.rh(0.014)),
            devicesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const LoadingCardWidget(height: 195),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(devicesProvider),
              ),
              data: (devices) {
                if (devices.isEmpty) {
                  return const InfoStateWidget.svg(
                    svgIconPath: 'assets/icons/maps-dot-filled-icon.svg',
                    message: 'Belum ada lokasi device untuk ditampilkan',
                    height: 195,
                  );
                }
                final lat =
                    selectedSite?.siteLat ??
                    (devices.isNotEmpty ? devices.first.devLat : null) ??
                    -6.9731;
                final lon =
                    selectedSite?.siteLon ??
                    (devices.isNotEmpty ? devices.first.devLon : null) ??
                    107.6338;
                return MapsWebviewWidget(
                  centerLat: lat,
                  centerLon: lon,
                  devices: devices,
                );
              },
            ),
            SizedBox(height: context.rh(0.024)),

            // Device List (reuse SensorByTypeCardWidget from analytics)
            const SectionHeaderWidget(title: 'Daftar Device & Sensor'),
            SizedBox(height: context.rh(0.014)),
            devicesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const LoadingCardWidget(height: 73),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) => devices.isEmpty
                  ? const InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/device-filled-icon.svg',
                      message: 'Belum ada device tersedia',
                      height: 73,
                    )
                  : SensorByTypeCardWidget(devices: devices),
            ),
            SizedBox(height: context.rh(0.02)),
          ],
        ),
      ),
    );
  }
}
