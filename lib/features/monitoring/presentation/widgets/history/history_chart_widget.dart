import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/locale_formatters.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../data/models/monitoring_models.dart';
import '../../utils/monitoring_display_utils.dart';
import '../../utils/sensor_metadata_adapter.dart';

class HistoryChartWidget extends StatelessWidget {
  final List<SensorReadModel> reads;
  final String param;
  final SensorMetadataAdapter metadataAdapter;

  const HistoryChartWidget({
    super.key,
    required this.reads,
    required this.param,
    required this.metadataAdapter,
  });

  Color get _color => metadataAdapter.colorFor(param);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (reads.isEmpty) {
      return InfoStateWidget.icon(
        icon: Icons.show_chart_rounded,
        message: l10n.monitoringEmptyHistory,
        height: 195,
      );
    }

    final chartReads = sampleForChart(reads, maxPoints: 160);
    final spots = chartReads
        .asMap()
        .entries
        .where((entry) => entry.value.hasNumericValue)
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.numericValue))
        .toList();

    if (spots.isEmpty) {
      return InfoStateWidget.icon(
        icon: Icons.show_chart_rounded,
        message: l10n.monitoringInvalidSensorData,
        height: 195,
      );
    }

    final values = reads.map((read) => read.parsedValue).whereType<double>();
    final valuesList = values.toList();
    final minVal = valuesList.reduce((a, b) => a < b ? a : b);
    final maxVal = valuesList.reduce((a, b) => a > b ? a : b);
    final avgVal = valuesList.reduce((a, b) => a + b) / valuesList.length;
    final unit = metadataAdapter.unitFor(param);

    return AppCardWidget.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 14),
          _buildStatsBar(context, minVal, avgVal, maxVal, unit),
          const SizedBox(height: 14),
          _buildChart(context, spots, chartReads, unit),
          const SizedBox(height: 10),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                metadataAdapter.labelFor(param),
                style: AppTextStyles.cardTitle(context),
              ),
              const SizedBox(height: 3),
              Text(
                l10n.monitoringHistoryCardSubtitle(reads.length),
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
    final l10n = AppLocalizations.of(context)!;
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
            label: l10n.commonMin,
            value: '${min.toStringAsFixed(1)}$unit',
            color: AppColors.info,
          ),
          Container(width: 1, height: 28, color: AppColors.divider),
          _StatColumn(
            label: l10n.commonAverage,
            value: '${avg.toStringAsFixed(1)}$unit',
            color: AppColors.primaryLight,
          ),
          Container(width: 1, height: 28, color: AppColors.divider),
          _StatColumn(
            label: l10n.commonMax,
            value: '${max.toStringAsFixed(1)}$unit',
            color: AppColors.temperature,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<FlSpot> spots,
    List<SensorReadModel> chartReads,
    String unit,
  ) {
    return SizedBox(
      height: 220,
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
                reservedSize: 42,
                getTitlesWidget: (value, _) => Text(
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
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= chartReads.length) {
                    return const SizedBox.shrink();
                  }
                  final date = chartReads[index].readDate;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      date != null
                          ? context.dateFormat('d/M').format(date)
                          : '',
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
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
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
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map(
                    (spot) => LineTooltipItem(
                      '${spot.y.toStringAsFixed(1)}$unit',
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
          metadataAdapter.labelFor(param),
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
