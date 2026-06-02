import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/dashboard_entity.dart';
import 'smart_score_gauge.dart';

class HealthCardWidget extends StatelessWidget {
  final EnvironmentalHealthEntity health;
  const HealthCardWidget({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    final score = health.overallHealth;
    final totalSensors = health.totalSensors;

    final status = _resolveStatus(score);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFFE1F3E2), Color(0xFFFDDEC5)],
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

  _HealthStatus _resolveStatus(double score) {
    if (score >= 80) {
      return const _HealthStatus(
        label: 'Sangat Baik',
        color: Color(0xFF88E096),
        icon: Icons.verified_rounded,
        iconSize: 13,
      );
    }
    if (score >= 60) {
      return const _HealthStatus(
        label: 'Kondisi Baik',
        color: Color(0xFF88E096),
        icon: Icons.check_circle_rounded,
        iconSize: 13,
      );
    }
    if (score >= 40) {
      return const _HealthStatus(
        label: 'Cukup',
        color: Color(0xFFFFD580),
        icon: Icons.info_rounded,
        iconSize: 13,
      );
    }
    return const _HealthStatus(
      label: 'Perlu Perhatian',
      color: Color(0xFFFCBCBC),
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
