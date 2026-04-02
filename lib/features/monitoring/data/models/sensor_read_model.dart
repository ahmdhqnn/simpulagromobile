// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_read_model.freezed.dart';
part 'sensor_read_model.g.dart';

/// Historical sensor reading
@freezed
class SensorReadModel with _$SensorReadModel {
  const SensorReadModel._();

  const factory SensorReadModel({
    @JsonKey(name: 'read_id') required String readId,
    @JsonKey(name: 'ds_id') String? dsId,
    @JsonKey(name: 'dev_id') String? devId,
    @JsonKey(name: 'log_rx_id') String? logRxId,
    @JsonKey(name: 'read_date') DateTime? readDate,
    @JsonKey(name: 'read_value') String? readValue,
    @JsonKey(name: 'read_sts') int? readSts,
  }) = _SensorReadModel;

  factory SensorReadModel.fromJson(Map<String, dynamic> json) =>
      _$SensorReadModelFromJson(json);

  /// Parse read_value as double (handle string values from API)
  double? get valueAsDouble {
    if (readValue == null) return null;
    return double.tryParse(readValue!);
  }
}

/// Latest/Real-time sensor reading
@freezed
class SensorReadUpdateModel with _$SensorReadUpdateModel {
  const SensorReadUpdateModel._();

  const factory SensorReadUpdateModel({
    @JsonKey(name: 'read_update_id') required String readUpdateId,
    @JsonKey(name: 'ds_id') required String dsId,
    @JsonKey(name: 'dev_id') required String devId,
    @JsonKey(name: 'read_update_date') DateTime? readUpdateDate,
    @JsonKey(name: 'read_update_value') String? readUpdateValue,
  }) = _SensorReadUpdateModel;

  factory SensorReadUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$SensorReadUpdateModelFromJson(json);

  /// Parse read_update_value as double
  double? get valueAsDouble {
    if (readUpdateValue == null) return null;
    return double.tryParse(readUpdateValue!);
  }
}

/// Daily sensor aggregation
@freezed
class SensorDailyModel with _$SensorDailyModel {
  const factory SensorDailyModel({
    @JsonKey(name: 'day') required DateTime day,
    @JsonKey(name: 'dev_id') required String devId,
    @JsonKey(name: 'ds_id') required String dsId,
    @JsonKey(name: 'avg_val') double? avgVal,
    @JsonKey(name: 'min_val') double? minVal,
    @JsonKey(name: 'max_val') double? maxVal,
  }) = _SensorDailyModel;

  factory SensorDailyModel.fromJson(Map<String, dynamic> json) =>
      _$SensorDailyModelFromJson(json);
}
