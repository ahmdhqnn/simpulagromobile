import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../data/models/monitoring_models.dart';
import '../utils/monitoring_display_utils.dart';
import '../utils/sensor_metadata_adapter.dart';
import 'monitoring_card_header_widget.dart';

/// Reusable sensor chart widget with multiple chart types
class SensorChartWidget extends StatefulWidget {
  final List<SensorReadModel> data;
  final String title;
  final ChartType chartType;
  final Color? color;
  final bool showLegend;
  final bool showGrid;
  final String? sensorId;
  final SensorMetadataAdapter? metadataAdapter;

  const SensorChartWidget({
    super.key,
    required this.data,
    required this.title,
    this.chartType = ChartType.line,
    this.color,
    this.showLegend = true,
    this.showGrid = true,
    this.sensorId,
    this.metadataAdapter,
  });

  @override
  State<SensorChartWidget> createState() => _SensorChartWidgetState();
}

class _SensorChartWidgetState extends State<SensorChartWidget> {
  List<SensorReadModel> get _validData {
    final rows = widget.data.where((item) => item.hasNumericValue).toList()
      ..sort(
        (a, b) =>
            (a.readDate ?? DateTime(0)).compareTo(b.readDate ?? DateTime(0)),
      );
    return rows;
  }

  String _sensorIdFor(SensorReadModel item) =>
      widget.sensorId ?? item.dsId ?? '';

  double _displayValue(SensorReadModel item) {
    return widget.metadataAdapter?.displayValueFor(
          _sensorIdFor(item),
          item.numericValue,
          devId: item.devId,
        ) ??
        item.numericValue;
  }

  String _displayUnit(SensorReadModel item) {
    return widget.metadataAdapter?.unitFor(
          _sensorIdFor(item),
          devId: item.devId,
        ) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    final maxPoints = widget.chartType == ChartType.bar ? 60 : 140;
    final data = sampleForChart(_validData, maxPoints: maxPoints);
    return AppCardWidget.elevated(
      boxShadow: null,
      padding: EdgeInsets.all(context.rw(0.041)),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonitoringCardHeaderWidget.icon(
            icon: _iconFor(widget.chartType),
            title: widget.title,
            description: _descriptionFor(context, widget.chartType),
            background: (widget.color ?? AppColors.primary).withValues(
              alpha: 0.12,
            ),
            tint: widget.color ?? AppColors.primary,
          ),
          SizedBox(height: context.rh(0.015)),
          SizedBox(
            height: 200,
            child: data.isEmpty ? _buildEmptyState() : _buildChart(data),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(ChartType type) {
    switch (type) {
      case ChartType.line:
        return Icons.show_chart_rounded;
      case ChartType.bar:
        return Icons.bar_chart_rounded;
      case ChartType.area:
        return Icons.stacked_line_chart_rounded;
    }
  }

  String _descriptionFor(BuildContext context, ChartType type) {
    switch (type) {
      case ChartType.line:
        return context.l10n.monitoringChartDescLine;
      case ChartType.bar:
        return context.l10n.monitoringChartDescBar;
      case ChartType.area:
        return context.l10n.monitoringChartDescArea;
    }
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
            context.l10n.commonNoDataYet,
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

  Widget _buildChart(List<SensorReadModel> data) {
    switch (widget.chartType) {
      case ChartType.line:
        return _buildLineChart(data);
      case ChartType.bar:
        return _buildBarChart(data);
      case ChartType.area:
        return _buildAreaChart(data);
    }
  }

  Widget _buildLineChart(List<SensorReadModel> data) {
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), _displayValue(e.value));
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
                if (idx < 0 || idx >= data.length) {
                  return const SizedBox.shrink();
                }
                final d = data[idx].readDate;
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
              show: spots.length <= 30,
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
                final item = data[idx];
                return LineTooltipItem(
                  '${_displayValue(item).toStringAsFixed(1)}${_displayUnit(item)}\n',
                  TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(12),
                  ),
                  children: [
                    TextSpan(
                      text: item.readDate != null
                          ? DateFormat('HH:mm').format(item.readDate!)
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

  Widget _buildBarChart(List<SensorReadModel> data) {
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
              interval: (data.length / 5).ceilToDouble().clamp(
                1,
                double.infinity,
              ),
              getTitlesWidget: (v, _) {
                final idx = v.toInt();
                if (idx < 0 || idx >= data.length) {
                  return const SizedBox.shrink();
                }
                final d = data[idx].readDate;
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
        barGroups: data.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: _displayValue(e.value),
                color: color,
                width: data.length > 40 ? 8 : 12,
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

  Widget _buildAreaChart(List<SensorReadModel> data) {
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), _displayValue(e.value));
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
                if (idx < 0 || idx >= data.length) {
                  return const SizedBox.shrink();
                }
                final d = data[idx].readDate;
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
