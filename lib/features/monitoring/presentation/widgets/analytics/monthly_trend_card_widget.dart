import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../data/models/monitoring_models.dart';

class MonthlyTrendCardWidget extends StatefulWidget {
  final List<MonthlyRekapModel> data;
  const MonthlyTrendCardWidget({super.key, required this.data});

  @override
  State<MonthlyTrendCardWidget> createState() => _MonthlyTrendCardWidgetState();
}

class _MonthlyTrendCardWidgetState extends State<MonthlyTrendCardWidget> {
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
                'Belum ada data rekap bulanan',
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

    final filtered = widget.data.where((d) => d.dsId == _selected).toList();
    final color = SensorMeta.color(_selected);
    final unit = SensorMeta.unit(_selected);

    final barGroups = filtered.asMap().entries.map((e) {
      final avg = e.value.avgVal ?? 0;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: avg,
            color: color,
            width: 14,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: (e.value.maxVal ?? avg) * 1.2,
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
                'Tidak ada data untuk sensor ini',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textTertiary,
                ),
              ),
            )
          else
            _buildBarChart(context, filtered, barGroups, color, unit),
          const SizedBox(height: 8),
          _buildLegend(context, color),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color color) {
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
              Text('Rekap Bulanan', style: AppTextStyles.cardTitle(context)),
              Text(
                'Rata-rata per bulan',
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
        children: _params.map((p) {
          final isSel = p == _selected;
          final c = SensorMeta.color(p);
          return GestureDetector(
            onTap: () => setState(() => _selected = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSel ? c : c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSel
                    ? [
                        BoxShadow(
                          color: c.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                SensorMeta.shortLabel(p),
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(10),
                  fontWeight: FontWeight.w600,
                  color: isSel ? Colors.white : c,
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
                FlLine(color: const Color(0xFFEEEEEE), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (v, _) => Text(
                  v.toStringAsFixed(0),
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
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= filtered.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      filtered[idx].month.length >= 7
                          ? filtered[idx].month.substring(5, 7)
                          : filtered[idx].month,
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
              getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                  BarTooltipItem(
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
          'Rata-rata ${SensorMeta.label(_selected)}',
          style: AppTextStyles.caption(context, size: 10),
        ),
      ],
    );
  }
}
