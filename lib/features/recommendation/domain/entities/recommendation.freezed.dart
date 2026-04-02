// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Recommendation {
  String get recommendationId => throw _privateConstructorUsedError;
  RecommendationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  RecommendationPriority get priority => throw _privateConstructorUsedError;
  RecommendationStatus get status => throw _privateConstructorUsedError;
  String? get plantId => throw _privateConstructorUsedError;
  String? get plantName => throw _privateConstructorUsedError;
  String? get siteId => throw _privateConstructorUsedError;
  String? get siteName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get parameters => throw _privateConstructorUsedError;
  List<String>? get actionItems => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get appliedAt => throw _privateConstructorUsedError;
  String? get appliedBy => throw _privateConstructorUsedError;
  double? get confidenceScore => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationCopyWith<Recommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationCopyWith<$Res> {
  factory $RecommendationCopyWith(
    Recommendation value,
    $Res Function(Recommendation) then,
  ) = _$RecommendationCopyWithImpl<$Res, Recommendation>;
  @useResult
  $Res call({
    String recommendationId,
    RecommendationType type,
    String title,
    String description,
    RecommendationPriority priority,
    RecommendationStatus status,
    String? plantId,
    String? plantName,
    String? siteId,
    String? siteName,
    Map<String, dynamic>? parameters,
    List<String>? actionItems,
    DateTime? createdAt,
    DateTime? appliedAt,
    String? appliedBy,
    double? confidenceScore,
    String? reason,
  });
}

/// @nodoc
class _$RecommendationCopyWithImpl<$Res, $Val extends Recommendation>
    implements $RecommendationCopyWith<$Res> {
  _$RecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recommendation
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
                      as RecommendationType,
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
                      as RecommendationPriority,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RecommendationStatus,
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
abstract class _$$RecommendationImplCopyWith<$Res>
    implements $RecommendationCopyWith<$Res> {
  factory _$$RecommendationImplCopyWith(
    _$RecommendationImpl value,
    $Res Function(_$RecommendationImpl) then,
  ) = __$$RecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String recommendationId,
    RecommendationType type,
    String title,
    String description,
    RecommendationPriority priority,
    RecommendationStatus status,
    String? plantId,
    String? plantName,
    String? siteId,
    String? siteName,
    Map<String, dynamic>? parameters,
    List<String>? actionItems,
    DateTime? createdAt,
    DateTime? appliedAt,
    String? appliedBy,
    double? confidenceScore,
    String? reason,
  });
}

/// @nodoc
class __$$RecommendationImplCopyWithImpl<$Res>
    extends _$RecommendationCopyWithImpl<$Res, _$RecommendationImpl>
    implements _$$RecommendationImplCopyWith<$Res> {
  __$$RecommendationImplCopyWithImpl(
    _$RecommendationImpl _value,
    $Res Function(_$RecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Recommendation
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
      _$RecommendationImpl(
        recommendationId: null == recommendationId
            ? _value.recommendationId
            : recommendationId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RecommendationType,
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
                  as RecommendationPriority,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RecommendationStatus,
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

class _$RecommendationImpl extends _Recommendation {
  const _$RecommendationImpl({
    required this.recommendationId,
    required this.type,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.plantId,
    this.plantName,
    this.siteId,
    this.siteName,
    final Map<String, dynamic>? parameters,
    final List<String>? actionItems,
    this.createdAt,
    this.appliedAt,
    this.appliedBy,
    this.confidenceScore,
    this.reason,
  }) : _parameters = parameters,
       _actionItems = actionItems,
       super._();

  @override
  final String recommendationId;
  @override
  final RecommendationType type;
  @override
  final String title;
  @override
  final String description;
  @override
  final RecommendationPriority priority;
  @override
  final RecommendationStatus status;
  @override
  final String? plantId;
  @override
  final String? plantName;
  @override
  final String? siteId;
  @override
  final String? siteName;
  final Map<String, dynamic>? _parameters;
  @override
  Map<String, dynamic>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _actionItems;
  @override
  List<String>? get actionItems {
    final value = _actionItems;
    if (value == null) return null;
    if (_actionItems is EqualUnmodifiableListView) return _actionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? appliedAt;
  @override
  final String? appliedBy;
  @override
  final double? confidenceScore;
  @override
  final String? reason;

  @override
  String toString() {
    return 'Recommendation(recommendationId: $recommendationId, type: $type, title: $title, description: $description, priority: $priority, status: $status, plantId: $plantId, plantName: $plantName, siteId: $siteId, siteName: $siteName, parameters: $parameters, actionItems: $actionItems, createdAt: $createdAt, appliedAt: $appliedAt, appliedBy: $appliedBy, confidenceScore: $confidenceScore, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationImpl &&
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

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationImplCopyWith<_$RecommendationImpl> get copyWith =>
      __$$RecommendationImplCopyWithImpl<_$RecommendationImpl>(
        this,
        _$identity,
      );
}

abstract class _Recommendation extends Recommendation {
  const factory _Recommendation({
    required final String recommendationId,
    required final RecommendationType type,
    required final String title,
    required final String description,
    required final RecommendationPriority priority,
    required final RecommendationStatus status,
    final String? plantId,
    final String? plantName,
    final String? siteId,
    final String? siteName,
    final Map<String, dynamic>? parameters,
    final List<String>? actionItems,
    final DateTime? createdAt,
    final DateTime? appliedAt,
    final String? appliedBy,
    final double? confidenceScore,
    final String? reason,
  }) = _$RecommendationImpl;
  const _Recommendation._() : super._();

  @override
  String get recommendationId;
  @override
  RecommendationType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  RecommendationPriority get priority;
  @override
  RecommendationStatus get status;
  @override
  String? get plantId;
  @override
  String? get plantName;
  @override
  String? get siteId;
  @override
  String? get siteName;
  @override
  Map<String, dynamic>? get parameters;
  @override
  List<String>? get actionItems;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get appliedAt;
  @override
  String? get appliedBy;
  @override
  double? get confidenceScore;
  @override
  String? get reason;

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationImplCopyWith<_$RecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
