// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_brand.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductBrand _$ProductBrandFromJson(Map<String, dynamic> json) {
  return _ProductBrand.fromJson(json);
}

/// @nodoc
mixin _$ProductBrand {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError; // Sync fields
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this ProductBrand to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductBrandCopyWith<ProductBrand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductBrandCopyWith<$Res> {
  factory $ProductBrandCopyWith(
    ProductBrand value,
    $Res Function(ProductBrand) then,
  ) = _$ProductBrandCopyWithImpl<$Res, ProductBrand>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? description,
    String? logoUrl,
    int displayOrder,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$ProductBrandCopyWithImpl<$Res, $Val extends ProductBrand>
    implements $ProductBrandCopyWith<$Res> {
  _$ProductBrandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? displayOrder = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            logoUrl:
                freezed == logoUrl
                    ? _value.logoUrl
                    : logoUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            lastSyncedAt:
                freezed == lastSyncedAt
                    ? _value.lastSyncedAt
                    : lastSyncedAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ProductBrandImplCopyWith<$Res>
    implements $ProductBrandCopyWith<$Res> {
  factory _$$ProductBrandImplCopyWith(
    _$ProductBrandImpl value,
    $Res Function(_$ProductBrandImpl) then,
  ) = __$$ProductBrandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? description,
    String? logoUrl,
    int displayOrder,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$ProductBrandImplCopyWithImpl<$Res>
    extends _$ProductBrandCopyWithImpl<$Res, _$ProductBrandImpl>
    implements _$$ProductBrandImplCopyWith<$Res> {
  __$$ProductBrandImplCopyWithImpl(
    _$ProductBrandImpl _value,
    $Res Function(_$ProductBrandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? displayOrder = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$ProductBrandImpl(
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
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        logoUrl:
            freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        lastSyncedAt:
            freezed == lastSyncedAt
                ? _value.lastSyncedAt
                : lastSyncedAt // ignore: cast_nullable_to_non_nullable
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
class _$ProductBrandImpl extends _ProductBrand {
  const _$ProductBrandImpl({
    required this.id,
    required this.businessId,
    required this.name,
    this.description,
    this.logoUrl,
    this.displayOrder = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : super._();

  factory _$ProductBrandImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductBrandImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  @JsonKey()
  final bool isActive;
  // Sync fields
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'ProductBrand(id: $id, businessId: $businessId, name: $name, description: $description, logoUrl: $logoUrl, displayOrder: $displayOrder, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductBrandImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    name,
    description,
    logoUrl,
    displayOrder,
    isActive,
    createdAt,
    updatedAt,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductBrandImplCopyWith<_$ProductBrandImpl> get copyWith =>
      __$$ProductBrandImplCopyWithImpl<_$ProductBrandImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductBrandImplToJson(this);
  }
}

abstract class _ProductBrand extends ProductBrand {
  const factory _ProductBrand({
    required final String id,
    required final String businessId,
    required final String name,
    final String? description,
    final String? logoUrl,
    final int displayOrder,
    final bool isActive,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$ProductBrandImpl;
  const _ProductBrand._() : super._();

  factory _ProductBrand.fromJson(Map<String, dynamic> json) =
      _$ProductBrandImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get logoUrl;
  @override
  int get displayOrder;
  @override
  bool get isActive; // Sync fields
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductBrandImplCopyWith<_$ProductBrandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
