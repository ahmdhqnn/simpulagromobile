import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../dashboard/data/models/environmental_health_model.dart';
import '../../../dashboard/presentation/widgets/sensor_status_card.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';

class RealtimeTab extends ConsumerWidget {
  const RealtimeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestAsync = ref.watch(latestReadsProvider);
    final todayAsync = ref.watch(todayReadsProvider);
    final logsAsync = ref.watch(logsProvider);
    final envHealthAsync = ref.watch(envHealthProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(latestReadsProvider);
        ref.invalidate(todayReadsProvider);
        ref.invalidate(logsProvider);
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
            const _SectionTitle('Status Sensor Terkini'),
            SizedBox(height: context.rh(0.014)),
            latestAsync.when(
              loading: () => _shimmerCard(context, 220),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(latestReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? const _EmptyStateCard(
                      height: 195,
                      message: 'Belum ada data sensor',
                    )
                  : _RealtimeSensorGrid(
                      reads: reads,
                      envHealth: envHealthAsync.valueOrNull,
                    ),
            ),

            SizedBox(height: context.rh(0.024)),

            const _SectionTitle('Grafik Hari Ini'),
            SizedBox(height: context.rh(0.014)),
            todayAsync.when(
              loading: () => _shimmerCard(context, 260),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(todayReadsProvider),
              ),
              data: (reads) => reads.isEmpty
                  ? const _EmptyStateCard(
                      height: 260,
                      message: 'Belum ada data grafik hari ini',
                      iconPath: 'assets/icons/grafik_outline_icon.svg',
                    )
                  : _TodayChart(reads: reads),
            ),

            SizedBox(height: context.rh(0.024)),

            const _SectionTitle('Detail Status Sensor'),
            SizedBox(height: context.rh(0.014)),
            latestAsync.when(
              loading: () => _shimmerCard(context, 60),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) => reads.isEmpty
                  ? const _EmptyStateCard(
                      height: 60,
                      message: 'Belum ada data sensor',
                    )
                  : _SensorStatusList(
                      reads: reads,
                      envHealth: envHealthAsync.valueOrNull,
                    ),
            ),

            SizedBox(height: context.rh(0.024)),

