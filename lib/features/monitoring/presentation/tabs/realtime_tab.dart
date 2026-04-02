import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';

class RealtimeTab extends ConsumerWidget {
  const RealtimeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestAsync = ref.watch(latestReadsProvider);
    final todayAsync = ref.watch(todayReadsProvider);
    final logsAsync = ref.watch(logsProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(latestReadsProvider);
        ref.invalidate(todayReadsProvider);
        ref.invalidate(logsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.rw(0.051)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Sensor Cards ──────────────────────────────
            _SectionTitle('Status Sensor Terkini'),
            SizedBox(height: context.rh(0.015)),
            latestAsync.when(
              loading: () => _shimmerGrid(context),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(latestReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? _EmptyCard(message: 'Belum ada data sensor')
                  : _SensorGrid(reads: reads),
            ),

            SizedBox(height: context.rh(0.03)),

            // ─── Today Chart ───────────────────────────────
            _SectionTitle('Grafik Hari Ini'),
            SizedBox(height: context.rh(0.015)),
            todayAsync.when(
              loading: () => _shimmerBox(context, 220),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(todayReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? _EmptyCard(message: 'Belum ada data hari ini')
                  : _TodayChart(reads: reads),
            ),

            SizedBox(height: context.rh(0.03)),

            // ─── Sensor Status ─────────────────────────────
            _SectionTitle('Status Sensor'),
            SizedBox(height: context.rh(0.015)),
            latestAsync.when(
              loading: () => _shimmerBox(context, 120),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) => _SensorStatusList(reads: reads),
            ),

            SizedBox(height: context.rh(0.03)),

            // ─── Log Sensor ────────────────────────────────
            _SectionTitle('Log Sensor'),
            SizedBox(height: context.rh(0.015)),
            logsAsync.when(
              loading: () => _shimmerBox(context, 160),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(logsProvider),
              ),
              data: (logs) => logs.isEmpty
                  ? _EmptyCard(message: 'Belum ada log')
                  : _LogList(logs: logs.take(20).toList()),
            ),

            SizedBox(height: context.rh(0.04)),
          ],
        ),
      ),
    );
  }

  Widget _shimmerGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _shimmerBox(BuildContext context, double height) {
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

// ─── Sensor Grid ─────────────────────────────────────────
class _SensorGrid extends StatelessWidget {
  final List<SensorReadUpdate> reads;
  const _SensorGrid({required this.reads});

  Color _color(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return AppColors.temperature;
      case 'env_hum':
        return AppColors.humidity;
      case 'soil_nitro':
        return AppColors.nitrogen;
      case 'soil_phos':
        return AppColors.phosphorus;
      case 'soil_pot':
        return AppColors.potassium;
      case 'soil_ph':
        return AppColors.ph;
      default:
        return AppColors.primaryLight;
    }
  }

  IconData _icon(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return Icons.thermostat_outlined;
      case 'env_hum':
        return Icons.water_drop_outlined;
      case 'soil_nitro':
        return Icons.grass_outlined;
      case 'soil_phos':
        return Icons.science_outlined;
      case 'soil_pot':
        return Icons.diamond_outlined;
      case 'soil_ph':
        return Icons.speed_outlined;
      default:
        return Icons.sensors_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.sw >= 600 ? 3 : 2,
        childAspectRatio: 1.35,
        crossAxisSpacing: context.rw(0.03),
        mainAxisSpacing: context.rw(0.03),
      ),
      itemCount: reads.length,
      itemBuilder: (context, i) {
        final r = reads[i];
        final color = _color(r.dsId);
        return Container(
          padding: EdgeInsets.all(context.rw(0.04)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(context.rw(0.02)),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _icon(r.dsId),
                  size: context.rw(0.051).clamp(16.0, 22.0),
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                '${r.readUpdateValue ?? '-'}${SensorMeta.unit(r.dsId)}',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(20),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.rh(0.003)),
              Text(
                SensorMeta.label(r.dsId),
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(11),
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (r.readUpdateDate != null) ...[
                SizedBox(height: context.rh(0.003)),
                Text(
                  DateFormat('HH:mm').format(r.readUpdateDate!),
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(10),
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ─── Today Chart ─────────────────────────────────────────
class _TodayChart extends StatefulWidget {
  final List<SensorReadModel> reads;
  const _TodayChart({required this.reads});

  @override
  State<_TodayChart> createState() => _TodayChartState();
}

class _TodayChartState extends State<_TodayChart> {
  String _selected = 'env_temp';

  List<String> get _availableParams {
    return widget.reads.map((r) => r.dsId ?? '').toSet().toList();
  }

  @override
  void initState() {
    super.initState();
    final params = _availableParams;
    if (params.isNotEmpty && !params.contains(_selected)) {
      _selected = params.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.reads.where((r) => r.dsId == _selected).toList()
      ..sort(
        (a, b) =>
            (a.readDate ?? DateTime(0)).compareTo(b.readDate ?? DateTime(0)),
      );

    final spots = filtered.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.numericValue);
    }).toList();

    final color = _colorFor(_selected);

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Param selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _availableParams.map((p) {
                final isSelected = p == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = p),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
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
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: context.rh(0.015)),
          SizedBox(
            height: 160,
            child: spots.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada data',
                      style: TextStyle(color: AppColors.textTertiary),
                    ),
                  )
                : LineChart(
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
                            reservedSize: 24,
                            interval: (spots.length / 4).ceilToDouble().clamp(
                              1,
                              double.infinity,
                            ),
                            getTitlesWidget: (v, _) {
                              final idx = v.toInt();
                              if (idx < 0 || idx >= filtered.length) {
                                return const SizedBox.shrink();
                              }
                              final d = filtered[idx].readDate;
                              return Text(
                                d != null ? DateFormat('HH:mm').format(d) : '',
                                style: TextStyle(
                                  fontSize: context.sp(9),
                                  color: AppColors.textTertiary,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: color,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return AppColors.temperature;
      case 'env_hum':
        return AppColors.humidity;
      case 'soil_nitro':
        return AppColors.nitrogen;
      case 'soil_phos':
        return AppColors.phosphorus;
      case 'soil_pot':
        return AppColors.potassium;
      case 'soil_ph':
        return AppColors.ph;
      default:
        return AppColors.primaryLight;
    }
  }
}

// ─── Sensor Status List ───────────────────────────────────
class _SensorStatusList extends StatelessWidget {
  final List<SensorReadUpdate> reads;
  const _SensorStatusList({required this.reads});

  @override
  Widget build(BuildContext context) {
    if (reads.isEmpty) return _EmptyCard(message: 'Belum ada data sensor');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: reads.asMap().entries.map((e) {
          final r = e.value;
          final isLast = e.key == reads.length - 1;
          final val = r.numericValue;
          final isOk = val > 0;
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.041),
              vertical: context.rh(0.015),
            ),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isOk ? AppColors.success : AppColors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: context.rw(0.03)),
                Expanded(
                  child: Text(
                    SensorMeta.label(r.dsId),
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(13),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${r.readUpdateValue ?? '-'}${SensorMeta.unit(r.dsId)}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: context.rw(0.02)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isOk
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.textTertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isOk ? 'Aktif' : 'Offline',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.w500,
                      color: isOk ? AppColors.success : AppColors.textTertiary,
                    ),
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

// ─── Log List ─────────────────────────────────────────────
class _LogList extends StatelessWidget {
  final List<LogModel> logs;
  const _LogList({required this.logs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: logs.asMap().entries.map((e) {
          final log = e.value;
          final isLast = e.key == logs.length - 1;
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.041),
              vertical: context.rh(0.012),
            ),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.circle,
                  size: 6,
                  color: AppColors.primaryLight,
                ),
                SizedBox(width: context.rw(0.025)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.logRxPayload ?? '-',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (log.logRxDate != null)
                        Text(
                          DateFormat('dd MMM HH:mm:ss').format(log.logRxDate!),
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(10),
                            color: AppColors.textTertiary,
                          ),
                        ),
                    ],
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

// ─── Shared Widgets ───────────────────────────────────────
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
      padding: EdgeInsets.all(context.rw(0.061)),
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
