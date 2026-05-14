import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../domain/entities/recommendation.dart';

class RecommendationInfoCardWidget extends StatelessWidget {
  final Recommendation recommendation;

  const RecommendationInfoCardWidget({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi', style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 12),
          if (recommendation.siteName != null)
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Lokasi',
              value: recommendation.siteName!,
            ),
          if (recommendation.plantName != null)
            _InfoRow(
              icon: Icons.eco_outlined,
              label: 'Tanaman',
              value: recommendation.plantName!,
            ),
          if (recommendation.confidenceScore != null)
            _InfoRow(
              icon: Icons.analytics_outlined,
              label: 'Tingkat Keyakinan',
              value:
                  '${recommendation.confidenceLevel} (${(recommendation.confidenceScore! * 100).toStringAsFixed(0)}%)',
            ),
          if (recommendation.createdAt != null)
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Dibuat',
              value: DateFormatter.formatDateTime(recommendation.createdAt!),
            ),
          if (recommendation.appliedAt != null)
            _InfoRow(
              icon: Icons.check_circle_outline,
              label: 'Diterapkan',
              value: DateFormatter.formatDateTime(recommendation.appliedAt!),
            ),
          if (recommendation.appliedBy != null)
            _InfoRow(
              icon: Icons.person_outline,
              label: 'Diterapkan oleh',
              value: recommendation.appliedBy!,
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(0.012)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(11),
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(13),
                    fontWeight: FontWeight.w500,
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
}