            const _SectionTitle('Log Sensor'),
            SizedBox(height: context.rh(0.014)),
            logsAsync.when(
              loading: () => _shimmerCard(context, 60),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(logsProvider),
              ),
              data: (logs) => logs.isEmpty
                  ? const _EmptyStateCard(
                      height: 60,
                      message: 'Belum ada log sensor',
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

class _RealtimeSensorGrid extends StatelessWidget {
  final List<SensorReadUpdate> reads;
  final EnvironmentalHealth? envHealth;
  const _RealtimeSensorGrid({required this.reads, this.envHealth});

  @override
  Widget build(BuildContext context) {
    final proxies = reads.map((r) => _SensorProxy(r, envHealth)).toList();
    return SensorStatusGrid(sensors: proxies, defaultCount: 6);
  }
}

class _SensorProxy {
  final SensorReadUpdate _r;
  final EnvironmentalHealth? _health;

  const _SensorProxy(this._r, this._health);

  String get dsId => _r.dsId;
  String get readUpdateValue => _r.readUpdateValue ?? '0';

  double get persentase {
    if (_health != null && _health.sensors.isNotEmpty) {
      final match = _health.sensors.where((s) => s.dsId == _r.dsId).firstOrNull;
      if (match != null) return match.persentase;
    }

    return _r.numericValue > 0 ? 80.0 : 0.0;
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

  List<String> get _availableParams => widget.reads
      .map((r) => r.dsId ?? '')
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();

  @override
  void initState() {
    super.initState();
    final params = _availableParams;
    if (params.isNotEmpty && !params.contains(_selected)) {
      _selected = params.first;
    }
  }

  Color _colorFor(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return const Color(0xFFFF8A65);
      case 'env_hum':
        return const Color(0xFF42A5F5);
      case 'soil_nitro':
        return const Color(0xFF66BB6A);
      case 'soil_phos':
        return const Color(0xFFAB47BC);
      case 'soil_pot':
        return const Color(0xFFFF7043);
      case 'soil_ph':
        return const Color(0xFF26C6DA);
      case 'soil_temp':
        return const Color(0xFF8BC34A);
      case 'soil_hum':
        return const Color(0xFF29B6F6);
      default:
        return AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = _availableParams;
    final filtered = widget.reads.where((r) => r.dsId == _selected).toList()
      ..sort(
        (a, b) =>
            (a.readDate ?? DateTime(0)).compareTo(b.readDate ?? DateTime(0)),
      );

    final spots = filtered
        .asMap()
        .entries
        .where((e) => e.value.numericValue > 0)
        .map((e) => FlSpot(e.key.toDouble(), e.value.numericValue))
        .toList();

    final color = _colorFor(_selected);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.show_chart,
                  color: Color(0xFF2196F3),
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Sensor Hari Ini',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(20),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pemantauan harian sensor realtime',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Selector parameter ──────────────────────────
          if (params.length > 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: params.map((p) {
                  final isSelected = p == _selected;
                  final c = _colorFor(p);
                  return GestureDetector(
                    onTap: () => setState(() => _selected = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? c : c.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        SensorMeta.label(p),
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(11),
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : c,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 12),

          SizedBox(
            height: 200,
            child: spots.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/grafik_outline_icon.svg',
                          width: 28,
                          height: 28,
                          colorFilter: ColorFilter.mode(
                            const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Belum ada data untuk sensor ini',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w300,
                            color: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: const Color(0xFFE0E0E0),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: context.sp(10),
                                  color: const Color(
                                    0xFF1D1D1D,
                                  ).withValues(alpha: 0.6),
                                ),
                              );
                            },
                          ),
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
                            reservedSize: 32,
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
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  d != null
                                      ? DateFormat('HH:mm').format(d)
                                      : '',
                                  style: TextStyle(
                                    fontSize: context.sp(9),
                                    color: const Color(
                                      0xFF1D1D1D,
                                    ).withValues(alpha: 0.5),
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
                                color.withValues(alpha: 0.03),
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
                          tooltipBorder: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SensorStatusList extends StatefulWidget {
  final List<SensorReadUpdate> reads;
  final EnvironmentalHealth? envHealth;
  const _SensorStatusList({required this.reads, this.envHealth});

  @override
  State<_SensorStatusList> createState() => _SensorStatusListState();
}

class _SensorStatusListState extends State<_SensorStatusList> {
  bool _expanded = false;

  Color _colorFor(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return const Color(0xFFFF8A65);
      case 'env_hum':
        return const Color(0xFF42A5F5);
      case 'soil_nitro':
        return const Color(0xFF66BB6A);
      case 'soil_phos':
        return const Color(0xFFAB47BC);
      case 'soil_pot':
        return const Color(0xFFFF7043);
      case 'soil_ph':
        return const Color(0xFF26C6DA);
      case 'soil_temp':
        return const Color(0xFF8BC34A);
      case 'soil_hum':
        return const Color(0xFF29B6F6);
      default:
        return AppColors.primaryLight;
    }
  }

  IconData _iconFor(String dsId) {
    switch (dsId) {
      case 'env_temp':
      case 'soil_temp':
        return Icons.thermostat_rounded;
      case 'env_hum':
      case 'soil_hum':
        return Icons.water_drop_rounded;
      case 'soil_nitro':
        return Icons.grass_rounded;
      case 'soil_phos':
        return Icons.science_rounded;
      case 'soil_pot':
        return Icons.diamond_rounded;
      case 'soil_ph':
        return Icons.speed_rounded;
      default:
        return Icons.sensors_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reads = widget.reads;
    final displayCount = _expanded
        ? reads.length
        : (reads.length > 3 ? 3 : reads.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: displayCount,
            separatorBuilder: (_, __) => Divider(
              height: 20,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.07),
            ),
            itemBuilder: (context, i) {
              final r = reads[i];
              final val = r.numericValue;
              final isOk = val > 0;
              final color = _colorFor(r.dsId);

              double persentase = isOk ? 80.0 : 0.0;
              if (widget.envHealth != null &&
                  widget.envHealth!.sensors.isNotEmpty) {
                final match = widget.envHealth!.sensors
                    .where((s) => s.dsId == r.dsId)
                    .firstOrNull;
                if (match != null) persentase = match.persentase;
              }

              return Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_iconFor(r.dsId), size: 18, color: color),
                  ),
                  SizedBox(width: context.rw(0.03)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                SensorMeta.label(r.dsId),
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: context.sp(13),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1D1D1D),
                                ),
                              ),
                            ),
                            Text(
                              '${r.readUpdateValue ?? '-'}${SensorMeta.unit(r.dsId)}',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: context.sp(13),
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: persentase / 100.0,
                            minHeight: 5,
                            backgroundColor: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.07),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.rw(0.025)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOk
                          ? AppColors.success.withValues(alpha: 0.1)
                          : const Color(0xFF1D1D1D).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isOk ? 'Aktif' : 'Offline',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(10),
                        fontWeight: FontWeight.w600,
                        color: isOk
                            ? AppColors.success
                            : const Color(0xFF1D1D1D).withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (reads.length > 3)
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.center,
                child: Text(
                  _expanded
                      ? 'Tampilkan Lebih Sedikit'
                      : 'Tampilkan Semua (${reads.length})',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LogList extends StatefulWidget {
  final List<LogModel> logs;
  const _LogList({required this.logs});

  @override
  State<_LogList> createState() => _LogListState();
}

class _LogListState extends State<_LogList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final logs = widget.logs;
    final displayCount = _expanded
        ? logs.length
        : (logs.length > 3 ? 3 : logs.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: displayCount,
            separatorBuilder: (_, __) => Divider(
              height: 12,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.07),
            ),
            itemBuilder: (context, i) {
              final log = logs[i];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
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
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (log.logRxDate != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            DateFormat(
                              'dd MMM yyyy, HH:mm:ss',
                            ).format(log.logRxDate!),
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(9),
                              color: const Color(
                                0xFF1D1D1D,
                              ).withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          if (logs.length > 3)
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.center,
                child: Text(
                  _expanded ? 'Tutup Log' : 'Lihat Semua Log (${logs.length})',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
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
              iconPath ?? 'assets/icons/sensor-icon.svg',
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: context.rh(0.008)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
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
