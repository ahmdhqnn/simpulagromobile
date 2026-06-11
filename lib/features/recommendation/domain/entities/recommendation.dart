import 'package:freezed_annotation/freezed_annotation.dart';
import 'recommendation_bundle.dart';

part 'recommendation.freezed.dart';

/// Recommendation entity
@freezed
class Recommendation with _$Recommendation {
  const Recommendation._();

  const factory Recommendation({
    required String recommendationId,
    required RecommendationType type,
    required String title,
    required String description,
    required RecommendationPriority priority,
    String? plantId,
    String? plantName,
    String? siteId,
    String? siteName,
    RecommendationBundle? parameters,
    List<String>? actionItems,
    DateTime? createdAt,
    double? confidenceScore,
    String? reason,
    String? errorMessage,
  }) = _Recommendation;

  /// Get priority color
  String get priorityColor {
    switch (priority) {
      case RecommendationPriority.low:
        return '#66BB6A'; // Green
      case RecommendationPriority.medium:
        return '#FFA726'; // Orange
      case RecommendationPriority.high:
        return '#EF5350'; // Red
      case RecommendationPriority.critical:
        return '#D32F2F'; // Dark Red
    }
  }

  bool get hasError => errorMessage?.trim().isNotEmpty == true;

  /// Get confidence level text
  String get confidenceLevel {
    if (confidenceScore == null) return 'Unknown';
    if (confidenceScore! >= 0.8) return 'Sangat Tinggi';
    if (confidenceScore! >= 0.6) return 'Tinggi';
    if (confidenceScore! >= 0.4) return 'Sedang';
    return 'Rendah';
  }
}

/// Recommendation type enum
enum RecommendationType {
  npk,
  ph,
  watering,
  pestControl,
  harvesting,
  planting,
  general;

  String get label {
    switch (this) {
      case RecommendationType.npk:
        return 'Pemupukan NPK';
      case RecommendationType.ph:
        return 'Penyesuaian pH';
      case RecommendationType.watering:
        return 'Penyiraman';
      case RecommendationType.pestControl:
        return 'Pengendalian Hama';
      case RecommendationType.harvesting:
        return 'Panen';
      case RecommendationType.planting:
        return 'Penanaman';
      case RecommendationType.general:
        return 'Umum';
    }
  }

  String get icon {
    switch (this) {
      case RecommendationType.npk:
        return '🌱';
      case RecommendationType.ph:
        return '⚗️';
      case RecommendationType.watering:
        return '💧';
      case RecommendationType.pestControl:
        return '🐛';
      case RecommendationType.harvesting:
        return '🌾';
      case RecommendationType.planting:
        return '🌿';
      case RecommendationType.general:
        return '📋';
    }
  }
}

/// Recommendation priority enum
enum RecommendationPriority {
  low,
  medium,
  high,
  critical;

  String get label {
    switch (this) {
      case RecommendationPriority.low:
        return 'Rendah';
      case RecommendationPriority.medium:
        return 'Sedang';
      case RecommendationPriority.high:
        return 'Tinggi';
      case RecommendationPriority.critical:
        return 'Kritis';
    }
  }
}
