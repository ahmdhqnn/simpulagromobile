// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlantModel _$PlantModelFromJson(Map<String, dynamic> json) {
  return _PlantModel.fromJson(json);
}

/// @nodoc
mixin _$PlantModel {
  @JsonKey(name: 'plant_id')
  String get plantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_id')
  String? get siteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'varietas_id')
  String? get varietasId => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_name')
  String? get plantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_type')
  CropType? get plantType => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_species')
  String? get plantSpecies => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_date')
  DateTime? get plantDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_harvest')
  DateTime? get plantHarvest => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_sts')
  int? get plantSts => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_created')
  DateTime? get plantCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_update')
  DateTime? get plantUpdate => throw _privateConstructorUsedError;

  /// Serializes this PlantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlantModelCopyWith<PlantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantModelCopyWith<$Res> {
  factory $PlantModelCopyWith(
    PlantModel value,
    $Res Function(PlantModel) then,
  ) = _$PlantModelCopyWithImpl<$Res, PlantModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'plant_id') String plantId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'varietas_id') String? varietasId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'plant_type') CropType? plantType,
    @JsonKey(name: 'plant_species') String? plantSpecies,
    @JsonKey(name: 'plant_date') DateTime? plantDate,
    @JsonKey(name: 'plant_harvest') DateTime? plantHarvest,
    @JsonKey(name: 'plant_sts') int? plantSts,
    @JsonKey(name: 'plant_created') DateTime? plantCreated,
    @JsonKey(name: 'plant_update') DateTime? plantUpdate,
  });
}

/// @nodoc
class _$PlantModelCopyWithImpl<$Res, $Val extends PlantModel>
    implements $PlantModelCopyWith<$Res> {
  _$PlantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? siteId = freezed,
    Object? varietasId = freezed,
    Object? plantName = freezed,
    Object? plantType = freezed,
    Object? plantSpecies = freezed,
    Object? plantDate = freezed,
    Object? plantHarvest = freezed,
    Object? plantSts = freezed,
    Object? plantCreated = freezed,
    Object? plantUpdate = freezed,
  }) {
    return _then(
      _value.copyWith(
            plantId: null == plantId
                ? _value.plantId
                : plantId // ignore: cast_nullable_to_non_nullable
                      as String,
            siteId: freezed == siteId
                ? _value.siteId
                : siteId // ignore: cast_nullable_to_non_nullable
                      as String?,
            varietasId: freezed == varietasId
                ? _value.varietasId
                : varietasId // ignore: cast_nullable_to_non_nullable
                      as String?,
            plantName: freezed == plantName
                ? _value.plantName
                : plantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            plantType: freezed == plantType
                ? _value.plantType
                : plantType // ignore: cast_nullable_to_non_nullable
                      as CropType?,
            plantSpecies: freezed == plantSpecies
                ? _value.plantSpecies
                : plantSpecies // ignore: cast_nullable_to_non_nullable
                      as String?,
            plantDate: freezed == plantDate
                ? _value.plantDate
                : plantDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            plantHarvest: freezed == plantHarvest
                ? _value.plantHarvest
                : plantHarvest // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            plantSts: freezed == plantSts
                ? _value.plantSts
                : plantSts // ignore: cast_nullable_to_non_nullable
                      as int?,
            plantCreated: freezed == plantCreated
                ? _value.plantCreated
                : plantCreated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            plantUpdate: freezed == plantUpdate
                ? _value.plantUpdate
                : plantUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlantModelImplCopyWith<$Res>
    implements $PlantModelCopyWith<$Res> {
  factory _$$PlantModelImplCopyWith(
    _$PlantModelImpl value,
    $Res Function(_$PlantModelImpl) then,
  ) = __$$PlantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'plant_id') String plantId,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'varietas_id') String? varietasId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'plant_type') CropType? plantType,
    @JsonKey(name: 'plant_species') String? plantSpecies,
    @JsonKey(name: 'plant_date') DateTime? plantDate,
    @JsonKey(name: 'plant_harvest') DateTime? plantHarvest,
    @JsonKey(name: 'plant_sts') int? plantSts,
    @JsonKey(name: 'plant_created') DateTime? plantCreated,
    @JsonKey(name: 'plant_update') DateTime? plantUpdate,
  });
}

