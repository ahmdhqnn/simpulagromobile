// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _SensorModel;

  factory SensorModel.fromJson(Map<String, dynamic> json) =>
      _$SensorModelFromJson(json);

  bool get hasCoordinates => sensLat != null && sensLon != null;
  String get displayName => sensName ?? sensId;
}

@freezed
class DeviceSensorModel with _$DeviceSensorModel {
  const DeviceSensorModel._();

  const factory DeviceSensorModel({
    @JsonKey(name: 'ds_id') required String dsId,
    @JsonKey(name: 'dev_id') required String devId,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'sens_id') String? sensId,
    @JsonKey(name: 'dc_normal_value') double? dcNormalValue,
    @JsonKey(name: 'ds_min_norm_value') double? dsMinNormValue,
    @JsonKey(name: 'ds_max_norm_value') double? dsMaxNormValue,
    @JsonKey(name: 'ds_min_value') double? dsMinValue,
    @JsonKey(name: 'ds_max_value') double? dsMaxValue,
    @JsonKey(name: 'ds_min_val_warn') double? dsMinValWarn,
    @JsonKey(name: 'ds_max_val_warn') double? dsMaxValWarn,
    @JsonKey(name: 'ds_name') String? dsName,
    @JsonKey(name: 'ds_address') String? dsAddress,
    @JsonKey(name: 'ds_seq') int? dsSeq,
    @JsonKey(name: 'ds_sts') int? dsSts,
  }) = _DeviceSensorModel;

  factory DeviceSensorModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceSensorModelFromJson(json);

  bool get isActive => dsSts == 1;
  String get displayName => dsName ?? dsId;
}
