// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SiteModel _$SiteModelFromJson(Map<String, dynamic> json) {
  return _SiteModel.fromJson(json);
}

/// @nodoc
mixin _$SiteModel {
  @JsonKey(name: 'site_id')
  String get siteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_name')
  String? get siteName => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_address')
  String? get siteAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_lon')
  double? get siteLon => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_lat')
  double? get siteLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_alt')
  double? get siteAlt => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_sts')
  int? get siteSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_created')
  DateTime? get siteCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_update')
  DateTime? get siteUpdate => throw _privateConstructorUsedError;

  /// Serializes this SiteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SiteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SiteModelCopyWith<SiteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteModelCopyWith<$Res> {
  factory $SiteModelCopyWith(SiteModel value, $Res Function(SiteModel) then) =
      _$SiteModelCopyWithImpl<$Res, SiteModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'site_id') String siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'site_address') String? siteAddress,
    @JsonKey(name: 'site_lon') double? siteLon,
    @JsonKey(name: 'site_lat') double? siteLat,
    @JsonKey(name: 'site_alt') double? siteAlt,
    @JsonKey(name: 'site_sts') int? siteSts,
    @JsonKey(name: 'site_created') DateTime? siteCreated,
    @JsonKey(name: 'site_update') DateTime? siteUpdate,
  });
}

/// @nodoc
class _$SiteModelCopyWithImpl<$Res, $Val extends SiteModel>
    implements $SiteModelCopyWith<$Res> {
  _$SiteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SiteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteId = null,
    Object? siteName = freezed,
    Object? siteAddress = freezed,
    Object? siteLon = freezed,
    Object? siteLat = freezed,
    Object? siteAlt = freezed,
    Object? siteSts = freezed,
    Object? siteCreated = freezed,
    Object? siteUpdate = freezed,
  }) {
    return _then(
      _value.copyWith(
            siteId: null == siteId
                ? _value.siteId
                : siteId // ignore: cast_nullable_to_non_nullable
                      as String,
            siteName: freezed == siteName
                ? _value.siteName
                : siteName // ignore: cast_nullable_to_non_nullable
                      as String?,
            siteAddress: freezed == siteAddress
                ? _value.siteAddress
                : siteAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            siteLon: freezed == siteLon
                ? _value.siteLon
                : siteLon // ignore: cast_nullable_to_non_nullable
                      as double?,
            siteLat: freezed == siteLat
                ? _value.siteLat
                : siteLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            siteAlt: freezed == siteAlt
                ? _value.siteAlt
                : siteAlt // ignore: cast_nullable_to_non_nullable
                      as double?,
            siteSts: freezed == siteSts
                ? _value.siteSts
                : siteSts // ignore: cast_nullable_to_non_nullable
                      as int?,
            siteCreated: freezed == siteCreated
                ? _value.siteCreated
                : siteCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            siteUpdate: freezed == siteUpdate
                ? _value.siteUpdate
                : siteUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SiteModelImplCopyWith<$Res>
    implements $SiteModelCopyWith<$Res> {
  factory _$$SiteModelImplCopyWith(
    _$SiteModelImpl value,
    $Res Function(_$SiteModelImpl) then,
  ) = __$$SiteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'site_id') String siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'site_address') String? siteAddress,
    @JsonKey(name: 'site_lon') double? siteLon,
    @JsonKey(name: 'site_lat') double? siteLat,
    @JsonKey(name: 'site_alt') double? siteAlt,
    @JsonKey(name: 'site_sts') int? siteSts,
    @JsonKey(name: 'site_created') DateTime? siteCreated,
    @JsonKey(name: 'site_update') DateTime? siteUpdate,
  });
}