/// @nodoc
class __$$PlantModelImplCopyWithImpl<$Res>
    extends _$PlantModelCopyWithImpl<$Res, _$PlantModelImpl>
    implements _$$PlantModelImplCopyWith<$Res> {
  __$$PlantModelImplCopyWithImpl(
    _$PlantModelImpl _value,
    $Res Function(_$PlantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? siteId = freezed,
    Object? varietasId = freezed,
    Object? plantName = freezed,
    Object? plantType = freezed,
    Object? plantSpecies = freezed,
    Object? plantDate = freezed,
    Object? plantHarvest = freezed,
    Object? plantSts = freezed,
    Object? plantCreated = freezed,
    Object? plantUpdate = freezed,
  }) {
    return _then(
      _$PlantModelImpl(
        plantId: null == plantId
            ? _value.plantId
            : plantId // ignore: cast_nullable_to_non_nullable
                  as String,
        siteId: freezed == siteId
            ? _value.siteId
            : siteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        varietasId: freezed == varietasId
            ? _value.varietasId
            : varietasId // ignore: cast_nullable_to_non_nullable
                  as String?,
        plantName: freezed == plantName
            ? _value.plantName
            : plantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        plantType: freezed == plantType
            ? _value.plantType
            : plantType // ignore: cast_nullable_to_non_nullable
                  as CropType?,
        plantSpecies: freezed == plantSpecies
            ? _value.plantSpecies
            : plantSpecies // ignore: cast_nullable_to_non_nullable
                  as String?,
        plantDate: freezed == plantDate
            ? _value.plantDate
            : plantDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        plantHarvest: freezed == plantHarvest
            ? _value.plantHarvest
            : plantHarvest // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        plantSts: freezed == plantSts
            ? _value.plantSts
            : plantSts // ignore: cast_nullable_to_non_nullable
                  as int?,
        plantCreated: freezed == plantCreated
            ? _value.plantCreated
            : plantCreated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        plantUpdate: freezed == plantUpdate
            ? _value.plantUpdate
            : plantUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantModelImpl extends _PlantModel {
  const _$PlantModelImpl({
    @JsonKey(name: 'plant_id') required this.plantId,
    @JsonKey(name: 'site_id') this.siteId,
    @JsonKey(name: 'varietas_id') this.varietasId,
    @JsonKey(name: 'plant_name') this.plantName,
    @JsonKey(name: 'plant_type') this.plantType,
    @JsonKey(name: 'plant_species') this.plantSpecies,
    @JsonKey(name: 'plant_date') this.plantDate,
    @JsonKey(name: 'plant_harvest') this.plantHarvest,
    @JsonKey(name: 'plant_sts') this.plantSts,
    @JsonKey(name: 'plant_created') this.plantCreated,
    @JsonKey(name: 'plant_update') this.plantUpdate,
  }) : super._();

  factory _$PlantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantModelImplFromJson(json);

  @override
  @JsonKey(name: 'plant_id')
  final String plantId;
  @override
  @JsonKey(name: 'site_id')
  final String? siteId;
  @override
  @JsonKey(name: 'varietas_id')
  final String? varietasId;
  @override
  @JsonKey(name: 'plant_name')
  final String? plantName;
  @override
  @JsonKey(name: 'plant_type')
  final CropType? plantType;
  @override
  @JsonKey(name: 'plant_species')
  final String? plantSpecies;
  @override
  @JsonKey(name: 'plant_date')
  final DateTime? plantDate;
  @override
  @JsonKey(name: 'plant_harvest')
  final DateTime? plantHarvest;
  @override
  @JsonKey(name: 'plant_sts')
  final int? plantSts;
  @override
  @JsonKey(name: 'plant_created')
  final DateTime? plantCreated;
  @override
  @JsonKey(name: 'plant_update')
  final DateTime? plantUpdate;

  @override
  String toString() {
    return 'PlantModel(plantId: $plantId, siteId: $siteId, varietasId: $varietasId, plantName: $plantName, plantType: $plantType, plantSpecies: $plantSpecies, plantDate: $plantDate, plantHarvest: $plantHarvest, plantSts: $plantSts, plantCreated: $plantCreated, plantUpdate: $plantUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantModelImpl &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.varietasId, varietasId) ||
                other.varietasId == varietasId) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.plantType, plantType) ||
                other.plantType == plantType) &&
            (identical(other.plantSpecies, plantSpecies) ||
                other.plantSpecies == plantSpecies) &&
            (identical(other.plantDate, plantDate) ||
                other.plantDate == plantDate) &&
            (identical(other.plantHarvest, plantHarvest) ||
                other.plantHarvest == plantHarvest) &&
            (identical(other.plantSts, plantSts) ||
                other.plantSts == plantSts) &&
            (identical(other.plantCreated, plantCreated) ||
                other.plantCreated == plantCreated) &&
            (identical(other.plantUpdate, plantUpdate) ||
                other.plantUpdate == plantUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    plantId,
    siteId,
    varietasId,
    plantName,
    plantType,
    plantSpecies,
    plantDate,
    plantHarvest,
    plantSts,
    plantCreated,
    plantUpdate,
  );

  /// Create a copy of PlantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantModelImplCopyWith<_$PlantModelImpl> get copyWith =>
      __$$PlantModelImplCopyWithImpl<_$PlantModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantModelImplToJson(this);
  }
}

abstract class _PlantModel extends PlantModel {
  const factory _PlantModel({
    @JsonKey(name: 'plant_id') required final String plantId,
    @JsonKey(name: 'site_id') final String? siteId,
    @JsonKey(name: 'varietas_id') final String? varietasId,
    @JsonKey(name: 'plant_name') final String? plantName,
    @JsonKey(name: 'plant_type') final CropType? plantType,
    @JsonKey(name: 'plant_species') final String? plantSpecies,
    @JsonKey(name: 'plant_date') final DateTime? plantDate,
    @JsonKey(name: 'plant_harvest') final DateTime? plantHarvest,
    @JsonKey(name: 'plant_sts') final int? plantSts,
    @JsonKey(name: 'plant_created') final DateTime? plantCreated,
    @JsonKey(name: 'plant_update') final DateTime? plantUpdate,
  }) = _$PlantModelImpl;
  const _PlantModel._() : super._();

  factory _PlantModel.fromJson(Map<String, dynamic> json) =
      _$PlantModelImpl.fromJson;

  @override
  @JsonKey(name: 'plant_id')
  String get plantId;
  @override
  @JsonKey(name: 'site_id')
  String? get siteId;
  @override
  @JsonKey(name: 'varietas_id')
  String? get varietasId;
  @override
  @JsonKey(name: 'plant_name')
  String? get plantName;
  @override
  @JsonKey(name: 'plant_type')
  CropType? get plantType;
  @override
  @JsonKey(name: 'plant_species')
  String? get plantSpecies;
  @override
  @JsonKey(name: 'plant_date')
  DateTime? get plantDate;
  @override
  @JsonKey(name: 'plant_harvest')
  DateTime? get plantHarvest;
  @override
  @JsonKey(name: 'plant_sts')
  int? get plantSts;
  @override
  @JsonKey(name: 'plant_created')
  DateTime? get plantCreated;
  @override
  @JsonKey(name: 'plant_update')
  DateTime? get plantUpdate;

  /// Create a copy of PlantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlantModelImplCopyWith<_$PlantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
