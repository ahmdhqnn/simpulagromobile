import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../dashboard/data/models/environmental_health_model.dart';
import '../../../dashboard/domain/entities/dashboard_entity.dart';
import '../../../dashboard/presentation/widgets/sensor_status_card.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';
import '../widgets/realtime/sensor_status_list_widget.dart';
import '../widgets/realtime/today_chart_widget.dart';

class RealtimeTab extends ConsumerWidget {
  const RealtimeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestAsync = ref.watch(latestReadsProvider);
    final todayAsync = ref.watch(todayReadsProvider);
    final envHealthAsync = ref.watch(envHealthProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(latestReadsProvider);
        ref.invalidate(todayReadsProvider);
        ref.invalidate(envHealthProvider);
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
            // Alarm Banner (Disabled - unsupported by backend live)
            const SizedBox.shrink(),

            // Sensor Grid
            const SectionHeaderWidget(title: 'Status Sensor Terkini'),
            SizedBox(height: context.rh(0.014)),
            latestAsync.when(
              loading: () =>
                  const LoadingCardWidget(height: 220, radius: AppRadius.lg),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(latestReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? const InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/sensor-icon.svg',
                      message: 'Belum ada data sensor',
                      height: 195,
                    )
                  : _RealtimeSensorGrid(
                      reads: reads,
                      envHealth: envHealthAsync.valueOrNull,
                    ),
            ),
            SizedBox(height: context.rh(0.024)),

            // Today Chart
            const SectionHeaderWidget(title: 'Grafik Hari Ini'),
            SizedBox(height: context.rh(0.014)),
            todayAsync.when(
              loading: () =>
                  const LoadingCardWidget(height: 260, radius: AppRadius.lg),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(todayReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? const InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/grafik_outline_icon.svg',
                      message: 'Belum ada data grafik hari ini',
                      height: 260,
                    )
                  : TodayChartWidget(reads: reads),
            ),
            SizedBox(height: context.rh(0.024)),

            // Sensor Status Detail
            const SectionHeaderWidget(title: 'Detail Status Sensor'),
            SizedBox(height: context.rh(0.014)),
            latestAsync.when(
              loading: () =>
                  const LoadingCardWidget(height: 60, radius: AppRadius.lg),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) => reads.isEmpty
                  ? const InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/sensor-icon.svg',
                      message: 'Belum ada data sensor',
                      height: 60,
                    )
                  : SensorStatusListWidget(
                      reads: reads,
                      envHealth: envHealthAsync.valueOrNull,
                    ),
            ),
            SizedBox(height: context.rh(0.024)),

            // Log Sensor (Disabled - unsupported by backend live)
            const SizedBox.shrink(),
            SizedBox(height: context.rh(0.02)),
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
  const _RealtimeSensorGrid({required this.reads, this.envHealth});

  @override
  Widget build(BuildContext context) {
    // Konversi SensorReadUpdate ke SensorHealthEntity
    final entities = reads.map((r) {
      double persentase = r.numericValue > 0 ? 80.0 : 0.0;
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

    return SensorStatusGrid(sensors: entities, defaultCount: 6);
  }
}
