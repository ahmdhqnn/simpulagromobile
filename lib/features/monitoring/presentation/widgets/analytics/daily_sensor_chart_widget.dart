import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/icon_badge_widget.dart';
import '../../../data/models/monitoring_models.dart';

class DailySensorChartWidget extends StatefulWidget {
  final List<SensorDailyModel> data;
  const DailySensorChartWidget({super.key, required this.data});

  @override
  State<DailySensorChartWidget> createState() => _DailySensorChartWidgetState();
}

class _DailySensorChartWidgetState extends State<DailySensorChartWidget> {
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
    if (widget.data.isEmpty) {
      return _buildEmptyState(context);
    }

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

    return AppCardWidget.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildParamSelector(context),
          SizedBox(height: context.rh(0.02)),
          if (filtered.isEmpty)
            const Center(
              child: Text(
                'Belum ada data harian',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            )
          else
            _buildChart(context, filtered, avgSpots, minSpots, maxSpots),
          SizedBox(height: context.rh(0.015)),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          Container(
            height: 218,
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/sensor-icon.svg',
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      AppColors.textPrimary.withValues(alpha: 0.3),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: context.rh(0.005)),
                  Text(
                    'Tidak ada data sensor yang tersedia untuk hari ini',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.hint(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const IconBadgeWidget.icon(
          icon: Icons.show_chart,
          background: Color(0xFFFFF3E0),
          tint: Color(0xFFFF9800),
          radius: 10,
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analisis Sensor Harian',
                style: AppTextStyles.sectionTitle(context, 20),
              ),
              const SizedBox(height: 4),
              Text(
                'Statistik Sensor Hari Ini',
                style: AppTextStyles.hint(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParamSelector(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _params.map((p) {
          final isSel = p == _selected;
          return GestureDetector(
            onTap: () => setState(() => _selected = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSel
                    ? SensorMeta.color(p)
                    : SensorMeta.color(p).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSel
                    ? [
                        BoxShadow(
                          color: SensorMeta.color(p).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                SensorMeta.shortLabel(p),
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(11),
                  fontWeight: FontWeight.w600,
                  color: isSel ? Colors.white : SensorMeta.color(p),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<SensorDailyModel> filtered,
    List<FlSpot> avgSpots,
    List<FlSpot> minSpots,
    List<FlSpot> maxSpots,
  ) {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: AppColors.divider, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(10),
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
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
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      d != null ? DateFormat('d/M').format(d) : '',
                      style: TextStyle(
                        fontSize: context.sp(10),
                        color: const Color(0xFF757575),
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            _bar(avgSpots, AppColors.success),
            _bar(minSpots, AppColors.info),
            _bar(maxSpots, AppColors.warning),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.white,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              tooltipBorder: const BorderSide(
                color: AppColors.divider,
                width: 1,
              ),
              getTooltipItems: (spots) => spots
                  .map(
                    (spot) => LineTooltipItem(
                      spot.y.toStringAsFixed(1),
                      const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          minY: 0,
        ),
      ),
    );
  }

  LineChartBarData _bar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendItem(AppColors.success, 'Rata-rata'),
        _legendItem(AppColors.info, 'Min'),
        _legendItem(AppColors.warning, 'Max'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
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
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
