import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../dashboard/data/models/environmental_health_model.dart';
import '../../../dashboard/domain/entities/dashboard_entity.dart';
import '../../../dashboard/presentation/widgets/sensor_status_card.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';
import '../utils/sensor_metadata_adapter.dart';
import '../widgets/no_active_plant_card_widget.dart';
import '../widgets/realtime/sensor_status_list_widget.dart';
import '../widgets/realtime/today_chart_widget.dart';

class RealtimeTab extends ConsumerWidget {
  const RealtimeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final latestAsync = ref.watch(latestReadsProvider);
    final todayAsync = ref.watch(todayReadsProvider);
    final envHealthAsync = ref.watch(envHealthProvider);
    final activePlantAsync = ref.watch(ongoingPlantProvider);
    final metadataAdapter = ref.watch(sensorMetadataAdapterProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await runSpacedInvalidations([
          () => ref.invalidate(latestReadsProvider),
          () => ref.invalidate(todayReadsProvider),
          () => ref.invalidate(envHealthProvider),
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
            activePlantAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (plant) => plant == null
                  ? Column(
                      children: [
                        const NoActivePlantCardWidget(),
                        SizedBox(height: context.rh(0.024)),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            // Alarm Banner (Disabled - unsupported by backend live)
            const SizedBox.shrink(),

            // Sensor Grid
            SectionHeaderWidget(title: l10n.monitoringLatestStatusTitle),
            SizedBox(height: context.rh(0.014)),
            latestAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () =>
                  const LoadingCardWidget(height: 220, radius: AppRadius.lg),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(latestReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/sensor-icon.svg',
                      message: l10n.monitoringEmptySensor,
                      height: 195,
                    )
                  : _RealtimeSensorGrid(
                      reads: reads,
                      envHealth: envHealthAsync.valueOrNull,
                      metadataAdapter: metadataAdapter,
                    ),
            ),
            SizedBox(height: context.rh(0.024)),

            // Today Chart
            SectionHeaderWidget(title: l10n.monitoringTodayChartSection),
            SizedBox(height: context.rh(0.014)),
            todayAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () =>
                  const LoadingCardWidget(height: 260, radius: AppRadius.lg),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(todayReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/grafik_outline_icon.svg',
                      message: l10n.monitoringEmptyTodayChart,
                      height: 260,
                    )
                  : TodayChartWidget(
                      reads: reads,
                      metadataAdapter: metadataAdapter,
                    ),
            ),
            SizedBox(height: context.rh(0.024)),

            // Sensor Status Detail
            SectionHeaderWidget(title: l10n.monitoringSensorDetailSection),
            SizedBox(height: context.rh(0.014)),
            latestAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () =>
                  const LoadingCardWidget(height: 60, radius: AppRadius.lg),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) => reads.isEmpty
                  ? InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/sensor-icon.svg',
                      message: l10n.monitoringEmptySensor,
                      height: 60,
                    )
                  : SensorStatusListWidget(
                      reads: reads,
                      envHealth: envHealthAsync.valueOrNull,
                      metadataAdapter: metadataAdapter,
                    ),
            ),
            SizedBox(height: context.rh(0.024)),

            // Log Sensor (Disabled - unsupported by backend live)
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

/// Adapts [SensorReadUpdate] to [SensorHealthEntity] for [SensorStatusGrid].
class _RealtimeSensorGrid extends StatelessWidget {
  final List<SensorReadUpdate> reads;
  final EnvironmentalHealth? envHealth;
  final SensorMetadataAdapter metadataAdapter;
  const _RealtimeSensorGrid({
    required this.reads,
    this.envHealth,
    required this.metadataAdapter,
  });

  @override
  Widget build(BuildContext context) {
    // Konversi SensorReadUpdate ke SensorHealthEntity
    final entities = reads.map((r) {
      double persentase = r.hasNumericValue ? 80.0 : 0.0;
      if (envHealth != null && envHealth!.sensors.isNotEmpty) {
        final match = envHealth!.sensors
            .where((s) => s.dsId == r.dsId)
            .firstOrNull;
        if (match != null) persentase = match.persentase;
      }
      return SensorHealthEntity(
        devId: r.devId,
        dsId: r.dsId,
        readUpdateValue: r.readUpdateValue ?? '0',
        persentase: persentase,
      );
    }).toList();

    return SensorStatusGrid(
      sensors: entities,
      defaultCount: 6,
      metadataAdapter: metadataAdapter,
    );
  }
}
