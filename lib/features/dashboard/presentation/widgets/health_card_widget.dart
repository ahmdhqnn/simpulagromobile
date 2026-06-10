import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/dashboard_entity.dart';
import 'smart_score_gauge.dart';

class HealthCardWidget extends StatelessWidget {
  final EnvironmentalHealthEntity health;
  const HealthCardWidget({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    final score = health.overallHealth;
    final totalSensors = health.totalSensors;

    final status = _resolveStatus(context, score);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [AppColors.healthGradientStart, AppColors.healthGradientEnd],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.rh(0.03),
          horizontal: context.rw(0.051),
        ),
        child: SmartScoreGauge(
          score: score,
          totalSensors: totalSensors,
          statusLabel: status.label,
          statusColor: status.color,
          statusIcon: status.icon,
          statusIconSize: status.iconSize,
        ),
      ),
    );
  }

  _HealthStatus _resolveStatus(BuildContext context, double score) {
    final l10n = context.l10n;
    if (score >= 80) {
      return _HealthStatus(
        label: l10n.monitoringHealthExcellent,
        color: AppColors.healthStatusGood,
        icon: Icons.verified_rounded,
        iconSize: 13,
      );
    }
    if (score >= 60) {
      return _HealthStatus(
        label: l10n.monitoringHealthGood,
        color: AppColors.healthStatusGood,
        icon: Icons.check_circle_rounded,
        iconSize: 13,
      );
    }
    if (score >= 40) {
      return _HealthStatus(
        label: l10n.monitoringHealthFair,
        color: AppColors.healthStatusWarning,
        icon: Icons.info_rounded,
        iconSize: 13,
      );
    }
    return _HealthStatus(
      label: l10n.monitoringHealthNeedsAttention,
      color: AppColors.healthStatusCritical,
      icon: Icons.warning_amber_rounded,
      iconSize: 14,
    );
  }
}

class _HealthStatus {
  const _HealthStatus({
    required this.label,
    required this.color,
    required this.icon,
    required this.iconSize,
  });

  final String label;
  final Color color;
  final IconData icon;
  final double iconSize;
}
