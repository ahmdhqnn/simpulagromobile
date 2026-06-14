import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/agro_entity.dart';
import '../../../../l10n/app_localizations.dart';

class EtcWidget extends StatelessWidget {
  final List<EtcDailyEntity> etcData;

  const EtcWidget({super.key, required this.etcData});

  @override
  Widget build(BuildContext context) {
    if (etcData.isEmpty) {
      return _buildEmptyState(context);
    }

    final recentData = _recentEtcData(limit: 7);
    final latestData = recentData.first;
    final weekData = recentData.reversed.toList();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.opacity,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ETC',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      l10n.agroWaterRequirement,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1.83,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildLatestEtc(context, latestData),
          const SizedBox(height: 20),
          _buildEtcChart(context, weekData),
          const SizedBox(height: 16),
          _buildWaterNeedsInfo(context, latestData),
          const SizedBox(height: 16),
          _buildEtcTable(context, weekData),
        ],
      ),
    );
  }

  Widget _buildLatestEtc(BuildContext context, EtcDailyEntity data) {
    final l10n = AppLocalizations.of(context)!;
    final metrics = <_EtcMetricData>[
      _EtcMetricData(
        label: 'ETC',
        value: data.etc?.toStringAsFixed(2) ?? '-',
        unit: l10n.agroUnitMmPerDay,
        color: AppColors.primary,
        icon: Icons.water_drop,
      ),
      if (data.kc != null)
        _EtcMetricData(
          label: 'Kc',
          value: data.kc!.toStringAsFixed(2),
          unit: l10n.agroUnitCoefficient,
          color: AppColors.accent,
          icon: Icons.eco,
        ),
      if (data.et0 != null)
        _EtcMetricData(
          label: 'ET0',
          value: data.et0!.toStringAsFixed(2),
          unit: l10n.agroUnitMmPerDay,
          color: AppColors.warning,
          icon: Icons.wb_sunny_outlined,
        ),
      if (data.waterNeeds != null)
        _EtcMetricData(
          label: l10n.agroWaterNeedsLabel,
          value: data.waterNeeds!.toStringAsFixed(1),
          unit: l10n.etcLitrePerSqmUnit,
          color: AppColors.info,
          icon: Icons.local_drink,
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = metrics.length == 1
            ? 1
            : metrics.length.clamp(2, 3).toInt();
        final width = (constraints.maxWidth - ((columns - 1) * 12)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width: width,
                    child: _buildMetricCard(
                      context,
                      metric.label,
                      metric.value,
                      metric.unit,
                      metric.color,
                      metric.icon,
                    ),
                  ),
              ],
            ),
            if (data.phase != null ||
                data.hst != null ||
                data.riceType != null ||
                data.daysToHarvest != null ||
                data.isCriticalPhase == true) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (data.phase != null)
                    _buildContextChip(Icons.eco_outlined, data.phase!),
                  if (data.hst != null)
                    _buildContextChip(
                      Icons.calendar_today_outlined,
                      '${data.hst} HST',
                    ),
                  if (data.riceType != null)
                    _buildContextChip(Icons.grass_outlined, data.riceType!),
                  if (data.daysToHarvest != null)
                    _buildContextChip(
                      Icons.hourglass_empty_outlined,
                      '${data.daysToHarvest} hari lagi panen',
                    ),
                  if (data.isCriticalPhase == true)
                    _buildContextChip(
                      Icons.warning_amber_rounded,
                      'Fase Kritis',
                      backgroundColor: Colors.red.shade50,
                      textColor: Colors.red.shade700,
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildContextChip(
    IconData icon,
    String label, {
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor ?? AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    String unit,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(10),
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(11),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D1D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtcChart(BuildContext context, List<EtcDailyEntity> weekData) {
    if (weekData.isEmpty) return const SizedBox.shrink();
    final hasWaterNeeds = weekData.any((data) => data.waterNeeds != null);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.agroEtcTrend7Days,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(14),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1D1D),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: AppColors.divider, strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= weekData.length) {
                        return const Text('');
                      }
                      final day = weekData[value.toInt()].day ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          day.split('-').last,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(10),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(10),
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    weekData.length,
                    (index) =>
                        FlSpot(index.toDouble(), weekData[index].etc ?? 0),
                  ),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                if (hasWaterNeeds)
                  LineChartBarData(
                    spots: List.generate(
                      weekData.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        weekData[index].waterNeeds ?? 0,
                      ),
                    ),
                    isCurved: true,
                    color: AppColors.info,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dashArray: [5, 5],
                    dotData: const FlDotData(show: false),
                  ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final day = weekData[spot.x.toInt()].day ?? '';
                      final label = spot.barIndex == 0
                          ? 'ETC'
                          : l10n.agroWaterNeedsLabel;
                      return LineTooltipItem(
                        '$label\n$day\n${spot.y.toStringAsFixed(2)}',
                        TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.white,
                          fontSize: context.sp(12),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(context, 'ETC', AppColors.primary, false),
            if (hasWaterNeeds) ...[
              const SizedBox(width: 16),
              _buildLegendItem(
                context,
                l10n.agroWaterNeedsLabel,
                AppColors.info,
                true,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    Color color,
    bool dashed,
  ) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: dashed
              ? CustomPaint(painter: DashedLinePainter(color: color))
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(11),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterNeedsInfo(BuildContext context, EtcDailyEntity data) {
    if (data.recommendation == null &&
        data.waterNeeds == null &&
        data.etc == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final waterNeeds = data.waterNeeds;
    final etc = data.etc;
    String recommendation;
    Color color;
    IconData icon;
    String title;

    if (data.recommendation != null) {
      title = data.waterStatus?.trim().isNotEmpty == true
          ? data.waterStatus!
          : l10n.agroWateringRecommendation;
      recommendation = data.recommendation!;
      if (data.waterNeededLiter != null) {
        final literStr = data.waterNeededLiter.toString();
        final formatted = literStr.length > 3 
            ? '${literStr.substring(0, literStr.length - 3)}.${literStr.substring(literStr.length - 3)}' 
            : literStr;
        recommendation += '\nTotal Kebutuhan: $formatted Liter';
      }
      final normalized = (data.waterStatus ?? '').toLowerCase();
      if (normalized.contains('sangat')) {
        color = AppColors.error;
        icon = Icons.error_outline;
      } else if (normalized.contains('tinggi')) {
        color = AppColors.warning;
        icon = Icons.warning_amber_outlined;
      } else if (normalized.contains('normal')) {
        color = AppColors.info;
        icon = Icons.info_outline;
      } else {
        color = AppColors.success;
        icon = Icons.check_circle_outline;
      }
    } else if (waterNeeds != null) {
      title = l10n.agroWateringRecommendation;
      if (waterNeeds < 3) {
        recommendation = l10n.agroRecWaterNeedsLow;
        color = AppColors.success;
        icon = Icons.check_circle_outline;
      } else if (waterNeeds < 6) {
        recommendation = l10n.agroRecWaterNeedsMedium;
        color = AppColors.info;
        icon = Icons.info_outline;
      } else if (waterNeeds < 10) {
        recommendation = l10n.agroRecWaterNeedsHigh;
        color = AppColors.warning;
        icon = Icons.warning_amber_outlined;
      } else {
        recommendation = l10n.agroRecWaterNeedsVeryHigh;
        color = AppColors.error;
        icon = Icons.error_outline;
      }
    } else {
      title = l10n.agroStatusEtc;
      if (etc! < 3) {
        recommendation = l10n.agroRecEtcLow;
        color = AppColors.success;
        icon = Icons.check_circle_outline;
      } else if (etc <= 6) {
        recommendation = l10n.agroRecEtcMedium;
        color = AppColors.info;
        icon = Icons.info_outline;
      } else {
        recommendation = l10n.agroRecEtcHigh;
        color = AppColors.warning;
        icon = Icons.warning_amber_outlined;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtcTable(BuildContext context, List<EtcDailyEntity> weekData) {
    if (weekData.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.agroDailyClimateDetail,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(14),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1D1D),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        l10n.agroTableDate,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        l10n.agroTableTemp,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        l10n.agroTableRh,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...weekData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: index < weekData.length - 1
                        ? const Border(
                            bottom: BorderSide(color: AppColors.divider),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          data.day ?? '-',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            color: const Color(0xFF1D1D1D),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatRange(data.tempMin, data.tempMax, 'C'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            color: const Color(0xFF1D1D1D),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatRange(data.rhMin, data.rhMax, '%'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            color: const Color(0xFF1D1D1D),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.opacity_outlined,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.agroEtcDataUnavailable,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatRange(double? min, double? max, String unit) {
    final minText = _formatValue(min, 1, unit);
    final maxText = _formatValue(max, 1, unit);
    if (min == null && max == null) return '-';
    if (min == null) return maxText;
    if (max == null) return minText;
    return '$minText - $maxText';
  }

  String _formatValue(double? value, int fractionDigits, String unit) {
    if (value == null) return '-';
    final number = value.toStringAsFixed(fractionDigits);
    if (unit == '%') return '$number%';
    return '$number $unit';
  }

  List<EtcDailyEntity> _recentEtcData({required int limit}) {
    final sorted = List<EtcDailyEntity>.from(etcData)
      ..sort((left, right) {
        final leftDate = DateTime.tryParse(left.day ?? '');
        final rightDate = DateTime.tryParse(right.day ?? '');
        if (leftDate == null && rightDate == null) return 0;
        if (leftDate == null) return 1;
        if (rightDate == null) return -1;
        return rightDate.compareTo(leftDate);
      });
    return sorted.take(limit).toList();
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EtcMetricData {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  const _EtcMetricData({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });
}
