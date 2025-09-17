// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  // Identification
  String get id => throw _privateConstructorUsedError;
  String get orderId =>
      throw _privateConstructorUsedError; // Product Information (snapshot at time of order)
  String get productId => throw _privateConstructorUsedError;
  String get variationId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String get variationName => throw _privateConstructorUsedError;
  String? get productCode => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get unitOfMeasure =>
      throw _privateConstructorUsedError; // Quantity & Pricing
  double get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError; // Original price
  double get modifiersPrice =>
      throw _privateConstructorUsedError; // Additional charges for modifiers
  // Modifiers/Customization
  List<ItemModifier> get modifiers => throw _privateConstructorUsedError;
  String? get specialInstructions =>
      throw _privateConstructorUsedError; // Discounts
  double get discountAmount => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  String? get discountReason => throw _privateConstructorUsedError;
  String? get appliedDiscountId =>
      throw _privateConstructorUsedError; // Tax (snapshot at time of order)
  double get taxRate => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  String? get taxGroupId => throw _privateConstructorUsedError;
  String? get taxGroupName =>
      throw _privateConstructorUsedError; // Calculated Totals
  double get subtotal =>
      throw _privateConstructorUsedError; // (unitPrice + modifiersPrice) * quantity
  double get total =>
      throw _privateConstructorUsedError; // subtotal - discount + tax
  // Kitchen/Preparation
  bool get skipKot => throw _privateConstructorUsedError;
  bool get kotPrinted => throw _privateConstructorUsedError;
  DateTime? get kotPrintedAt => throw _privateConstructorUsedError;
  String? get kotNumber => throw _privateConstructorUsedError;
  PreparationStatus get preparationStatus => throw _privateConstructorUsedError;
  DateTime? get preparedAt => throw _privateConstructorUsedError;
  String? get preparedBy =>
      throw _privateConstructorUsedError; // Kitchen staff ID
  String? get station =>
      throw _privateConstructorUsedError; // Kitchen station (e.g., "Main Kitchen", "Bar", "Dessert")
  // Service
  DateTime? get servedAt => throw _privateConstructorUsedError;
  String? get servedBy => throw _privateConstructorUsedError; // Waiter ID
  // Void/Cancel Information
  bool get isVoided => throw _privateConstructorUsedError;
  DateTime? get voidedAt => throw _privateConstructorUsedError;
  String? get voidedBy => throw _privateConstructorUsedError;
  String? get voidReason => throw _privateConstructorUsedError;
  bool get isComplimentary => throw _privateConstructorUsedError;
  String? get complimentaryReason =>
      throw _privateConstructorUsedError; // Return/Refund
  bool get isReturned => throw _privateConstructorUsedError;
  double get returnedQuantity => throw _privateConstructorUsedError;
  DateTime? get returnedAt => throw _privateConstructorUsedError;
  String? get returnReason => throw _privateConstructorUsedError;
  double get refundedAmount =>
      throw _privateConstructorUsedError; // Display & Sorting
  int get displayOrder => throw _privateConstructorUsedError;
  String? get category =>
      throw _privateConstructorUsedError; // For grouping in display
  String? get categoryId => throw _privateConstructorUsedError; // Notes
  String? get itemNotes => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({
    String id,
    String orderId,
    String productId,
    String variationId,
    String productName,
    String variationName,
    String? productCode,
    String? sku,
    String? unitOfMeasure,
    double quantity,
    double unitPrice,
    double modifiersPrice,
    List<ItemModifier> modifiers,
    String? specialInstructions,
    double discountAmount,
    double discountPercent,
    String? discountReason,
    String? appliedDiscountId,
    double taxRate,
    double taxAmount,
    String? taxGroupId,
    String? taxGroupName,
    double subtotal,
    double total,
    bool skipKot,
    bool kotPrinted,
    DateTime? kotPrintedAt,
    String? kotNumber,
    PreparationStatus preparationStatus,
    DateTime? preparedAt,
    String? preparedBy,
    String? station,
    DateTime? servedAt,
    String? servedBy,
    bool isVoided,
    DateTime? voidedAt,
    String? voidedBy,
    String? voidReason,
    bool isComplimentary,
    String? complimentaryReason,
    bool isReturned,
    double returnedQuantity,
    DateTime? returnedAt,
    String? returnReason,
    double refundedAmount,
    int displayOrder,
    String? category,
    String? categoryId,
    String? itemNotes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? variationId = null,
    Object? productName = null,
    Object? variationName = null,
    Object? productCode = freezed,
    Object? sku = freezed,
    Object? unitOfMeasure = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? modifiersPrice = null,
    Object? modifiers = null,
    Object? specialInstructions = freezed,
    Object? discountAmount = null,
    Object? discountPercent = null,
    Object? discountReason = freezed,
    Object? appliedDiscountId = freezed,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? taxGroupId = freezed,
    Object? taxGroupName = freezed,
    Object? subtotal = null,
    Object? total = null,
    Object? skipKot = null,
    Object? kotPrinted = null,
    Object? kotPrintedAt = freezed,
    Object? kotNumber = freezed,
    Object? preparationStatus = null,
    Object? preparedAt = freezed,
    Object? preparedBy = freezed,
    Object? station = freezed,
    Object? servedAt = freezed,
    Object? servedBy = freezed,
    Object? isVoided = null,
    Object? voidedAt = freezed,
    Object? voidedBy = freezed,
    Object? voidReason = freezed,
    Object? isComplimentary = null,
    Object? complimentaryReason = freezed,
    Object? isReturned = null,
    Object? returnedQuantity = null,
    Object? returnedAt = freezed,
    Object? returnReason = freezed,
    Object? refundedAmount = null,
    Object? displayOrder = null,
    Object? category = freezed,
    Object? categoryId = freezed,
    Object? itemNotes = freezed,
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
            orderId:
                null == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String,
            productId:
                null == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String,
            variationId:
                null == variationId
                    ? _value.variationId
                    : variationId // ignore: cast_nullable_to_non_nullable
                        as String,
            productName:
                null == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String,
            variationName:
                null == variationName
                    ? _value.variationName
                    : variationName // ignore: cast_nullable_to_non_nullable
                        as String,
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
            modifiersPrice:
                null == modifiersPrice
                    ? _value.modifiersPrice
                    : modifiersPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            modifiers:
                null == modifiers
                    ? _value.modifiers
                    : modifiers // ignore: cast_nullable_to_non_nullable
                        as List<ItemModifier>,
            specialInstructions:
                freezed == specialInstructions
                    ? _value.specialInstructions
                    : specialInstructions // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            taxRate:
                null == taxRate
                    ? _value.taxRate
                    : taxRate // ignore: cast_nullable_to_non_nullable
                        as double,
            taxAmount:
                null == taxAmount
                    ? _value.taxAmount
                    : taxAmount // ignore: cast_nullable_to_non_nullable
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
            subtotal:
                null == subtotal
                    ? _value.subtotal
                    : subtotal // ignore: cast_nullable_to_non_nullable
                        as double,
            total:
                null == total
                    ? _value.total
                    : total // ignore: cast_nullable_to_non_nullable
                        as double,
            skipKot:
                null == skipKot
                    ? _value.skipKot
                    : skipKot // ignore: cast_nullable_to_non_nullable
                        as bool,
            kotPrinted:
                null == kotPrinted
                    ? _value.kotPrinted
                    : kotPrinted // ignore: cast_nullable_to_non_nullable
                        as bool,
            kotPrintedAt:
                freezed == kotPrintedAt
                    ? _value.kotPrintedAt
                    : kotPrintedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            kotNumber:
                freezed == kotNumber
                    ? _value.kotNumber
                    : kotNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            preparationStatus:
                null == preparationStatus
                    ? _value.preparationStatus
                    : preparationStatus // ignore: cast_nullable_to_non_nullable
                        as PreparationStatus,
            preparedAt:
                freezed == preparedAt
                    ? _value.preparedAt
                    : preparedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            preparedBy:
                freezed == preparedBy
                    ? _value.preparedBy
                    : preparedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            station:
                freezed == station
                    ? _value.station
                    : station // ignore: cast_nullable_to_non_nullable
                        as String?,
            servedAt:
                freezed == servedAt
                    ? _value.servedAt
                    : servedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            servedBy:
                freezed == servedBy
                    ? _value.servedBy
                    : servedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            isVoided:
                null == isVoided
                    ? _value.isVoided
                    : isVoided // ignore: cast_nullable_to_non_nullable
                        as bool,
            voidedAt:
                freezed == voidedAt
                    ? _value.voidedAt
                    : voidedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            voidedBy:
                freezed == voidedBy
                    ? _value.voidedBy
                    : voidedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            voidReason:
                freezed == voidReason
                    ? _value.voidReason
                    : voidReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            isComplimentary:
                null == isComplimentary
                    ? _value.isComplimentary
                    : isComplimentary // ignore: cast_nullable_to_non_nullable
                        as bool,
            complimentaryReason:
                freezed == complimentaryReason
                    ? _value.complimentaryReason
                    : complimentaryReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            isReturned:
                null == isReturned
                    ? _value.isReturned
                    : isReturned // ignore: cast_nullable_to_non_nullable
                        as bool,
            returnedQuantity:
                null == returnedQuantity
                    ? _value.returnedQuantity
                    : returnedQuantity // ignore: cast_nullable_to_non_nullable
                        as double,
            returnedAt:
                freezed == returnedAt
                    ? _value.returnedAt
                    : returnedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            returnReason:
                freezed == returnReason
                    ? _value.returnReason
                    : returnReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            refundedAmount:
                null == refundedAmount
                    ? _value.refundedAmount
                    : refundedAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            category:
                freezed == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String?,
            categoryId:
                freezed == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            itemNotes:
                freezed == itemNotes
                    ? _value.itemNotes
                    : itemNotes // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    String productId,
    String variationId,
    String productName,
    String variationName,
    String? productCode,
    String? sku,
    String? unitOfMeasure,
    double quantity,
    double unitPrice,
    double modifiersPrice,
    List<ItemModifier> modifiers,
    String? specialInstructions,
    double discountAmount,
    double discountPercent,
    String? discountReason,
    String? appliedDiscountId,
    double taxRate,
    double taxAmount,
    String? taxGroupId,
    String? taxGroupName,
    double subtotal,
    double total,
    bool skipKot,
    bool kotPrinted,
    DateTime? kotPrintedAt,
    String? kotNumber,
    PreparationStatus preparationStatus,
    DateTime? preparedAt,
    String? preparedBy,
    String? station,
    DateTime? servedAt,
    String? servedBy,
    bool isVoided,
    DateTime? voidedAt,
    String? voidedBy,
    String? voidReason,
    bool isComplimentary,
    String? complimentaryReason,
    bool isReturned,
    double returnedQuantity,
    DateTime? returnedAt,
    String? returnReason,
    double refundedAmount,
    int displayOrder,
    String? category,
    String? categoryId,
    String? itemNotes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? variationId = null,
    Object? productName = null,
    Object? variationName = null,
    Object? productCode = freezed,
    Object? sku = freezed,
    Object? unitOfMeasure = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? modifiersPrice = null,
    Object? modifiers = null,
    Object? specialInstructions = freezed,
    Object? discountAmount = null,
    Object? discountPercent = null,
    Object? discountReason = freezed,
    Object? appliedDiscountId = freezed,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? taxGroupId = freezed,
    Object? taxGroupName = freezed,
    Object? subtotal = null,
    Object? total = null,
    Object? skipKot = null,
    Object? kotPrinted = null,
    Object? kotPrintedAt = freezed,
    Object? kotNumber = freezed,
    Object? preparationStatus = null,
    Object? preparedAt = freezed,
    Object? preparedBy = freezed,
    Object? station = freezed,
    Object? servedAt = freezed,
    Object? servedBy = freezed,
    Object? isVoided = null,
    Object? voidedAt = freezed,
    Object? voidedBy = freezed,
    Object? voidReason = freezed,
    Object? isComplimentary = null,
    Object? complimentaryReason = freezed,
    Object? isReturned = null,
    Object? returnedQuantity = null,
    Object? returnedAt = freezed,
    Object? returnReason = freezed,
    Object? refundedAmount = null,
    Object? displayOrder = null,
    Object? category = freezed,
    Object? categoryId = freezed,
    Object? itemNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$OrderItemImpl(
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
        productId:
            null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String,
        variationId:
            null == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                    as String,
        productName:
            null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String,
        variationName:
            null == variationName
                ? _value.variationName
                : variationName // ignore: cast_nullable_to_non_nullable
                    as String,
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
        modifiersPrice:
            null == modifiersPrice
                ? _value.modifiersPrice
                : modifiersPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        modifiers:
            null == modifiers
                ? _value._modifiers
                : modifiers // ignore: cast_nullable_to_non_nullable
                    as List<ItemModifier>,
        specialInstructions:
            freezed == specialInstructions
                ? _value.specialInstructions
                : specialInstructions // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        taxRate:
            null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                    as double,
        taxAmount:
            null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
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
        subtotal:
            null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                    as double,
        total:
            null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                    as double,
        skipKot:
            null == skipKot
                ? _value.skipKot
                : skipKot // ignore: cast_nullable_to_non_nullable
                    as bool,
        kotPrinted:
            null == kotPrinted
                ? _value.kotPrinted
                : kotPrinted // ignore: cast_nullable_to_non_nullable
                    as bool,
        kotPrintedAt:
            freezed == kotPrintedAt
                ? _value.kotPrintedAt
                : kotPrintedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        kotNumber:
            freezed == kotNumber
                ? _value.kotNumber
                : kotNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        preparationStatus:
            null == preparationStatus
                ? _value.preparationStatus
                : preparationStatus // ignore: cast_nullable_to_non_nullable
                    as PreparationStatus,
        preparedAt:
            freezed == preparedAt
                ? _value.preparedAt
                : preparedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        preparedBy:
            freezed == preparedBy
                ? _value.preparedBy
                : preparedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        station:
            freezed == station
                ? _value.station
                : station // ignore: cast_nullable_to_non_nullable
                    as String?,
        servedAt:
            freezed == servedAt
                ? _value.servedAt
                : servedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        servedBy:
            freezed == servedBy
                ? _value.servedBy
                : servedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        isVoided:
            null == isVoided
                ? _value.isVoided
                : isVoided // ignore: cast_nullable_to_non_nullable
                    as bool,
        voidedAt:
            freezed == voidedAt
                ? _value.voidedAt
                : voidedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        voidedBy:
            freezed == voidedBy
                ? _value.voidedBy
                : voidedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        voidReason:
            freezed == voidReason
                ? _value.voidReason
                : voidReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        isComplimentary:
            null == isComplimentary
                ? _value.isComplimentary
                : isComplimentary // ignore: cast_nullable_to_non_nullable
                    as bool,
        complimentaryReason:
            freezed == complimentaryReason
                ? _value.complimentaryReason
                : complimentaryReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        isReturned:
            null == isReturned
                ? _value.isReturned
                : isReturned // ignore: cast_nullable_to_non_nullable
                    as bool,
        returnedQuantity:
            null == returnedQuantity
                ? _value.returnedQuantity
                : returnedQuantity // ignore: cast_nullable_to_non_nullable
                    as double,
        returnedAt:
            freezed == returnedAt
                ? _value.returnedAt
                : returnedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        returnReason:
            freezed == returnReason
                ? _value.returnReason
                : returnReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        refundedAmount:
            null == refundedAmount
                ? _value.refundedAmount
                : refundedAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        category:
            freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String?,
        categoryId:
            freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        itemNotes:
            freezed == itemNotes
                ? _value.itemNotes
                : itemNotes // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl extends _OrderItem {
  const _$OrderItemImpl({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.variationId,
    required this.productName,
    required this.variationName,
    this.productCode,
    this.sku,
    this.unitOfMeasure,
    this.quantity = 1,
    required this.unitPrice,
    this.modifiersPrice = 0,
    final List<ItemModifier> modifiers = const [],
    this.specialInstructions,
    this.discountAmount = 0,
    this.discountPercent = 0,
    this.discountReason,
    this.appliedDiscountId,
    this.taxRate = 0,
    this.taxAmount = 0,
    this.taxGroupId,
    this.taxGroupName,
    this.subtotal = 0,
    this.total = 0,
    this.skipKot = false,
    this.kotPrinted = false,
    this.kotPrintedAt,
    this.kotNumber,
    this.preparationStatus = PreparationStatus.pending,
    this.preparedAt,
    this.preparedBy,
    this.station,
    this.servedAt,
    this.servedBy,
    this.isVoided = false,
    this.voidedAt,
    this.voidedBy,
    this.voidReason,
    this.isComplimentary = false,
    this.complimentaryReason,
    this.isReturned = false,
    this.returnedQuantity = 0,
    this.returnedAt,
    this.returnReason,
    this.refundedAmount = 0,
    this.displayOrder = 0,
    this.category,
    this.categoryId,
    this.itemNotes,
    required this.createdAt,
    required this.updatedAt,
  }) : _modifiers = modifiers,
       super._();

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  // Identification
  @override
  final String id;
  @override
  final String orderId;
  // Product Information (snapshot at time of order)
  @override
  final String productId;
  @override
  final String variationId;
  @override
  final String productName;
  @override
  final String variationName;
  @override
  final String? productCode;
  @override
  final String? sku;
  @override
  final String? unitOfMeasure;
  // Quantity & Pricing
  @override
  @JsonKey()
  final double quantity;
  @override
  final double unitPrice;
  // Original price
  @override
  @JsonKey()
  final double modifiersPrice;
  // Additional charges for modifiers
  // Modifiers/Customization
  final List<ItemModifier> _modifiers;
  // Additional charges for modifiers
  // Modifiers/Customization
  @override
  @JsonKey()
  List<ItemModifier> get modifiers {
    if (_modifiers is EqualUnmodifiableListView) return _modifiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modifiers);
  }

  @override
  final String? specialInstructions;
  // Discounts
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
  // Tax (snapshot at time of order)
  @override
  @JsonKey()
  final double taxRate;
  @override
  @JsonKey()
  final double taxAmount;
  @override
  final String? taxGroupId;
  @override
  final String? taxGroupName;
  // Calculated Totals
  @override
  @JsonKey()
  final double subtotal;
  // (unitPrice + modifiersPrice) * quantity
  @override
  @JsonKey()
  final double total;
  // subtotal - discount + tax
  // Kitchen/Preparation
  @override
  @JsonKey()
  final bool skipKot;
  @override
  @JsonKey()
  final bool kotPrinted;
  @override
  final DateTime? kotPrintedAt;
  @override
  final String? kotNumber;
  @override
  @JsonKey()
  final PreparationStatus preparationStatus;
  @override
  final DateTime? preparedAt;
  @override
  final String? preparedBy;
  // Kitchen staff ID
  @override
  final String? station;
  // Kitchen station (e.g., "Main Kitchen", "Bar", "Dessert")
  // Service
  @override
  final DateTime? servedAt;
  @override
  final String? servedBy;
  // Waiter ID
  // Void/Cancel Information
  @override
  @JsonKey()
  final bool isVoided;
  @override
  final DateTime? voidedAt;
  @override
  final String? voidedBy;
  @override
  final String? voidReason;
  @override
  @JsonKey()
  final bool isComplimentary;
  @override
  final String? complimentaryReason;
  // Return/Refund
  @override
  @JsonKey()
  final bool isReturned;
  @override
  @JsonKey()
  final double returnedQuantity;
  @override
  final DateTime? returnedAt;
  @override
  final String? returnReason;
  @override
  @JsonKey()
  final double refundedAmount;
  // Display & Sorting
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final String? category;
  // For grouping in display
  @override
  final String? categoryId;
  // Notes
  @override
  final String? itemNotes;
  // Metadata
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, variationId: $variationId, productName: $productName, variationName: $variationName, productCode: $productCode, sku: $sku, unitOfMeasure: $unitOfMeasure, quantity: $quantity, unitPrice: $unitPrice, modifiersPrice: $modifiersPrice, modifiers: $modifiers, specialInstructions: $specialInstructions, discountAmount: $discountAmount, discountPercent: $discountPercent, discountReason: $discountReason, appliedDiscountId: $appliedDiscountId, taxRate: $taxRate, taxAmount: $taxAmount, taxGroupId: $taxGroupId, taxGroupName: $taxGroupName, subtotal: $subtotal, total: $total, skipKot: $skipKot, kotPrinted: $kotPrinted, kotPrintedAt: $kotPrintedAt, kotNumber: $kotNumber, preparationStatus: $preparationStatus, preparedAt: $preparedAt, preparedBy: $preparedBy, station: $station, servedAt: $servedAt, servedBy: $servedBy, isVoided: $isVoided, voidedAt: $voidedAt, voidedBy: $voidedBy, voidReason: $voidReason, isComplimentary: $isComplimentary, complimentaryReason: $complimentaryReason, isReturned: $isReturned, returnedQuantity: $returnedQuantity, returnedAt: $returnedAt, returnReason: $returnReason, refundedAmount: $refundedAmount, displayOrder: $displayOrder, category: $category, categoryId: $categoryId, itemNotes: $itemNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variationName, variationName) ||
                other.variationName == variationName) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.unitOfMeasure, unitOfMeasure) ||
                other.unitOfMeasure == unitOfMeasure) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.modifiersPrice, modifiersPrice) ||
                other.modifiersPrice == modifiersPrice) &&
            const DeepCollectionEquality().equals(
              other._modifiers,
              _modifiers,
            ) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountReason, discountReason) ||
                other.discountReason == discountReason) &&
            (identical(other.appliedDiscountId, appliedDiscountId) ||
                other.appliedDiscountId == appliedDiscountId) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.taxGroupId, taxGroupId) ||
                other.taxGroupId == taxGroupId) &&
            (identical(other.taxGroupName, taxGroupName) ||
                other.taxGroupName == taxGroupName) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skipKot, skipKot) || other.skipKot == skipKot) &&
            (identical(other.kotPrinted, kotPrinted) ||
                other.kotPrinted == kotPrinted) &&
            (identical(other.kotPrintedAt, kotPrintedAt) ||
                other.kotPrintedAt == kotPrintedAt) &&
            (identical(other.kotNumber, kotNumber) ||
                other.kotNumber == kotNumber) &&
            (identical(other.preparationStatus, preparationStatus) ||
                other.preparationStatus == preparationStatus) &&
            (identical(other.preparedAt, preparedAt) ||
                other.preparedAt == preparedAt) &&
            (identical(other.preparedBy, preparedBy) ||
                other.preparedBy == preparedBy) &&
            (identical(other.station, station) || other.station == station) &&
            (identical(other.servedAt, servedAt) ||
                other.servedAt == servedAt) &&
            (identical(other.servedBy, servedBy) ||
                other.servedBy == servedBy) &&
            (identical(other.isVoided, isVoided) ||
                other.isVoided == isVoided) &&
            (identical(other.voidedAt, voidedAt) ||
                other.voidedAt == voidedAt) &&
            (identical(other.voidedBy, voidedBy) ||
                other.voidedBy == voidedBy) &&
            (identical(other.voidReason, voidReason) ||
                other.voidReason == voidReason) &&
            (identical(other.isComplimentary, isComplimentary) ||
                other.isComplimentary == isComplimentary) &&
            (identical(other.complimentaryReason, complimentaryReason) ||
                other.complimentaryReason == complimentaryReason) &&
            (identical(other.isReturned, isReturned) ||
                other.isReturned == isReturned) &&
            (identical(other.returnedQuantity, returnedQuantity) ||
                other.returnedQuantity == returnedQuantity) &&
            (identical(other.returnedAt, returnedAt) ||
                other.returnedAt == returnedAt) &&
            (identical(other.returnReason, returnReason) ||
                other.returnReason == returnReason) &&
            (identical(other.refundedAmount, refundedAmount) ||
                other.refundedAmount == refundedAmount) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.itemNotes, itemNotes) ||
                other.itemNotes == itemNotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    orderId,
    productId,
    variationId,
    productName,
    variationName,
    productCode,
    sku,
    unitOfMeasure,
    quantity,
    unitPrice,
    modifiersPrice,
    const DeepCollectionEquality().hash(_modifiers),
    specialInstructions,
    discountAmount,
    discountPercent,
    discountReason,
    appliedDiscountId,
    taxRate,
    taxAmount,
    taxGroupId,
    taxGroupName,
    subtotal,
    total,
    skipKot,
    kotPrinted,
    kotPrintedAt,
    kotNumber,
    preparationStatus,
    preparedAt,
    preparedBy,
    station,
    servedAt,
    servedBy,
    isVoided,
    voidedAt,
    voidedBy,
    voidReason,
    isComplimentary,
    complimentaryReason,
    isReturned,
    returnedQuantity,
    returnedAt,
    returnReason,
    refundedAmount,
    displayOrder,
    category,
    categoryId,
    itemNotes,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(this);
  }
}

