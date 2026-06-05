import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    final (healthColor, healthLabel) = _resolveHealth(overall);

    return AppCardWidget.elevated(
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
                      ).copyWith(height: 0.50),
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
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/warning-outline-icon.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  total == 0 ? AppColors.error : AppColors.success,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$total sensor tersedia, ${total == 0 ? 'silakan konfigurasi untuk mulai monitoring.' : 'monitoring berjalan normal.'}',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(9),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                    height: 1.33,
                  ),
                ),
              ),
            ],
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
