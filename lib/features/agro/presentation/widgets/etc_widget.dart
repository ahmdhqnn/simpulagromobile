import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/agro_entity.dart';

class EtcWidget extends StatelessWidget {
  final List<EtcDailyEntity> etcData;

  const EtcWidget({super.key, required this.etcData});

  @override
  Widget build(BuildContext context) {
    if (etcData.isEmpty) {
      return _buildEmptyState(context);
    }

    final latestData = etcData.first;
    final weekData = etcData.take(7).toList();

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
                      'Kebutuhan Air Tanaman',
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
    final metrics = <_EtcMetricData>[
      _EtcMetricData(
        label: 'ETC',
        value: data.etc?.toStringAsFixed(2) ?? '-',
        unit: 'mm/hari',
        color: AppColors.primary,
        icon: Icons.water_drop,
      ),
      if (data.kc != null)
        _EtcMetricData(
          label: 'Kc',
          value: data.kc!.toStringAsFixed(2),
          unit: 'koefisien',
          color: AppColors.accent,
          icon: Icons.eco,
        ),
      if (data.waterNeeds != null)
        _EtcMetricData(
          label: 'Kebutuhan',
          value: data.waterNeeds!.toStringAsFixed(1),
          unit: 'L/m2',
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

        return Wrap(
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
        );
      },
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trend ETC (7 Hari)',
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
                      final label = spot.barIndex == 0 ? 'ETC' : 'Kebutuhan';
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
              _buildLegendItem(context, 'Kebutuhan Air', AppColors.info, true),
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
    if (data.waterNeeds == null && data.etc == null) {
      return const SizedBox.shrink();
    }

    final waterNeeds = data.waterNeeds;
    final etc = data.etc;
    String recommendation;
    Color color;
    IconData icon;
    String title;

    if (waterNeeds != null) {
      title = 'Rekomendasi Penyiraman';
      if (waterNeeds < 3) {
        recommendation =
            'Kebutuhan air rendah. Penyiraman minimal atau tidak diperlukan.';
        color = AppColors.success;
        icon = Icons.check_circle_outline;
      } else if (waterNeeds < 6) {
        recommendation =
            'Kebutuhan air sedang. Lakukan penyiraman rutin sesuai jadwal.';
        color = AppColors.info;
        icon = Icons.info_outline;
      } else if (waterNeeds < 10) {
        recommendation =
            'Kebutuhan air tinggi. Tingkatkan frekuensi penyiraman.';
        color = AppColors.warning;
        icon = Icons.warning_amber_outlined;
      } else {
        recommendation =
            'Kebutuhan air sangat tinggi! Penyiraman intensif diperlukan.';
        color = AppColors.error;
        icon = Icons.error_outline;
      }
    } else {
      title = 'Status ETC';
      if (etc! < 3) {
        recommendation =
            'ETC rendah. Kebutuhan evapotranspirasi tanaman sedang ringan.';
        color = AppColors.success;
        icon = Icons.check_circle_outline;
      } else if (etc <= 6) {
        recommendation =
            'ETC berada pada rentang sedang. Pantau kelembaban dan jadwal irigasi.';
        color = AppColors.info;
        icon = Icons.info_outline;
      } else {
        recommendation =
            'ETC tinggi. Periksa kelembaban tanah dan kesiapan irigasi.';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Iklim Harian',
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
                        'Tanggal',
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
                        'Temp (Min-Max)',
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
                        'RH (Min-Max)',
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
              'Data ETC tidak tersedia',
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
