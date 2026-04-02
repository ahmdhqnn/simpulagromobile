import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/agro_model.dart';

class EtcWidget extends StatelessWidget {
  final List<EtcDailyModel> etcData;

  const EtcWidget({super.key, required this.etcData});

  @override
  Widget build(BuildContext context) {
    if (etcData.isEmpty) {
      return _buildEmptyState();
    }

    final latestData = etcData.first;
    final weekData = etcData.take(7).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.opacity,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ETC (Evapotranspiration)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Kebutuhan Air Tanaman',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildLatestEtc(latestData),
            const SizedBox(height: 20),
            _buildEtcChart(weekData),
            const SizedBox(height: 16),
            _buildWaterNeedsInfo(latestData),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestEtc(EtcDailyModel data) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'ETC',
            data.etc?.toStringAsFixed(2) ?? '-',
            'mm/hari',
            AppColors.primary,
            Icons.water_drop,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Kc',
            data.kc?.toStringAsFixed(2) ?? '-',
            'koefisien',
            AppColors.accent,
            Icons.eco,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Kebutuhan',
            data.waterNeeds?.toStringAsFixed(1) ?? '-',
            'L/m²',
            AppColors.info,
            Icons.local_drink,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
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
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildEtcChart(List<EtcDailyModel> weekData) {
    if (weekData.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trend ETC (7 Hari)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                          style: const TextStyle(
                            fontSize: 10,
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
                        style: const TextStyle(
                          fontSize: 10,
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
                        const TextStyle(color: Colors.white, fontSize: 12),
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
            _buildLegendItem('ETC', AppColors.primary, false),
            const SizedBox(width: 16),
            _buildLegendItem('Kebutuhan Air', AppColors.info, true),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, bool dashed) {
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
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildWaterNeedsInfo(EtcDailyModel data) {
    final waterNeeds = data.waterNeeds ?? 0;
    String recommendation;
    Color color;
    IconData icon;

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
      recommendation = 'Kebutuhan air tinggi. Tingkatkan frekuensi penyiraman.';
      color = AppColors.warning;
      icon = Icons.warning_amber_outlined;
    } else {
      recommendation =
          'Kebutuhan air sangat tinggi! Penyiraman intensif diperlukan.';
      color = AppColors.error;
      icon = Icons.error_outline;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
                  'Rekomendasi Penyiraman',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation,
                  style: const TextStyle(
                    fontSize: 12,
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

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.opacity_outlined,
                size: 48,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'Data ETC tidak tersedia',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
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
