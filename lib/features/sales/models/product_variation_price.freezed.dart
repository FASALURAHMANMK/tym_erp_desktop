// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_variation_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductVariationPrice _$ProductVariationPriceFromJson(
  Map<String, dynamic> json,
) {
  return _ProductVariationPrice.fromJson(json);
}

/// @nodoc
mixin _$ProductVariationPrice {
  String get id => throw _privateConstructorUsedError;
  String get variationId => throw _privateConstructorUsedError;
  String get priceCategoryId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double? get cost => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this ProductVariationPrice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductVariationPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductVariationPriceCopyWith<ProductVariationPrice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductVariationPriceCopyWith<$Res> {
  factory $ProductVariationPriceCopyWith(
    ProductVariationPrice value,
    $Res Function(ProductVariationPrice) then,
  ) = _$ProductVariationPriceCopyWithImpl<$Res, ProductVariationPrice>;
  @useResult
  $Res call({
    String id,
    String variationId,
    String priceCategoryId,
    double price,
    double? cost,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$ProductVariationPriceCopyWithImpl<
  $Res,
  $Val extends ProductVariationPrice
>
    implements $ProductVariationPriceCopyWith<$Res> {
  _$ProductVariationPriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductVariationPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variationId = null,
    Object? priceCategoryId = null,
    Object? price = null,
    Object? cost = freezed,
    Object? isActive = null,
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
            variationId:
                null == variationId
                    ? _value.variationId
                    : variationId // ignore: cast_nullable_to_non_nullable
                        as String,
            priceCategoryId:
                null == priceCategoryId
                    ? _value.priceCategoryId
                    : priceCategoryId // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            cost:
                freezed == cost
                    ? _value.cost
                    : cost // ignore: cast_nullable_to_non_nullable
                        as double?,
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
abstract class _$$ProductVariationPriceImplCopyWith<$Res>
    implements $ProductVariationPriceCopyWith<$Res> {
  factory _$$ProductVariationPriceImplCopyWith(
    _$ProductVariationPriceImpl value,
    $Res Function(_$ProductVariationPriceImpl) then,
  ) = __$$ProductVariationPriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String variationId,
    String priceCategoryId,
    double price,
    double? cost,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$ProductVariationPriceImplCopyWithImpl<$Res>
    extends
        _$ProductVariationPriceCopyWithImpl<$Res, _$ProductVariationPriceImpl>
    implements _$$ProductVariationPriceImplCopyWith<$Res> {
  __$$ProductVariationPriceImplCopyWithImpl(
    _$ProductVariationPriceImpl _value,
    $Res Function(_$ProductVariationPriceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductVariationPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variationId = null,
    Object? priceCategoryId = null,
    Object? price = null,
    Object? cost = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$ProductVariationPriceImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        variationId:
            null == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                    as String,
        priceCategoryId:
            null == priceCategoryId
                ? _value.priceCategoryId
                : priceCategoryId // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        cost:
            freezed == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                    as double?,
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
class _$ProductVariationPriceImpl extends _ProductVariationPrice {
  const _$ProductVariationPriceImpl({
    required this.id,
    required this.variationId,
    required this.priceCategoryId,
    required this.price,
    this.cost,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : super._();

  factory _$ProductVariationPriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductVariationPriceImplFromJson(json);

  @override
  final String id;
  @override
  final String variationId;
  @override
  final String priceCategoryId;
  @override
  final double price;
  @override
  final double? cost;
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
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'ProductVariationPrice(id: $id, variationId: $variationId, priceCategoryId: $priceCategoryId, price: $price, cost: $cost, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductVariationPriceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.priceCategoryId, priceCategoryId) ||
                other.priceCategoryId == priceCategoryId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
    variationId,
    priceCategoryId,
    price,
    cost,
    isActive,
    createdAt,
    updatedAt,
    createdBy,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of ProductVariationPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductVariationPriceImplCopyWith<_$ProductVariationPriceImpl>
  get copyWith =>
      __$$ProductVariationPriceImplCopyWithImpl<_$ProductVariationPriceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductVariationPriceImplToJson(this);
  }
}

abstract class _ProductVariationPrice extends ProductVariationPrice {
  const factory _ProductVariationPrice({
    required final String id,
    required final String variationId,
    required final String priceCategoryId,
    required final double price,
    final double? cost,
    final bool isActive,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? createdBy,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$ProductVariationPriceImpl;
  const _ProductVariationPrice._() : super._();

  factory _ProductVariationPrice.fromJson(Map<String, dynamic> json) =
      _$ProductVariationPriceImpl.fromJson;

  @override
  String get id;
  @override
  String get variationId;
  @override
  String get priceCategoryId;
  @override
  double get price;
  @override
  double? get cost;
  @override
  bool get isActive;
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

  /// Create a copy of ProductVariationPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductVariationPriceImplCopyWith<_$ProductVariationPriceImpl>
  get copyWith => throw _privateConstructorUsedError;
}
