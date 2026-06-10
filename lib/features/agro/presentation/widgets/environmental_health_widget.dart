import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/agro_entity.dart';
import '../../../dashboard/domain/entities/dashboard_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n.dart';

class EnvironmentalHealthWidget extends StatelessWidget {
  final AgroEntity? agroData;
  final EnvironmentalHealthEntity? healthData;

  const EnvironmentalHealthWidget({super.key, this.agroData, this.healthData});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final healthScore = _calculateHealthScore();
    final healthStatus = _getHealthStatus(context, healthScore);

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
                  Icons.eco,
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
                      l10n.healthSectionTitle,
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
                      l10n.environmentalHealthScore,
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
          const SizedBox(height: 24),
          _buildHealthScore(context, healthScore, healthStatus),
          if (healthData != null && !healthData!.isEmpty) ...[
            const SizedBox(height: 16),
            _buildBackendHealthData(context),
          ],
          const SizedBox(height: 24),
          _buildParameterScores(context),
          const SizedBox(height: 16),
          _buildRecommendations(context, healthStatus),
        ],
      ),
    );
  }

  Widget _buildBackendHealthData(BuildContext context) {
    final sensors = healthData!.sensors.take(4).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sensors, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.monitoringSensorsMonitoredCount(healthData!.totalSensors),
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${healthData!.overallHealth.toStringAsFixed(1)}/100',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (sensors.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...sensors.map(
              (sensor) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildSensorHealthRow(context, sensor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSensorHealthRow(
    BuildContext context,
    SensorHealthEntity sensor,
  ) {
    final color = _getScoreColor(sensor.persentase);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sensor.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${sensor.devId} - ${_formatSensorValue(sensor)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(11),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            '${sensor.persentase.toStringAsFixed(0)}%',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(11),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthScore(
    BuildContext context,
    double score,
    HealthStatus status,
  ) {
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
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(56),
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
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(24),
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
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
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
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterScores(BuildContext context) {
    final vdpScore = _calculateVdpScore();
    final gddScore = _calculateGddScore();
    final etcScore = _calculateEtcScore();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.agroParameterScoreTitle,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(14),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1D1D),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCircularParameter(
              context,
              'VDP',
              vdpScore,
              Icons.water_drop,
              AppColors.info,
            ),
            _buildCircularParameter(
              context,
              'GDD',
              gddScore,
              Icons.thermostat,
              AppColors.warning,
            ),
            _buildCircularParameter(
              context,
              'ETC',
              etcScore,
              Icons.opacity,
              AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularParameter(
    BuildContext context,
    String label,
    double score,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 35.0,
          lineWidth: 6.0,
          animation: true,
          percent: (score / 100).clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(height: 2),
              Text(
                score.toStringAsFixed(0),
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(11),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: color,
          backgroundColor: AppColors.divider,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(12),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1D1D1D),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context, HealthStatus status) {
    final recommendations = _getRecommendations(context, status);
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: status.color, size: 18),
              const SizedBox(width: 8),
              Text(
                context.l10n.recommendationTitle,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
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
                    '- ',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      color: status.color,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        color: const Color(0xFF1D1D1D),
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
    if (healthData != null) return healthData!.overallHealth;
    final vdpScore = _calculateVdpScore();
    final gddScore = _calculateGddScore();
    final etcScore = _calculateEtcScore();
    return (vdpScore + gddScore + etcScore) / 3;
  }

  double _calculateVdpScore() {
    final vdp = agroData?.vdp?.vdp;
    if (vdp == null) return 50;

    if (vdp >= 0.4 && vdp <= 1.2) return 100;
    if (vdp < 0.4) {
      return 100 - ((0.4 - vdp) / 0.4 * 50);
    } else {
      return 100 - ((vdp - 1.2) / 0.8 * 50);
    }
  }

  double _calculateGddScore() {
    final totalGdd = agroData?.gdd?.totalGDD;
    if (totalGdd == null) return 50;

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
    if (waterNeeds == null) {
      final etc = latestEtc.etc;
      if (etc == null) return 50;
      if (etc >= 3 && etc <= 6) return 100;
      if (etc < 3) {
        return (70 + (etc / 3 * 30)).clamp(0, 100);
      }
      return (100 - ((etc - 6) / 6 * 50)).clamp(0, 100);
    }

    if (waterNeeds >= 3 && waterNeeds <= 6) return 100;
    if (waterNeeds < 3) {
      return 100 - ((3 - waterNeeds) / 3 * 30);
    } else {
      return 100 - ((waterNeeds - 6) / 10 * 50);
    }
  }

  HealthStatus _getHealthStatus(BuildContext context, double score) {
    final l10n = AppLocalizations.of(context)!;
    if (score >= 80) {
      return HealthStatus(
        label: l10n.monitoringHealthExcellent,
        description: l10n.monitoringHealthExcellentDesc,
        color: AppColors.success,
        icon: Icons.check_circle,
      );
    } else if (score >= 60) {
      return HealthStatus(
        label: l10n.monitoringHealthGood,
        description: l10n.monitoringHealthGoodDesc,
        color: AppColors.accent,
        icon: Icons.thumb_up,
      );
    } else if (score >= 40) {
      return HealthStatus(
        label: l10n.monitoringHealthFair,
        description: l10n.monitoringHealthFairDesc,
        color: AppColors.warning,
        icon: Icons.warning_amber,
      );
    } else {
      return HealthStatus(
        label: l10n.monitoringHealthNeedsAttention,
        description: l10n.monitoringHealthNeedsAttentionDesc,
        color: AppColors.error,
        icon: Icons.error,
      );
    }
  }

  List<String> _getRecommendations(BuildContext context, HealthStatus status) {
    final l10n = AppLocalizations.of(context)!;
    final recommendations = <String>[];

    final vdp = agroData?.vdp?.vdp;
    if (vdp != null) {
      if (vdp < 0.4) {
        recommendations.add(l10n.agroRecVentilationLowerHumidity);
      } else if (vdp > 1.6) {
        recommendations.add(l10n.agroRecIncreaseIrrigationHumidity);
      }
    }

    if (agroData?.etc.isNotEmpty ?? false) {
      final latestEtc = agroData!.etc.first;
      final waterNeeds = latestEtc.waterNeeds;
      if (waterNeeds != null && waterNeeds > 6) {
        recommendations.add(l10n.agroRecIncreaseWateringFrequency);
      } else if (waterNeeds == null &&
          latestEtc.etc != null &&
          latestEtc.etc! > 6) {
        recommendations.add(l10n.agroRecHighEtcCheckSoil);
      }
    }

    if (status.label == l10n.monitoringHealthNeedsAttention) {
      recommendations.add(l10n.agroRecIntenseMonitoring);
      recommendations.add(l10n.agroRecConsultAgronomist);
    }

    return recommendations;
  }

  String _formatSensorValue(SensorHealthEntity sensor) {
    final unit = sensor.unit;
    if (unit.isEmpty) return sensor.readUpdateValue;
    return '${sensor.readUpdateValue} $unit';
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.accent;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
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
