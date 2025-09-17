// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerGroup _$CustomerGroupFromJson(Map<String, dynamic> json) {
  return _CustomerGroup.fromJson(json);
}

/// @nodoc
mixin _$CustomerGroup {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  double get creditLimit => throw _privateConstructorUsedError;
  int get paymentTerms => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this CustomerGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerGroupCopyWith<CustomerGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerGroupCopyWith<$Res> {
  factory $CustomerGroupCopyWith(
    CustomerGroup value,
    $Res Function(CustomerGroup) then,
  ) = _$CustomerGroupCopyWithImpl<$Res, CustomerGroup>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String code,
    String? description,
    String? color,
    double discountPercent,
    double creditLimit,
    int paymentTerms,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$CustomerGroupCopyWithImpl<$Res, $Val extends CustomerGroup>
    implements $CustomerGroupCopyWith<$Res> {
  _$CustomerGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? color = freezed,
    Object? discountPercent = null,
    Object? creditLimit = null,
    Object? paymentTerms = null,
    Object? isActive = null,
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
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            color:
                freezed == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as String?,
            discountPercent:
                null == discountPercent
                    ? _value.discountPercent
                    : discountPercent // ignore: cast_nullable_to_non_nullable
                        as double,
            creditLimit:
                null == creditLimit
                    ? _value.creditLimit
                    : creditLimit // ignore: cast_nullable_to_non_nullable
                        as double,
            paymentTerms:
                null == paymentTerms
                    ? _value.paymentTerms
                    : paymentTerms // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CustomerGroupImplCopyWith<$Res>
    implements $CustomerGroupCopyWith<$Res> {
  factory _$$CustomerGroupImplCopyWith(
    _$CustomerGroupImpl value,
    $Res Function(_$CustomerGroupImpl) then,
  ) = __$$CustomerGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String code,
    String? description,
    String? color,
    double discountPercent,
    double creditLimit,
    int paymentTerms,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$CustomerGroupImplCopyWithImpl<$Res>
    extends _$CustomerGroupCopyWithImpl<$Res, _$CustomerGroupImpl>
    implements _$$CustomerGroupImplCopyWith<$Res> {
  __$$CustomerGroupImplCopyWithImpl(
    _$CustomerGroupImpl _value,
    $Res Function(_$CustomerGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? color = freezed,
    Object? discountPercent = null,
    Object? creditLimit = null,
    Object? paymentTerms = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$CustomerGroupImpl(
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
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        color:
            freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as String?,
        discountPercent:
            null == discountPercent
                ? _value.discountPercent
                : discountPercent // ignore: cast_nullable_to_non_nullable
                    as double,
        creditLimit:
            null == creditLimit
                ? _value.creditLimit
                : creditLimit // ignore: cast_nullable_to_non_nullable
                    as double,
        paymentTerms:
            null == paymentTerms
                ? _value.paymentTerms
                : paymentTerms // ignore: cast_nullable_to_non_nullable
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
class _$CustomerGroupImpl implements _CustomerGroup {
  const _$CustomerGroupImpl({
    required this.id,
    required this.businessId,
    required this.name,
    required this.code,
    this.description,
    this.color,
    this.discountPercent = 0,
    this.creditLimit = 0,
    this.paymentTerms = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.hasUnsyncedChanges = false,
  });

  factory _$CustomerGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final String code;
  @override
  final String? description;
  @override
  final String? color;
  @override
  @JsonKey()
  final double discountPercent;
  @override
  @JsonKey()
  final double creditLimit;
  @override
  @JsonKey()
  final int paymentTerms;
  @override
  @JsonKey()
  final bool isActive;
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
    return 'CustomerGroup(id: $id, businessId: $businessId, name: $name, code: $code, description: $description, color: $color, discountPercent: $discountPercent, creditLimit: $creditLimit, paymentTerms: $paymentTerms, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.paymentTerms, paymentTerms) ||
                other.paymentTerms == paymentTerms) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
    description,
    color,
    discountPercent,
    creditLimit,
    paymentTerms,
    isActive,
    createdAt,
    updatedAt,
    createdBy,
    hasUnsyncedChanges,
  );

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerGroupImplCopyWith<_$CustomerGroupImpl> get copyWith =>
      __$$CustomerGroupImplCopyWithImpl<_$CustomerGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerGroupImplToJson(this);
  }
}

abstract class _CustomerGroup implements CustomerGroup {
  const factory _CustomerGroup({
    required final String id,
    required final String businessId,
    required final String name,
    required final String code,
    final String? description,
    final String? color,
    final double discountPercent,
    final double creditLimit,
    final int paymentTerms,
    final bool isActive,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? createdBy,
    final bool hasUnsyncedChanges,
  }) = _$CustomerGroupImpl;

  factory _CustomerGroup.fromJson(Map<String, dynamic> json) =
      _$CustomerGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  String get code;
  @override
  String? get description;
  @override
  String? get color;
  @override
  double get discountPercent;
  @override
  double get creditLimit;
  @override
  int get paymentTerms;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerGroupImplCopyWith<_$CustomerGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
