// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) {
  return _UnitModel.fromJson(json);
}

/// @nodoc
mixin _$UnitModel {
  @JsonKey(name: 'unit_id')
  String get unitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_name')
  String? get unitName => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_symbol')
  String? get unitSymbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_desc')
  String? get unitDesc => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_sts')
  int? get unitSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_created')
  DateTime? get unitCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_update')
  DateTime? get unitUpdate => throw _privateConstructorUsedError;

  /// Serializes this UnitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnitModelCopyWith<UnitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitModelCopyWith<$Res> {
  factory $UnitModelCopyWith(UnitModel value, $Res Function(UnitModel) then) =
      _$UnitModelCopyWithImpl<$Res, UnitModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'unit_id') String unitId,
    @JsonKey(name: 'unit_name') String? unitName,
    @JsonKey(name: 'unit_symbol') String? unitSymbol,
    @JsonKey(name: 'unit_desc') String? unitDesc,
    @JsonKey(name: 'unit_sts') int? unitSts,
    @JsonKey(name: 'unit_created') DateTime? unitCreated,
    @JsonKey(name: 'unit_update') DateTime? unitUpdate,
  });
}

/// @nodoc
class _$UnitModelCopyWithImpl<$Res, $Val extends UnitModel>
    implements $UnitModelCopyWith<$Res> {
  _$UnitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unitId = null,
    Object? unitName = freezed,
    Object? unitSymbol = freezed,
    Object? unitDesc = freezed,
    Object? unitSts = freezed,
    Object? unitCreated = freezed,
    Object? unitUpdate = freezed,
  }) {
    return _then(
      _value.copyWith(
            unitId: null == unitId
                ? _value.unitId
                : unitId // ignore: cast_nullable_to_non_nullable
                      as String,
            unitName: freezed == unitName
                ? _value.unitName
                : unitName // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitSymbol: freezed == unitSymbol
                ? _value.unitSymbol
                : unitSymbol // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitDesc: freezed == unitDesc
                ? _value.unitDesc
                : unitDesc // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitSts: freezed == unitSts
                ? _value.unitSts
                : unitSts // ignore: cast_nullable_to_non_nullable
                      as int?,
            unitCreated: freezed == unitCreated
                ? _value.unitCreated
                : unitCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            unitUpdate: freezed == unitUpdate
                ? _value.unitUpdate
                : unitUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UnitModelImplCopyWith<$Res>
    implements $UnitModelCopyWith<$Res> {
  factory _$$UnitModelImplCopyWith(
    _$UnitModelImpl value,
    $Res Function(_$UnitModelImpl) then,
  ) = __$$UnitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'unit_id') String unitId,
    @JsonKey(name: 'unit_name') String? unitName,
    @JsonKey(name: 'unit_symbol') String? unitSymbol,
    @JsonKey(name: 'unit_desc') String? unitDesc,
    @JsonKey(name: 'unit_sts') int? unitSts,
    @JsonKey(name: 'unit_created') DateTime? unitCreated,
    @JsonKey(name: 'unit_update') DateTime? unitUpdate,
  });
}

