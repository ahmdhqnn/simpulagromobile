import 'package:freezed_annotation/freezed_annotation.dart';

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
    required RecommendationStatus status,
    String? plantId,
    String? plantName,
    String? siteId,
    String? siteName,
    Map<String, dynamic>? parameters,
    List<String>? actionItems,
    DateTime? createdAt,
    DateTime? appliedAt,
    String? appliedBy,
    double? confidenceScore,
    String? reason,
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

  /// Get status color
  String get statusColor {
    switch (status) {
      case RecommendationStatus.pending:
        return '#FFA726'; // Orange
      case RecommendationStatus.applied:
        return '#66BB6A'; // Green
      case RecommendationStatus.dismissed:
        return '#9E9E9E'; // Grey
      case RecommendationStatus.expired:
        return '#757575'; // Dark Grey
    }
  }

  /// Check if recommendation is actionable
  bool get isActionable {
    return status == RecommendationStatus.pending;
  }

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

/// Recommendation status enum
enum RecommendationStatus {
  pending,
  applied,
  dismissed,
  expired;

  String get label {
    switch (this) {
      case RecommendationStatus.pending:
        return 'Menunggu';
      case RecommendationStatus.applied:
        return 'Diterapkan';
      case RecommendationStatus.dismissed:
        return 'Diabaikan';
      case RecommendationStatus.expired:
        return 'Kadaluarsa';
    }
  }
}
