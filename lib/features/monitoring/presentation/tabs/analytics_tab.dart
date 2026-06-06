import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../providers/monitoring_provider.dart';
import '../widgets/analytics/action_required_card_widget.dart';
import '../widgets/analytics/daily_sensor_chart_widget.dart';
import '../widgets/analytics/device_sensor_overview_widget.dart';
import '../widgets/analytics/environmental_health_card_widget.dart';
import '../widgets/analytics/growth_phase_card_widget.dart';
import '../widgets/analytics/monthly_trend_card_widget.dart';
import '../widgets/analytics/plant_distribution_card_widget.dart';
import '../widgets/analytics/plant_recommendation_card_widget.dart';
import '../widgets/analytics/plant_statistics_card_widget.dart';
import '../widgets/analytics/sensor_by_type_card_widget.dart';
import '../widgets/no_active_plant_card_widget.dart';

class AnalyticsTab extends ConsumerWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envAsync = ref.watch(envHealthProvider);
    final plantRecAsync = ref.watch(plantRecommendationProvider);
    final dailyAsync = ref.watch(dailyReadsProvider);
    final devicesAsync = ref.watch(devicesProvider);
    final activePlantAsync = ref.watch(ongoingPlantProvider);
    final plant = activePlantAsync.valueOrNull;
    final monthlyAsync = ref.watch(monthlyReadsProvider);
    final metadataAdapter = ref.watch(sensorMetadataAdapterProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await runSpacedInvalidations([
          () => ref.invalidate(envHealthProvider),
          () => ref.invalidate(plantRecommendationProvider),
          () => ref.invalidate(dailyReadsProvider),
          () => ref.invalidate(devicesProvider),
          () => ref.invalidate(monthlyReadsProvider),
          () => ref.invalidate(ongoingPlantProvider),
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
            const SectionHeaderWidget(title: 'Analytics Overview'),
            SizedBox(height: context.rh(0.015)),

            // Environmental Health
            envAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const EnvironmentalHealthCardSkeleton(),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(envHealthProvider),
              ),
              data: (health) => EnvironmentalHealthCardWidget(health: health),
            ),
            SizedBox(height: context.rh(0.025)),

            // Action Required (when no sensors)
            envAsync.whenOrNull(
                  data: (health) {
                    if (health.totalSensors == 0) {
                      return Column(
                        children: [
                          const ActionRequiredCardWidget(),
                          SizedBox(height: context.rh(0.025)),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ) ??
                const SizedBox.shrink(),

            activePlantAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (activePlant) => activePlant == null
                  ? Column(
                      children: [
                        const NoActivePlantCardWidget(),
                        SizedBox(height: context.rh(0.025)),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            // Plant Statistics
            const SectionHeaderWidget(title: 'Statistik Tanaman'),
            SizedBox(height: context.rh(0.015)),
            PlantStatisticsCardWidget(plant: plant),
            SizedBox(height: context.rh(0.025)),

            if (plant != null) ...[
              GrowthPhaseCardWidget(plant: plant),
              SizedBox(height: context.rh(0.025)),
              PlantDistributionCardWidget(plant: plant),
              SizedBox(height: context.rh(0.025)),
            ],

            // Plant Recommendation
            const SectionHeaderWidget(title: 'Rekomendasi Tanaman'),
            SizedBox(height: context.rh(0.015)),
            plantRecAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const RecommendationOverviewCardSkeleton(),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(plantRecommendationProvider),
              ),
              data: (rec) => PlantRecommendationCardWidget(
                data: rec,
                metadataAdapter: metadataAdapter,
              ),
            ),
            SizedBox(height: context.rh(0.025)),

            // Device & Sensor Overview
            const SectionHeaderWidget(title: 'Perangkat & Sensor Overview'),
            SizedBox(height: context.rh(0.015)),
            devicesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const SplitMetricCardsSkeleton(),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) {
                final sensorCountAsync = ref.watch(
                  monitoringSensorCountProvider,
                );
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
                return DeviceSensorOverviewWidget(
                  devices: devices,
                  totalSensors: sensorCount,
                );
              },
            ),
            SizedBox(height: context.rh(0.015)),

            devicesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const SimpleRowsCardSkeleton(rowCount: 2),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) => SensorByTypeCardWidget(devices: devices),
            ),
            SizedBox(height: context.rh(0.025)),

            // Daily Sensor Analysis
            const SectionHeaderWidget(title: 'Analisis Sensor Harian'),
            SizedBox(height: context.rh(0.015)),
            dailyAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () =>
                  const ChartCardSkeleton(chartHeight: 250, hasStats: false),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(dailyReadsProvider),
              ),
              data: (daily) => DailySensorChartWidget(
                data: daily,
                metadataAdapter: metadataAdapter,
              ),
            ),
            SizedBox(height: context.rh(0.025)),

            // Monthly Recap
            const SectionHeaderWidget(title: 'Rekap Bulanan Sensor'),
            SizedBox(height: context.rh(0.015)),
            monthlyAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () =>
                  const ChartCardSkeleton(chartHeight: 200, hasStats: false),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(monthlyReadsProvider),
              ),
              data: (monthly) => MonthlyTrendCardWidget(
                data: monthly,
                metadataAdapter: metadataAdapter,
              ),
            ),
            SizedBox(height: context.rh(0.025)),
          ],
        ),
      ),
    );
  }
}
