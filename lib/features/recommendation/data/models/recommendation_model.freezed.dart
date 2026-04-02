// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecommendationModel _$RecommendationModelFromJson(Map<String, dynamic> json) {
  return _RecommendationModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendationModel {
  @JsonKey(name: 'recommendation_id')
  String get recommendationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'priority')
  String get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_id')
  String? get plantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'plant_name')
  String? get plantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_id')
  String? get siteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_name')
  String? get siteName => throw _privateConstructorUsedError;
  @JsonKey(name: 'parameters')
  Map<String, dynamic>? get parameters => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_items')
  List<String>? get actionItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'applied_at')
  DateTime? get appliedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'applied_by')
  String? get appliedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'confidence_score')
  double? get confidenceScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'reason')
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this RecommendationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationModelCopyWith<RecommendationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationModelCopyWith<$Res> {
  factory $RecommendationModelCopyWith(
    RecommendationModel value,
    $Res Function(RecommendationModel) then,
  ) = _$RecommendationModelCopyWithImpl<$Res, RecommendationModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'recommendation_id') String recommendationId,
    @JsonKey(name: 'type') String type,
    @JsonKey(name: 'title') String title,
    @JsonKey(name: 'description') String description,
    @JsonKey(name: 'priority') String priority,
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'plant_id') String? plantId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'parameters') Map<String, dynamic>? parameters,
    @JsonKey(name: 'action_items') List<String>? actionItems,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'applied_at') DateTime? appliedAt,
    @JsonKey(name: 'applied_by') String? appliedBy,
    @JsonKey(name: 'confidence_score') double? confidenceScore,
    @JsonKey(name: 'reason') String? reason,
  });
}

/// @nodoc
class _$RecommendationModelCopyWithImpl<$Res, $Val extends RecommendationModel>
    implements $RecommendationModelCopyWith<$Res> {
  _$RecommendationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendationId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? status = null,
    Object? plantId = freezed,
    Object? plantName = freezed,
    Object? siteId = freezed,
    Object? siteName = freezed,
    Object? parameters = freezed,
    Object? actionItems = freezed,
    Object? createdAt = freezed,
    Object? appliedAt = freezed,
    Object? appliedBy = freezed,
    Object? confidenceScore = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      _value.copyWith(
            recommendationId: null == recommendationId
                ? _value.recommendationId
                : recommendationId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            plantId: freezed == plantId
                ? _value.plantId
                : plantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            plantName: freezed == plantName
                ? _value.plantName
                : plantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            siteId: freezed == siteId
                ? _value.siteId
                : siteId // ignore: cast_nullable_to_non_nullable
                      as String?,
            siteName: freezed == siteName
                ? _value.siteName
                : siteName // ignore: cast_nullable_to_non_nullable
                      as String?,
            parameters: freezed == parameters
                ? _value.parameters
                : parameters // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            actionItems: freezed == actionItems
                ? _value.actionItems
                : actionItems // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            appliedAt: freezed == appliedAt
                ? _value.appliedAt
                : appliedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            appliedBy: freezed == appliedBy
                ? _value.appliedBy
                : appliedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            confidenceScore: freezed == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecommendationModelImplCopyWith<$Res>
    implements $RecommendationModelCopyWith<$Res> {
  factory _$$RecommendationModelImplCopyWith(
    _$RecommendationModelImpl value,
    $Res Function(_$RecommendationModelImpl) then,
  ) = __$$RecommendationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'recommendation_id') String recommendationId,
    @JsonKey(name: 'type') String type,
    @JsonKey(name: 'title') String title,
    @JsonKey(name: 'description') String description,
    @JsonKey(name: 'priority') String priority,
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'plant_id') String? plantId,
    @JsonKey(name: 'plant_name') String? plantName,
    @JsonKey(name: 'site_id') String? siteId,
    @JsonKey(name: 'site_name') String? siteName,
    @JsonKey(name: 'parameters') Map<String, dynamic>? parameters,
    @JsonKey(name: 'action_items') List<String>? actionItems,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'applied_at') DateTime? appliedAt,
    @JsonKey(name: 'applied_by') String? appliedBy,
    @JsonKey(name: 'confidence_score') double? confidenceScore,
    @JsonKey(name: 'reason') String? reason,
  });
}

