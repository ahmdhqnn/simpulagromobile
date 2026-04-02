// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationModelImpl _$$RecommendationModelImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendationModelImpl(
  recommendationId: json['recommendation_id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  priority: json['priority'] as String,
  status: json['status'] as String,
  plantId: json['plant_id'] as String?,
  plantName: json['plant_name'] as String?,
  siteId: json['site_id'] as String?,
  siteName: json['site_name'] as String?,
  parameters: json['parameters'] as Map<String, dynamic>?,
  actionItems: (json['action_items'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  appliedAt: json['applied_at'] == null
      ? null
      : DateTime.parse(json['applied_at'] as String),
  appliedBy: json['applied_by'] as String?,
  confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$$RecommendationModelImplToJson(
  _$RecommendationModelImpl instance,
) => <String, dynamic>{
  'recommendation_id': instance.recommendationId,
  'type': instance.type,
  'title': instance.title,
  'description': instance.description,
  'priority': instance.priority,
  'status': instance.status,
  'plant_id': instance.plantId,
  'plant_name': instance.plantName,
  'site_id': instance.siteId,
  'site_name': instance.siteName,
  'parameters': instance.parameters,
  'action_items': instance.actionItems,
  'created_at': instance.createdAt?.toIso8601String(),
  'applied_at': instance.appliedAt?.toIso8601String(),
  'applied_by': instance.appliedBy,
  'confidence_score': instance.confidenceScore,
  'reason': instance.reason,
};
