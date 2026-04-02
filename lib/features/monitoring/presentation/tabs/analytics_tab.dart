import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';

class AnalyticsTab extends ConsumerWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envAsync = ref.watch(envHealthProvider);
    final plantRecAsync = ref.watch(plantRecommendationProvider);
    final dailyAsync = ref.watch(dailyReadsProvider);
    final devicesAsync = ref.watch(devicesProvider);
    final plant = ref.watch(currentPlantProvider);
    final latestAsync = ref.watch(latestReadsProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(envHealthProvider);
        ref.invalidate(plantRecommendationProvider);
        ref.invalidate(dailyReadsProvider);
        ref.invalidate(devicesProvider);
        ref.invalidate(latestReadsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.rw(0.051)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Analytics Overview ────────────────────────
            _SectionTitle('Analytics Overview'),
            SizedBox(height: context.rh(0.015)),
            envAsync.when(
              loading: () => _shimmer(context, 120),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(envHealthProvider),
              ),
              data: (health) => _AnalyticsOverview(health: health),
            ),

            SizedBox(height: context.rh(0.025)),

            // ─── Plant Recommendation ──────────────────────
            _SectionTitle('Plant Recommendation'),
            SizedBox(height: context.rh(0.015)),
            plantRecAsync.when(
              loading: () => _shimmer(context, 140),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(plantRecommendationProvider),
              ),
              data: (rec) => _PlantRecommendationCard(data: rec),
            ),

            SizedBox(height: context.rh(0.025)),

            // ─── Current Condition ─────────────────────────
            _SectionTitle('Current Condition'),
            SizedBox(height: context.rh(0.015)),
            latestAsync.when(
              loading: () => _shimmer(context, 160),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) => _CurrentConditionCard(reads: reads),
            ),

            SizedBox(height: context.rh(0.025)),

            // ─── Plant Statistics ──────────────────────────
            _SectionTitle('Plant Statistics'),
            SizedBox(height: context.rh(0.015)),
            _PlantStatCard(plant: plant),

            SizedBox(height: context.rh(0.025)),

            // ─── Device & Sensor Overview ──────────────────
            _SectionTitle('Device & Sensor Overview'),
            SizedBox(height: context.rh(0.015)),
            devicesAsync.when(
              loading: () => _shimmer(context, 100),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) => _DeviceSensorOverview(devices: devices),
            ),

            SizedBox(height: context.rh(0.025)),

            // ─── Daily Sensor Analytics ────────────────────
            _SectionTitle('Daily Sensor Analytics'),
            SizedBox(height: context.rh(0.015)),
            dailyAsync.when(
              loading: () => _shimmer(context, 220),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(dailyReadsProvider),
              ),
              data: (daily) => _DailySensorChart(data: daily),
            ),

            SizedBox(height: context.rh(0.04)),
          ],
        ),
      ),
    );
  }

  Widget _shimmer(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

// ─── Analytics Overview ───────────────────────────────────
class _AnalyticsOverview extends StatelessWidget {
  final Map<String, dynamic> health;
  const _AnalyticsOverview({required this.health});

  @override
  Widget build(BuildContext context) {
    final overall = (health['overall_health'] as num?)?.toDouble() ?? 0;
    final total = health['total_sensors'] ?? 0;
    Color healthColor;
    String healthLabel;
    if (overall >= 80) {
      healthColor = AppColors.success;
      healthLabel = 'Sangat Baik';
    } else if (overall >= 60) {
      healthColor = AppColors.primaryLight;
      healthLabel = 'Baik';
    } else if (overall >= 40) {
      healthColor = AppColors.warning;
      healthLabel = 'Cukup';
    } else {
      healthColor = AppColors.error;
      healthLabel = 'Perlu Perhatian';
    }

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: healthColor.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: healthColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${overall.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.w700,
                  color: healthColor,
                ),
              ),
            ),
          ),
          SizedBox(width: context.rw(0.04)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  healthLabel,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$total sensor aktif',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.rh(0.008)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: healthColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Kesehatan Lingkungan',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.w500,
                      color: healthColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Plant Recommendation ─────────────────────────────────
class _PlantRecommendationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _PlantRecommendationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final recData = data['data'] as Map<String, dynamic>?;
    final recommendation = recData?['recommendation'] as Map<String, dynamic>?;
    final plantName = recommendation?['plant'] as String? ?? '-';
    final confidence = (recommendation?['confidence'] as num?)?.toDouble();
    final sensorData = recData?['sensor_data'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rekomendasi Tanaman',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      plantName,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (confidence != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(confidence * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
          if (sensorData != null) ...[
            SizedBox(height: context.rh(0.015)),
            const Divider(color: AppColors.divider),
            SizedBox(height: context.rh(0.01)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sensorData.entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${SensorMeta.label(e.key)}: ${e.value}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (recData == null)
            Center(
              child: Text(
                'Belum ada rekomendasi',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Current Condition ────────────────────────────────────
class _CurrentConditionCard extends StatelessWidget {
  final List<SensorReadUpdate> reads;
  const _CurrentConditionCard({required this.reads});

  @override
  Widget build(BuildContext context) {
    if (reads.isEmpty) {
      return _EmptyCard(message: 'Belum ada data kondisi');
    }
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: reads.map((r) {
          final isLast = r == reads.last;
          return Container(
            padding: EdgeInsets.symmetric(vertical: context.rh(0.01)),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Text(
                  SensorMeta.label(r.dsId),
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${r.readUpdateValue ?? '-'}${SensorMeta.unit(r.dsId)}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Plant Statistics ─────────────────────────────────────
class _PlantStatCard extends StatelessWidget {
  final dynamic plant;
  const _PlantStatCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    if (plant == null) {
      return _EmptyCard(message: 'Belum ada tanaman aktif');
    }
    final hst = plant.hst as int;
    final phase = plant.growthPhase as String;
    final plantDate = plant.plantDate as DateTime?;

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _statRow(context, 'Nama Tanaman', plant.plantName ?? '-'),
          _statRow(context, 'Jenis', plant.plantType?.displayName ?? '-'),
          _statRow(context, 'HST (Hari Setelah Tanam)', '$hst hari'),
          _statRow(context, 'Fase Pertumbuhan', phase),
          if (plantDate != null)
            _statRow(
              context,
              'Tanggal Tanam',
              DateFormat('dd MMM yyyy').format(plantDate),
            ),
        ],
      ),
    );
  }

  Widget _statRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rh(0.008)),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Device & Sensor Overview ─────────────────────────────
class _DeviceSensorOverview extends StatelessWidget {
  final List<DeviceModel> devices;
  const _DeviceSensorOverview({required this.devices});

  @override
  Widget build(BuildContext context) {
    final totalSensors = devices.fold<int>(0, (s, d) => s + d.sensors.length);
    final active = devices.where((d) => d.isActive).length;
    final inactive = devices.length - active;

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _overviewItem(
            context,
            '${devices.length}',
            'Device',
            AppColors.primary,
          ),
          _divider(),
          _overviewItem(context, '$totalSensors', 'Sensor', AppColors.info),
          _divider(),
          _overviewItem(context, '$active', 'Aktif', AppColors.success),
          _divider(),
          _overviewItem(
            context,
            '$inactive',
            'Offline',
            AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _overviewItem(
    BuildContext context,
    String val,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(11),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 40,
    color: AppColors.divider,
    margin: const EdgeInsets.symmetric(horizontal: 4),
  );
}

// ─── Daily Sensor Chart ───────────────────────────────────
class _DailySensorChart extends StatefulWidget {
  final List<SensorDailyModel> data;
  const _DailySensorChart({required this.data});

  @override
  State<_DailySensorChart> createState() => _DailySensorChartState();
}

class _DailySensorChartState extends State<_DailySensorChart> {
  String _selected = 'env_temp';

  List<String> get _params => widget.data.map((d) => d.dsId).toSet().toList();

  @override
  void initState() {
    super.initState();
    final p = _params;
    if (p.isNotEmpty && !p.contains(_selected)) _selected = p.first;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.data.where((d) => d.dsId == _selected).toList()
      ..sort((a, b) => (a.day ?? DateTime(0)).compareTo(b.day ?? DateTime(0)));

    final avgSpots = filtered
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.avgVal ?? 0))
        .toList();
    final minSpots = filtered
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.minVal ?? 0))
        .toList();
    final maxSpots = filtered
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.maxVal ?? 0))
        .toList();

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _params.map((p) {
                final isSel = p == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = p),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSel
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      SensorMeta.label(p),
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(11),
                        fontWeight: FontWeight.w500,
                        color: isSel ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: context.rh(0.015)),
          if (filtered.isEmpty)
            const Center(
              child: Text(
                'Belum ada data harian',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            )
          else
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: AppColors.divider, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: (filtered.length / 5).ceilToDouble().clamp(
                          1,
                          double.infinity,
                        ),
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= filtered.length) {
                            return const SizedBox.shrink();
                          }
                          final d = filtered[idx].day;
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              d != null ? DateFormat('d/M').format(d) : '',
                              style: TextStyle(
                                fontSize: context.sp(9),
                                color: AppColors.textTertiary,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _bar(avgSpots, AppColors.primary),
                    _bar(minSpots, AppColors.info.withValues(alpha: 0.7)),
                    _bar(maxSpots, AppColors.warning.withValues(alpha: 0.7)),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: context.rh(0.01)),
          Row(
            children: [
              _legend(AppColors.primary, 'Rata-rata'),
              const SizedBox(width: 12),
              _legend(AppColors.info, 'Min'),
              const SizedBox(width: 12),
              _legend(AppColors.warning, 'Max'),
            ],
          ),
        ],
      ),
    );
  }

  LineChartBarData _bar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.08),
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── Shared ───────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(16),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(13),
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 28),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
