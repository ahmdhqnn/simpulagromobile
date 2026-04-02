import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/monitoring_models.dart';

/// Reusable sensor chart widget with multiple chart types
class SensorChartWidget extends StatefulWidget {
  final List<SensorReadModel> data;
  final String title;
  final ChartType chartType;
  final Color? color;
  final bool showLegend;
  final bool showGrid;

  const SensorChartWidget({
    super.key,
    required this.data,
    required this.title,
    this.chartType = ChartType.line,
    this.color,
    this.showLegend = true,
    this.showGrid = true,
  });

  @override
  State<SensorChartWidget> createState() => _SensorChartWidgetState();
}

class _SensorChartWidgetState extends State<SensorChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.015)),
          SizedBox(
            height: 200,
            child: widget.data.isEmpty ? _buildEmptyState() : _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart_outlined,
            size: 48,
            color: AppColors.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada data',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    switch (widget.chartType) {
      case ChartType.line:
        return _buildLineChart();
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.area:
        return _buildAreaChart();
    }
  }

  Widget _buildLineChart() {
    final spots = widget.data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.numericValue);
    }).toList();

    final color = widget.color ?? AppColors.primary;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: widget.showGrid,
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
                  fontSize: context.sp(10),
                  color: AppColors.textTertiary,
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
              interval: (spots.length / 5).ceilToDouble().clamp(
                1,
                double.infinity,
              ),
              getTitlesWidget: (v, _) {
                final idx = v.toInt();
                if (idx < 0 || idx >= widget.data.length) {
                  return const SizedBox.shrink();
                }
                final d = widget.data[idx].readDate;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    d != null ? DateFormat('HH:mm').format(d) : '',
                    style: TextStyle(
                      fontSize: context.sp(9),
                      color: AppColors.textTertiary,
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
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.white,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final idx = spot.x.toInt();
                final data = widget.data[idx];
                return LineTooltipItem(
                  '${data.numericValue.toStringAsFixed(1)}\n',
                  TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(12),
                  ),
                  children: [
                    TextSpan(
                      text: data.readDate != null
                          ? DateFormat('HH:mm').format(data.readDate!)
                          : '',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: context.sp(10),
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final color = widget.color ?? AppColors.primary;

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: widget.showGrid,
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
                  fontSize: context.sp(10),
                  color: AppColors.textTertiary,
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
                if (idx < 0 || idx >= widget.data.length) {
                  return const SizedBox.shrink();
                }
                final d = widget.data[idx].readDate;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    d != null ? DateFormat('HH:mm').format(d) : '',
                    style: TextStyle(
                      fontSize: context.sp(9),
                      color: AppColors.textTertiary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: widget.data.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.numericValue,
                color: color,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAreaChart() {
    final spots = widget.data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.numericValue);
    }).toList();

    final color = widget.color ?? AppColors.primary;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: widget.showGrid,
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
                  fontSize: context.sp(10),
                  color: AppColors.textTertiary,
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
              interval: (spots.length / 5).ceilToDouble().clamp(
                1,
                double.infinity,
              ),
              getTitlesWidget: (v, _) {
                final idx = v.toInt();
                if (idx < 0 || idx >= widget.data.length) {
                  return const SizedBox.shrink();
                }
                final d = widget.data[idx].readDate;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    d != null ? DateFormat('HH:mm').format(d) : '',
                    style: TextStyle(
                      fontSize: context.sp(9),
                      color: AppColors.textTertiary,
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
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.2),
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
      ),
    );
  }
}

enum ChartType { line, bar, area }