/// @nodoc
class __$$SiteModelImplCopyWithImpl<$Res>
    extends _$SiteModelCopyWithImpl<$Res, _$SiteModelImpl>
    implements _$$SiteModelImplCopyWith<$Res> {
  __$$SiteModelImplCopyWithImpl(
    _$SiteModelImpl _value,
    $Res Function(_$SiteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SiteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteId = null,
    Object? siteName = freezed,
    Object? siteAddress = freezed,
    Object? siteLon = freezed,
    Object? siteLat = freezed,
    Object? siteAlt = freezed,
    Object? siteSts = freezed,
    Object? siteCreated = freezed,
    Object? siteUpdate = freezed,
  }) {
    return _then(
      _$SiteModelImpl(
        siteId: null == siteId
            ? _value.siteId
            : siteId // ignore: cast_nullable_to_non_nullable
                  as String,
        siteName: freezed == siteName
            ? _value.siteName
            : siteName // ignore: cast_nullable_to_non_nullable
                  as String?,
        siteAddress: freezed == siteAddress
            ? _value.siteAddress
            : siteAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        siteLon: freezed == siteLon
            ? _value.siteLon
            : siteLon // ignore: cast_nullable_to_non_nullable
                  as double?,
        siteLat: freezed == siteLat
            ? _value.siteLat
            : siteLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        siteAlt: freezed == siteAlt
            ? _value.siteAlt
            : siteAlt // ignore: cast_nullable_to_non_nullable
                  as double?,
        siteSts: freezed == siteSts
            ? _value.siteSts
            : siteSts // ignore: cast_nullable_to_non_nullable
                  as int?,
        siteCreated: freezed == siteCreated
            ? _value.siteCreated
            : siteCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        siteUpdate: freezed == siteUpdate
            ? _value.siteUpdate
            : siteUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SiteModelImpl extends _SiteModel {
  const _$SiteModelImpl({
    @JsonKey(name: 'site_id') required this.siteId,
    @JsonKey(name: 'site_name') this.siteName,
    @JsonKey(name: 'site_address') this.siteAddress,
    @JsonKey(name: 'site_lon') this.siteLon,
    @JsonKey(name: 'site_lat') this.siteLat,
    @JsonKey(name: 'site_alt') this.siteAlt,
    @JsonKey(name: 'site_sts') this.siteSts,
    @JsonKey(name: 'site_created') this.siteCreated,
    @JsonKey(name: 'site_update') this.siteUpdate,
  }) : super._();

  factory _$SiteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SiteModelImplFromJson(json);

  @override
  @JsonKey(name: 'site_id')
  final String siteId;
  @override
  @JsonKey(name: 'site_name')
  final String? siteName;
  @override
  @JsonKey(name: 'site_address')
  final String? siteAddress;
  @override
  @JsonKey(name: 'site_lon')
  final double? siteLon;
  @override
  @JsonKey(name: 'site_lat')
  final double? siteLat;
  @override
  @JsonKey(name: 'site_alt')
  final double? siteAlt;
  @override
  @JsonKey(name: 'site_sts')
  final int? siteSts;
  @override
  @JsonKey(name: 'site_created')
  final DateTime? siteCreated;
  @override
  @JsonKey(name: 'site_update')
  final DateTime? siteUpdate;

  @override
  String toString() {
    return 'SiteModel(siteId: $siteId, siteName: $siteName, siteAddress: $siteAddress, siteLon: $siteLon, siteLat: $siteLat, siteAlt: $siteAlt, siteSts: $siteSts, siteCreated: $siteCreated, siteUpdate: $siteUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteModelImpl &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.siteName, siteName) ||
                other.siteName == siteName) &&
            (identical(other.siteAddress, siteAddress) ||
                other.siteAddress == siteAddress) &&
            (identical(other.siteLon, siteLon) || other.siteLon == siteLon) &&
            (identical(other.siteLat, siteLat) || other.siteLat == siteLat) &&
            (identical(other.siteAlt, siteAlt) || other.siteAlt == siteAlt) &&
            (identical(other.siteSts, siteSts) || other.siteSts == siteSts) &&
            (identical(other.siteCreated, siteCreated) ||
                other.siteCreated == siteCreated) &&
            (identical(other.siteUpdate, siteUpdate) ||
                other.siteUpdate == siteUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    siteId,
    siteName,
    siteAddress,
    siteLon,
    siteLat,
    siteAlt,
    siteSts,
    siteCreated,
    siteUpdate,
  );

  /// Create a copy of SiteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteModelImplCopyWith<_$SiteModelImpl> get copyWith =>
      __$$SiteModelImplCopyWithImpl<_$SiteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SiteModelImplToJson(this);
  }
}

abstract class _SiteModel extends SiteModel {
  const factory _SiteModel({
    @JsonKey(name: 'site_id') required final String siteId,
    @JsonKey(name: 'site_name') final String? siteName,
    @JsonKey(name: 'site_address') final String? siteAddress,
    @JsonKey(name: 'site_lon') final double? siteLon,
    @JsonKey(name: 'site_lat') final double? siteLat,
    @JsonKey(name: 'site_alt') final double? siteAlt,
    @JsonKey(name: 'site_sts') final int? siteSts,
    @JsonKey(name: 'site_created') final DateTime? siteCreated,
    @JsonKey(name: 'site_update') final DateTime? siteUpdate,
  }) = _$SiteModelImpl;
  const _SiteModel._() : super._();

  factory _SiteModel.fromJson(Map<String, dynamic> json) =
      _$SiteModelImpl.fromJson;

  @override
  @JsonKey(name: 'site_id')
  String get siteId;
  @override
  @JsonKey(name: 'site_name')
  String? get siteName;
  @override
  @JsonKey(name: 'site_address')
  String? get siteAddress;
  @override
  @JsonKey(name: 'site_lon')
  double? get siteLon;
  @override
  @JsonKey(name: 'site_lat')
  double? get siteLat;
  @override
  @JsonKey(name: 'site_alt')
  double? get siteAlt;
  @override
  @JsonKey(name: 'site_sts')
  int? get siteSts;
  @override
  @JsonKey(name: 'site_created')
  DateTime? get siteCreated;
  @override
  @JsonKey(name: 'site_update')
  DateTime? get siteUpdate;

  /// Create a copy of SiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SiteModelImplCopyWith<_$SiteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