/// @nodoc
class __$$RecommendationModelImplCopyWithImpl<$Res>
    extends _$RecommendationModelCopyWithImpl<$Res, _$RecommendationModelImpl>
    implements _$$RecommendationModelImplCopyWith<$Res> {
  __$$RecommendationModelImplCopyWithImpl(
    _$RecommendationModelImpl _value,
    $Res Function(_$RecommendationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendationId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? status = null,
    Object? plantId = freezed,
    Object? plantName = freezed,
    Object? siteId = freezed,
    Object? siteName = freezed,
    Object? parameters = freezed,
    Object? actionItems = freezed,
    Object? createdAt = freezed,
    Object? appliedAt = freezed,
    Object? appliedBy = freezed,
    Object? confidenceScore = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      _$RecommendationModelImpl(
        recommendationId: null == recommendationId
            ? _value.recommendationId
            : recommendationId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        plantId: freezed == plantId
            ? _value.plantId
            : plantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        plantName: freezed == plantName
            ? _value.plantName
            : plantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        siteId: freezed == siteId
            ? _value.siteId
            : siteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        siteName: freezed == siteName
            ? _value.siteName
            : siteName // ignore: cast_nullable_to_non_nullable
                  as String?,
        parameters: freezed == parameters
            ? _value._parameters
            : parameters // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        actionItems: freezed == actionItems
            ? _value._actionItems
            : actionItems // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        appliedAt: freezed == appliedAt
            ? _value.appliedAt
            : appliedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        appliedBy: freezed == appliedBy
            ? _value.appliedBy
            : appliedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        confidenceScore: freezed == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationModelImpl extends _RecommendationModel {
  const _$RecommendationModelImpl({
    @JsonKey(name: 'recommendation_id') required this.recommendationId,
    @JsonKey(name: 'type') required this.type,
    @JsonKey(name: 'title') required this.title,
    @JsonKey(name: 'description') required this.description,
    @JsonKey(name: 'priority') required this.priority,
    @JsonKey(name: 'status') required this.status,
    @JsonKey(name: 'plant_id') this.plantId,
    @JsonKey(name: 'plant_name') this.plantName,
    @JsonKey(name: 'site_id') this.siteId,
    @JsonKey(name: 'site_name') this.siteName,
    @JsonKey(name: 'parameters') final Map<String, dynamic>? parameters,
    @JsonKey(name: 'action_items') final List<String>? actionItems,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'applied_at') this.appliedAt,
    @JsonKey(name: 'applied_by') this.appliedBy,
    @JsonKey(name: 'confidence_score') this.confidenceScore,
    @JsonKey(name: 'reason') this.reason,
  }) : _parameters = parameters,
       _actionItems = actionItems,
       super._();

  factory _$RecommendationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationModelImplFromJson(json);

  @override
  @JsonKey(name: 'recommendation_id')
  final String recommendationId;
  @override
  @JsonKey(name: 'type')
  final String type;
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'description')
  final String description;
  @override
  @JsonKey(name: 'priority')
  final String priority;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'plant_id')
  final String? plantId;
  @override
  @JsonKey(name: 'plant_name')
  final String? plantName;
  @override
  @JsonKey(name: 'site_id')
  final String? siteId;
  @override
  @JsonKey(name: 'site_name')
  final String? siteName;
  final Map<String, dynamic>? _parameters;
  @override
  @JsonKey(name: 'parameters')
  Map<String, dynamic>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _actionItems;
  @override
  @JsonKey(name: 'action_items')
  List<String>? get actionItems {
    final value = _actionItems;
    if (value == null) return null;
    if (_actionItems is EqualUnmodifiableListView) return _actionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'applied_at')
  final DateTime? appliedAt;
  @override
  @JsonKey(name: 'applied_by')
  final String? appliedBy;
  @override
  @JsonKey(name: 'confidence_score')
  final double? confidenceScore;
  @override
  @JsonKey(name: 'reason')
  final String? reason;

  @override
  String toString() {
    return 'RecommendationModel(recommendationId: $recommendationId, type: $type, title: $title, description: $description, priority: $priority, status: $status, plantId: $plantId, plantName: $plantName, siteId: $siteId, siteName: $siteName, parameters: $parameters, actionItems: $actionItems, createdAt: $createdAt, appliedAt: $appliedAt, appliedBy: $appliedBy, confidenceScore: $confidenceScore, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationModelImpl &&
            (identical(other.recommendationId, recommendationId) ||
                other.recommendationId == recommendationId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.siteName, siteName) ||
                other.siteName == siteName) &&
            const DeepCollectionEquality().equals(
              other._parameters,
              _parameters,
            ) &&
            const DeepCollectionEquality().equals(
              other._actionItems,
              _actionItems,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            (identical(other.appliedBy, appliedBy) ||
                other.appliedBy == appliedBy) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    recommendationId,
    type,
    title,
    description,
    priority,
    status,
    plantId,
    plantName,
    siteId,
    siteName,
    const DeepCollectionEquality().hash(_parameters),
    const DeepCollectionEquality().hash(_actionItems),
    createdAt,
    appliedAt,
    appliedBy,
    confidenceScore,
    reason,
  );

  /// Create a copy of RecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationModelImplCopyWith<_$RecommendationModelImpl> get copyWith =>
      __$$RecommendationModelImplCopyWithImpl<_$RecommendationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationModelImplToJson(this);
  }
}

