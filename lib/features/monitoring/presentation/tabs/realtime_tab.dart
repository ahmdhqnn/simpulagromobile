import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.015),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('Status Sensor Terkini'),
            SizedBox(height: context.rh(0.014)),
            latestAsync.when(
              loading: () => _shimmerCard(context, 195),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(latestReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? _EmptyStateCard(
                      height: 195,
                      message: 'Belum ada data sensor',
                    )
                  : _SensorGrid(reads: reads),
            ),

            SizedBox(height: context.rh(0.024)),

            _SectionTitle('Grafik Hari Ini'),
            SizedBox(height: context.rh(0.014)),
            todayAsync.when(
              loading: () => _shimmerCard(context, 195),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(todayReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? const _EmptyStateCard(
                      height: 195,
                      message: 'Belum ada data sensor',
                      iconPath: 'assets/icons/monitoring-filled-icon.svg',
                    )
                  : _TodayChart(reads: reads),
            ),

            SizedBox(height: context.rh(0.024)),

            _SectionTitle('Status Sensor'),
            SizedBox(height: context.rh(0.014)),
            latestAsync.when(
              loading: () => _shimmerCard(context, 195),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) => reads.isEmpty
                  ? _EmptyStateCard(
                      height: 195,
                      message: 'Belum ada data sensor',
                    )
                  : _SensorStatusList(reads: reads),
            ),

            SizedBox(height: context.rh(0.024)),

            _SectionTitle('Log Sensor'),
            SizedBox(height: context.rh(0.014)),
            logsAsync.when(
              loading: () => _shimmerCard(context, 97),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(logsProvider),
              ),
              data: (logs) => logs.isEmpty
                  ? _EmptyStateCard(
                      height: 97,
                      message: 'Belum ada data sensor',
                    )
                  : _LogList(logs: logs.take(20).toList()),
            ),

            SizedBox(height: context.rh(0.02)),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCard(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _SensorGrid extends StatelessWidget {
  final List<SensorReadUpdate> reads;
  const _SensorGrid({required this.reads});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: context.rw(0.025),
          mainAxisSpacing: context.rh(0.012),
        ),
        itemCount: reads.length.clamp(0, 6),
        itemBuilder: (context, i) {
          final r = reads[i];
          return _SensorCard(read: r);
        },
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  final SensorReadUpdate read;
  const _SensorCard({required this.read});

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
    final color = _color(read.dsId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(context.rw(0.02)),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_icon(read.dsId), size: 20, color: color),
        ),
        SizedBox(height: context.rh(0.006)),
        Text(
          '${read.readUpdateValue ?? '-'}${SensorMeta.unit(read.dsId)}',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(14),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1D1D),
          ),
        ),
        SizedBox(height: context.rh(0.002)),
        Text(
          SensorMeta.label(read.dsId),
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(10),
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _TodayChart extends StatefulWidget {
  final List<SensorReadModel> reads;
  const _TodayChart({required this.reads});

  @override
  State<_TodayChart> createState() => _TodayChartState();
}

class _TodayChartState extends State<_TodayChart> {
  String _selected = 'env_temp';

  List<String> get _availableParams {
    return widget.reads
        .map((r) => r.dsId ?? '')
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
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
    if (widget.reads.isEmpty) {
      return const _EmptyStateCard(
        height: 195,
        message: 'Belum ada data sensor',
        iconPath: 'assets/icons/grafik_filled_icon.svg',
      );
    }

    final filtered = widget.reads.where((r) => r.dsId == _selected).toList()
      ..sort(
        (a, b) =>
            (a.readDate ?? DateTime(0)).compareTo(b.readDate ?? DateTime(0)),
      );

    if (filtered.isEmpty) {
      return Container(
        height: 195,
        padding: EdgeInsets.all(context.rw(0.041)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/grafik_filled_icon.svg',
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Belum ada data untuk sensor ini',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  color: Color(0xFF1D1D1D),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final spots = filtered
        .asMap()
        .entries
        .where((e) => e.value.numericValue > 0)
        .map((e) {
          return FlSpot(e.key.toDouble(), e.value.numericValue);
        })
        .toList();

    if (spots.isEmpty) {
      return Container(
        height: 195,
        padding: EdgeInsets.all(context.rw(0.041)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/grafik_filled_icon.svg',
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Data sensor tidak valid',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  color: Color(0xFF1D1D1D),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final color = _colorFor(_selected);

    return Container(
      height: 195,
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: const Color(0xFFE0E0E0), strokeWidth: 1),
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
                      color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
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
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.white,
              tooltipBorder: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
        ),
      ),
    );
  }

  Color _colorFor(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return const Color(0xFF4FC3F7);
      case 'env_hum':
        return const Color(0xFF81C784);
      case 'soil_nitro':
        return const Color(0xFFFFB74D);
      case 'soil_phos':
        return const Color(0xFFBA68C8);
      case 'soil_pot':
        return const Color(0xFFE57373);
      case 'soil_ph':
        return const Color(0xFF64B5F6);
      default:
        return AppColors.primaryLight;
    }
  }
}

class _SensorStatusList extends StatelessWidget {
  final List<SensorReadUpdate> reads;
  const _SensorStatusList({required this.reads});

  @override
  Widget build(BuildContext context) {
    if (reads.isEmpty) {
      return const _EmptyStateCard(
        height: 195,
        message: 'Belum ada data sensor',
      );
    }
    return Container(
      height: 195,
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: reads.length.clamp(0, 4),
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: const Color(0xFF1D1D1D).withValues(alpha: 0.1),
        ),
        itemBuilder: (context, i) {
          final r = reads[i];
          final val = r.numericValue;
          final isOk = val > 0;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.rh(0.01)),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isOk
                        ? AppColors.success
                        : const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: context.rw(0.03)),
                Expanded(
                  child: Text(
                    SensorMeta.label(r.dsId),
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      color: const Color(0xFF1D1D1D),
                    ),
                  ),
                ),
                Text(
                  '${r.readUpdateValue ?? '-'}${SensorMeta.unit(r.dsId)}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D1D1D),
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
                        : const Color(0xFF1D1D1D).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isOk ? 'Aktif' : 'Offline',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.w500,
                      color: isOk
                          ? AppColors.success
                          : const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LogList extends StatelessWidget {
  final List<LogModel> logs;
  const _LogList({required this.logs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: logs.length.clamp(0, 2),
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: const Color(0xFF1D1D1D).withValues(alpha: 0.1),
        ),
        itemBuilder: (context, i) {
          final log = logs[i];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.rh(0.008)),
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
                          fontSize: context.sp(11),
                          color: const Color(0xFF1D1D1D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (log.logRxDate != null)
                        Text(
                          DateFormat('dd MMM HH:mm:ss').format(log.logRxDate!),
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(9),
                            color: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.5),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(22),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF1D1D1D),
        height: 1.0,
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final double height;
  final String message;
  final String? iconPath;

  const _EmptyStateCard({
    required this.height,
    required this.message,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath ?? 'assets/icons/device-filled-icon.svg',
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: context.rh(0.005)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D),
                height: 1.83,
              ),
            ),
          ],
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
        borderRadius: BorderRadius.circular(18),
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
