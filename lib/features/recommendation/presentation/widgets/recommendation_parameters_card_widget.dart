import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import 'recommendation_color_helper.dart';

class RecommendationParametersCardWidget extends StatelessWidget {
  final Map<String, dynamic> parameters;

  const RecommendationParametersCardWidget({
    super.key,
    required this.parameters,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Parameter', style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 12),
          ...parameters.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    RecommendationColors.formatParameterKey(entry.key),
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    entry.value.toString(),
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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
}
