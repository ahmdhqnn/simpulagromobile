// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/device.dart';
import '../../../../core/utils/safe_double_converter.dart';
import 'admin_model_parsers.dart';

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
    @SafeDoubleConverter() @JsonKey(name: 'dev_lon') double? devLon,
    @SafeDoubleConverter() @JsonKey(name: 'dev_lat') double? devLat,
    @SafeDoubleConverter() @JsonKey(name: 'dev_alt') double? devAlt,
    @JsonKey(name: 'dev_number_id') String? devNumberId,
    @JsonKey(name: 'dev_ip') String? devIp,
    @JsonKey(name: 'dev_port') String? devPort,
    @JsonKey(name: 'dev_img') String? devImg,
    @JsonKey(name: 'dev_sts') int? devSts,
    @JsonKey(name: 'dev_created') DateTime? devCreated,
    @JsonKey(name: 'dev_update') DateTime? devUpdate,
  }) = _DeviceModel;

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    final site = json['site'];
    final siteMap = site is Map ? Map<String, dynamic>.from(site) : null;
    final user = json['user'];
    final userMap = user is Map ? Map<String, dynamic>.from(user) : null;

    return DeviceModel(
      devId: adminStringValue(
        adminFirstOf(json, const [
          'dev_id',
          'devId',
          'device_id',
          'deviceId',
          'id',
        ]),
      ),
      siteId: adminNullableString(
        adminFirstOf(json, const ['site_id', 'siteId']) ??
            adminFirstOf(siteMap ?? const {}, const ['site_id', 'siteId']),
      ),
      userId: adminNullableString(
        adminFirstOf(json, const ['user_id', 'userId']) ??
            adminFirstOf(userMap ?? const {}, const ['user_id', 'userId']),
      ),
      devName: adminNullableString(
        adminFirstOf(json, const ['dev_name', 'devName', 'name']),
      ),
      devToken: adminNullableString(
        adminFirstOf(json, const ['dev_token', 'devToken', 'token']),
      ),
      devLocation: adminNullableString(
        adminFirstOf(json, const ['dev_location', 'devLocation', 'location']),
      ),
      devLon: adminDoubleValue(
        adminFirstOf(json, const ['dev_lon', 'devLon', 'lon', 'longitude']),
      ),
      devLat: adminDoubleValue(
        adminFirstOf(json, const ['dev_lat', 'devLat', 'lat', 'latitude']),
      ),
      devAlt: adminDoubleValue(
        adminFirstOf(json, const ['dev_alt', 'devAlt', 'alt', 'altitude']),
      ),
      devNumberId: adminNullableString(
        adminFirstOf(json, const [
          'dev_number_id',
          'devNumberId',
          'number_id',
          'numberId',
        ]),
      ),
      devIp: adminNullableString(
        adminFirstOf(json, const ['dev_ip', 'devIp', 'ip']),
      ),
      devPort: adminNullableString(
        adminFirstOf(json, const ['dev_port', 'devPort', 'port']),
      ),
      devImg: adminNullableString(
        adminFirstOf(json, const ['dev_img', 'devImg', 'image', 'img']),
      ),
      devSts: adminIntValue(
        adminFirstOf(json, const [
          'dev_sts',
          'devSts',
          'device_status',
          'deviceStatus',
          'is_active',
          'isActive',
          'active',
          'status',
        ]),
      ),
      devCreated: adminDateTimeValue(adminCreatedValue(json, 'dev')),
      devUpdate: adminDateTimeValue(adminUpdatedValue(json, 'dev')),
    );
  }

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
