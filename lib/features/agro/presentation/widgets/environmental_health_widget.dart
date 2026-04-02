import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/agro_model.dart';

class EnvironmentalHealthWidget extends StatelessWidget {
  final AgroModel? agroData;

  const EnvironmentalHealthWidget({super.key, this.agroData});

  @override
  Widget build(BuildContext context) {
    final healthScore = _calculateHealthScore();
    final healthStatus = _getHealthStatus(healthScore);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.eco, color: AppColors.success, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kesehatan Lingkungan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Environmental Health Score',
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
            const SizedBox(height: 24),
            _buildHealthScore(healthScore, healthStatus),
            const SizedBox(height: 24),
            _buildParameterScores(),
            const SizedBox(height: 16),
            _buildRecommendations(healthStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScore(double score, HealthStatus status) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            status.color.withValues(alpha: 0.1),
            status.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: status.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: status.color,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  '/100',
                  style: TextStyle(
                    fontSize: 24,
                    color: status.color.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: status.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(status.icon, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  status.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            status.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterScores() {
    final vdpScore = _calculateVdpScore();
    final gddScore = _calculateGddScore();
    final etcScore = _calculateEtcScore();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skor Parameter',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildParameterBar('VDP', vdpScore, Icons.water_drop, AppColors.info),
        const SizedBox(height: 8),
        _buildParameterBar(
          'GDD',
          gddScore,
          Icons.thermostat,
          AppColors.warning,
        ),
        const SizedBox(height: 8),
        _buildParameterBar('ETC', etcScore, Icons.opacity, AppColors.primary),
      ],
    );
  }

  Widget _buildParameterBar(
    String label,
    double score,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              '${score.toStringAsFixed(0)}/100',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 8,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(HealthStatus status) {
    final recommendations = _getRecommendations(status);
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: status.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: status.color, size: 18),
              const SizedBox(width: 8),
              Text(
                'Rekomendasi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: status.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(fontSize: 12, color: status.color),
                  ),
                  Expanded(
                    child: Text(
                      rec,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateHealthScore() {
    if (agroData == null) return 0;

    final vdpScore = _calculateVdpScore();
    final gddScore = _calculateGddScore();
    final etcScore = _calculateEtcScore();

    // Weighted average: VDP 30%, GDD 30%, ETC 40%
    return (vdpScore * 0.3) + (gddScore * 0.3) + (etcScore * 0.4);
  }

  double _calculateVdpScore() {
    final vdp = agroData?.vdp?.vdp;
    if (vdp == null) return 50;

    // Optimal VDP: 0.4-1.2 kPa
    if (vdp >= 0.4 && vdp <= 1.2) return 100;
    if (vdp < 0.4) {
      // Low VDP: score decreases as it gets lower
      return 100 - ((0.4 - vdp) / 0.4 * 50);
    } else {
      // High VDP: score decreases as it gets higher
      return 100 - ((vdp - 1.2) / 0.8 * 50);
    }
  }

  double _calculateGddScore() {
    final totalGdd = agroData?.gdd?.totalGDD;
    if (totalGdd == null) return 50;

    // Assume optimal GDD range based on crop (this is simplified)
    // For rice: 2000-2500 GDD
    if (totalGdd >= 2000 && totalGdd <= 2500) return 100;
    if (totalGdd < 2000) {
      return (totalGdd / 2000 * 100).clamp(0, 100);
    } else {
      return (100 - ((totalGdd - 2500) / 500 * 50)).clamp(0, 100);
    }
  }

  double _calculateEtcScore() {
    if (agroData?.etc.isEmpty ?? true) return 50;

    final latestEtc = agroData!.etc.first;
    final waterNeeds = latestEtc.waterNeeds;
    if (waterNeeds == null) return 50;

    // Optimal water needs: 3-6 L/m²
    if (waterNeeds >= 3 && waterNeeds <= 6) return 100;
    if (waterNeeds < 3) {
      return 100 - ((3 - waterNeeds) / 3 * 30);
    } else {
      return 100 - ((waterNeeds - 6) / 10 * 50);
    }
  }

  HealthStatus _getHealthStatus(double score) {
    if (score >= 80) {
      return HealthStatus(
        label: 'Sangat Baik',
        description: 'Kondisi lingkungan optimal untuk pertumbuhan tanaman',
        color: AppColors.success,
        icon: Icons.check_circle,
      );
    } else if (score >= 60) {
      return HealthStatus(
        label: 'Baik',
        description: 'Kondisi lingkungan mendukung pertumbuhan tanaman',
        color: AppColors.accent,
        icon: Icons.thumb_up,
      );
    } else if (score >= 40) {
      return HealthStatus(
        label: 'Cukup',
        description: 'Beberapa parameter perlu perhatian',
        color: AppColors.warning,
        icon: Icons.warning_amber,
      );
    } else {
      return HealthStatus(
        label: 'Perlu Perhatian',
        description: 'Kondisi lingkungan memerlukan perbaikan segera',
        color: AppColors.error,
        icon: Icons.error,
      );
    }
  }

  List<String> _getRecommendations(HealthStatus status) {
    final recommendations = <String>[];

    // VDP recommendations
    final vdp = agroData?.vdp?.vdp;
    if (vdp != null) {
      if (vdp < 0.4) {
        recommendations.add('Tingkatkan ventilasi untuk menurunkan kelembaban');
      } else if (vdp > 1.6) {
        recommendations.add('Tingkatkan penyiraman dan kelembaban udara');
      }
    }

    // ETC recommendations
    if (agroData?.etc.isNotEmpty ?? false) {
      final waterNeeds = agroData!.etc.first.waterNeeds;
      if (waterNeeds != null && waterNeeds > 6) {
        recommendations.add('Tingkatkan frekuensi penyiraman');
      }
    }

    // General recommendations based on score
    if (status.label == 'Perlu Perhatian') {
      recommendations.add('Lakukan monitoring lebih intensif');
      recommendations.add('Konsultasikan dengan ahli agronomi');
    }

    return recommendations;
  }
}

class HealthStatus {
  final String label;
  final String description;
  final Color color;
  final IconData icon;

  HealthStatus({
    required this.label,
    required this.description,
    required this.color,
    required this.icon,
  });
}