abstract class _OrderItem extends OrderItem {
  const factory _OrderItem({
    required final String id,
    required final String orderId,
    required final String productId,
    required final String variationId,
    required final String productName,
    required final String variationName,
    final String? productCode,
    final String? sku,
    final String? unitOfMeasure,
    final double quantity,
    required final double unitPrice,
    final double modifiersPrice,
    final List<ItemModifier> modifiers,
    final String? specialInstructions,
    final double discountAmount,
    final double discountPercent,
    final String? discountReason,
    final String? appliedDiscountId,
    final double taxRate,
    final double taxAmount,
    final String? taxGroupId,
    final String? taxGroupName,
    final double subtotal,
    final double total,
    final bool skipKot,
    final bool kotPrinted,
    final DateTime? kotPrintedAt,
    final String? kotNumber,
    final PreparationStatus preparationStatus,
    final DateTime? preparedAt,
    final String? preparedBy,
    final String? station,
    final DateTime? servedAt,
    final String? servedBy,
    final bool isVoided,
    final DateTime? voidedAt,
    final String? voidedBy,
    final String? voidReason,
    final bool isComplimentary,
    final String? complimentaryReason,
    final bool isReturned,
    final double returnedQuantity,
    final DateTime? returnedAt,
    final String? returnReason,
    final double refundedAmount,
    final int displayOrder,
    final String? category,
    final String? categoryId,
    final String? itemNotes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$OrderItemImpl;
  const _OrderItem._() : super._();

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  // Identification
  @override
  String get id;
  @override
  String get orderId; // Product Information (snapshot at time of order)
  @override
  String get productId;
  @override
  String get variationId;
  @override
  String get productName;
  @override
  String get variationName;
  @override
  String? get productCode;
  @override
  String? get sku;
  @override
  String? get unitOfMeasure; // Quantity & Pricing
  @override
  double get quantity;
  @override
  double get unitPrice; // Original price
  @override
  double get modifiersPrice; // Additional charges for modifiers
  // Modifiers/Customization
  @override
  List<ItemModifier> get modifiers;
  @override
  String? get specialInstructions; // Discounts
  @override
  double get discountAmount;
  @override
  double get discountPercent;
  @override
  String? get discountReason;
  @override
  String? get appliedDiscountId; // Tax (snapshot at time of order)
  @override
  double get taxRate;
  @override
  double get taxAmount;
  @override
  String? get taxGroupId;
  @override
  String? get taxGroupName; // Calculated Totals
  @override
  double get subtotal; // (unitPrice + modifiersPrice) * quantity
  @override
  double get total; // subtotal - discount + tax
  // Kitchen/Preparation
  @override
  bool get skipKot;
  @override
  bool get kotPrinted;
  @override
  DateTime? get kotPrintedAt;
  @override
  String? get kotNumber;
  @override
  PreparationStatus get preparationStatus;
  @override
  DateTime? get preparedAt;
  @override
  String? get preparedBy; // Kitchen staff ID
  @override
  String? get station; // Kitchen station (e.g., "Main Kitchen", "Bar", "Dessert")
  // Service
  @override
  DateTime? get servedAt;
  @override
  String? get servedBy; // Waiter ID
  // Void/Cancel Information
  @override
  bool get isVoided;
  @override
  DateTime? get voidedAt;
  @override
  String? get voidedBy;
  @override
  String? get voidReason;
  @override
  bool get isComplimentary;
  @override
  String? get complimentaryReason; // Return/Refund
  @override
  bool get isReturned;
  @override
  double get returnedQuantity;
  @override
  DateTime? get returnedAt;
  @override
  String? get returnReason;
  @override
  double get refundedAmount; // Display & Sorting
  @override
  int get displayOrder;
  @override
  String? get category; // For grouping in display
  @override
  String? get categoryId; // Notes
  @override
  String? get itemNotes; // Metadata
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
