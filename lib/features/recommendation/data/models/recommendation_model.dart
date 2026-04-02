// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation.dart';

part 'recommendation_model.freezed.dart';
part 'recommendation_model.g.dart';

/// Recommendation model for data layer
@freezed
class RecommendationModel with _$RecommendationModel {
  const RecommendationModel._();

  const factory RecommendationModel({
    @JsonKey(name: 'recommendation_id') required String recommendationId,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'priority') required String priority,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'plant_id') String? plantId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'parameters') Map<String, dynamic>? parameters,
    @JsonKey(name: 'action_items') List<String>? actionItems,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'applied_at') DateTime? appliedAt,
    @JsonKey(name: 'applied_by') String? appliedBy,
    @JsonKey(name: 'confidence_score') double? confidenceScore,
    @JsonKey(name: 'reason') String? reason,
  }) = _RecommendationModel;

  factory RecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationModelFromJson(json);

  /// Convert model to entity
  Recommendation toEntity() {
    return Recommendation(
      recommendationId: recommendationId,
      type: _parseType(type),
      title: title,
      description: description,
      priority: _parsePriority(priority),
      status: _parseStatus(status),
      plantId: plantId,
      plantName: plantName,
      siteId: siteId,
      siteName: siteName,
      parameters: parameters,
      actionItems: actionItems,
      createdAt: createdAt,
      appliedAt: appliedAt,
      appliedBy: appliedBy,
      confidenceScore: confidenceScore,
      reason: reason,
    );
  }

  /// Create model from entity
  factory RecommendationModel.fromEntity(Recommendation recommendation) {
    return RecommendationModel(
      recommendationId: recommendation.recommendationId,
      type: recommendation.type.name,
      title: recommendation.title,
      description: recommendation.description,
      priority: recommendation.priority.name,
      status: recommendation.status.name,
      plantId: recommendation.plantId,
      plantName: recommendation.plantName,
      siteId: recommendation.siteId,
      siteName: recommendation.siteName,
      parameters: recommendation.parameters,
      actionItems: recommendation.actionItems,
      createdAt: recommendation.createdAt,
      appliedAt: recommendation.appliedAt,
      appliedBy: recommendation.appliedBy,
      confidenceScore: recommendation.confidenceScore,
      reason: recommendation.reason,
    );
  }

  static RecommendationType _parseType(String type) {
    return RecommendationType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => RecommendationType.general,
    );
  }

  static RecommendationPriority _parsePriority(String priority) {
    return RecommendationPriority.values.firstWhere(
      (e) => e.name == priority,
      orElse: () => RecommendationPriority.medium,
    );
  }

  static RecommendationStatus _parseStatus(String status) {
    return RecommendationStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => RecommendationStatus.pending,
    );
  }
}
