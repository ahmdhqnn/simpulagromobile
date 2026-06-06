import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../dashboard/data/models/environmental_health_model.dart';
import '../monitoring_card_header_widget.dart';

class EnvironmentalHealthCardWidget extends StatelessWidget {
  final EnvironmentalHealth health;
  const EnvironmentalHealthCardWidget({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    final overall = health.overallHealth;
    final total = health.totalSensors;
    final hasSensors = total > 0;

    final (healthColor, healthLabel) = _resolveHealth(overall);
    final healthProgress = (overall / 100).clamp(0.0, 1.0).toDouble();
    final statusColor = hasSensors ? healthColor : AppColors.warning;
    final statusIcon = !hasSensors
        ? Icons.settings_suggest_outlined
        : overall >= 60
        ? Icons.check_circle_outline_rounded
        : Icons.error_outline_rounded;
    final statusText = !hasSensors
        ? 'Belum ada sensor tersedia, silakan konfigurasi untuk mulai monitoring.'
        : overall >= 60
        ? '$total sensor tersedia, kondisi monitoring stabil.'
        : '$total sensor tersedia, beberapa parameter perlu perhatian.';

    return AppCardWidget.elevated(
      boxShadow: null,
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MonitoringCardHeaderWidget.icon(
            icon: Icons.eco_outlined,
            title: 'Kesehatan Lingkungan',
            description: 'Skor kondisi sensor site aktif',
            background: AppColors.softGreen,
            tint: AppColors.primary,
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      overall.toStringAsFixed(0),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.metric(
                        context,
                        size: 44,
                        color: healthColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/100',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.metric(
                        context,
                        size: 22,
                        color: healthColor,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  healthLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: healthColor,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: healthProgress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(healthColor),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                Icon(statusIcon, size: 18, color: statusColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _resolveHealth(double overall) {
    if (overall == 0) return (AppColors.warning, 'Perlu Konfigurasi');
    if (overall >= 80) return (AppColors.success, 'Sangat Baik');
    if (overall >= 60) return (AppColors.primaryLight, 'Baik');
    if (overall >= 40) return (AppColors.warning, 'Cukup');
    return (AppColors.error, 'Perlu Perhatian');
  }
}
