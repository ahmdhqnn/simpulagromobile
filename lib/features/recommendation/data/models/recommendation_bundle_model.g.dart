// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_bundle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationSensorDataModelImpl
_$$RecommendationSensorDataModelImplFromJson(Map<String, dynamic> json) =>
    _$RecommendationSensorDataModelImpl(
      nitrogen: json['nitrogen'] as num?,
      phosphorus: json['phosphorus'] as num?,
      potassium: json['potassium'] as num?,
      ph: json['ph'] as num?,
      envTemp: json['env_temp'] as num?,
      envHum: json['env_hum'] as num?,
      soilTemp: json['soil_temp'] as num?,
      soilHum: json['soil_hum'] as num?,
    );

Map<String, dynamic> _$$RecommendationSensorDataModelImplToJson(
  _$RecommendationSensorDataModelImpl instance,
) => <String, dynamic>{
  'nitrogen': instance.nitrogen,
  'phosphorus': instance.phosphorus,
  'potassium': instance.potassium,
  'ph': instance.ph,
  'env_temp': instance.envTemp,
  'env_hum': instance.envHum,
  'soil_temp': instance.soilTemp,
  'soil_hum': instance.soilHum,
};

_$RecommendationActionResultModelImpl
_$$RecommendationActionResultModelImplFromJson(Map<String, dynamic> json) =>
    _$RecommendationActionResultModelImpl(
      status: json['status'] as String,
      pesan: json['pesan'] as String,
      dosisKgHa: json['dosis_kg_ha'] as num,
    );

Map<String, dynamic> _$$RecommendationActionResultModelImplToJson(
  _$RecommendationActionResultModelImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'pesan': instance.pesan,
  'dosis_kg_ha': instance.dosisKgHa,
};

_$RecommendationBundleModelImpl _$$RecommendationBundleModelImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendationBundleModelImpl(
  npk: json['npk'] == null
      ? null
      : RecommendationActionResultModel.fromJson(
          json['npk'] as Map<String, dynamic>,
        ),
  ph: json['ph'] == null
      ? null
      : RecommendationActionResultModel.fromJson(
          json['ph'] as Map<String, dynamic>,
        ),
  sensorData: json['sensor_data'] == null
      ? null
      : RecommendationSensorDataModel.fromJson(
          json['sensor_data'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$RecommendationBundleModelImplToJson(
  _$RecommendationBundleModelImpl instance,
) => <String, dynamic>{
  'npk': instance.npk,
  'ph': instance.ph,
  'sensor_data': instance.sensorData,
};
