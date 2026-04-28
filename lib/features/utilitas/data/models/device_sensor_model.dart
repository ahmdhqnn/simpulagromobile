// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/device_sensor.dart';

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
    @JsonKey(name: 'ds_created') DateTime? dsCreated,
    @JsonKey(name: 'ds_update') DateTime? dsUpdate,
  }) = _DeviceSensorModel;

  factory DeviceSensorModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceSensorModelFromJson(json);

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
