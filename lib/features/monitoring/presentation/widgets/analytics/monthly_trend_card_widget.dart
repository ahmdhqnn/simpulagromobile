import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../data/models/monitoring_models.dart';
import '../../utils/monitoring_display_utils.dart';
import '../../utils/sensor_metadata_adapter.dart';

class MonthlyTrendCardWidget extends StatefulWidget {
  final List<MonthlyRekapModel> data;
  final SensorMetadataAdapter metadataAdapter;

  const MonthlyTrendCardWidget({
    super.key,
    required this.data,
    required this.metadataAdapter,
  });

  @override
  State<MonthlyTrendCardWidget> createState() => _MonthlyTrendCardWidgetState();
}

class _MonthlyTrendCardWidgetState extends State<MonthlyTrendCardWidget> {
  String _selected = 'env_temp';

  List<String> get _params =>
      widget.data
          .map((item) => item.dsId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  @override
  void initState() {
    super.initState();
    final params = _params;
    if (params.isNotEmpty && !params.contains(_selected)) {
      _selected = params.first;
    }
  }

  @override
  void didUpdateWidget(covariant MonthlyTrendCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final params = _params;
    if (params.isNotEmpty && !params.contains(_selected)) {
      _selected = params.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.data.isEmpty) {
      return AppCardWidget(
        height: 120,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart_rounded,
                size: 28,
                color: AppColors.textPrimary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.monitoringMonthlyCardEmpty,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textPrimary.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filtered =
        widget.data.where((item) => item.dsId == _selected).toList()
          ..sort((a, b) => a.month.compareTo(b.month));
    final validRows = filtered
        .where(
          (item) =>
              item.avgVal != null || item.minVal != null || item.maxVal != null,
        )
        .toList();
    final chartRows = sampleForChart(validRows, maxPoints: 36);
    final color = widget.metadataAdapter.colorFor(_selected);
    final unit = widget.metadataAdapter.unitFor(_selected);

    final barGroups = chartRows.asMap().entries.map((entry) {
      final avg = entry.value.avgVal ?? 0;
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: avg,
            color: color,
            width: 14,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: (entry.value.maxVal ?? avg) * 1.2,
              color: color.withValues(alpha: 0.08),
            ),
          ),
        ],
      );
    }).toList();

    return AppCardWidget.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, color),
          const SizedBox(height: 12),
          _buildParamSelector(context),
          if (filtered.isEmpty)
            Center(
              child: Text(
                l10n.monitoringMonthlyCardNoSensorData,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textTertiary,
                ),
              ),
            )
          else if (chartRows.isEmpty)
            Center(
              child: Text(
                l10n.monitoringMonthlyCardNoSensorData,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textTertiary,
                ),
              ),
            )
          else
            _buildBarChart(context, chartRows, barGroups, color, unit),
          const SizedBox(height: 8),
          _buildLegend(context, color),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color color) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(Icons.bar_chart_rounded, color: color, size: 22),
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.monitoringMonthlyCardTitle,
                style: AppTextStyles.cardTitle(context),
              ),
              Text(
                l10n.monitoringMonthlyCardSubtitle,
                style: AppTextStyles.caption(context),
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
        children: _params.map((param) {
          final isSelected = param == _selected;
          final color = widget.metadataAdapter.colorFor(param);
          return GestureDetector(
            onTap: () => setState(() => _selected = param),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                widget.metadataAdapter.shortLabelFor(param),
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(10),
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    List<MonthlyRekapModel> filtered,
    List<BarChartGroupData> barGroups,
    Color color,
    String unit,
  ) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
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
                reservedSize: 28,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= filtered.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      filtered[index].month.length >= 7
                          ? filtered[index].month.substring(5, 7)
                          : filtered[index].month,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(9),
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.white,
              tooltipRoundedRadius: 10,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              tooltipBorder: BorderSide(color: color.withValues(alpha: 0.3)),
              getTooltipItem: (_, __, rod, ___) => BarTooltipItem(
                '${rod.toY.toStringAsFixed(1)}$unit',
                TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, Color color) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          l10n.monitoringMonthlyLegendAverage(
            widget.metadataAdapter.labelFor(_selected),
          ),
          style: AppTextStyles.caption(context, size: 10),
        ),
      ],
    );
  }
}
