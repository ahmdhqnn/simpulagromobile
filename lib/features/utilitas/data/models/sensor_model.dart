// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sensor.dart';

part 'sensor_model.freezed.dart';
part 'sensor_model.g.dart';

@freezed
class SensorModel with _$SensorModel {
  const SensorModel._();

  const factory SensorModel({
    @JsonKey(name: 'sens_id') required String sensId,
    @JsonKey(name: 'dev_id') String? devId,
    @JsonKey(name: 'sens_name') String? sensName,
    @JsonKey(name: 'sens_address') String? sensAddress,
    @JsonKey(name: 'sens_location') String? sensLocation,
    @JsonKey(name: 'sens_lat') double? sensLat,
    @JsonKey(name: 'sens_lon') double? sensLon,
    @JsonKey(name: 'sens_alt') double? sensAlt,
    @JsonKey(name: 'sens_sts') int? sensSts,
    @JsonKey(name: 'sens_created') DateTime? sensCreated,
    @JsonKey(name: 'sens_update') DateTime? sensUpdate,
  }) = _SensorModel;

  factory SensorModel.fromJson(Map<String, dynamic> json) =>
      _$SensorModelFromJson(json);

  /// Convert Model to Entity
  Sensor toEntity() => Sensor(
    sensId: sensId,
    devId: devId,
    sensName: sensName,
    sensAddress: sensAddress,
    sensLocation: sensLocation,
    sensLat: sensLat,
    sensLon: sensLon,
    sensAlt: sensAlt,
    sensSts: sensSts,
    sensCreated: sensCreated,
    sensUpdate: sensUpdate,
  );

  /// Convert Entity to Model
  factory SensorModel.fromEntity(Sensor entity) => SensorModel(
    sensId: entity.sensId,
    devId: entity.devId,
    sensName: entity.sensName,
    sensAddress: entity.sensAddress,
    sensLocation: entity.sensLocation,
    sensLat: entity.sensLat,
    sensLon: entity.sensLon,
    sensAlt: entity.sensAlt,
    sensSts: entity.sensSts,
    sensCreated: entity.sensCreated,
    sensUpdate: entity.sensUpdate,
  );
}
