// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sensor.dart';
import '../../../../core/utils/safe_double_converter.dart';
import 'admin_model_parsers.dart';

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
    @SafeDoubleConverter() @JsonKey(name: 'sens_lat') double? sensLat,
    @SafeDoubleConverter() @JsonKey(name: 'sens_lon') double? sensLon,
    @SafeDoubleConverter() @JsonKey(name: 'sens_alt') double? sensAlt,
    @JsonKey(name: 'sens_sts') int? sensSts,
    @JsonKey(name: 'sens_created') DateTime? sensCreated,
    @JsonKey(name: 'sens_update') DateTime? sensUpdate,
  }) = _SensorModel;

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    final device = json['device'];
    final deviceMap = device is Map ? Map<String, dynamic>.from(device) : null;

    return SensorModel(
      sensId: adminStringValue(
        adminFirstOf(json, const [
              'sens_id',
              'sensId',
              'sensor_id',
              'sensorId',
              'id',
            ]) ??
            adminFirstOf(deviceMap ?? const {}, const ['sens_id', 'sensId']),
      ),
      devId: adminNullableString(
        adminFirstOf(json, const [
              'dev_id',
              'devId',
              'device_id',
              'deviceId',
            ]) ??
            adminFirstOf(deviceMap ?? const {}, const ['dev_id', 'devId']),
      ),
      sensName: adminNullableString(
        adminFirstOf(json, const ['sens_name', 'sensName', 'name']),
      ),
      sensAddress: adminNullableString(
        adminFirstOf(json, const ['sens_address', 'sensAddress', 'address']),
      ),
      sensLocation: adminNullableString(
        adminFirstOf(json, const ['sens_location', 'sensLocation', 'location']),
      ),
      sensLat: adminDoubleValue(
        adminFirstOf(json, const ['sens_lat', 'sensLat', 'lat', 'latitude']),
      ),
      sensLon: adminDoubleValue(
        adminFirstOf(json, const ['sens_lon', 'sensLon', 'lon', 'longitude']),
      ),
      sensAlt: adminDoubleValue(
        adminFirstOf(json, const ['sens_alt', 'sensAlt', 'alt', 'altitude']),
      ),
      sensSts: adminIntValue(
        adminFirstOf(json, const [
          'sens_sts',
          'sensSts',
          'sensor_status',
          'sensorStatus',
          'is_active',
          'isActive',
          'active',
          'status',
        ]),
      ),
      sensCreated: adminDateTimeValue(adminCreatedValue(json, 'sens')),
      sensUpdate: adminDateTimeValue(adminUpdatedValue(json, 'sens')),
    );
  }

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
