import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_bundle.freezed.dart';

@freezed
class RecommendationSensorData with _$RecommendationSensorData {
  const RecommendationSensorData._();

  const factory RecommendationSensorData({
    num? nitrogen,
    num? phosphorus,
    num? potassium,
    num? ph,
  }) = _RecommendationSensorData;
}

@freezed
class RecommendationActionResult with _$RecommendationActionResult {
  const RecommendationActionResult._();

  const factory RecommendationActionResult({
    required String status,
    required String pesan,
    required num dosisKgHa,
  }) = _RecommendationActionResult;
}

@freezed
class RecommendationBundle with _$RecommendationBundle {
  const RecommendationBundle._();

  const factory RecommendationBundle({
    RecommendationActionResult? npk,
    RecommendationActionResult? ph,
  }) = _RecommendationBundle;

  bool get isNotEmpty => npk != null || ph != null;
}
