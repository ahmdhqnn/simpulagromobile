// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Unit {
  String get unitId => throw _privateConstructorUsedError;
  String? get unitName => throw _privateConstructorUsedError;
  String? get unitSymbol => throw _privateConstructorUsedError;
  String? get unitDesc => throw _privateConstructorUsedError;
  int? get unitSts => throw _privateConstructorUsedError;
  DateTime? get unitCreated => throw _privateConstructorUsedError;
  DateTime? get unitUpdate => throw _privateConstructorUsedError;

  /// Create a copy of Unit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnitCopyWith<Unit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitCopyWith<$Res> {
  factory $UnitCopyWith(Unit value, $Res Function(Unit) then) =
      _$UnitCopyWithImpl<$Res, Unit>;
  @useResult
  $Res call({
    String unitId,
    String? unitName,
    String? unitSymbol,
    String? unitDesc,
    int? unitSts,
    DateTime? unitCreated,
    DateTime? unitUpdate,
  });
}

/// @nodoc
class _$UnitCopyWithImpl<$Res, $Val extends Unit>
    implements $UnitCopyWith<$Res> {
  _$UnitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Unit
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
abstract class _$$UnitImplCopyWith<$Res> implements $UnitCopyWith<$Res> {
  factory _$$UnitImplCopyWith(
    _$UnitImpl value,
    $Res Function(_$UnitImpl) then,
  ) = __$$UnitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String unitId,
    String? unitName,
    String? unitSymbol,
    String? unitDesc,
    int? unitSts,
    DateTime? unitCreated,
    DateTime? unitUpdate,
  });
}

/// @nodoc
class __$$UnitImplCopyWithImpl<$Res>
    extends _$UnitCopyWithImpl<$Res, _$UnitImpl>
    implements _$$UnitImplCopyWith<$Res> {
  __$$UnitImplCopyWithImpl(_$UnitImpl _value, $Res Function(_$UnitImpl) _then)
    : super(_value, _then);

  /// Create a copy of Unit
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
      _$UnitImpl(
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

class _$UnitImpl extends _Unit {
  const _$UnitImpl({
    required this.unitId,
    this.unitName,
    this.unitSymbol,
    this.unitDesc,
    this.unitSts,
    this.unitCreated,
    this.unitUpdate,
  }) : super._();

  @override
  final String unitId;
  @override
  final String? unitName;
  @override
  final String? unitSymbol;
  @override
  final String? unitDesc;
  @override
  final int? unitSts;
  @override
  final DateTime? unitCreated;
  @override
  final DateTime? unitUpdate;

  @override
  String toString() {
    return 'Unit(unitId: $unitId, unitName: $unitName, unitSymbol: $unitSymbol, unitDesc: $unitDesc, unitSts: $unitSts, unitCreated: $unitCreated, unitUpdate: $unitUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitImpl &&
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

  /// Create a copy of Unit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitImplCopyWith<_$UnitImpl> get copyWith =>
      __$$UnitImplCopyWithImpl<_$UnitImpl>(this, _$identity);
}

abstract class _Unit extends Unit {
  const factory _Unit({
    required final String unitId,
    final String? unitName,
    final String? unitSymbol,
    final String? unitDesc,
    final int? unitSts,
    final DateTime? unitCreated,
    final DateTime? unitUpdate,
  }) = _$UnitImpl;
  const _Unit._() : super._();

  @override
  String get unitId;
  @override
  String? get unitName;
  @override
  String? get unitSymbol;
  @override
  String? get unitDesc;
  @override
  int? get unitSts;
  @override
  DateTime? get unitCreated;
  @override
  DateTime? get unitUpdate;

  /// Create a copy of Unit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitImplCopyWith<_$UnitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
