// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return _ProductCategory.fromJson(json);
}

/// @nodoc
mixin _$ProductCategory {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameInAlternateLanguage => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get iconName => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get parentCategoryId =>
      throw _privateConstructorUsedError; // KOT settings
  String? get defaultKotPrinterId =>
      throw _privateConstructorUsedError; // Sync fields
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this ProductCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCategoryCopyWith<ProductCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCategoryCopyWith<$Res> {
  factory $ProductCategoryCopyWith(
    ProductCategory value,
    $Res Function(ProductCategory) then,
  ) = _$ProductCategoryCopyWithImpl<$Res, ProductCategory>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? nameInAlternateLanguage,
    String? description,
    String? imageUrl,
    String? iconName,
    int displayOrder,
    bool isActive,
    String? parentCategoryId,
    String? defaultKotPrinterId,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$ProductCategoryCopyWithImpl<$Res, $Val extends ProductCategory>
    implements $ProductCategoryCopyWith<$Res> {
  _$ProductCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? nameInAlternateLanguage = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? iconName = freezed,
    Object? displayOrder = null,
    Object? isActive = null,
    Object? parentCategoryId = freezed,
    Object? defaultKotPrinterId = freezed,
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
            nameInAlternateLanguage:
                freezed == nameInAlternateLanguage
                    ? _value.nameInAlternateLanguage
                    : nameInAlternateLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            imageUrl:
                freezed == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            iconName:
                freezed == iconName
                    ? _value.iconName
                    : iconName // ignore: cast_nullable_to_non_nullable
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
            parentCategoryId:
                freezed == parentCategoryId
                    ? _value.parentCategoryId
                    : parentCategoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            defaultKotPrinterId:
                freezed == defaultKotPrinterId
                    ? _value.defaultKotPrinterId
                    : defaultKotPrinterId // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$ProductCategoryImplCopyWith<$Res>
    implements $ProductCategoryCopyWith<$Res> {
  factory _$$ProductCategoryImplCopyWith(
    _$ProductCategoryImpl value,
    $Res Function(_$ProductCategoryImpl) then,
  ) = __$$ProductCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? nameInAlternateLanguage,
    String? description,
    String? imageUrl,
    String? iconName,
    int displayOrder,
    bool isActive,
    String? parentCategoryId,
    String? defaultKotPrinterId,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$ProductCategoryImplCopyWithImpl<$Res>
    extends _$ProductCategoryCopyWithImpl<$Res, _$ProductCategoryImpl>
    implements _$$ProductCategoryImplCopyWith<$Res> {
  __$$ProductCategoryImplCopyWithImpl(
    _$ProductCategoryImpl _value,
    $Res Function(_$ProductCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? nameInAlternateLanguage = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? iconName = freezed,
    Object? displayOrder = null,
    Object? isActive = null,
    Object? parentCategoryId = freezed,
    Object? defaultKotPrinterId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$ProductCategoryImpl(
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
        nameInAlternateLanguage:
            freezed == nameInAlternateLanguage
                ? _value.nameInAlternateLanguage
                : nameInAlternateLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        imageUrl:
            freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        iconName:
            freezed == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
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
        parentCategoryId:
            freezed == parentCategoryId
                ? _value.parentCategoryId
                : parentCategoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        defaultKotPrinterId:
            freezed == defaultKotPrinterId
                ? _value.defaultKotPrinterId
                : defaultKotPrinterId // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$ProductCategoryImpl extends _ProductCategory {
  const _$ProductCategoryImpl({
    required this.id,
    required this.businessId,
    required this.name,
    this.nameInAlternateLanguage,
    this.description,
    this.imageUrl,
    this.iconName,
    this.displayOrder = 0,
    this.isActive = true,
    this.parentCategoryId,
    this.defaultKotPrinterId,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : super._();

  factory _$ProductCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final String? nameInAlternateLanguage;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? iconName;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? parentCategoryId;
  // KOT settings
  @override
  final String? defaultKotPrinterId;
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
    return 'ProductCategory(id: $id, businessId: $businessId, name: $name, nameInAlternateLanguage: $nameInAlternateLanguage, description: $description, imageUrl: $imageUrl, iconName: $iconName, displayOrder: $displayOrder, isActive: $isActive, parentCategoryId: $parentCategoryId, defaultKotPrinterId: $defaultKotPrinterId, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(
                  other.nameInAlternateLanguage,
                  nameInAlternateLanguage,
                ) ||
                other.nameInAlternateLanguage == nameInAlternateLanguage) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.parentCategoryId, parentCategoryId) ||
                other.parentCategoryId == parentCategoryId) &&
            (identical(other.defaultKotPrinterId, defaultKotPrinterId) ||
                other.defaultKotPrinterId == defaultKotPrinterId) &&
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
    nameInAlternateLanguage,
    description,
    imageUrl,
    iconName,
    displayOrder,
    isActive,
    parentCategoryId,
    defaultKotPrinterId,
    createdAt,
    updatedAt,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductCategoryImplCopyWith<_$ProductCategoryImpl> get copyWith =>
      __$$ProductCategoryImplCopyWithImpl<_$ProductCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductCategoryImplToJson(this);
  }
}

abstract class _ProductCategory extends ProductCategory {
  const factory _ProductCategory({
    required final String id,
    required final String businessId,
    required final String name,
    final String? nameInAlternateLanguage,
    final String? description,
    final String? imageUrl,
    final String? iconName,
    final int displayOrder,
    final bool isActive,
    final String? parentCategoryId,
    final String? defaultKotPrinterId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$ProductCategoryImpl;
  const _ProductCategory._() : super._();

  factory _ProductCategory.fromJson(Map<String, dynamic> json) =
      _$ProductCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  String? get nameInAlternateLanguage;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get iconName;
  @override
  int get displayOrder;
  @override
  bool get isActive;
  @override
  String? get parentCategoryId; // KOT settings
  @override
  String? get defaultKotPrinterId; // Sync fields
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductCategoryImplCopyWith<_$ProductCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
