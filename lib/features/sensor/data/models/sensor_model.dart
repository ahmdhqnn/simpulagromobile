// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sensor.dart';

part 'sensor_model.freezed.dart';
part 'sensor_model.g.dart';

@freezed
class SensorModel with _$SensorModel {
  const SensorModel._();

  const factory SensorModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'device_id') required String deviceId,
    required String name,
    required String type,
    required String unit,
    String? description,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SensorModel;

  factory SensorModel.fromJson(Map<String, dynamic> json) =>
      _$SensorModelFromJson(json);

  Sensor toEntity() => Sensor(
    id: id,
    deviceId: deviceId,
    name: name,
    type: type,
    unit: unit,
    description: description,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
