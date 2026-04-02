// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'sensor_model.dart';

part 'device_model.freezed.dart';
part 'device_model.g.dart';

@freezed
class DeviceModel with _$DeviceModel {
  const DeviceModel._();

  const factory DeviceModel({
    @JsonKey(name: 'dev_id') required String devId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'dev_name') String? devName,
    @JsonKey(name: 'dev_token') String? devToken,
    @JsonKey(name: 'dev_location') String? devLocation,
    @JsonKey(name: 'dev_lon') double? devLon,
    @JsonKey(name: 'dev_lat') double? devLat,
    @JsonKey(name: 'dev_alt') double? devAlt,
    @JsonKey(name: 'dev_number_id') String? devNumberId,
    @JsonKey(name: 'dev_ip') String? devIp,
    @JsonKey(name: 'dev_port') String? devPort,
    @JsonKey(name: 'dev_img') String? devImg,
    @JsonKey(name: 'dev_sts') int? devSts,
    @JsonKey(name: 'sensor') List<SensorModel>? sensors,
  }) = _DeviceModel;

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  bool get isActive => devSts == 1;
  bool get hasCoordinates => devLon != null && devLat != null;
  String get displayName => devName ?? devId;
}
