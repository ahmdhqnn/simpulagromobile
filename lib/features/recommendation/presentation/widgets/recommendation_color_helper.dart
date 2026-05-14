import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recommendation.dart';

class RecommendationColors {
  RecommendationColors._();

  static Color forPriority(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.low:
        return AppColors.success;
      case RecommendationPriority.medium:
        return AppColors.warning;
      case RecommendationPriority.high:
        return AppColors.error;
      case RecommendationPriority.critical:
        return const Color(0xFFD32F2F);
    }
  }

  static Color forStatus(RecommendationStatus status) {
    switch (status) {
      case RecommendationStatus.pending:
        return AppColors.warning;
      case RecommendationStatus.applied:
        return AppColors.success;
      case RecommendationStatus.dismissed:
        return AppColors.textSecondary;
      case RecommendationStatus.expired:
        return const Color(0xFF757575);
    }
  }

  /// Capitalizes "snake_case_keys" into "Snake Case Keys" for display.
  static String formatParameterKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }
}
