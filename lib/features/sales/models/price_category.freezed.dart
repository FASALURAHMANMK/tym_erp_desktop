// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PriceCategory _$PriceCategoryFromJson(Map<String, dynamic> json) {
  return _PriceCategory.fromJson(json);
}

/// @nodoc
mixin _$PriceCategory {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  PriceCategoryType get type => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  String? get iconName => throw _privateConstructorUsedError;
  String? get colorHex => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this PriceCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceCategoryCopyWith<PriceCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceCategoryCopyWith<$Res> {
  factory $PriceCategoryCopyWith(
    PriceCategory value,
    $Res Function(PriceCategory) then,
  ) = _$PriceCategoryCopyWithImpl<$Res, PriceCategory>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    PriceCategoryType type,
    String? description,
    bool isDefault,
    bool isActive,
    bool isVisible,
    int displayOrder,
    String? iconName,
    String? colorHex,
    Map<String, dynamic> settings,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$PriceCategoryCopyWithImpl<$Res, $Val extends PriceCategory>
    implements $PriceCategoryCopyWith<$Res> {
  _$PriceCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? isVisible = null,
    Object? displayOrder = null,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
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
            locationId:
                null == locationId
                    ? _value.locationId
                    : locationId // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as PriceCategoryType,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
                        as bool,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isVisible:
                null == isVisible
                    ? _value.isVisible
                    : isVisible // ignore: cast_nullable_to_non_nullable
                        as bool,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            iconName:
                freezed == iconName
                    ? _value.iconName
                    : iconName // ignore: cast_nullable_to_non_nullable
                        as String?,
            colorHex:
                freezed == colorHex
                    ? _value.colorHex
                    : colorHex // ignore: cast_nullable_to_non_nullable
                        as String?,
            settings:
                null == settings
                    ? _value.settings
                    : settings // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
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
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$PriceCategoryImplCopyWith<$Res>
    implements $PriceCategoryCopyWith<$Res> {
  factory _$$PriceCategoryImplCopyWith(
    _$PriceCategoryImpl value,
    $Res Function(_$PriceCategoryImpl) then,
  ) = __$$PriceCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    PriceCategoryType type,
    String? description,
    bool isDefault,
    bool isActive,
    bool isVisible,
    int displayOrder,
    String? iconName,
    String? colorHex,
    Map<String, dynamic> settings,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$PriceCategoryImplCopyWithImpl<$Res>
    extends _$PriceCategoryCopyWithImpl<$Res, _$PriceCategoryImpl>
    implements _$$PriceCategoryImplCopyWith<$Res> {
  __$$PriceCategoryImplCopyWithImpl(
    _$PriceCategoryImpl _value,
    $Res Function(_$PriceCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriceCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? isVisible = null,
    Object? displayOrder = null,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$PriceCategoryImpl(
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
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as PriceCategoryType,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                    as bool,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isVisible:
            null == isVisible
                ? _value.isVisible
                : isVisible // ignore: cast_nullable_to_non_nullable
                    as bool,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        iconName:
            freezed == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                    as String?,
        colorHex:
            freezed == colorHex
                ? _value.colorHex
                : colorHex // ignore: cast_nullable_to_non_nullable
                    as String?,
        settings:
            null == settings
                ? _value._settings
                : settings // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
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
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$PriceCategoryImpl extends _PriceCategory {
  const _$PriceCategoryImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.name,
    required this.type,
    this.description,
    this.isDefault = false,
    this.isActive = true,
    this.isVisible = true,
    this.displayOrder = 0,
    this.iconName,
    this.colorHex,
    final Map<String, dynamic> settings = const {},
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : _settings = settings,
       super._();

  factory _$PriceCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String name;
  @override
  final PriceCategoryType type;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isVisible;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final String? iconName;
  @override
  final String? colorHex;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? createdBy;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'PriceCategory(id: $id, businessId: $businessId, locationId: $locationId, name: $name, type: $type, description: $description, isDefault: $isDefault, isActive: $isActive, isVisible: $isVisible, displayOrder: $displayOrder, iconName: $iconName, colorHex: $colorHex, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
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
    locationId,
    name,
    type,
    description,
    isDefault,
    isActive,
    isVisible,
    displayOrder,
    iconName,
    colorHex,
    const DeepCollectionEquality().hash(_settings),
    createdAt,
    updatedAt,
    createdBy,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of PriceCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceCategoryImplCopyWith<_$PriceCategoryImpl> get copyWith =>
      __$$PriceCategoryImplCopyWithImpl<_$PriceCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceCategoryImplToJson(this);
  }
}

abstract class _PriceCategory extends PriceCategory {
  const factory _PriceCategory({
    required final String id,
    required final String businessId,
    required final String locationId,
    required final String name,
    required final PriceCategoryType type,
    final String? description,
    final bool isDefault,
    final bool isActive,
    final bool isVisible,
    final int displayOrder,
    final String? iconName,
    final String? colorHex,
    final Map<String, dynamic> settings,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? createdBy,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$PriceCategoryImpl;
  const _PriceCategory._() : super._();

  factory _PriceCategory.fromJson(Map<String, dynamic> json) =
      _$PriceCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get name;
  @override
  PriceCategoryType get type;
  @override
  String? get description;
  @override
  bool get isDefault;
  @override
  bool get isActive;
  @override
  bool get isVisible;
  @override
  int get displayOrder;
  @override
  String? get iconName;
  @override
  String? get colorHex;
  @override
  Map<String, dynamic> get settings;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of PriceCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceCategoryImplCopyWith<_$PriceCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
