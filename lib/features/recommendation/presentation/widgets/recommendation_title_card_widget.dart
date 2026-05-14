import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/status_chip_widget.dart';
import '../../domain/entities/recommendation.dart';
import 'recommendation_color_helper.dart';

class RecommendationTitleCardWidget extends StatelessWidget {
  final Recommendation recommendation;

  const RecommendationTitleCardWidget({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = RecommendationColors.forPriority(
      recommendation.priority,
    );
    final statusColor = RecommendationColors.forStatus(recommendation.status);

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                recommendation.type.icon,
                style: TextStyle(fontSize: context.sp(40)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.type.label,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(12),
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recommendation.title,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              StatusChipWidget(
                label: recommendation.priority.label,
                color: priorityColor,
              ),
              const SizedBox(width: 8),
              StatusChipWidget(
                label: recommendation.status.label,
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            recommendation.description,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(14),
              color: AppColors.textPrimary.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
