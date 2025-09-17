// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  String get id =>
      throw _privateConstructorUsedError; // Unique ID for this cart item
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get categoryId =>
      throw _privateConstructorUsedError; // Add category ID for discount matching
  String? get categoryName => throw _privateConstructorUsedError;
  String get variationId => throw _privateConstructorUsedError;
  String get variationName => throw _privateConstructorUsedError;
  String? get productImage => throw _privateConstructorUsedError;
  String? get productCode => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get unitOfMeasure => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get originalPrice =>
      throw _privateConstructorUsedError; // Original price before any modifications
  double get discountAmount => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  String? get discountReason => throw _privateConstructorUsedError;
  String? get appliedDiscountId => throw _privateConstructorUsedError;
  List<AppliedItemDiscount> get appliedDiscounts =>
      throw _privateConstructorUsedError; // Track all applied discounts
  bool get manuallyRemovedDiscounts =>
      throw _privateConstructorUsedError; // Track if user manually removed discounts
  double get taxAmount => throw _privateConstructorUsedError;
  double get taxPercent => throw _privateConstructorUsedError;
  double get taxRate => throw _privateConstructorUsedError;
  String? get taxGroupId => throw _privateConstructorUsedError;
  String? get taxGroupName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;
  bool get skipKot => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata =>
      throw _privateConstructorUsedError; // For any additional data
  DateTime get addedAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call({
    String id,
    String productId,
    String productName,
    String? categoryId,
    String? categoryName,
    String variationId,
    String variationName,
    String? productImage,
    String? productCode,
    String? sku,
    String? unitOfMeasure,
    double quantity,
    double unitPrice,
    double originalPrice,
    double discountAmount,
    double discountPercent,
    String? discountReason,
    String? appliedDiscountId,
    List<AppliedItemDiscount> appliedDiscounts,
    bool manuallyRemovedDiscounts,
    double taxAmount,
    double taxPercent,
    double taxRate,
    String? taxGroupId,
    String? taxGroupName,
    String? notes,
    String? specialInstructions,
    bool skipKot,
    Map<String, dynamic> metadata,
    DateTime addedAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? variationId = null,
    Object? variationName = null,
    Object? productImage = freezed,
    Object? productCode = freezed,
    Object? sku = freezed,
    Object? unitOfMeasure = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? originalPrice = null,
    Object? discountAmount = null,
    Object? discountPercent = null,
    Object? discountReason = freezed,
    Object? appliedDiscountId = freezed,
    Object? appliedDiscounts = null,
    Object? manuallyRemovedDiscounts = null,
    Object? taxAmount = null,
    Object? taxPercent = null,
    Object? taxRate = null,
    Object? taxGroupId = freezed,
    Object? taxGroupName = freezed,
    Object? notes = freezed,
    Object? specialInstructions = freezed,
    Object? skipKot = null,
    Object? metadata = null,
    Object? addedAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            productId:
                null == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String,
            productName:
                null == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String,
            categoryId:
                freezed == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            categoryName:
                freezed == categoryName
                    ? _value.categoryName
                    : categoryName // ignore: cast_nullable_to_non_nullable
                        as String?,
            variationId:
                null == variationId
                    ? _value.variationId
                    : variationId // ignore: cast_nullable_to_non_nullable
                        as String,
            variationName:
                null == variationName
                    ? _value.variationName
                    : variationName // ignore: cast_nullable_to_non_nullable
                        as String,
            productImage:
                freezed == productImage
                    ? _value.productImage
                    : productImage // ignore: cast_nullable_to_non_nullable
                        as String?,
            productCode:
                freezed == productCode
                    ? _value.productCode
                    : productCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            sku:
                freezed == sku
                    ? _value.sku
                    : sku // ignore: cast_nullable_to_non_nullable
                        as String?,
            unitOfMeasure:
                freezed == unitOfMeasure
                    ? _value.unitOfMeasure
                    : unitOfMeasure // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                null == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as double,
            unitPrice:
                null == unitPrice
                    ? _value.unitPrice
                    : unitPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            originalPrice:
                null == originalPrice
                    ? _value.originalPrice
                    : originalPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            discountAmount:
                null == discountAmount
                    ? _value.discountAmount
                    : discountAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            discountPercent:
                null == discountPercent
                    ? _value.discountPercent
                    : discountPercent // ignore: cast_nullable_to_non_nullable
                        as double,
            discountReason:
                freezed == discountReason
                    ? _value.discountReason
                    : discountReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            appliedDiscountId:
                freezed == appliedDiscountId
                    ? _value.appliedDiscountId
                    : appliedDiscountId // ignore: cast_nullable_to_non_nullable
                        as String?,
            appliedDiscounts:
                null == appliedDiscounts
                    ? _value.appliedDiscounts
                    : appliedDiscounts // ignore: cast_nullable_to_non_nullable
                        as List<AppliedItemDiscount>,
            manuallyRemovedDiscounts:
                null == manuallyRemovedDiscounts
                    ? _value.manuallyRemovedDiscounts
                    : manuallyRemovedDiscounts // ignore: cast_nullable_to_non_nullable
                        as bool,
            taxAmount:
                null == taxAmount
                    ? _value.taxAmount
                    : taxAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            taxPercent:
                null == taxPercent
                    ? _value.taxPercent
                    : taxPercent // ignore: cast_nullable_to_non_nullable
                        as double,
            taxRate:
                null == taxRate
                    ? _value.taxRate
                    : taxRate // ignore: cast_nullable_to_non_nullable
                        as double,
            taxGroupId:
                freezed == taxGroupId
                    ? _value.taxGroupId
                    : taxGroupId // ignore: cast_nullable_to_non_nullable
                        as String?,
            taxGroupName:
                freezed == taxGroupName
                    ? _value.taxGroupName
                    : taxGroupName // ignore: cast_nullable_to_non_nullable
                        as String?,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            specialInstructions:
                freezed == specialInstructions
                    ? _value.specialInstructions
                    : specialInstructions // ignore: cast_nullable_to_non_nullable
                        as String?,
            skipKot:
                null == skipKot
                    ? _value.skipKot
                    : skipKot // ignore: cast_nullable_to_non_nullable
                        as bool,
            metadata:
                null == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            addedAt:
                null == addedAt
                    ? _value.addedAt
                    : addedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
    _$CartItemImpl value,
    $Res Function(_$CartItemImpl) then,
  ) = __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productId,
    String productName,
    String? categoryId,
    String? categoryName,
    String variationId,
    String variationName,
    String? productImage,
    String? productCode,
    String? sku,
    String? unitOfMeasure,
    double quantity,
    double unitPrice,
    double originalPrice,
    double discountAmount,
    double discountPercent,
    String? discountReason,
    String? appliedDiscountId,
    List<AppliedItemDiscount> appliedDiscounts,
    bool manuallyRemovedDiscounts,
    double taxAmount,
    double taxPercent,
    double taxRate,
    String? taxGroupId,
    String? taxGroupName,
    String? notes,
    String? specialInstructions,
    bool skipKot,
    Map<String, dynamic> metadata,
    DateTime addedAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
    _$CartItemImpl _value,
    $Res Function(_$CartItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? variationId = null,
    Object? variationName = null,
    Object? productImage = freezed,
    Object? productCode = freezed,
    Object? sku = freezed,
    Object? unitOfMeasure = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? originalPrice = null,
    Object? discountAmount = null,
    Object? discountPercent = null,
    Object? discountReason = freezed,
    Object? appliedDiscountId = freezed,
    Object? appliedDiscounts = null,
    Object? manuallyRemovedDiscounts = null,
    Object? taxAmount = null,
    Object? taxPercent = null,
    Object? taxRate = null,
    Object? taxGroupId = freezed,
    Object? taxGroupName = freezed,
    Object? notes = freezed,
    Object? specialInstructions = freezed,
    Object? skipKot = null,
    Object? metadata = null,
    Object? addedAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CartItemImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        productId:
            null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String,
        productName:
            null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String,
        categoryId:
            freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        categoryName:
            freezed == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                    as String?,
        variationId:
            null == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                    as String,
        variationName:
            null == variationName
                ? _value.variationName
                : variationName // ignore: cast_nullable_to_non_nullable
                    as String,
        productImage:
            freezed == productImage
                ? _value.productImage
                : productImage // ignore: cast_nullable_to_non_nullable
                    as String?,
        productCode:
            freezed == productCode
                ? _value.productCode
                : productCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        sku:
            freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                    as String?,
        unitOfMeasure:
            freezed == unitOfMeasure
                ? _value.unitOfMeasure
                : unitOfMeasure // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as double,
        unitPrice:
            null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        originalPrice:
            null == originalPrice
                ? _value.originalPrice
                : originalPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        discountAmount:
            null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        discountPercent:
            null == discountPercent
                ? _value.discountPercent
                : discountPercent // ignore: cast_nullable_to_non_nullable
                    as double,
        discountReason:
            freezed == discountReason
                ? _value.discountReason
                : discountReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        appliedDiscountId:
            freezed == appliedDiscountId
                ? _value.appliedDiscountId
                : appliedDiscountId // ignore: cast_nullable_to_non_nullable
                    as String?,
        appliedDiscounts:
            null == appliedDiscounts
                ? _value._appliedDiscounts
                : appliedDiscounts // ignore: cast_nullable_to_non_nullable
                    as List<AppliedItemDiscount>,
        manuallyRemovedDiscounts:
            null == manuallyRemovedDiscounts
                ? _value.manuallyRemovedDiscounts
                : manuallyRemovedDiscounts // ignore: cast_nullable_to_non_nullable
                    as bool,
        taxAmount:
            null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        taxPercent:
            null == taxPercent
                ? _value.taxPercent
                : taxPercent // ignore: cast_nullable_to_non_nullable
                    as double,
        taxRate:
            null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                    as double,
        taxGroupId:
            freezed == taxGroupId
                ? _value.taxGroupId
                : taxGroupId // ignore: cast_nullable_to_non_nullable
                    as String?,
        taxGroupName:
            freezed == taxGroupName
                ? _value.taxGroupName
                : taxGroupName // ignore: cast_nullable_to_non_nullable
                    as String?,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        specialInstructions:
            freezed == specialInstructions
                ? _value.specialInstructions
                : specialInstructions // ignore: cast_nullable_to_non_nullable
                    as String?,
        skipKot:
            null == skipKot
                ? _value.skipKot
                : skipKot // ignore: cast_nullable_to_non_nullable
                    as bool,
        metadata:
            null == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        addedAt:
            null == addedAt
                ? _value.addedAt
                : addedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl extends _CartItem {
  const _$CartItemImpl({
    required this.id,
    required this.productId,
    required this.productName,
    this.categoryId,
    this.categoryName,
    required this.variationId,
    required this.variationName,
    this.productImage,
    this.productCode,
    this.sku,
    this.unitOfMeasure,
    required this.quantity,
    required this.unitPrice,
    required this.originalPrice,
    this.discountAmount = 0.0,
    this.discountPercent = 0.0,
    this.discountReason,
    this.appliedDiscountId,
    final List<AppliedItemDiscount> appliedDiscounts = const [],
    this.manuallyRemovedDiscounts = false,
    this.taxAmount = 0.0,
    this.taxPercent = 0.0,
    this.taxRate = 0.0,
    this.taxGroupId,
    this.taxGroupName,
    this.notes,
    this.specialInstructions,
    this.skipKot = false,
    final Map<String, dynamic> metadata = const {},
    required this.addedAt,
    this.updatedAt,
  }) : _appliedDiscounts = appliedDiscounts,
       _metadata = metadata,
       super._();

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  final String id;
  // Unique ID for this cart item
  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? categoryId;
  // Add category ID for discount matching
  @override
  final String? categoryName;
  @override
  final String variationId;
  @override
  final String variationName;
  @override
  final String? productImage;
  @override
  final String? productCode;
  @override
  final String? sku;
  @override
  final String? unitOfMeasure;
  @override
  final double quantity;
  @override
  final double unitPrice;
  @override
  final double originalPrice;
  // Original price before any modifications
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double discountPercent;
  @override
  final String? discountReason;
  @override
  final String? appliedDiscountId;
  final List<AppliedItemDiscount> _appliedDiscounts;
  @override
  @JsonKey()
  List<AppliedItemDiscount> get appliedDiscounts {
    if (_appliedDiscounts is EqualUnmodifiableListView)
      return _appliedDiscounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appliedDiscounts);
  }

  // Track all applied discounts
  @override
  @JsonKey()
  final bool manuallyRemovedDiscounts;
  // Track if user manually removed discounts
  @override
  @JsonKey()
  final double taxAmount;
  @override
  @JsonKey()
  final double taxPercent;
  @override
  @JsonKey()
  final double taxRate;
  @override
  final String? taxGroupId;
  @override
  final String? taxGroupName;
  @override
  final String? notes;
  @override
  final String? specialInstructions;
  @override
  @JsonKey()
  final bool skipKot;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  // For any additional data
  @override
  final DateTime addedAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CartItem(id: $id, productId: $productId, productName: $productName, categoryId: $categoryId, categoryName: $categoryName, variationId: $variationId, variationName: $variationName, productImage: $productImage, productCode: $productCode, sku: $sku, unitOfMeasure: $unitOfMeasure, quantity: $quantity, unitPrice: $unitPrice, originalPrice: $originalPrice, discountAmount: $discountAmount, discountPercent: $discountPercent, discountReason: $discountReason, appliedDiscountId: $appliedDiscountId, appliedDiscounts: $appliedDiscounts, manuallyRemovedDiscounts: $manuallyRemovedDiscounts, taxAmount: $taxAmount, taxPercent: $taxPercent, taxRate: $taxRate, taxGroupId: $taxGroupId, taxGroupName: $taxGroupName, notes: $notes, specialInstructions: $specialInstructions, skipKot: $skipKot, metadata: $metadata, addedAt: $addedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.variationName, variationName) ||
                other.variationName == variationName) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.unitOfMeasure, unitOfMeasure) ||
                other.unitOfMeasure == unitOfMeasure) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountReason, discountReason) ||
                other.discountReason == discountReason) &&
            (identical(other.appliedDiscountId, appliedDiscountId) ||
                other.appliedDiscountId == appliedDiscountId) &&
            const DeepCollectionEquality().equals(
              other._appliedDiscounts,
              _appliedDiscounts,
            ) &&
            (identical(
                  other.manuallyRemovedDiscounts,
                  manuallyRemovedDiscounts,
                ) ||
                other.manuallyRemovedDiscounts == manuallyRemovedDiscounts) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.taxPercent, taxPercent) ||
                other.taxPercent == taxPercent) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxGroupId, taxGroupId) ||
                other.taxGroupId == taxGroupId) &&
            (identical(other.taxGroupName, taxGroupName) ||
                other.taxGroupName == taxGroupName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.skipKot, skipKot) || other.skipKot == skipKot) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    productId,
    productName,
    categoryId,
    categoryName,
    variationId,
    variationName,
    productImage,
    productCode,
    sku,
    unitOfMeasure,
    quantity,
    unitPrice,
    originalPrice,
    discountAmount,
    discountPercent,
    discountReason,
    appliedDiscountId,
    const DeepCollectionEquality().hash(_appliedDiscounts),
    manuallyRemovedDiscounts,
    taxAmount,
    taxPercent,
    taxRate,
    taxGroupId,
    taxGroupName,
    notes,
    specialInstructions,
    skipKot,
    const DeepCollectionEquality().hash(_metadata),
    addedAt,
    updatedAt,
  ]);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(this);
  }
}

