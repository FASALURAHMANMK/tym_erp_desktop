// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Discount _$DiscountFromJson(Map<String, dynamic> json) {
  return _Discount.fromJson(json);
}

/// @nodoc
mixin _$Discount {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get value =>
      throw _privateConstructorUsedError; // Percentage or fixed amount
  DiscountType get type => throw _privateConstructorUsedError;
  DiscountScope get scope => throw _privateConstructorUsedError;
  double? get minimumAmount =>
      throw _privateConstructorUsedError; // Minimum purchase amount to apply
  double? get maximumDiscount =>
      throw _privateConstructorUsedError; // Cap on discount amount
  String? get categoryId =>
      throw _privateConstructorUsedError; // For category-specific discounts
  String? get productId =>
      throw _privateConstructorUsedError; // For product-specific discounts
  String? get couponCode =>
      throw _privateConstructorUsedError; // Optional coupon code
  DateTime? get validFrom => throw _privateConstructorUsedError;
  DateTime? get validUntil => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isAutoApply =>
      throw _privateConstructorUsedError; // Automatically apply if conditions met
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get conditions =>
      throw _privateConstructorUsedError; // Additional conditions
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Discount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Discount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscountCopyWith<Discount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscountCopyWith<$Res> {
  factory $DiscountCopyWith(Discount value, $Res Function(Discount) then) =
      _$DiscountCopyWithImpl<$Res, Discount>;
  @useResult
  $Res call({
    String id,
    String name,
    double value,
    DiscountType type,
    DiscountScope scope,
    double? minimumAmount,
    double? maximumDiscount,
    String? categoryId,
    String? productId,
    String? couponCode,
    DateTime? validFrom,
    DateTime? validUntil,
    bool isActive,
    bool isAutoApply,
    String? description,
    Map<String, dynamic> conditions,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$DiscountCopyWithImpl<$Res, $Val extends Discount>
    implements $DiscountCopyWith<$Res> {
  _$DiscountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Discount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? value = null,
    Object? type = null,
    Object? scope = null,
    Object? minimumAmount = freezed,
    Object? maximumDiscount = freezed,
    Object? categoryId = freezed,
    Object? productId = freezed,
    Object? couponCode = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? isActive = null,
    Object? isAutoApply = null,
    Object? description = freezed,
    Object? conditions = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as DiscountType,
            scope:
                null == scope
                    ? _value.scope
                    : scope // ignore: cast_nullable_to_non_nullable
                        as DiscountScope,
            minimumAmount:
                freezed == minimumAmount
                    ? _value.minimumAmount
                    : minimumAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
            maximumDiscount:
                freezed == maximumDiscount
                    ? _value.maximumDiscount
                    : maximumDiscount // ignore: cast_nullable_to_non_nullable
                        as double?,
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
            couponCode:
                freezed == couponCode
                    ? _value.couponCode
                    : couponCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            validFrom:
                freezed == validFrom
                    ? _value.validFrom
                    : validFrom // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            validUntil:
                freezed == validUntil
                    ? _value.validUntil
                    : validUntil // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isAutoApply:
                null == isAutoApply
                    ? _value.isAutoApply
                    : isAutoApply // ignore: cast_nullable_to_non_nullable
                        as bool,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            conditions:
                null == conditions
                    ? _value.conditions
                    : conditions // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiscountImplCopyWith<$Res>
    implements $DiscountCopyWith<$Res> {
  factory _$$DiscountImplCopyWith(
    _$DiscountImpl value,
    $Res Function(_$DiscountImpl) then,
  ) = __$$DiscountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double value,
    DiscountType type,
    DiscountScope scope,
    double? minimumAmount,
    double? maximumDiscount,
    String? categoryId,
    String? productId,
    String? couponCode,
    DateTime? validFrom,
    DateTime? validUntil,
    bool isActive,
    bool isAutoApply,
    String? description,
    Map<String, dynamic> conditions,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$DiscountImplCopyWithImpl<$Res>
    extends _$DiscountCopyWithImpl<$Res, _$DiscountImpl>
    implements _$$DiscountImplCopyWith<$Res> {
  __$$DiscountImplCopyWithImpl(
    _$DiscountImpl _value,
    $Res Function(_$DiscountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Discount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? value = null,
    Object? type = null,
    Object? scope = null,
    Object? minimumAmount = freezed,
    Object? maximumDiscount = freezed,
    Object? categoryId = freezed,
    Object? productId = freezed,
    Object? couponCode = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? isActive = null,
    Object? isAutoApply = null,
    Object? description = freezed,
    Object? conditions = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$DiscountImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as DiscountType,
        scope:
            null == scope
                ? _value.scope
                : scope // ignore: cast_nullable_to_non_nullable
                    as DiscountScope,
        minimumAmount:
            freezed == minimumAmount
                ? _value.minimumAmount
                : minimumAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
        maximumDiscount:
            freezed == maximumDiscount
                ? _value.maximumDiscount
                : maximumDiscount // ignore: cast_nullable_to_non_nullable
                    as double?,
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
        couponCode:
            freezed == couponCode
                ? _value.couponCode
                : couponCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        validFrom:
            freezed == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        validUntil:
            freezed == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isAutoApply:
            null == isAutoApply
                ? _value.isAutoApply
                : isAutoApply // ignore: cast_nullable_to_non_nullable
                    as bool,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        conditions:
            null == conditions
                ? _value._conditions
                : conditions // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscountImpl extends _Discount {
  const _$DiscountImpl({
    required this.id,
    required this.name,
    required this.value,
    this.type = DiscountType.percentage,
    this.scope = DiscountScope.cart,
    this.minimumAmount,
    this.maximumDiscount,
    this.categoryId,
    this.productId,
    this.couponCode,
    this.validFrom,
    this.validUntil,
    this.isActive = true,
    this.isAutoApply = false,
    this.description,
    final Map<String, dynamic> conditions = const {},
    required this.createdAt,
    required this.updatedAt,
  }) : _conditions = conditions,
       super._();

  factory _$DiscountImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscountImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double value;
  // Percentage or fixed amount
  @override
  @JsonKey()
  final DiscountType type;
  @override
  @JsonKey()
  final DiscountScope scope;
  @override
  final double? minimumAmount;
  // Minimum purchase amount to apply
  @override
  final double? maximumDiscount;
  // Cap on discount amount
  @override
  final String? categoryId;
  // For category-specific discounts
  @override
  final String? productId;
  // For product-specific discounts
  @override
  final String? couponCode;
  // Optional coupon code
  @override
  final DateTime? validFrom;
  @override
  final DateTime? validUntil;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isAutoApply;
  // Automatically apply if conditions met
  @override
  final String? description;
  final Map<String, dynamic> _conditions;
  @override
  @JsonKey()
  Map<String, dynamic> get conditions {
    if (_conditions is EqualUnmodifiableMapView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conditions);
  }

  // Additional conditions
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Discount(id: $id, name: $name, value: $value, type: $type, scope: $scope, minimumAmount: $minimumAmount, maximumDiscount: $maximumDiscount, categoryId: $categoryId, productId: $productId, couponCode: $couponCode, validFrom: $validFrom, validUntil: $validUntil, isActive: $isActive, isAutoApply: $isAutoApply, description: $description, conditions: $conditions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.minimumAmount, minimumAmount) ||
                other.minimumAmount == minimumAmount) &&
            (identical(other.maximumDiscount, maximumDiscount) ||
                other.maximumDiscount == maximumDiscount) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isAutoApply, isAutoApply) ||
                other.isAutoApply == isAutoApply) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._conditions,
              _conditions,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    value,
    type,
    scope,
    minimumAmount,
    maximumDiscount,
    categoryId,
    productId,
    couponCode,
    validFrom,
    validUntil,
    isActive,
    isAutoApply,
    description,
    const DeepCollectionEquality().hash(_conditions),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Discount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscountImplCopyWith<_$DiscountImpl> get copyWith =>
      __$$DiscountImplCopyWithImpl<_$DiscountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscountImplToJson(this);
  }
}

abstract class _Discount extends Discount {
  const factory _Discount({
    required final String id,
    required final String name,
    required final double value,
    final DiscountType type,
    final DiscountScope scope,
    final double? minimumAmount,
    final double? maximumDiscount,
    final String? categoryId,
    final String? productId,
    final String? couponCode,
    final DateTime? validFrom,
    final DateTime? validUntil,
    final bool isActive,
    final bool isAutoApply,
    final String? description,
    final Map<String, dynamic> conditions,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$DiscountImpl;
  const _Discount._() : super._();

  factory _Discount.fromJson(Map<String, dynamic> json) =
      _$DiscountImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get value; // Percentage or fixed amount
  @override
  DiscountType get type;
  @override
  DiscountScope get scope;
  @override
  double? get minimumAmount; // Minimum purchase amount to apply
  @override
  double? get maximumDiscount; // Cap on discount amount
  @override
  String? get categoryId; // For category-specific discounts
  @override
  String? get productId; // For product-specific discounts
  @override
  String? get couponCode; // Optional coupon code
  @override
  DateTime? get validFrom;
  @override
  DateTime? get validUntil;
  @override
  bool get isActive;
  @override
  bool get isAutoApply; // Automatically apply if conditions met
  @override
  String? get description;
  @override
  Map<String, dynamic> get conditions; // Additional conditions
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Discount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscountImplCopyWith<_$DiscountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  return _Coupon.fromJson(json);
}

/// @nodoc
mixin _$Coupon {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  Discount get discount => throw _privateConstructorUsedError;
  int? get usageLimit =>
      throw _privateConstructorUsedError; // Total usage limit
  int? get usageCount =>
      throw _privateConstructorUsedError; // Current usage count
  int? get perCustomerLimit =>
      throw _privateConstructorUsedError; // Usage limit per customer
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  List<String> get applicableCategories => throw _privateConstructorUsedError;
  List<String> get applicableProducts => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Coupon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponCopyWith<Coupon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponCopyWith<$Res> {
  factory $CouponCopyWith(Coupon value, $Res Function(Coupon) then) =
      _$CouponCopyWithImpl<$Res, Coupon>;
  @useResult
  $Res call({
    String id,
    String code,
    Discount discount,
    int? usageLimit,
    int? usageCount,
    int? perCustomerLimit,
    bool isActive,
    DateTime? expiresAt,
    List<String> applicableCategories,
    List<String> applicableProducts,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $DiscountCopyWith<$Res> get discount;
}

/// @nodoc
class _$CouponCopyWithImpl<$Res, $Val extends Coupon>
    implements $CouponCopyWith<$Res> {
  _$CouponCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? discount = null,
    Object? usageLimit = freezed,
    Object? usageCount = freezed,
    Object? perCustomerLimit = freezed,
    Object? isActive = null,
    Object? expiresAt = freezed,
    Object? applicableCategories = null,
    Object? applicableProducts = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            code:
                null == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as String,
            discount:
                null == discount
                    ? _value.discount
                    : discount // ignore: cast_nullable_to_non_nullable
                        as Discount,
            usageLimit:
                freezed == usageLimit
                    ? _value.usageLimit
                    : usageLimit // ignore: cast_nullable_to_non_nullable
                        as int?,
            usageCount:
                freezed == usageCount
                    ? _value.usageCount
                    : usageCount // ignore: cast_nullable_to_non_nullable
                        as int?,
            perCustomerLimit:
                freezed == perCustomerLimit
                    ? _value.perCustomerLimit
                    : perCustomerLimit // ignore: cast_nullable_to_non_nullable
                        as int?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            expiresAt:
                freezed == expiresAt
                    ? _value.expiresAt
                    : expiresAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            applicableCategories:
                null == applicableCategories
                    ? _value.applicableCategories
                    : applicableCategories // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            applicableProducts:
                null == applicableProducts
                    ? _value.applicableProducts
                    : applicableProducts // ignore: cast_nullable_to_non_nullable
                        as List<String>,
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
          )
          as $Val,
    );
  }

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DiscountCopyWith<$Res> get discount {
    return $DiscountCopyWith<$Res>(_value.discount, (value) {
      return _then(_value.copyWith(discount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CouponImplCopyWith<$Res> implements $CouponCopyWith<$Res> {
  factory _$$CouponImplCopyWith(
    _$CouponImpl value,
    $Res Function(_$CouponImpl) then,
  ) = __$$CouponImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    Discount discount,
    int? usageLimit,
    int? usageCount,
    int? perCustomerLimit,
    bool isActive,
    DateTime? expiresAt,
    List<String> applicableCategories,
    List<String> applicableProducts,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $DiscountCopyWith<$Res> get discount;
}

/// @nodoc
class __$$CouponImplCopyWithImpl<$Res>
    extends _$CouponCopyWithImpl<$Res, _$CouponImpl>
    implements _$$CouponImplCopyWith<$Res> {
  __$$CouponImplCopyWithImpl(
    _$CouponImpl _value,
    $Res Function(_$CouponImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? discount = null,
    Object? usageLimit = freezed,
    Object? usageCount = freezed,
    Object? perCustomerLimit = freezed,
    Object? isActive = null,
    Object? expiresAt = freezed,
    Object? applicableCategories = null,
    Object? applicableProducts = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$CouponImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        code:
            null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String,
        discount:
            null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                    as Discount,
        usageLimit:
            freezed == usageLimit
                ? _value.usageLimit
                : usageLimit // ignore: cast_nullable_to_non_nullable
                    as int?,
        usageCount:
            freezed == usageCount
                ? _value.usageCount
                : usageCount // ignore: cast_nullable_to_non_nullable
                    as int?,
        perCustomerLimit:
            freezed == perCustomerLimit
                ? _value.perCustomerLimit
                : perCustomerLimit // ignore: cast_nullable_to_non_nullable
                    as int?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        expiresAt:
            freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        applicableCategories:
            null == applicableCategories
                ? _value._applicableCategories
                : applicableCategories // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        applicableProducts:
            null == applicableProducts
                ? _value._applicableProducts
                : applicableProducts // ignore: cast_nullable_to_non_nullable
                    as List<String>,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponImpl extends _Coupon {
  const _$CouponImpl({
    required this.id,
    required this.code,
    required this.discount,
    this.usageLimit,
    this.usageCount,
    this.perCustomerLimit,
    this.isActive = true,
    this.expiresAt,
    final List<String> applicableCategories = const [],
    final List<String> applicableProducts = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : _applicableCategories = applicableCategories,
       _applicableProducts = applicableProducts,
       super._();

  factory _$CouponImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final Discount discount;
  @override
  final int? usageLimit;
  // Total usage limit
  @override
  final int? usageCount;
  // Current usage count
  @override
  final int? perCustomerLimit;
  // Usage limit per customer
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? expiresAt;
  final List<String> _applicableCategories;
  @override
  @JsonKey()
  List<String> get applicableCategories {
    if (_applicableCategories is EqualUnmodifiableListView)
      return _applicableCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableCategories);
  }

  final List<String> _applicableProducts;
  @override
  @JsonKey()
  List<String> get applicableProducts {
    if (_applicableProducts is EqualUnmodifiableListView)
      return _applicableProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableProducts);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Coupon(id: $id, code: $code, discount: $discount, usageLimit: $usageLimit, usageCount: $usageCount, perCustomerLimit: $perCustomerLimit, isActive: $isActive, expiresAt: $expiresAt, applicableCategories: $applicableCategories, applicableProducts: $applicableProducts, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.usageLimit, usageLimit) ||
                other.usageLimit == usageLimit) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.perCustomerLimit, perCustomerLimit) ||
                other.perCustomerLimit == perCustomerLimit) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(
              other._applicableCategories,
              _applicableCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._applicableProducts,
              _applicableProducts,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    discount,
    usageLimit,
    usageCount,
    perCustomerLimit,
    isActive,
    expiresAt,
    const DeepCollectionEquality().hash(_applicableCategories),
    const DeepCollectionEquality().hash(_applicableProducts),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponImplCopyWith<_$CouponImpl> get copyWith =>
      __$$CouponImplCopyWithImpl<_$CouponImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponImplToJson(this);
  }
}

abstract class _Coupon extends Coupon {
  const factory _Coupon({
    required final String id,
    required final String code,
    required final Discount discount,
    final int? usageLimit,
    final int? usageCount,
    final int? perCustomerLimit,
    final bool isActive,
    final DateTime? expiresAt,
    final List<String> applicableCategories,
    final List<String> applicableProducts,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$CouponImpl;
  const _Coupon._() : super._();

  factory _Coupon.fromJson(Map<String, dynamic> json) = _$CouponImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  Discount get discount;
  @override
  int? get usageLimit; // Total usage limit
  @override
  int? get usageCount; // Current usage count
  @override
  int? get perCustomerLimit; // Usage limit per customer
  @override
  bool get isActive;
  @override
  DateTime? get expiresAt;
  @override
  List<String> get applicableCategories;
  @override
  List<String> get applicableProducts;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponImplCopyWith<_$CouponImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
