// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_discount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderDiscount _$OrderDiscountFromJson(Map<String, dynamic> json) {
  return _OrderDiscount.fromJson(json);
}

/// @nodoc
mixin _$OrderDiscount {
  String get id => throw _privateConstructorUsedError;
  String get orderId =>
      throw _privateConstructorUsedError; // Discount Information (snapshot)
  String get discountId => throw _privateConstructorUsedError;
  String get discountName => throw _privateConstructorUsedError;
  String get discountCode => throw _privateConstructorUsedError; // Type
  String get discountType =>
      throw _privateConstructorUsedError; // percentage, fixed, item_based, buy_x_get_y
  String get appliedTo =>
      throw _privateConstructorUsedError; // order, items, category, specific_items
  // Values
  double get discountPercent => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get maximumDiscount =>
      throw _privateConstructorUsedError; // Applied Amount (actual discount given)
  double get appliedAmount =>
      throw _privateConstructorUsedError; // Conditions (snapshot of what qualified this discount)
  double get minimumPurchase => throw _privateConstructorUsedError;
  int get minimumQuantity => throw _privateConstructorUsedError;
  List<String> get applicableCategories => throw _privateConstructorUsedError;
  List<String> get applicableProducts =>
      throw _privateConstructorUsedError; // Application Details
  String get applicationMethod =>
      throw _privateConstructorUsedError; // auto, manual, coupon
  String? get couponCode => throw _privateConstructorUsedError;
  String? get appliedBy =>
      throw _privateConstructorUsedError; // User ID who applied manual discount
  String? get appliedByName => throw _privateConstructorUsedError; // Snapshot
  // Reason (for manual discounts)
  String? get reason => throw _privateConstructorUsedError;
  String? get authorizedBy =>
      throw _privateConstructorUsedError; // Manager who authorized
  // Metadata
  DateTime get appliedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this OrderDiscount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDiscount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDiscountCopyWith<OrderDiscount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDiscountCopyWith<$Res> {
  factory $OrderDiscountCopyWith(
    OrderDiscount value,
    $Res Function(OrderDiscount) then,
  ) = _$OrderDiscountCopyWithImpl<$Res, OrderDiscount>;
  @useResult
  $Res call({
    String id,
    String orderId,
    String discountId,
    String discountName,
    String discountCode,
    String discountType,
    String appliedTo,
    double discountPercent,
    double discountAmount,
    double maximumDiscount,
    double appliedAmount,
    double minimumPurchase,
    int minimumQuantity,
    List<String> applicableCategories,
    List<String> applicableProducts,
    String applicationMethod,
    String? couponCode,
    String? appliedBy,
    String? appliedByName,
    String? reason,
    String? authorizedBy,
    DateTime appliedAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$OrderDiscountCopyWithImpl<$Res, $Val extends OrderDiscount>
    implements $OrderDiscountCopyWith<$Res> {
  _$OrderDiscountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDiscount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? discountId = null,
    Object? discountName = null,
    Object? discountCode = null,
    Object? discountType = null,
    Object? appliedTo = null,
    Object? discountPercent = null,
    Object? discountAmount = null,
    Object? maximumDiscount = null,
    Object? appliedAmount = null,
    Object? minimumPurchase = null,
    Object? minimumQuantity = null,
    Object? applicableCategories = null,
    Object? applicableProducts = null,
    Object? applicationMethod = null,
    Object? couponCode = freezed,
    Object? appliedBy = freezed,
    Object? appliedByName = freezed,
    Object? reason = freezed,
    Object? authorizedBy = freezed,
    Object? appliedAt = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            orderId:
                null == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String,
            discountId:
                null == discountId
                    ? _value.discountId
                    : discountId // ignore: cast_nullable_to_non_nullable
                        as String,
            discountName:
                null == discountName
                    ? _value.discountName
                    : discountName // ignore: cast_nullable_to_non_nullable
                        as String,
            discountCode:
                null == discountCode
                    ? _value.discountCode
                    : discountCode // ignore: cast_nullable_to_non_nullable
                        as String,
            discountType:
                null == discountType
                    ? _value.discountType
                    : discountType // ignore: cast_nullable_to_non_nullable
                        as String,
            appliedTo:
                null == appliedTo
                    ? _value.appliedTo
                    : appliedTo // ignore: cast_nullable_to_non_nullable
                        as String,
            discountPercent:
                null == discountPercent
                    ? _value.discountPercent
                    : discountPercent // ignore: cast_nullable_to_non_nullable
                        as double,
            discountAmount:
                null == discountAmount
                    ? _value.discountAmount
                    : discountAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            maximumDiscount:
                null == maximumDiscount
                    ? _value.maximumDiscount
                    : maximumDiscount // ignore: cast_nullable_to_non_nullable
                        as double,
            appliedAmount:
                null == appliedAmount
                    ? _value.appliedAmount
                    : appliedAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            minimumPurchase:
                null == minimumPurchase
                    ? _value.minimumPurchase
                    : minimumPurchase // ignore: cast_nullable_to_non_nullable
                        as double,
            minimumQuantity:
                null == minimumQuantity
                    ? _value.minimumQuantity
                    : minimumQuantity // ignore: cast_nullable_to_non_nullable
                        as int,
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
            applicationMethod:
                null == applicationMethod
                    ? _value.applicationMethod
                    : applicationMethod // ignore: cast_nullable_to_non_nullable
                        as String,
            couponCode:
                freezed == couponCode
                    ? _value.couponCode
                    : couponCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            appliedBy:
                freezed == appliedBy
                    ? _value.appliedBy
                    : appliedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            appliedByName:
                freezed == appliedByName
                    ? _value.appliedByName
                    : appliedByName // ignore: cast_nullable_to_non_nullable
                        as String?,
            reason:
                freezed == reason
                    ? _value.reason
                    : reason // ignore: cast_nullable_to_non_nullable
                        as String?,
            authorizedBy:
                freezed == authorizedBy
                    ? _value.authorizedBy
                    : authorizedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            appliedAt:
                null == appliedAt
                    ? _value.appliedAt
                    : appliedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderDiscountImplCopyWith<$Res>
    implements $OrderDiscountCopyWith<$Res> {
  factory _$$OrderDiscountImplCopyWith(
    _$OrderDiscountImpl value,
    $Res Function(_$OrderDiscountImpl) then,
  ) = __$$OrderDiscountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    String discountId,
    String discountName,
    String discountCode,
    String discountType,
    String appliedTo,
    double discountPercent,
    double discountAmount,
    double maximumDiscount,
    double appliedAmount,
    double minimumPurchase,
    int minimumQuantity,
    List<String> applicableCategories,
    List<String> applicableProducts,
    String applicationMethod,
    String? couponCode,
    String? appliedBy,
    String? appliedByName,
    String? reason,
    String? authorizedBy,
    DateTime appliedAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$OrderDiscountImplCopyWithImpl<$Res>
    extends _$OrderDiscountCopyWithImpl<$Res, _$OrderDiscountImpl>
    implements _$$OrderDiscountImplCopyWith<$Res> {
  __$$OrderDiscountImplCopyWithImpl(
    _$OrderDiscountImpl _value,
    $Res Function(_$OrderDiscountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDiscount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? discountId = null,
    Object? discountName = null,
    Object? discountCode = null,
    Object? discountType = null,
    Object? appliedTo = null,
    Object? discountPercent = null,
    Object? discountAmount = null,
    Object? maximumDiscount = null,
    Object? appliedAmount = null,
    Object? minimumPurchase = null,
    Object? minimumQuantity = null,
    Object? applicableCategories = null,
    Object? applicableProducts = null,
    Object? applicationMethod = null,
    Object? couponCode = freezed,
    Object? appliedBy = freezed,
    Object? appliedByName = freezed,
    Object? reason = freezed,
    Object? authorizedBy = freezed,
    Object? appliedAt = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$OrderDiscountImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        orderId:
            null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String,
        discountId:
            null == discountId
                ? _value.discountId
                : discountId // ignore: cast_nullable_to_non_nullable
                    as String,
        discountName:
            null == discountName
                ? _value.discountName
                : discountName // ignore: cast_nullable_to_non_nullable
                    as String,
        discountCode:
            null == discountCode
                ? _value.discountCode
                : discountCode // ignore: cast_nullable_to_non_nullable
                    as String,
        discountType:
            null == discountType
                ? _value.discountType
                : discountType // ignore: cast_nullable_to_non_nullable
                    as String,
        appliedTo:
            null == appliedTo
                ? _value.appliedTo
                : appliedTo // ignore: cast_nullable_to_non_nullable
                    as String,
        discountPercent:
            null == discountPercent
                ? _value.discountPercent
                : discountPercent // ignore: cast_nullable_to_non_nullable
                    as double,
        discountAmount:
            null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        maximumDiscount:
            null == maximumDiscount
                ? _value.maximumDiscount
                : maximumDiscount // ignore: cast_nullable_to_non_nullable
                    as double,
        appliedAmount:
            null == appliedAmount
                ? _value.appliedAmount
                : appliedAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        minimumPurchase:
            null == minimumPurchase
                ? _value.minimumPurchase
                : minimumPurchase // ignore: cast_nullable_to_non_nullable
                    as double,
        minimumQuantity:
            null == minimumQuantity
                ? _value.minimumQuantity
                : minimumQuantity // ignore: cast_nullable_to_non_nullable
                    as int,
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
        applicationMethod:
            null == applicationMethod
                ? _value.applicationMethod
                : applicationMethod // ignore: cast_nullable_to_non_nullable
                    as String,
        couponCode:
            freezed == couponCode
                ? _value.couponCode
                : couponCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        appliedBy:
            freezed == appliedBy
                ? _value.appliedBy
                : appliedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        appliedByName:
            freezed == appliedByName
                ? _value.appliedByName
                : appliedByName // ignore: cast_nullable_to_non_nullable
                    as String?,
        reason:
            freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                    as String?,
        authorizedBy:
            freezed == authorizedBy
                ? _value.authorizedBy
                : authorizedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        appliedAt:
            null == appliedAt
                ? _value.appliedAt
                : appliedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDiscountImpl extends _OrderDiscount {
  const _$OrderDiscountImpl({
    required this.id,
    required this.orderId,
    required this.discountId,
    required this.discountName,
    required this.discountCode,
    required this.discountType,
    required this.appliedTo,
    this.discountPercent = 0,
    this.discountAmount = 0,
    this.maximumDiscount = 0,
    required this.appliedAmount,
    this.minimumPurchase = 0,
    this.minimumQuantity = 0,
    final List<String> applicableCategories = const [],
    final List<String> applicableProducts = const [],
    this.applicationMethod = 'auto',
    this.couponCode,
    this.appliedBy,
    this.appliedByName,
    this.reason,
    this.authorizedBy,
    required this.appliedAt,
    final Map<String, dynamic>? metadata,
  }) : _applicableCategories = applicableCategories,
       _applicableProducts = applicableProducts,
       _metadata = metadata,
       super._();

  factory _$OrderDiscountImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDiscountImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  // Discount Information (snapshot)
  @override
  final String discountId;
  @override
  final String discountName;
  @override
  final String discountCode;
  // Type
  @override
  final String discountType;
  // percentage, fixed, item_based, buy_x_get_y
  @override
  final String appliedTo;
  // order, items, category, specific_items
  // Values
  @override
  @JsonKey()
  final double discountPercent;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double maximumDiscount;
  // Applied Amount (actual discount given)
  @override
  final double appliedAmount;
  // Conditions (snapshot of what qualified this discount)
  @override
  @JsonKey()
  final double minimumPurchase;
  @override
  @JsonKey()
  final int minimumQuantity;
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

  // Application Details
  @override
  @JsonKey()
  final String applicationMethod;
  // auto, manual, coupon
  @override
  final String? couponCode;
  @override
  final String? appliedBy;
  // User ID who applied manual discount
  @override
  final String? appliedByName;
  // Snapshot
  // Reason (for manual discounts)
  @override
  final String? reason;
  @override
  final String? authorizedBy;
  // Manager who authorized
  // Metadata
  @override
  final DateTime appliedAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'OrderDiscount(id: $id, orderId: $orderId, discountId: $discountId, discountName: $discountName, discountCode: $discountCode, discountType: $discountType, appliedTo: $appliedTo, discountPercent: $discountPercent, discountAmount: $discountAmount, maximumDiscount: $maximumDiscount, appliedAmount: $appliedAmount, minimumPurchase: $minimumPurchase, minimumQuantity: $minimumQuantity, applicableCategories: $applicableCategories, applicableProducts: $applicableProducts, applicationMethod: $applicationMethod, couponCode: $couponCode, appliedBy: $appliedBy, appliedByName: $appliedByName, reason: $reason, authorizedBy: $authorizedBy, appliedAt: $appliedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDiscountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.discountId, discountId) ||
                other.discountId == discountId) &&
            (identical(other.discountName, discountName) ||
                other.discountName == discountName) &&
            (identical(other.discountCode, discountCode) ||
                other.discountCode == discountCode) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.appliedTo, appliedTo) ||
                other.appliedTo == appliedTo) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.maximumDiscount, maximumDiscount) ||
                other.maximumDiscount == maximumDiscount) &&
            (identical(other.appliedAmount, appliedAmount) ||
                other.appliedAmount == appliedAmount) &&
            (identical(other.minimumPurchase, minimumPurchase) ||
                other.minimumPurchase == minimumPurchase) &&
            (identical(other.minimumQuantity, minimumQuantity) ||
                other.minimumQuantity == minimumQuantity) &&
            const DeepCollectionEquality().equals(
              other._applicableCategories,
              _applicableCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._applicableProducts,
              _applicableProducts,
            ) &&
            (identical(other.applicationMethod, applicationMethod) ||
                other.applicationMethod == applicationMethod) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
            (identical(other.appliedBy, appliedBy) ||
                other.appliedBy == appliedBy) &&
            (identical(other.appliedByName, appliedByName) ||
                other.appliedByName == appliedByName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.authorizedBy, authorizedBy) ||
                other.authorizedBy == authorizedBy) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    orderId,
    discountId,
    discountName,
    discountCode,
    discountType,
    appliedTo,
    discountPercent,
    discountAmount,
    maximumDiscount,
    appliedAmount,
    minimumPurchase,
    minimumQuantity,
    const DeepCollectionEquality().hash(_applicableCategories),
    const DeepCollectionEquality().hash(_applicableProducts),
    applicationMethod,
    couponCode,
    appliedBy,
    appliedByName,
    reason,
    authorizedBy,
    appliedAt,
    const DeepCollectionEquality().hash(_metadata),
  ]);

  /// Create a copy of OrderDiscount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDiscountImplCopyWith<_$OrderDiscountImpl> get copyWith =>
      __$$OrderDiscountImplCopyWithImpl<_$OrderDiscountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDiscountImplToJson(this);
  }
}

