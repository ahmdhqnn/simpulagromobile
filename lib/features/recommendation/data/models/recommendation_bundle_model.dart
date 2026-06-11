// ignore_for_file: invalid_annotation_target, unused_element

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation_bundle.dart';

part 'recommendation_bundle_model.freezed.dart';
part 'recommendation_bundle_model.g.dart';

@freezed
class RecommendationSensorDataModel with _$RecommendationSensorDataModel {
  const RecommendationSensorDataModel._();

  const factory RecommendationSensorDataModel({
    @JsonKey(name: 'nitrogen') num? nitrogen,
    @JsonKey(name: 'phosphorus') num? phosphorus,
    @JsonKey(name: 'potassium') num? potassium,
    @JsonKey(name: 'ph') num? ph,
  }) = _RecommendationSensorDataModel;

  factory RecommendationSensorDataModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationSensorDataModelFromJson(json);

  RecommendationSensorData toEntity() {
    return RecommendationSensorData(
      nitrogen: nitrogen,
      phosphorus: phosphorus,
      potassium: potassium,
      ph: ph,
    );
  }

  factory RecommendationSensorDataModel.fromEntity(
    RecommendationSensorData entity,
  ) {
    return RecommendationSensorDataModel(
      nitrogen: entity.nitrogen,
      phosphorus: entity.phosphorus,
      potassium: entity.potassium,
      ph: entity.ph,
    );
  }
}

@freezed
class RecommendationActionResultModel with _$RecommendationActionResultModel {
  const RecommendationActionResultModel._();

  const factory RecommendationActionResultModel({
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'pesan') required String pesan,
    @JsonKey(name: 'dosis_kg_ha') required num dosisKgHa,
  }) = _RecommendationActionResultModel;

  factory RecommendationActionResultModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationActionResultModelFromJson(json);

  RecommendationActionResult toEntity() {
    return RecommendationActionResult(
      status: status,
      pesan: pesan,
      dosisKgHa: dosisKgHa,
    );
  }

  factory RecommendationActionResultModel.fromEntity(
    RecommendationActionResult entity,
  ) {
    return RecommendationActionResultModel(
      status: entity.status,
      pesan: entity.pesan,
      dosisKgHa: entity.dosisKgHa,
    );
  }
}

@freezed
class RecommendationBundleModel with _$RecommendationBundleModel {
  const RecommendationBundleModel._();

  const factory RecommendationBundleModel({
    @JsonKey(name: 'npk') RecommendationActionResultModel? npk,
    @JsonKey(name: 'ph') RecommendationActionResultModel? ph,
    @JsonKey(name: 'sensor_data') RecommendationSensorDataModel? sensorData,
  }) = _RecommendationBundleModel;

  factory RecommendationBundleModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationBundleModelFromJson(json);

  RecommendationBundle toEntity() {
    return RecommendationBundle(
      npk: npk?.toEntity(),
      ph: ph?.toEntity(),
      sensorData: sensorData?.toEntity(),
    );
  }

  factory RecommendationBundleModel.fromEntity(RecommendationBundle entity) {
    return RecommendationBundleModel(
      npk: entity.npk != null
          ? RecommendationActionResultModel.fromEntity(entity.npk!)
          : null,
      ph: entity.ph != null
          ? RecommendationActionResultModel.fromEntity(entity.ph!)
          : null,
      sensorData: entity.sensorData != null
          ? RecommendationSensorDataModel.fromEntity(entity.sensorData!)
          : null,
    );
  }
}
