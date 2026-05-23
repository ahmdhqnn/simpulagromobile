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

    final (statusLabel, statusColor, showWarning) = _resolveStatus(score);

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
          statusLabel: statusLabel,
          statusColor: statusColor,
          showWarning: showWarning,
        ),
      ),
    );
  }

  (String, Color, bool) _resolveStatus(double score) {
    if (score >= 80) return ('Sangat Baik', const Color(0xFF88E096), false);
    if (score >= 60) return ('Kondisi Baik', const Color(0xFF88E096), false);
    if (score >= 40) return ('Cukup', const Color(0xFFFFD580), true);
    return ('Perlu Perhatian', const Color(0xFFFCBCBC), true);
  }
}
