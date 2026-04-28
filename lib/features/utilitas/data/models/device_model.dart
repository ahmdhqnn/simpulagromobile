// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/device.dart';

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
    @JsonKey(name: 'dev_created') DateTime? devCreated,
    @JsonKey(name: 'dev_update') DateTime? devUpdate,
  }) = _DeviceModel;

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  /// Convert Model to Entity
  Device toEntity() => Device(
    devId: devId,
    siteId: siteId,
    userId: userId,
    devName: devName,
    devToken: devToken,
    devLocation: devLocation,
    devLon: devLon,
    devLat: devLat,
    devAlt: devAlt,
    devNumberId: devNumberId,
    devIp: devIp,
    devPort: devPort,
    devImg: devImg,
    devSts: devSts,
    devCreated: devCreated,
    devUpdate: devUpdate,
  );

  /// Convert Entity to Model
  factory DeviceModel.fromEntity(Device entity) => DeviceModel(
    devId: entity.devId,
    siteId: entity.siteId,
    userId: entity.userId,
    devName: entity.devName,
    devToken: entity.devToken,
    devLocation: entity.devLocation,
    devLon: entity.devLon,
    devLat: entity.devLat,
    devAlt: entity.devAlt,
    devNumberId: entity.devNumberId,
    devIp: entity.devIp,
    devPort: entity.devPort,
    devImg: entity.devImg,
    devSts: entity.devSts,
    devCreated: entity.devCreated,
    devUpdate: entity.devUpdate,
  );
}
