import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../domain/entities/recommendation_bundle.dart';

class RecommendationParametersCardWidget extends StatelessWidget {
  final RecommendationBundle parameters;

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
          if (parameters.npk != null) ...[
            _buildRow(context, 'Status NPK', parameters.npk!.status),
            _buildRow(context, 'Dosis NPK', '${parameters.npk!.dosisKgHa} kg/ha'),
          ],
          if (parameters.ph != null) ...[
            _buildRow(context, 'Status pH', parameters.ph!.status),
            _buildRow(context, 'Dosis pH', '${parameters.ph!.dosisKgHa} kg/ha'),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
