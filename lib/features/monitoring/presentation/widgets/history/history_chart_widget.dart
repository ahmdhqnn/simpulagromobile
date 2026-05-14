import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../data/models/monitoring_models.dart';

class HistoryChartWidget extends StatelessWidget {
  final List<SensorReadModel> reads;
  final String param;

  const HistoryChartWidget({
    super.key,
    required this.reads,
    required this.param,
  });

  Color get _color => SensorMeta.color(param);

  @override
  Widget build(BuildContext context) {
    if (reads.isEmpty) {
      return const InfoStateWidget.icon(
        icon: Icons.show_chart_rounded,
        message: 'Belum ada data riwayat',
        height: 195,
      );
    }

    final spots = reads
        .asMap()
        .entries
        .where((e) => e.value.numericValue > 0)
        .map((e) => FlSpot(e.key.toDouble(), e.value.numericValue))
        .toList();

    if (spots.isEmpty) {
      return const InfoStateWidget.icon(
        icon: Icons.show_chart_rounded,
        message: 'Data sensor tidak valid',
        height: 195,
      );
    }

    final values = reads
        .map((r) => r.numericValue)
        .where((v) => v > 0)
        .toList();
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final avgVal = values.reduce((a, b) => a + b) / values.length;
    final unit = SensorMeta.unit(param);

    return AppCardWidget.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 14),
          _buildStatsBar(context, minVal, avgVal, maxVal, unit),
          const SizedBox(height: 14),
          _buildChart(context, spots, unit),
          const SizedBox(height: 10),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(Icons.show_chart_rounded, color: _color, size: 22),
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SensorMeta.label(param),
                style: AppTextStyles.cardTitle(context),
              ),
              const SizedBox(height: 3),
              Text(
                '${reads.length} data · riwayat sensor',
                style: AppTextStyles.caption(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBar(
    BuildContext context,
    double min,
    double avg,
    double max,
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
            color: AppColors.primaryLight,
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

  Widget _buildChart(BuildContext context, List<FlSpot> spots, String unit) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: const Color(0xFFEEEEEE), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(9),
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
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
                reservedSize: 30,
                interval: (spots.length / 5).ceilToDouble().clamp(
                  1,
                  double.infinity,
                ),
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= reads.length) {
                    return const SizedBox.shrink();
                  }
                  final d = reads[idx].readDate;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      d != null ? DateFormat('d/M').format(d) : '',
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
              curveSmoothness: 0.35,
              color: _color,
              barWidth: 3,
              dotData: FlDotData(
                show: spots.length <= 20,
                getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                  radius: 3.5,
                  color: _color,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    _color.withValues(alpha: 0.25),
                    _color.withValues(alpha: 0.03),
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
              tooltipBorder: BorderSide(color: _color.withValues(alpha: 0.3)),
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      '${s.y.toStringAsFixed(1)}$unit',
                      TextStyle(
                        color: _color,
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

  Widget _buildLegend(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          SensorMeta.label(param),
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
