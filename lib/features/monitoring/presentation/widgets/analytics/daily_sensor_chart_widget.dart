import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/locale_formatters.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../data/models/monitoring_models.dart';
import '../../utils/monitoring_display_utils.dart';
import '../../utils/sensor_metadata_adapter.dart';
import '../monitoring_card_header_widget.dart';

class DailySensorChartWidget extends StatefulWidget {
  final List<SensorDailyModel> data;
  final SensorMetadataAdapter metadataAdapter;

  const DailySensorChartWidget({
    super.key,
    required this.data,
    required this.metadataAdapter,
  });

  @override
  State<DailySensorChartWidget> createState() => _DailySensorChartWidgetState();
}

class _DailySensorChartWidgetState extends State<DailySensorChartWidget> {
  String _selected = 'env_temp';

  List<String> get _params =>
      widget.data.map((item) => item.dsId).toSet().toList()..sort();

  @override
  void initState() {
    super.initState();
    final params = _params;
    if (params.isNotEmpty && !params.contains(_selected)) {
      _selected = params.first;
    }
  }

  @override
  void didUpdateWidget(covariant DailySensorChartWidget oldWidget) {
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
      return _buildEmptyState(context);
    }

    final filtered =
        widget.data.where((item) => item.dsId == _selected).toList()..sort(
          (a, b) => (a.day ?? DateTime(0)).compareTo(b.day ?? DateTime(0)),
        );
    final validRows = filtered
        .where(
          (item) =>
              item.avgVal != null || item.minVal != null || item.maxVal != null,
        )
        .toList();
    final chartRows = sampleForChart(validRows, maxPoints: 90);
    final unit = widget.metadataAdapter.unitFor(_selected);

    final avgSpots = chartRows
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(
            entry.key.toDouble(),
            widget.metadataAdapter.displayValueFor(
              _selected,
              entry.value.avgVal ??
                  entry.value.minVal ??
                  entry.value.maxVal ??
                  0,
            ),
          ),
        )
        .toList();
    final minSpots = chartRows
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(
            entry.key.toDouble(),
            widget.metadataAdapter.displayValueFor(
              _selected,
              entry.value.minVal ?? entry.value.avgVal ?? 0,
            ),
          ),
        )
        .toList();
    final maxSpots = chartRows
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(
            entry.key.toDouble(),
            widget.metadataAdapter.displayValueFor(
              _selected,
              entry.value.maxVal ?? entry.value.avgVal ?? 0,
            ),
          ),
        )
        .toList();

    return AppCardWidget.elevated(
      boxShadow: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildParamSelector(context),
          SizedBox(height: context.rh(0.02)),
          if (filtered.isEmpty || chartRows.isEmpty)
            Center(
              child: Text(
                l10n.monitoringDailyEmpty,
                style: const TextStyle(color: AppColors.textTertiary),
              ),
            )
          else
            _buildChart(context, chartRows, avgSpots, minSpots, maxSpots, unit),
          SizedBox(height: context.rh(0.015)),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          SizedBox(
            height: 218,
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
                    l10n.monitoringDailyUnavailableToday,
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
    final l10n = AppLocalizations.of(context)!;
    return MonitoringCardHeaderWidget.icon(
      icon: Icons.show_chart_rounded,
      title: l10n.monitoringDailyAnalyticsTitle,
      description: l10n.monitoringDailyAnalyticsSubtitle,
      background: AppColors.softOrange,
      tint: AppColors.warning,
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
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                widget.metadataAdapter.shortLabelFor(param),
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(11),
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

  Widget _buildChart(
    BuildContext context,
    List<SensorDailyModel> filtered,
    List<FlSpot> avgSpots,
    List<FlSpot> minSpots,
    List<FlSpot> maxSpots,
    String unit,
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
                getTitlesWidget: (value, _) => Text(
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
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= filtered.length) {
                    return const SizedBox.shrink();
                  }
                  final date = filtered[index].day;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      date != null
                          ? context.dateFormat('d/M').format(date)
                          : '',
                      style: TextStyle(
                        fontSize: context.sp(10),
                        color: AppColors.textSecondary,
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
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map(
                    (spot) => LineTooltipItem(
                      '${spot.y.toStringAsFixed(1)}$unit',
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
        show: spots.length <= 28,
        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
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

  Widget _buildLegend(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendItem(AppColors.success, l10n.commonAverage),
        _legendItem(AppColors.info, l10n.commonMin),
        _legendItem(AppColors.warning, l10n.commonMax),
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
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
