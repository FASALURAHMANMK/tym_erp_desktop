// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) {
  return _PaymentMethod.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethod {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code =>
      throw _privateConstructorUsedError; // Unique code like 'cash', 'card', 'upi'
  String? get icon =>
      throw _privateConstructorUsedError; // Icon identifier for UI
  bool get isActive => throw _privateConstructorUsedError;
  bool get isDefault =>
      throw _privateConstructorUsedError; // For system default payment methods
  bool get requiresReference =>
      throw _privateConstructorUsedError; // If true, requires reference number
  bool get requiresApproval =>
      throw _privateConstructorUsedError; // If true, requires manager approval
  int get displayOrder => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings =>
      throw _privateConstructorUsedError; // Additional settings
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodCopyWith<PaymentMethod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodCopyWith<$Res> {
  factory $PaymentMethodCopyWith(
    PaymentMethod value,
    $Res Function(PaymentMethod) then,
  ) = _$PaymentMethodCopyWithImpl<$Res, PaymentMethod>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String code,
    String? icon,
    bool isActive,
    bool isDefault,
    bool requiresReference,
    bool requiresApproval,
    int displayOrder,
    Map<String, dynamic> settings,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$PaymentMethodCopyWithImpl<$Res, $Val extends PaymentMethod>
    implements $PaymentMethodCopyWith<$Res> {
  _$PaymentMethodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? code = null,
    Object? icon = freezed,
    Object? isActive = null,
    Object? isDefault = null,
    Object? requiresReference = null,
    Object? requiresApproval = null,
    Object? displayOrder = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
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
            code:
                null == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as String,
            icon:
                freezed == icon
                    ? _value.icon
                    : icon // ignore: cast_nullable_to_non_nullable
                        as String?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
                        as bool,
            requiresReference:
                null == requiresReference
                    ? _value.requiresReference
                    : requiresReference // ignore: cast_nullable_to_non_nullable
                        as bool,
            requiresApproval:
                null == requiresApproval
                    ? _value.requiresApproval
                    : requiresApproval // ignore: cast_nullable_to_non_nullable
                        as bool,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
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
abstract class _$$PaymentMethodImplCopyWith<$Res>
    implements $PaymentMethodCopyWith<$Res> {
  factory _$$PaymentMethodImplCopyWith(
    _$PaymentMethodImpl value,
    $Res Function(_$PaymentMethodImpl) then,
  ) = __$$PaymentMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String code,
    String? icon,
    bool isActive,
    bool isDefault,
    bool requiresReference,
    bool requiresApproval,
    int displayOrder,
    Map<String, dynamic> settings,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$PaymentMethodImplCopyWithImpl<$Res>
    extends _$PaymentMethodCopyWithImpl<$Res, _$PaymentMethodImpl>
    implements _$$PaymentMethodImplCopyWith<$Res> {
  __$$PaymentMethodImplCopyWithImpl(
    _$PaymentMethodImpl _value,
    $Res Function(_$PaymentMethodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? code = null,
    Object? icon = freezed,
    Object? isActive = null,
    Object? isDefault = null,
    Object? requiresReference = null,
    Object? requiresApproval = null,
    Object? displayOrder = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$PaymentMethodImpl(
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
        code:
            null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String,
        icon:
            freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                    as String?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                    as bool,
        requiresReference:
            null == requiresReference
                ? _value.requiresReference
                : requiresReference // ignore: cast_nullable_to_non_nullable
                    as bool,
        requiresApproval:
            null == requiresApproval
                ? _value.requiresApproval
                : requiresApproval // ignore: cast_nullable_to_non_nullable
                    as bool,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
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
class _$PaymentMethodImpl extends _PaymentMethod {
  const _$PaymentMethodImpl({
    required this.id,
    required this.businessId,
    required this.name,
    required this.code,
    this.icon,
    this.isActive = true,
    this.isDefault = false,
    this.requiresReference = false,
    this.requiresApproval = false,
    this.displayOrder = 0,
    final Map<String, dynamic> settings = const {},
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.hasUnsyncedChanges = false,
  }) : _settings = settings,
       super._();

  factory _$PaymentMethodImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final String code;
  // Unique code like 'cash', 'card', 'upi'
  @override
  final String? icon;
  // Icon identifier for UI
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isDefault;
  // For system default payment methods
  @override
  @JsonKey()
  final bool requiresReference;
  // If true, requires reference number
  @override
  @JsonKey()
  final bool requiresApproval;
  // If true, requires manager approval
  @override
  @JsonKey()
  final int displayOrder;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  // Additional settings
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? createdBy;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'PaymentMethod(id: $id, businessId: $businessId, name: $name, code: $code, icon: $icon, isActive: $isActive, isDefault: $isDefault, requiresReference: $requiresReference, requiresApproval: $requiresApproval, displayOrder: $displayOrder, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.requiresReference, requiresReference) ||
                other.requiresReference == requiresReference) &&
            (identical(other.requiresApproval, requiresApproval) ||
                other.requiresApproval == requiresApproval) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
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
    code,
    icon,
    isActive,
    isDefault,
    requiresReference,
    requiresApproval,
    displayOrder,
    const DeepCollectionEquality().hash(_settings),
    createdAt,
    updatedAt,
    createdBy,
    hasUnsyncedChanges,
  );

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodImplCopyWith<_$PaymentMethodImpl> get copyWith =>
      __$$PaymentMethodImplCopyWithImpl<_$PaymentMethodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodImplToJson(this);
  }
}

abstract class _PaymentMethod extends PaymentMethod {
  const factory _PaymentMethod({
    required final String id,
    required final String businessId,
    required final String name,
    required final String code,
    final String? icon,
    final bool isActive,
    final bool isDefault,
    final bool requiresReference,
    final bool requiresApproval,
    final int displayOrder,
    final Map<String, dynamic> settings,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? createdBy,
    final bool hasUnsyncedChanges,
  }) = _$PaymentMethodImpl;
  const _PaymentMethod._() : super._();

  factory _PaymentMethod.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  String get code; // Unique code like 'cash', 'card', 'upi'
  @override
  String? get icon; // Icon identifier for UI
  @override
  bool get isActive;
  @override
  bool get isDefault; // For system default payment methods
  @override
  bool get requiresReference; // If true, requires reference number
  @override
  bool get requiresApproval; // If true, requires manager approval
  @override
  int get displayOrder;
  @override
  Map<String, dynamic> get settings; // Additional settings
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodImplCopyWith<_$PaymentMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
