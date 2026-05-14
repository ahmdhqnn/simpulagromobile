import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class RecommendationActionButtonsWidget extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback onApply;
  final String dismissLabel;
  final String applyLabel;

  const RecommendationActionButtonsWidget({
    super.key,
    required this.onDismiss,
    required this.onApply,
    this.dismissLabel = 'Abaikan',
    this.applyLabel = 'Terapkan',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onDismiss,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.error),
              foregroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: Text(
              dismissLabel,
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: Text(
              applyLabel,
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
          ),
        ),
      ],
    );
  }
}
