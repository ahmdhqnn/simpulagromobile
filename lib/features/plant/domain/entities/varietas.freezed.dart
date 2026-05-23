// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'varietas.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Varietas {
  String get varietasId => throw _privateConstructorUsedError;
  String? get varietasName => throw _privateConstructorUsedError;
  String? get varietasDesc => throw _privateConstructorUsedError;
  int get varietasStatus => throw _privateConstructorUsedError;

  /// Create a copy of Varietas
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VarietasCopyWith<Varietas> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VarietasCopyWith<$Res> {
  factory $VarietasCopyWith(Varietas value, $Res Function(Varietas) then) =
      _$VarietasCopyWithImpl<$Res, Varietas>;
  @useResult
  $Res call({
    String varietasId,
    String? varietasName,
    String? varietasDesc,
    int varietasStatus,
  });
}

/// @nodoc
class _$VarietasCopyWithImpl<$Res, $Val extends Varietas>
    implements $VarietasCopyWith<$Res> {
  _$VarietasCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Varietas
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? varietasId = null,
    Object? varietasName = freezed,
    Object? varietasDesc = freezed,
    Object? varietasStatus = null,
  }) {
    return _then(
      _value.copyWith(
            varietasId: null == varietasId
                ? _value.varietasId
                : varietasId // ignore: cast_nullable_to_non_nullable
                      as String,
            varietasName: freezed == varietasName
                ? _value.varietasName
                : varietasName // ignore: cast_nullable_to_non_nullable
                      as String?,
            varietasDesc: freezed == varietasDesc
                ? _value.varietasDesc
                : varietasDesc // ignore: cast_nullable_to_non_nullable
                      as String?,
            varietasStatus: null == varietasStatus
                ? _value.varietasStatus
                : varietasStatus // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VarietasImplCopyWith<$Res>
    implements $VarietasCopyWith<$Res> {
  factory _$$VarietasImplCopyWith(
    _$VarietasImpl value,
    $Res Function(_$VarietasImpl) then,
  ) = __$$VarietasImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String varietasId,
    String? varietasName,
    String? varietasDesc,
    int varietasStatus,
  });
}

/// @nodoc
class __$$VarietasImplCopyWithImpl<$Res>
    extends _$VarietasCopyWithImpl<$Res, _$VarietasImpl>
    implements _$$VarietasImplCopyWith<$Res> {
  __$$VarietasImplCopyWithImpl(
    _$VarietasImpl _value,
    $Res Function(_$VarietasImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Varietas
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? varietasId = null,
    Object? varietasName = freezed,
    Object? varietasDesc = freezed,
    Object? varietasStatus = null,
  }) {
    return _then(
      _$VarietasImpl(
        varietasId: null == varietasId
            ? _value.varietasId
            : varietasId // ignore: cast_nullable_to_non_nullable
                  as String,
        varietasName: freezed == varietasName
            ? _value.varietasName
            : varietasName // ignore: cast_nullable_to_non_nullable
                  as String?,
        varietasDesc: freezed == varietasDesc
            ? _value.varietasDesc
            : varietasDesc // ignore: cast_nullable_to_non_nullable
                  as String?,
        varietasStatus: null == varietasStatus
            ? _value.varietasStatus
            : varietasStatus // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$VarietasImpl extends _Varietas {
  const _$VarietasImpl({
    required this.varietasId,
    this.varietasName,
    this.varietasDesc,
    required this.varietasStatus,
  }) : super._();

  @override
  final String varietasId;
  @override
  final String? varietasName;
  @override
  final String? varietasDesc;
  @override
  final int varietasStatus;

  @override
  String toString() {
    return 'Varietas(varietasId: $varietasId, varietasName: $varietasName, varietasDesc: $varietasDesc, varietasStatus: $varietasStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VarietasImpl &&
            (identical(other.varietasId, varietasId) ||
                other.varietasId == varietasId) &&
            (identical(other.varietasName, varietasName) ||
                other.varietasName == varietasName) &&
            (identical(other.varietasDesc, varietasDesc) ||
                other.varietasDesc == varietasDesc) &&
            (identical(other.varietasStatus, varietasStatus) ||
                other.varietasStatus == varietasStatus));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    varietasId,
    varietasName,
    varietasDesc,
    varietasStatus,
  );

  /// Create a copy of Varietas
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VarietasImplCopyWith<_$VarietasImpl> get copyWith =>
      __$$VarietasImplCopyWithImpl<_$VarietasImpl>(this, _$identity);
}

abstract class _Varietas extends Varietas {
  const factory _Varietas({
    required final String varietasId,
    final String? varietasName,
    final String? varietasDesc,
    required final int varietasStatus,
  }) = _$VarietasImpl;
  const _Varietas._() : super._();

  @override
  String get varietasId;
  @override
  String? get varietasName;
  @override
  String? get varietasDesc;
  @override
  int get varietasStatus;

  /// Create a copy of Varietas
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VarietasImplCopyWith<_$VarietasImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
