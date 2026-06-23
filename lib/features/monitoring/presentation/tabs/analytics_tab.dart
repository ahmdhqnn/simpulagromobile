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
import '../../../plant/presentation/providers/plant_provider.dart';
import '../../../recommendation/presentation/providers/recommendation_hub_provider.dart';
import '../../../recommendation/presentation/providers/recommendation_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
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
    final plantRecAsync = ref.watch(recommendationPlantFeedProvider);
    final dailyAsync = ref.watch(dailyReadsProvider);
    final devicesAsync = ref.watch(devicesProvider);
    final activePlantAsync = ref.watch(ongoingPlantProvider);
    final plant = activePlantAsync.valueOrNull;
    final monthlyAsync = ref.watch(monthlyReadsProvider);
    final metadataAdapter = ref.watch(sensorMetadataAdapterProvider);
    final sectionGap = context.rh(0.024);
    final contentGap = context.rh(0.012);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await runSpacedInvalidations([
          () => ref.invalidate(envHealthProvider),
          () => ref.invalidate(recommendationPlantFeedProvider),
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
            SectionHeaderWidget(
              title: context.l10n.monitoringAnalyticsOverview,
            ),
            SizedBox(height: contentGap),

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
            // Action Required (when no sensors)
            envAsync.whenOrNull(
                  data: (health) {
                    if (health.totalSensors == 0) {
                      return Column(
                        children: [
                          SizedBox(height: contentGap),
                          const ActionRequiredCardWidget(),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ) ??
                const SizedBox.shrink(),
            SizedBox(height: sectionGap),

            activePlantAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => Column(
                children: [
                  const NoActivePlantCardSkeleton(),
                  SizedBox(height: sectionGap),
                ],
              ),
              error: (_, __) => const SizedBox.shrink(),
              data: (activePlant) => activePlant == null
                  ? Column(
                      children: [
                        const NoActivePlantCardWidget(),
                        SizedBox(height: sectionGap),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            // Plant Statistics
            SectionHeaderWidget(
              title: context.l10n.monitoringPlantStatisticsSection,
            ),
            SizedBox(height: contentGap),
            if (activePlantAsync.isLoading && plant == null)
              const CompactStatsCardSkeleton()
            else
              PlantStatisticsCardWidget(plant: plant),
            if (plant != null) ...[
              SizedBox(height: contentGap),
              GrowthPhaseCardWidget(plant: plant),
              SizedBox(height: contentGap),
              PlantDistributionCardWidget(plant: plant),
            ],
            SizedBox(height: sectionGap),

            // Plant Recommendation
            SectionHeaderWidget(
              title: context.l10n.monitoringPlantRecommendationSection,
            ),
            SizedBox(height: contentGap),
            plantRecAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const RecommendationOverviewCardSkeleton(),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () {
                  final siteId = ref.read(selectedSiteIdProvider);
                  if (siteId != null) {
                    ref.invalidate(plantRecommendationsBySiteProvider(siteId));
                  }
                  ref.invalidate(recommendationPlantFeedProvider);
                },
              ),
              data: (rec) =>
                  PlantRecommendationCardWidget(recommendations: rec),
            ),
            SizedBox(height: sectionGap),

            // Device & Sensor Overview
            SectionHeaderWidget(
              title: context.l10n.monitoringDeviceSensorOverviewSection,
            ),
            SizedBox(height: contentGap),
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
            SizedBox(height: sectionGap),

            devicesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => Column(
                children: [
                  const SimpleRowsCardSkeleton(rowCount: 2),
                  SizedBox(height: sectionGap),
                ],
              ),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) => devices.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        SensorByTypeCardWidget(devices: devices),
                        SizedBox(height: sectionGap),
                      ],
                    ),
            ),

            // Daily Sensor Analysis
            SectionHeaderWidget(
              title: context.l10n.monitoringDailyAnalyticsTitle,
            ),
            SizedBox(height: contentGap),
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
            SizedBox(height: sectionGap),

            // Monthly Recap
            SectionHeaderWidget(
              title: context.l10n.monitoringMonthlySensorRecap,
            ),
            SizedBox(height: contentGap),
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
          ],
        ),
      ),
    );
  }
}
