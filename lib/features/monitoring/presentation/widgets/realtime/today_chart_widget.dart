import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/icon_badge_widget.dart';
import '../../../data/models/monitoring_models.dart';

class TodayChartWidget extends StatefulWidget {
  final List<SensorReadModel> reads;
  const TodayChartWidget({super.key, required this.reads});

  @override
  State<TodayChartWidget> createState() => _TodayChartWidgetState();
}

class _TodayChartWidgetState extends State<TodayChartWidget> {
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

    final color = SensorMeta.color(_selected);
    final unit = SensorMeta.unit(_selected);
    final values = filtered
        .map((r) => r.numericValue)
        .where((v) => v > 0)
        .toList();
    final minVal = values.isNotEmpty
        ? values.reduce((a, b) => a < b ? a : b)
        : 0.0;
    final maxVal = values.isNotEmpty
        ? values.reduce((a, b) => a > b ? a : b)
        : 0.0;
    final avgVal = values.isNotEmpty
        ? values.reduce((a, b) => a + b) / values.length
        : 0.0;

    return AppCardWidget.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          if (params.length > 1) _buildParamSelector(context, params, color),
          const SizedBox(height: 12),
          _buildStatsBar(context, minVal, avgVal, maxVal, color, unit),
          const SizedBox(height: 12),
          _buildChartArea(context, spots, filtered, color, unit),
          const SizedBox(height: 10),
          _buildLegend(context, color),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const IconBadgeWidget.icon(
          icon: Icons.show_chart,
          background: Color(0xFFE3F2FD),
          tint: Color(0xFF2196F3),
          radius: 10,
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Sensor Hari Ini',
                style: AppTextStyles.sectionTitle(context, 20),
              ),
              const SizedBox(height: 4),
              Text(
                'Pemantauan harian sensor realtime',
                style: AppTextStyles.hint(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParamSelector(
    BuildContext context,
    List<String> params,
    Color activeColor,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: params.map((p) {
          final isSelected = p == _selected;
          final c = SensorMeta.color(p);
          return GestureDetector(
            onTap: () => setState(() => _selected = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? c : c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                SensorMeta.label(p),
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(11),
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : c,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsBar(
    BuildContext context,
    double min,
    double avg,
    double max,
    Color color,
    String unit,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(
            label: 'Min',
            value: '${min.toStringAsFixed(1)}$unit',
            color: AppColors.info,
          ),
          Container(width: 1, height: 28, color: AppColors.divider),
          _StatColumn(
            label: 'Rata-rata',
            value: '${avg.toStringAsFixed(1)}$unit',
            color: color,
          ),
          Container(width: 1, height: 28, color: AppColors.divider),
          _StatColumn(
            label: 'Max',
            value: '${max.toStringAsFixed(1)}$unit',
            color: AppColors.temperature,
          ),
        ],
      ),
    );
  }

  Widget _buildChartArea(
    BuildContext context,
    List<FlSpot> spots,
    List<SensorReadModel> filtered,
    Color color,
    String unit,
  ) {
    if (spots.isEmpty) {
      return SizedBox(
        height: 230,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/grafik_outline_icon.svg',
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  AppColors.textPrimary.withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Belum ada data untuk sensor ini',
                style: AppTextStyles.hint(context),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 230,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
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
                      d != null ? DateFormat('HH:mm').format(d) : '',
                      style: TextStyle(
                        fontSize: context.sp(9),
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                        fontFamily: AppTextStyles.fontFamily,
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
              tooltipRoundedRadius: 10,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              tooltipBorder: BorderSide(color: color.withValues(alpha: 0.3)),
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      '${s.y.toStringAsFixed(1)}$unit',
                      TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          SensorMeta.label(_selected),
          style: AppTextStyles.caption(context, size: 10),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(13),
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(9),
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