abstract class _RecommendationModel extends RecommendationModel {
  const factory _RecommendationModel({
    @JsonKey(name: 'recommendation_id') required final String recommendationId,
    @JsonKey(name: 'type') required final String type,
    @JsonKey(name: 'title') required final String title,
    @JsonKey(name: 'description') required final String description,
    @JsonKey(name: 'priority') required final String priority,
    @JsonKey(name: 'status') required final String status,
    @JsonKey(name: 'plant_id') final String? plantId,
    @JsonKey(name: 'plant_name') final String? plantName,
    @JsonKey(name: 'site_id') final String? siteId,
    @JsonKey(name: 'site_name') final String? siteName,
    @JsonKey(name: 'parameters') final Map<String, dynamic>? parameters,
    @JsonKey(name: 'action_items') final List<String>? actionItems,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'applied_at') final DateTime? appliedAt,
    @JsonKey(name: 'applied_by') final String? appliedBy,
    @JsonKey(name: 'confidence_score') final double? confidenceScore,
    @JsonKey(name: 'reason') final String? reason,
  }) = _$RecommendationModelImpl;
  const _RecommendationModel._() : super._();

  factory _RecommendationModel.fromJson(Map<String, dynamic> json) =
      _$RecommendationModelImpl.fromJson;

  @override
  @JsonKey(name: 'recommendation_id')
  String get recommendationId;
  @override
  @JsonKey(name: 'type')
  String get type;
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(name: 'priority')
  String get priority;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'plant_id')
  String? get plantId;
  @override
  @JsonKey(name: 'plant_name')
  String? get plantName;
  @override
  @JsonKey(name: 'site_id')
  String? get siteId;
  @override
  @JsonKey(name: 'site_name')
  String? get siteName;
  @override
  @JsonKey(name: 'parameters')
  Map<String, dynamic>? get parameters;
  @override
  @JsonKey(name: 'action_items')
  List<String>? get actionItems;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'applied_at')
  DateTime? get appliedAt;
  @override
  @JsonKey(name: 'applied_by')
  String? get appliedBy;
  @override
  @JsonKey(name: 'confidence_score')
  double? get confidenceScore;
  @override
  @JsonKey(name: 'reason')
  String? get reason;

  /// Create a copy of RecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationModelImplCopyWith<_$RecommendationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
