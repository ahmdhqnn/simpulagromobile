// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation.dart';
import 'recommendation_bundle_model.dart';

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
    @JsonKey(name: 'plant_id') String? plantId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'parameters') RecommendationBundleModel? parameters,
    @JsonKey(name: 'action_items') List<String>? actionItems,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'confidence_score') double? confidenceScore,
    @JsonKey(name: 'reason') String? reason,
    @JsonKey(name: 'error_message') String? errorMessage,
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
      plantId: plantId,
      plantName: plantName,
      siteId: siteId,
      siteName: siteName,
      parameters: parameters?.toEntity(),
      actionItems: actionItems,
      createdAt: createdAt,
      confidenceScore: confidenceScore,
      reason: reason,
      errorMessage: errorMessage,
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
      plantId: recommendation.plantId,
      plantName: recommendation.plantName,
      siteId: recommendation.siteId,
      siteName: recommendation.siteName,
      parameters: recommendation.parameters != null
          ? RecommendationBundleModel.fromEntity(recommendation.parameters!)
          : null,
      actionItems: recommendation.actionItems,
      createdAt: recommendation.createdAt,
      confidenceScore: recommendation.confidenceScore,
      reason: recommendation.reason,
      errorMessage: recommendation.errorMessage,
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
}
