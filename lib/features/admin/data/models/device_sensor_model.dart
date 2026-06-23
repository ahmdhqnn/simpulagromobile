// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/device_sensor.dart';
import '../../../../core/utils/safe_double_converter.dart';
import 'admin_model_parsers.dart';

part 'device_sensor_model.freezed.dart';
part 'device_sensor_model.g.dart';

@freezed
class DeviceSensorModel with _$DeviceSensorModel {
  const DeviceSensorModel._();

  const factory DeviceSensorModel({
    @JsonKey(name: 'ds_id') required String dsId,
    @JsonKey(name: 'dev_id') required String devId,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'sens_id') String? sensId,
    @SafeDoubleConverter()
    @JsonKey(name: 'dc_normal_value')
    double? dcNormalValue,
    @SafeDoubleConverter()
    @JsonKey(name: 'ds_min_norm_value')
    double? dsMinNormValue,
    @SafeDoubleConverter()
    @JsonKey(name: 'ds_max_norm_value')
    double? dsMaxNormValue,
    @SafeDoubleConverter() @JsonKey(name: 'ds_min_value') double? dsMinValue,
    @SafeDoubleConverter() @JsonKey(name: 'ds_max_value') double? dsMaxValue,
    @SafeDoubleConverter()
    @JsonKey(name: 'ds_min_val_warn')
    double? dsMinValWarn,
    @SafeDoubleConverter()
    @JsonKey(name: 'ds_max_val_warn')
    double? dsMaxValWarn,
    @JsonKey(name: 'ds_name') String? dsName,
    @JsonKey(name: 'ds_address') String? dsAddress,
    @JsonKey(name: 'ds_seq') int? dsSeq,
    @JsonKey(name: 'ds_sts') int? dsSts,
    @JsonKey(name: 'ds_created') DateTime? dsCreated,
    @JsonKey(name: 'ds_update') DateTime? dsUpdate,
  }) = _DeviceSensorModel;

  factory DeviceSensorModel.fromJson(Map<String, dynamic> json) {
    final sensor =
        json['sensor'] ??
        json['sensors'] ??
        json['td_sensor'] ??
        json['sensor_data'];
    final sensorMap = _mapValue(sensor);
    final unit = json['unit'] ?? json['units'] ?? json['tm_unit'];
    final unitMap = _mapValue(unit);
    final device = json['device'] ?? json['devices'] ?? json['tm_device'];
    final deviceMap = _mapValue(device);

    return DeviceSensorModel(
      dsId: adminStringValue(
        adminFirstOf(json, const [
          'ds_id',
          'dsId',
          'device_sensor_id',
          'deviceSensorId',
          'id',
        ]),
      ),
      devId: adminStringValue(
        adminFirstOf(json, const [
              'dev_id',
              'devId',
              'device_id',
              'deviceId',
            ]) ??
            adminFirstOf(deviceMap ?? const {}, const ['dev_id', 'devId']),
      ),
      unitId: adminNullableString(
        adminFirstOf(json, const ['unit_id', 'unitId']) ??
            adminFirstOf(unitMap ?? const {}, const ['unit_id', 'unitId']),
      ),
      sensId: adminNullableString(
        adminFirstOf(json, const [
              'sens_id',
              'sensId',
              'sensor_id',
              'sensorId',
            ]) ??
            adminFirstOf(sensorMap ?? const {}, const ['sens_id', 'sensId']),
      ),
      dcNormalValue: adminDoubleValue(
        adminFirstOf(json, const [
          'dc_normal_value',
          'dcNormalValue',
          'normal_value',
          'normalValue',
        ]),
      ),
      dsMinNormValue: adminDoubleValue(
        adminFirstOf(json, const [
          'ds_min_norm_value',
          'dsMinNormValue',
          'min_norm',
          'minNorm',
          'min_normal',
          'minNormal',
        ]),
      ),
      dsMaxNormValue: adminDoubleValue(
        adminFirstOf(json, const [
          'ds_max_norm_value',
          'dsMaxNormValue',
          'max_norm',
          'maxNorm',
          'max_normal',
          'maxNormal',
        ]),
      ),
      dsMinValue: adminDoubleValue(
        adminFirstOf(json, const [
          'ds_min_value',
          'dsMinValue',
          'ds_min',
          'dsMin',
          'min_val',
          'minVal',
          'min_value',
          'minValue',
        ]),
      ),
      dsMaxValue: adminDoubleValue(
        adminFirstOf(json, const [
          'ds_max_value',
          'dsMaxValue',
          'ds_max',
          'dsMax',
          'max_val',
          'maxVal',
          'max_value',
          'maxValue',
        ]),
      ),
      dsMinValWarn: adminDoubleValue(
        adminFirstOf(json, const [
          'ds_min_val_warn',
          'dsMinValWarn',
          'min_warn',
          'minWarn',
          'min_warning',
          'minWarning',
        ]),
      ),
      dsMaxValWarn: adminDoubleValue(
        adminFirstOf(json, const [
          'ds_max_val_warn',
          'dsMaxValWarn',
          'max_warn',
          'maxWarn',
          'max_warning',
          'maxWarning',
        ]),
      ),
      dsName: adminNullableString(
        adminFirstOf(json, const ['ds_name', 'dsName', 'name']) ??
            adminFirstOf(sensorMap ?? const {}, const [
              'sens_name',
              'sensName',
            ]),
      ),
      dsAddress: adminNullableString(
        adminFirstOf(json, const ['ds_address', 'dsAddress', 'address']),
      ),
      dsSeq: adminIntValue(
        adminFirstOf(json, const [
          'ds_seq',
          'dsSeq',
          'ds_sequence',
          'dsSequence',
          'sequence',
        ]),
      ),
      dsSts: adminIntValue(
        adminFirstOf(json, const [
          'ds_sts',
          'dsSts',
          'mapping_status',
          'mappingStatus',
          'is_active',
          'isActive',
          'active',
          'status',
        ]),
      ),
      dsCreated: adminDateTimeValue(adminCreatedValue(json, 'ds')),
      dsUpdate: adminDateTimeValue(adminUpdatedValue(json, 'ds')),
    );
  }

  /// Convert Model to Entity
  DeviceSensor toEntity() => DeviceSensor(
    dsId: dsId,
    devId: devId,
    unitId: unitId,
    sensId: sensId,
    dcNormalValue: dcNormalValue,
    dsMinNormValue: dsMinNormValue,
    dsMaxNormValue: dsMaxNormValue,
    dsMinValue: dsMinValue,
    dsMaxValue: dsMaxValue,
    dsMinValWarn: dsMinValWarn,
    dsMaxValWarn: dsMaxValWarn,
    dsName: dsName,
    dsAddress: dsAddress,
    dsSeq: dsSeq,
    dsSts: dsSts,
    dsCreated: dsCreated,
    dsUpdate: dsUpdate,
  );

  /// Convert Entity to Model
  factory DeviceSensorModel.fromEntity(DeviceSensor entity) =>
      DeviceSensorModel(
        dsId: entity.dsId,
        devId: entity.devId,
        unitId: entity.unitId,
        sensId: entity.sensId,
        dcNormalValue: entity.dcNormalValue,
        dsMinNormValue: entity.dsMinNormValue,
        dsMaxNormValue: entity.dsMaxNormValue,
        dsMinValue: entity.dsMinValue,
        dsMaxValue: entity.dsMaxValue,
        dsMinValWarn: entity.dsMinValWarn,
        dsMaxValWarn: entity.dsMaxValWarn,
        dsName: entity.dsName,
        dsAddress: entity.dsAddress,
        dsSeq: entity.dsSeq,
        dsSts: entity.dsSts,
        dsCreated: entity.dsCreated,
        dsUpdate: entity.dsUpdate,
      );
}

Map<String, dynamic>? _mapValue(dynamic value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is List) {
    for (final item in value) {
      if (item is Map) return Map<String, dynamic>.from(item);
    }
  }
  return null;
}