abstract class _OrderDiscount extends OrderDiscount {
  const factory _OrderDiscount({
    required final String id,
    required final String orderId,
    required final String discountId,
    required final String discountName,
    required final String discountCode,
    required final String discountType,
    required final String appliedTo,
    final double discountPercent,
    final double discountAmount,
    final double maximumDiscount,
    required final double appliedAmount,
    final double minimumPurchase,
    final int minimumQuantity,
    final List<String> applicableCategories,
    final List<String> applicableProducts,
    final String applicationMethod,
    final String? couponCode,
    final String? appliedBy,
    final String? appliedByName,
    final String? reason,
    final String? authorizedBy,
    required final DateTime appliedAt,
    final Map<String, dynamic>? metadata,
  }) = _$OrderDiscountImpl;
  const _OrderDiscount._() : super._();

  factory _OrderDiscount.fromJson(Map<String, dynamic> json) =
      _$OrderDiscountImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId; // Discount Information (snapshot)
  @override
  String get discountId;
  @override
  String get discountName;
  @override
  String get discountCode; // Type
  @override
  String get discountType; // percentage, fixed, item_based, buy_x_get_y
  @override
  String get appliedTo; // order, items, category, specific_items
  // Values
  @override
  double get discountPercent;
  @override
  double get discountAmount;
  @override
  double get maximumDiscount; // Applied Amount (actual discount given)
  @override
  double get appliedAmount; // Conditions (snapshot of what qualified this discount)
  @override
  double get minimumPurchase;
  @override
  int get minimumQuantity;
  @override
  List<String> get applicableCategories;
  @override
  List<String> get applicableProducts; // Application Details
  @override
  String get applicationMethod; // auto, manual, coupon
  @override
  String? get couponCode;
  @override
  String? get appliedBy; // User ID who applied manual discount
  @override
  String? get appliedByName; // Snapshot
  // Reason (for manual discounts)
  @override
  String? get reason;
  @override
  String? get authorizedBy; // Manager who authorized
  // Metadata
  @override
  DateTime get appliedAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of OrderDiscount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDiscountImplCopyWith<_$OrderDiscountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
