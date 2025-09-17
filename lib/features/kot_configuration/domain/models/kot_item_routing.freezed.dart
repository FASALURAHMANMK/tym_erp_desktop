// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kot_item_routing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KotItemRouting _$KotItemRoutingFromJson(Map<String, dynamic> json) {
  return _KotItemRouting.fromJson(json);
}

/// @nodoc
mixin _$KotItemRouting {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get stationId => throw _privateConstructorUsedError;
  String? get categoryId =>
      throw _privateConstructorUsedError; // route all items in category
  String? get productId =>
      throw _privateConstructorUsedError; // route specific product
  String? get variationId =>
      throw _privateConstructorUsedError; // route specific variation
  int get priority =>
      throw _privateConstructorUsedError; // routing priority (higher = more specific)
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this KotItemRouting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KotItemRouting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KotItemRoutingCopyWith<KotItemRouting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KotItemRoutingCopyWith<$Res> {
  factory $KotItemRoutingCopyWith(
    KotItemRouting value,
    $Res Function(KotItemRouting) then,
  ) = _$KotItemRoutingCopyWithImpl<$Res, KotItemRouting>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String stationId,
    String? categoryId,
    String? productId,
    String? variationId,
    int priority,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$KotItemRoutingCopyWithImpl<$Res, $Val extends KotItemRouting>
    implements $KotItemRoutingCopyWith<$Res> {
  _$KotItemRoutingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KotItemRouting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? stationId = null,
    Object? categoryId = freezed,
    Object? productId = freezed,
    Object? variationId = freezed,
    Object? priority = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            businessId:
                null == businessId
                    ? _value.businessId
                    : businessId // ignore: cast_nullable_to_non_nullable
                        as String,
            locationId:
                null == locationId
                    ? _value.locationId
                    : locationId // ignore: cast_nullable_to_non_nullable
                        as String,
            stationId:
                null == stationId
                    ? _value.stationId
                    : stationId // ignore: cast_nullable_to_non_nullable
                        as String,
            categoryId:
                freezed == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            variationId:
                freezed == variationId
                    ? _value.variationId
                    : variationId // ignore: cast_nullable_to_non_nullable
                        as String?,
            priority:
                null == priority
                    ? _value.priority
                    : priority // ignore: cast_nullable_to_non_nullable
                        as int,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            hasUnsyncedChanges:
                null == hasUnsyncedChanges
                    ? _value.hasUnsyncedChanges
                    : hasUnsyncedChanges // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KotItemRoutingImplCopyWith<$Res>
    implements $KotItemRoutingCopyWith<$Res> {
  factory _$$KotItemRoutingImplCopyWith(
    _$KotItemRoutingImpl value,
    $Res Function(_$KotItemRoutingImpl) then,
  ) = __$$KotItemRoutingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String stationId,
    String? categoryId,
    String? productId,
    String? variationId,
    int priority,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$KotItemRoutingImplCopyWithImpl<$Res>
    extends _$KotItemRoutingCopyWithImpl<$Res, _$KotItemRoutingImpl>
    implements _$$KotItemRoutingImplCopyWith<$Res> {
  __$$KotItemRoutingImplCopyWithImpl(
    _$KotItemRoutingImpl _value,
    $Res Function(_$KotItemRoutingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KotItemRouting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? stationId = null,
    Object? categoryId = freezed,
    Object? productId = freezed,
    Object? variationId = freezed,
    Object? priority = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$KotItemRoutingImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        businessId:
            null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                    as String,
        locationId:
            null == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                    as String,
        stationId:
            null == stationId
                ? _value.stationId
                : stationId // ignore: cast_nullable_to_non_nullable
                    as String,
        categoryId:
            freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        variationId:
            freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                    as String?,
        priority:
            null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                    as int,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        hasUnsyncedChanges:
            null == hasUnsyncedChanges
                ? _value.hasUnsyncedChanges
                : hasUnsyncedChanges // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KotItemRoutingImpl implements _KotItemRouting {
  const _$KotItemRoutingImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.stationId,
    this.categoryId,
    this.productId,
    this.variationId,
    required this.priority,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.hasUnsyncedChanges = false,
  });

  factory _$KotItemRoutingImpl.fromJson(Map<String, dynamic> json) =>
      _$$KotItemRoutingImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String stationId;
  @override
  final String? categoryId;
  // route all items in category
  @override
  final String? productId;
  // route specific product
  @override
  final String? variationId;
  // route specific variation
  @override
  final int priority;
  // routing priority (higher = more specific)
  @override
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'KotItemRouting(id: $id, businessId: $businessId, locationId: $locationId, stationId: $stationId, categoryId: $categoryId, productId: $productId, variationId: $variationId, priority: $priority, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KotItemRoutingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    locationId,
    stationId,
    categoryId,
    productId,
    variationId,
    priority,
    isActive,
    createdAt,
    updatedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of KotItemRouting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KotItemRoutingImplCopyWith<_$KotItemRoutingImpl> get copyWith =>
      __$$KotItemRoutingImplCopyWithImpl<_$KotItemRoutingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KotItemRoutingImplToJson(this);
  }
}

abstract class _KotItemRouting implements KotItemRouting {
  const factory _KotItemRouting({
    required final String id,
    required final String businessId,
    required final String locationId,
    required final String stationId,
    final String? categoryId,
    final String? productId,
    final String? variationId,
    required final int priority,
    required final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final bool hasUnsyncedChanges,
  }) = _$KotItemRoutingImpl;

  factory _KotItemRouting.fromJson(Map<String, dynamic> json) =
      _$KotItemRoutingImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get stationId;
  @override
  String? get categoryId; // route all items in category
  @override
  String? get productId; // route specific product
  @override
  String? get variationId; // route specific variation
  @override
  int get priority; // routing priority (higher = more specific)
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of KotItemRouting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KotItemRoutingImplCopyWith<_$KotItemRoutingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