/// @nodoc
class __$$UnitModelImplCopyWithImpl<$Res>
    extends _$UnitModelCopyWithImpl<$Res, _$UnitModelImpl>
    implements _$$UnitModelImplCopyWith<$Res> {
  __$$UnitModelImplCopyWithImpl(
    _$UnitModelImpl _value,
    $Res Function(_$UnitModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unitId = null,
    Object? unitName = freezed,
    Object? unitSymbol = freezed,
    Object? unitDesc = freezed,
    Object? unitSts = freezed,
    Object? unitCreated = freezed,
    Object? unitUpdate = freezed,
  }) {
    return _then(
      _$UnitModelImpl(
        unitId: null == unitId
            ? _value.unitId
            : unitId // ignore: cast_nullable_to_non_nullable
                  as String,
        unitName: freezed == unitName
            ? _value.unitName
            : unitName // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitSymbol: freezed == unitSymbol
            ? _value.unitSymbol
            : unitSymbol // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitDesc: freezed == unitDesc
            ? _value.unitDesc
            : unitDesc // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitSts: freezed == unitSts
            ? _value.unitSts
            : unitSts // ignore: cast_nullable_to_non_nullable
                  as int?,
        unitCreated: freezed == unitCreated
            ? _value.unitCreated
            : unitCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        unitUpdate: freezed == unitUpdate
            ? _value.unitUpdate
            : unitUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UnitModelImpl extends _UnitModel {
  const _$UnitModelImpl({
    @JsonKey(name: 'unit_id') required this.unitId,
    @JsonKey(name: 'unit_name') this.unitName,
    @JsonKey(name: 'unit_symbol') this.unitSymbol,
    @JsonKey(name: 'unit_desc') this.unitDesc,
    @JsonKey(name: 'unit_sts') this.unitSts,
    @JsonKey(name: 'unit_created') this.unitCreated,
    @JsonKey(name: 'unit_update') this.unitUpdate,
  }) : super._();

  factory _$UnitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitModelImplFromJson(json);

  @override
  @JsonKey(name: 'unit_id')
  final String unitId;
  @override
  @JsonKey(name: 'unit_name')
  final String? unitName;
  @override
  @JsonKey(name: 'unit_symbol')
  final String? unitSymbol;
  @override
  @JsonKey(name: 'unit_desc')
  final String? unitDesc;
  @override
  @JsonKey(name: 'unit_sts')
  final int? unitSts;
  @override
  @JsonKey(name: 'unit_created')
  final DateTime? unitCreated;
  @override
  @JsonKey(name: 'unit_update')
  final DateTime? unitUpdate;

  @override
  String toString() {
    return 'UnitModel(unitId: $unitId, unitName: $unitName, unitSymbol: $unitSymbol, unitDesc: $unitDesc, unitSts: $unitSts, unitCreated: $unitCreated, unitUpdate: $unitUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitModelImpl &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.unitName, unitName) ||
                other.unitName == unitName) &&
            (identical(other.unitSymbol, unitSymbol) ||
                other.unitSymbol == unitSymbol) &&
            (identical(other.unitDesc, unitDesc) ||
                other.unitDesc == unitDesc) &&
            (identical(other.unitSts, unitSts) || other.unitSts == unitSts) &&
            (identical(other.unitCreated, unitCreated) ||
                other.unitCreated == unitCreated) &&
            (identical(other.unitUpdate, unitUpdate) ||
                other.unitUpdate == unitUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    unitId,
    unitName,
    unitSymbol,
    unitDesc,
    unitSts,
    unitCreated,
    unitUpdate,
  );

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitModelImplCopyWith<_$UnitModelImpl> get copyWith =>
      __$$UnitModelImplCopyWithImpl<_$UnitModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnitModelImplToJson(this);
  }
}

abstract class _UnitModel extends UnitModel {
  const factory _UnitModel({
    @JsonKey(name: 'unit_id') required final String unitId,
    @JsonKey(name: 'unit_name') final String? unitName,
    @JsonKey(name: 'unit_symbol') final String? unitSymbol,
    @JsonKey(name: 'unit_desc') final String? unitDesc,
    @JsonKey(name: 'unit_sts') final int? unitSts,
    @JsonKey(name: 'unit_created') final DateTime? unitCreated,
    @JsonKey(name: 'unit_update') final DateTime? unitUpdate,
  }) = _$UnitModelImpl;
  const _UnitModel._() : super._();

  factory _UnitModel.fromJson(Map<String, dynamic> json) =
      _$UnitModelImpl.fromJson;

  @override
  @JsonKey(name: 'unit_id')
  String get unitId;
  @override
  @JsonKey(name: 'unit_name')
  String? get unitName;
  @override
  @JsonKey(name: 'unit_symbol')
  String? get unitSymbol;
  @override
  @JsonKey(name: 'unit_desc')
  String? get unitDesc;
  @override
  @JsonKey(name: 'unit_sts')
  int? get unitSts;
  @override
  @JsonKey(name: 'unit_created')
  DateTime? get unitCreated;
  @override
  @JsonKey(name: 'unit_update')
  DateTime? get unitUpdate;

  /// Create a copy of UnitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitModelImplCopyWith<_$UnitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