abstract class _CartItem extends CartItem {
  const factory _CartItem({
    required final String id,
    required final String productId,
    required final String productName,
    final String? categoryId,
    final String? categoryName,
    required final String variationId,
    required final String variationName,
    final String? productImage,
    final String? productCode,
    final String? sku,
    final String? unitOfMeasure,
    required final double quantity,
    required final double unitPrice,
    required final double originalPrice,
    final double discountAmount,
    final double discountPercent,
    final String? discountReason,
    final String? appliedDiscountId,
    final List<AppliedItemDiscount> appliedDiscounts,
    final bool manuallyRemovedDiscounts,
    final double taxAmount,
    final double taxPercent,
    final double taxRate,
    final String? taxGroupId,
    final String? taxGroupName,
    final String? notes,
    final String? specialInstructions,
    final bool skipKot,
    final Map<String, dynamic> metadata,
    required final DateTime addedAt,
    final DateTime? updatedAt,
  }) = _$CartItemImpl;
  const _CartItem._() : super._();

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  String get id; // Unique ID for this cart item
  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get categoryId; // Add category ID for discount matching
  @override
  String? get categoryName;
  @override
  String get variationId;
  @override
  String get variationName;
  @override
  String? get productImage;
  @override
  String? get productCode;
  @override
  String? get sku;
  @override
  String? get unitOfMeasure;
  @override
  double get quantity;
  @override
  double get unitPrice;
  @override
  double get originalPrice; // Original price before any modifications
  @override
  double get discountAmount;
  @override
  double get discountPercent;
  @override
  String? get discountReason;
  @override
  String? get appliedDiscountId;
  @override
  List<AppliedItemDiscount> get appliedDiscounts; // Track all applied discounts
  @override
  bool get manuallyRemovedDiscounts; // Track if user manually removed discounts
  @override
  double get taxAmount;
  @override
  double get taxPercent;
  @override
  double get taxRate;
  @override
  String? get taxGroupId;
  @override
  String? get taxGroupName;
  @override
  String? get notes;
  @override
  String? get specialInstructions;
  @override
  bool get skipKot;
  @override
  Map<String, dynamic> get metadata; // For any additional data
  @override
  DateTime get addedAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
