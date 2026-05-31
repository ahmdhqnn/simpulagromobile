// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/unit.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

@freezed
class UnitModel with _$UnitModel {
  const UnitModel._();

  const factory UnitModel({
    @JsonKey(name: 'unit_id') required String unitId,
    @JsonKey(name: 'unit_name') String? unitName,
    @JsonKey(name: 'unit_symbol') String? unitSymbol,
    @JsonKey(name: 'unit_desc') String? unitDesc,
    @JsonKey(name: 'unit_sts') int? unitSts,
    @JsonKey(name: 'unit_created') DateTime? unitCreated,
    @JsonKey(name: 'unit_update') DateTime? unitUpdate,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  /// Convert Model to Entity
  Unit toEntity() => Unit(
    unitId: unitId,
    unitName: unitName,
    unitSymbol: unitSymbol,
    unitDesc: unitDesc,
    unitSts: unitSts,
    unitCreated: unitCreated,
    unitUpdate: unitUpdate,
  );

  /// Convert Entity to Model
  factory UnitModel.fromEntity(Unit entity) => UnitModel(
    unitId: entity.unitId,
    unitName: entity.unitName,
    unitSymbol: entity.unitSymbol,
    unitDesc: entity.unitDesc,
    unitSts: entity.unitSts,
    unitCreated: entity.unitCreated,
    unitUpdate: entity.unitUpdate,
  );
}
