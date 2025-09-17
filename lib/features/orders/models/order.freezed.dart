// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  // Identification
  String get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get posDeviceId =>
      throw _privateConstructorUsedError; // Order Type & Context
  OrderType get orderType => throw _privateConstructorUsedError;
  String? get priceCategoryName =>
      throw _privateConstructorUsedError; // Original price category name for reporting (e.g., "Catering", "VIP Service")
  OrderSource get orderSource => throw _privateConstructorUsedError;
  String? get tableId => throw _privateConstructorUsedError;
  String? get tableName =>
      throw _privateConstructorUsedError; // Snapshot for display
  // Customer Information
  String get customerId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError; // Snapshot
  String? get customerPhone => throw _privateConstructorUsedError; // Snapshot
  String? get customerEmail => throw _privateConstructorUsedError; // Snapshot
  // Delivery Information (for delivery orders)
  String? get deliveryAddressLine1 => throw _privateConstructorUsedError;
  String? get deliveryAddressLine2 => throw _privateConstructorUsedError;
  String? get deliveryCity => throw _privateConstructorUsedError;
  String? get deliveryPostalCode => throw _privateConstructorUsedError;
  String? get deliveryPhone => throw _privateConstructorUsedError;
  String? get deliveryInstructions =>
      throw _privateConstructorUsedError; // Timing
  DateTime get orderedAt => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  DateTime? get preparedAt => throw _privateConstructorUsedError;
  DateTime? get readyAt => throw _privateConstructorUsedError;
  DateTime? get servedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  DateTime? get estimatedReadyTime =>
      throw _privateConstructorUsedError; // Order Items
  List<OrderItem> get items =>
      throw _privateConstructorUsedError; // Pricing (all amounts are final calculated values)
  double get subtotal => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get chargesAmount =>
      throw _privateConstructorUsedError; // Total of all charges
  double get deliveryCharge =>
      throw _privateConstructorUsedError; // Deprecated - use charges list
  double get serviceCharge =>
      throw _privateConstructorUsedError; // Deprecated - use charges list
  double get tipAmount => throw _privateConstructorUsedError;
  double get roundOffAmount => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError; // Discounts Applied
  List<OrderDiscount> get orderDiscounts =>
      throw _privateConstructorUsedError; // Charges Applied
  List<OrderCharge> get orderCharges =>
      throw _privateConstructorUsedError; // Payment
  PaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  List<OrderPayment> get payments => throw _privateConstructorUsedError;
  double get totalPaid => throw _privateConstructorUsedError;
  double get changeAmount => throw _privateConstructorUsedError; // Status
  OrderStatus get status => throw _privateConstructorUsedError;
  KitchenStatus? get kitchenStatus =>
      throw _privateConstructorUsedError; // Staff Information
  String get createdBy => throw _privateConstructorUsedError; // User ID
  String? get createdByName => throw _privateConstructorUsedError; // Snapshot
  String? get servedBy => throw _privateConstructorUsedError; // Waiter ID
  String? get servedByName => throw _privateConstructorUsedError; // Snapshot
  List<String> get preparedBy =>
      throw _privateConstructorUsedError; // Kitchen staff IDs
  // Notes
  String? get customerNotes => throw _privateConstructorUsedError;
  String? get kitchenNotes => throw _privateConstructorUsedError;
  String? get internalNotes => throw _privateConstructorUsedError;
  String? get cancellationReason =>
      throw _privateConstructorUsedError; // Token/Queue Number (for takeaway/quick service)
  String? get tokenNumber => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges =>
      throw _privateConstructorUsedError; // Additional flags
  bool get isPriority => throw _privateConstructorUsedError;
  bool get isVoid => throw _privateConstructorUsedError;
  String? get voidReason => throw _privateConstructorUsedError;
  DateTime? get voidedAt => throw _privateConstructorUsedError;
  String? get voidedBy =>
      throw _privateConstructorUsedError; // Analytics fields (calculated)
  int? get preparationTimeMinutes => throw _privateConstructorUsedError;
  int? get serviceTimeMinutes => throw _privateConstructorUsedError;
  int? get totalTimeMinutes => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    String id,
    String orderNumber,
    String businessId,
    String locationId,
    String posDeviceId,
    OrderType orderType,
    String? priceCategoryName,
    OrderSource orderSource,
    String? tableId,
    String? tableName,
    String customerId,
    String customerName,
    String? customerPhone,
    String? customerEmail,
    String? deliveryAddressLine1,
    String? deliveryAddressLine2,
    String? deliveryCity,
    String? deliveryPostalCode,
    String? deliveryPhone,
    String? deliveryInstructions,
    DateTime orderedAt,
    DateTime? confirmedAt,
    DateTime? preparedAt,
    DateTime? readyAt,
    DateTime? servedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? estimatedReadyTime,
    List<OrderItem> items,
    double subtotal,
    double discountAmount,
    double taxAmount,
    double chargesAmount,
    double deliveryCharge,
    double serviceCharge,
    double tipAmount,
    double roundOffAmount,
    double total,
    List<OrderDiscount> orderDiscounts,
    List<OrderCharge> orderCharges,
    PaymentStatus paymentStatus,
    List<OrderPayment> payments,
    double totalPaid,
    double changeAmount,
    OrderStatus status,
    KitchenStatus? kitchenStatus,
    String createdBy,
    String? createdByName,
    String? servedBy,
    String? servedByName,
    List<String> preparedBy,
    String? customerNotes,
    String? kitchenNotes,
    String? internalNotes,
    String? cancellationReason,
    String? tokenNumber,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
    bool isPriority,
    bool isVoid,
    String? voidReason,
    DateTime? voidedAt,
    String? voidedBy,
    int? preparationTimeMinutes,
    int? serviceTimeMinutes,
    int? totalTimeMinutes,
  });
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? posDeviceId = null,
    Object? orderType = null,
    Object? priceCategoryName = freezed,
    Object? orderSource = null,
    Object? tableId = freezed,
    Object? tableName = freezed,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? deliveryAddressLine1 = freezed,
    Object? deliveryAddressLine2 = freezed,
    Object? deliveryCity = freezed,
    Object? deliveryPostalCode = freezed,
    Object? deliveryPhone = freezed,
    Object? deliveryInstructions = freezed,
    Object? orderedAt = null,
    Object? confirmedAt = freezed,
    Object? preparedAt = freezed,
    Object? readyAt = freezed,
    Object? servedAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
    Object? estimatedReadyTime = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? discountAmount = null,
    Object? taxAmount = null,
    Object? chargesAmount = null,
    Object? deliveryCharge = null,
    Object? serviceCharge = null,
    Object? tipAmount = null,
    Object? roundOffAmount = null,
    Object? total = null,
    Object? orderDiscounts = null,
    Object? orderCharges = null,
    Object? paymentStatus = null,
    Object? payments = null,
    Object? totalPaid = null,
    Object? changeAmount = null,
    Object? status = null,
    Object? kitchenStatus = freezed,
    Object? createdBy = null,
    Object? createdByName = freezed,
    Object? servedBy = freezed,
    Object? servedByName = freezed,
    Object? preparedBy = null,
    Object? customerNotes = freezed,
    Object? kitchenNotes = freezed,
    Object? internalNotes = freezed,
    Object? cancellationReason = freezed,
    Object? tokenNumber = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
    Object? isPriority = null,
    Object? isVoid = null,
    Object? voidReason = freezed,
    Object? voidedAt = freezed,
    Object? voidedBy = freezed,
    Object? preparationTimeMinutes = freezed,
    Object? serviceTimeMinutes = freezed,
    Object? totalTimeMinutes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            orderNumber:
                null == orderNumber
                    ? _value.orderNumber
                    : orderNumber // ignore: cast_nullable_to_non_nullable
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
            posDeviceId:
                null == posDeviceId
                    ? _value.posDeviceId
                    : posDeviceId // ignore: cast_nullable_to_non_nullable
                        as String,
            orderType:
                null == orderType
                    ? _value.orderType
                    : orderType // ignore: cast_nullable_to_non_nullable
                        as OrderType,
            priceCategoryName:
                freezed == priceCategoryName
                    ? _value.priceCategoryName
                    : priceCategoryName // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderSource:
                null == orderSource
                    ? _value.orderSource
                    : orderSource // ignore: cast_nullable_to_non_nullable
                        as OrderSource,
            tableId:
                freezed == tableId
                    ? _value.tableId
                    : tableId // ignore: cast_nullable_to_non_nullable
                        as String?,
            tableName:
                freezed == tableName
                    ? _value.tableName
                    : tableName // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerId:
                null == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String,
            customerName:
                null == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String,
            customerPhone:
                freezed == customerPhone
                    ? _value.customerPhone
                    : customerPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerEmail:
                freezed == customerEmail
                    ? _value.customerEmail
                    : customerEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            deliveryAddressLine1:
                freezed == deliveryAddressLine1
                    ? _value.deliveryAddressLine1
                    : deliveryAddressLine1 // ignore: cast_nullable_to_non_nullable
                        as String?,
            deliveryAddressLine2:
                freezed == deliveryAddressLine2
                    ? _value.deliveryAddressLine2
                    : deliveryAddressLine2 // ignore: cast_nullable_to_non_nullable
                        as String?,
            deliveryCity:
                freezed == deliveryCity
                    ? _value.deliveryCity
                    : deliveryCity // ignore: cast_nullable_to_non_nullable
                        as String?,
            deliveryPostalCode:
                freezed == deliveryPostalCode
                    ? _value.deliveryPostalCode
                    : deliveryPostalCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            deliveryPhone:
                freezed == deliveryPhone
                    ? _value.deliveryPhone
                    : deliveryPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            deliveryInstructions:
                freezed == deliveryInstructions
                    ? _value.deliveryInstructions
                    : deliveryInstructions // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderedAt:
                null == orderedAt
                    ? _value.orderedAt
                    : orderedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            confirmedAt:
                freezed == confirmedAt
                    ? _value.confirmedAt
                    : confirmedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            preparedAt:
                freezed == preparedAt
                    ? _value.preparedAt
                    : preparedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            readyAt:
                freezed == readyAt
                    ? _value.readyAt
                    : readyAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            servedAt:
                freezed == servedAt
                    ? _value.servedAt
                    : servedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            cancelledAt:
                freezed == cancelledAt
                    ? _value.cancelledAt
                    : cancelledAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            estimatedReadyTime:
                freezed == estimatedReadyTime
                    ? _value.estimatedReadyTime
                    : estimatedReadyTime // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<OrderItem>,
            subtotal:
                null == subtotal
                    ? _value.subtotal
                    : subtotal // ignore: cast_nullable_to_non_nullable
                        as double,
            discountAmount:
                null == discountAmount
                    ? _value.discountAmount
                    : discountAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            taxAmount:
                null == taxAmount
                    ? _value.taxAmount
                    : taxAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            chargesAmount:
                null == chargesAmount
                    ? _value.chargesAmount
                    : chargesAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            deliveryCharge:
                null == deliveryCharge
                    ? _value.deliveryCharge
                    : deliveryCharge // ignore: cast_nullable_to_non_nullable
                        as double,
            serviceCharge:
                null == serviceCharge
                    ? _value.serviceCharge
                    : serviceCharge // ignore: cast_nullable_to_non_nullable
                        as double,
            tipAmount:
                null == tipAmount
                    ? _value.tipAmount
                    : tipAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            roundOffAmount:
                null == roundOffAmount
                    ? _value.roundOffAmount
                    : roundOffAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            total:
                null == total
                    ? _value.total
                    : total // ignore: cast_nullable_to_non_nullable
                        as double,
            orderDiscounts:
                null == orderDiscounts
                    ? _value.orderDiscounts
                    : orderDiscounts // ignore: cast_nullable_to_non_nullable
                        as List<OrderDiscount>,
            orderCharges:
                null == orderCharges
                    ? _value.orderCharges
                    : orderCharges // ignore: cast_nullable_to_non_nullable
                        as List<OrderCharge>,
            paymentStatus:
                null == paymentStatus
                    ? _value.paymentStatus
                    : paymentStatus // ignore: cast_nullable_to_non_nullable
                        as PaymentStatus,
            payments:
                null == payments
                    ? _value.payments
                    : payments // ignore: cast_nullable_to_non_nullable
                        as List<OrderPayment>,
            totalPaid:
                null == totalPaid
                    ? _value.totalPaid
                    : totalPaid // ignore: cast_nullable_to_non_nullable
                        as double,
            changeAmount:
                null == changeAmount
                    ? _value.changeAmount
                    : changeAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as OrderStatus,
            kitchenStatus:
                freezed == kitchenStatus
                    ? _value.kitchenStatus
                    : kitchenStatus // ignore: cast_nullable_to_non_nullable
                        as KitchenStatus?,
            createdBy:
                null == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String,
            createdByName:
                freezed == createdByName
                    ? _value.createdByName
                    : createdByName // ignore: cast_nullable_to_non_nullable
                        as String?,
            servedBy:
                freezed == servedBy
                    ? _value.servedBy
                    : servedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            servedByName:
                freezed == servedByName
                    ? _value.servedByName
                    : servedByName // ignore: cast_nullable_to_non_nullable
                        as String?,
            preparedBy:
                null == preparedBy
                    ? _value.preparedBy
                    : preparedBy // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            customerNotes:
                freezed == customerNotes
                    ? _value.customerNotes
                    : customerNotes // ignore: cast_nullable_to_non_nullable
                        as String?,
            kitchenNotes:
                freezed == kitchenNotes
                    ? _value.kitchenNotes
                    : kitchenNotes // ignore: cast_nullable_to_non_nullable
                        as String?,
            internalNotes:
                freezed == internalNotes
                    ? _value.internalNotes
                    : internalNotes // ignore: cast_nullable_to_non_nullable
                        as String?,
            cancellationReason:
                freezed == cancellationReason
                    ? _value.cancellationReason
                    : cancellationReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            tokenNumber:
                freezed == tokenNumber
                    ? _value.tokenNumber
                    : tokenNumber // ignore: cast_nullable_to_non_nullable
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
            isPriority:
                null == isPriority
                    ? _value.isPriority
                    : isPriority // ignore: cast_nullable_to_non_nullable
                        as bool,
            isVoid:
                null == isVoid
                    ? _value.isVoid
                    : isVoid // ignore: cast_nullable_to_non_nullable
                        as bool,
            voidReason:
                freezed == voidReason
                    ? _value.voidReason
                    : voidReason // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            preparationTimeMinutes:
                freezed == preparationTimeMinutes
                    ? _value.preparationTimeMinutes
                    : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
                        as int?,
            serviceTimeMinutes:
                freezed == serviceTimeMinutes
                    ? _value.serviceTimeMinutes
                    : serviceTimeMinutes // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalTimeMinutes:
                freezed == totalTimeMinutes
                    ? _value.totalTimeMinutes
                    : totalTimeMinutes // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderNumber,
    String businessId,
    String locationId,
    String posDeviceId,
    OrderType orderType,
    String? priceCategoryName,
    OrderSource orderSource,
    String? tableId,
    String? tableName,
    String customerId,
    String customerName,
    String? customerPhone,
    String? customerEmail,
    String? deliveryAddressLine1,
    String? deliveryAddressLine2,
    String? deliveryCity,
    String? deliveryPostalCode,
    String? deliveryPhone,
    String? deliveryInstructions,
    DateTime orderedAt,
    DateTime? confirmedAt,
    DateTime? preparedAt,
    DateTime? readyAt,
    DateTime? servedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? estimatedReadyTime,
    List<OrderItem> items,
    double subtotal,
    double discountAmount,
    double taxAmount,
    double chargesAmount,
    double deliveryCharge,
    double serviceCharge,
    double tipAmount,
    double roundOffAmount,
    double total,
    List<OrderDiscount> orderDiscounts,
    List<OrderCharge> orderCharges,
    PaymentStatus paymentStatus,
    List<OrderPayment> payments,
    double totalPaid,
    double changeAmount,
    OrderStatus status,
    KitchenStatus? kitchenStatus,
    String createdBy,
    String? createdByName,
    String? servedBy,
    String? servedByName,
    List<String> preparedBy,
    String? customerNotes,
    String? kitchenNotes,
    String? internalNotes,
    String? cancellationReason,
    String? tokenNumber,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
    bool isPriority,
    bool isVoid,
    String? voidReason,
    DateTime? voidedAt,
    String? voidedBy,
    int? preparationTimeMinutes,
    int? serviceTimeMinutes,
    int? totalTimeMinutes,
  });
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? posDeviceId = null,
    Object? orderType = null,
    Object? priceCategoryName = freezed,
    Object? orderSource = null,
    Object? tableId = freezed,
    Object? tableName = freezed,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? deliveryAddressLine1 = freezed,
    Object? deliveryAddressLine2 = freezed,
    Object? deliveryCity = freezed,
    Object? deliveryPostalCode = freezed,
    Object? deliveryPhone = freezed,
    Object? deliveryInstructions = freezed,
    Object? orderedAt = null,
    Object? confirmedAt = freezed,
    Object? preparedAt = freezed,
    Object? readyAt = freezed,
    Object? servedAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
    Object? estimatedReadyTime = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? discountAmount = null,
    Object? taxAmount = null,
    Object? chargesAmount = null,
    Object? deliveryCharge = null,
    Object? serviceCharge = null,
    Object? tipAmount = null,
    Object? roundOffAmount = null,
    Object? total = null,
    Object? orderDiscounts = null,
    Object? orderCharges = null,
    Object? paymentStatus = null,
    Object? payments = null,
    Object? totalPaid = null,
    Object? changeAmount = null,
    Object? status = null,
    Object? kitchenStatus = freezed,
    Object? createdBy = null,
    Object? createdByName = freezed,
    Object? servedBy = freezed,
    Object? servedByName = freezed,
    Object? preparedBy = null,
    Object? customerNotes = freezed,
    Object? kitchenNotes = freezed,
    Object? internalNotes = freezed,
    Object? cancellationReason = freezed,
    Object? tokenNumber = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
    Object? isPriority = null,
    Object? isVoid = null,
    Object? voidReason = freezed,
    Object? voidedAt = freezed,
    Object? voidedBy = freezed,
    Object? preparationTimeMinutes = freezed,
    Object? serviceTimeMinutes = freezed,
    Object? totalTimeMinutes = freezed,
  }) {
    return _then(
      _$OrderImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        orderNumber:
            null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
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
        posDeviceId:
            null == posDeviceId
                ? _value.posDeviceId
                : posDeviceId // ignore: cast_nullable_to_non_nullable
                    as String,
        orderType:
            null == orderType
                ? _value.orderType
                : orderType // ignore: cast_nullable_to_non_nullable
                    as OrderType,
        priceCategoryName:
            freezed == priceCategoryName
                ? _value.priceCategoryName
                : priceCategoryName // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderSource:
            null == orderSource
                ? _value.orderSource
                : orderSource // ignore: cast_nullable_to_non_nullable
                    as OrderSource,
        tableId:
            freezed == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                    as String?,
        tableName:
            freezed == tableName
                ? _value.tableName
                : tableName // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerId:
            null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String,
        customerName:
            null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String,
        customerPhone:
            freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerEmail:
            freezed == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        deliveryAddressLine1:
            freezed == deliveryAddressLine1
                ? _value.deliveryAddressLine1
                : deliveryAddressLine1 // ignore: cast_nullable_to_non_nullable
                    as String?,
        deliveryAddressLine2:
            freezed == deliveryAddressLine2
                ? _value.deliveryAddressLine2
                : deliveryAddressLine2 // ignore: cast_nullable_to_non_nullable
                    as String?,
        deliveryCity:
            freezed == deliveryCity
                ? _value.deliveryCity
                : deliveryCity // ignore: cast_nullable_to_non_nullable
                    as String?,
        deliveryPostalCode:
            freezed == deliveryPostalCode
                ? _value.deliveryPostalCode
                : deliveryPostalCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        deliveryPhone:
            freezed == deliveryPhone
                ? _value.deliveryPhone
                : deliveryPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        deliveryInstructions:
            freezed == deliveryInstructions
                ? _value.deliveryInstructions
                : deliveryInstructions // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderedAt:
            null == orderedAt
                ? _value.orderedAt
                : orderedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        confirmedAt:
            freezed == confirmedAt
                ? _value.confirmedAt
                : confirmedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        preparedAt:
            freezed == preparedAt
                ? _value.preparedAt
                : preparedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        readyAt:
            freezed == readyAt
                ? _value.readyAt
                : readyAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        servedAt:
            freezed == servedAt
                ? _value.servedAt
                : servedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        cancelledAt:
            freezed == cancelledAt
                ? _value.cancelledAt
                : cancelledAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        estimatedReadyTime:
            freezed == estimatedReadyTime
                ? _value.estimatedReadyTime
                : estimatedReadyTime // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<OrderItem>,
        subtotal:
            null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                    as double,
        discountAmount:
            null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        taxAmount:
            null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        chargesAmount:
            null == chargesAmount
                ? _value.chargesAmount
                : chargesAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        deliveryCharge:
            null == deliveryCharge
                ? _value.deliveryCharge
                : deliveryCharge // ignore: cast_nullable_to_non_nullable
                    as double,
        serviceCharge:
            null == serviceCharge
                ? _value.serviceCharge
                : serviceCharge // ignore: cast_nullable_to_non_nullable
                    as double,
        tipAmount:
            null == tipAmount
                ? _value.tipAmount
                : tipAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        roundOffAmount:
            null == roundOffAmount
                ? _value.roundOffAmount
                : roundOffAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        total:
            null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                    as double,
        orderDiscounts:
            null == orderDiscounts
                ? _value._orderDiscounts
                : orderDiscounts // ignore: cast_nullable_to_non_nullable
                    as List<OrderDiscount>,
        orderCharges:
            null == orderCharges
                ? _value._orderCharges
                : orderCharges // ignore: cast_nullable_to_non_nullable
                    as List<OrderCharge>,
        paymentStatus:
            null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                    as PaymentStatus,
        payments:
            null == payments
                ? _value._payments
                : payments // ignore: cast_nullable_to_non_nullable
                    as List<OrderPayment>,
        totalPaid:
            null == totalPaid
                ? _value.totalPaid
                : totalPaid // ignore: cast_nullable_to_non_nullable
                    as double,
        changeAmount:
            null == changeAmount
                ? _value.changeAmount
                : changeAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as OrderStatus,
        kitchenStatus:
            freezed == kitchenStatus
                ? _value.kitchenStatus
                : kitchenStatus // ignore: cast_nullable_to_non_nullable
                    as KitchenStatus?,
        createdBy:
            null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String,
        createdByName:
            freezed == createdByName
                ? _value.createdByName
                : createdByName // ignore: cast_nullable_to_non_nullable
                    as String?,
        servedBy:
            freezed == servedBy
                ? _value.servedBy
                : servedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        servedByName:
            freezed == servedByName
                ? _value.servedByName
                : servedByName // ignore: cast_nullable_to_non_nullable
                    as String?,
        preparedBy:
            null == preparedBy
                ? _value._preparedBy
                : preparedBy // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        customerNotes:
            freezed == customerNotes
                ? _value.customerNotes
                : customerNotes // ignore: cast_nullable_to_non_nullable
                    as String?,
        kitchenNotes:
            freezed == kitchenNotes
                ? _value.kitchenNotes
                : kitchenNotes // ignore: cast_nullable_to_non_nullable
                    as String?,
        internalNotes:
            freezed == internalNotes
                ? _value.internalNotes
                : internalNotes // ignore: cast_nullable_to_non_nullable
                    as String?,
        cancellationReason:
            freezed == cancellationReason
                ? _value.cancellationReason
                : cancellationReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        tokenNumber:
            freezed == tokenNumber
                ? _value.tokenNumber
                : tokenNumber // ignore: cast_nullable_to_non_nullable
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
        isPriority:
            null == isPriority
                ? _value.isPriority
                : isPriority // ignore: cast_nullable_to_non_nullable
                    as bool,
        isVoid:
            null == isVoid
                ? _value.isVoid
                : isVoid // ignore: cast_nullable_to_non_nullable
                    as bool,
        voidReason:
            freezed == voidReason
                ? _value.voidReason
                : voidReason // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        preparationTimeMinutes:
            freezed == preparationTimeMinutes
                ? _value.preparationTimeMinutes
                : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
                    as int?,
        serviceTimeMinutes:
            freezed == serviceTimeMinutes
                ? _value.serviceTimeMinutes
                : serviceTimeMinutes // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalTimeMinutes:
            freezed == totalTimeMinutes
                ? _value.totalTimeMinutes
                : totalTimeMinutes // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$OrderImpl extends _Order {
  const _$OrderImpl({
    required this.id,
    required this.orderNumber,
    required this.businessId,
    required this.locationId,
    required this.posDeviceId,
    this.orderType = OrderType.dineIn,
    this.priceCategoryName,
    this.orderSource = OrderSource.pos,
    this.tableId,
    this.tableName,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.deliveryAddressLine1,
    this.deliveryAddressLine2,
    this.deliveryCity,
    this.deliveryPostalCode,
    this.deliveryPhone,
    this.deliveryInstructions,
    required this.orderedAt,
    this.confirmedAt,
    this.preparedAt,
    this.readyAt,
    this.servedAt,
    this.completedAt,
    this.cancelledAt,
    this.estimatedReadyTime,
    final List<OrderItem> items = const [],
    this.subtotal = 0,
    this.discountAmount = 0,
    this.taxAmount = 0,
    this.chargesAmount = 0,
    this.deliveryCharge = 0,
    this.serviceCharge = 0,
    this.tipAmount = 0,
    this.roundOffAmount = 0,
    required this.total,
    final List<OrderDiscount> orderDiscounts = const [],
    final List<OrderCharge> orderCharges = const [],
    this.paymentStatus = PaymentStatus.pending,
    final List<OrderPayment> payments = const [],
    this.totalPaid = 0,
    this.changeAmount = 0,
    this.status = OrderStatus.draft,
    this.kitchenStatus,
    required this.createdBy,
    this.createdByName,
    this.servedBy,
    this.servedByName,
    final List<String> preparedBy = const [],
    this.customerNotes,
    this.kitchenNotes,
    this.internalNotes,
    this.cancellationReason,
    this.tokenNumber,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
    this.isPriority = false,
    this.isVoid = false,
    this.voidReason,
    this.voidedAt,
    this.voidedBy,
    this.preparationTimeMinutes,
    this.serviceTimeMinutes,
    this.totalTimeMinutes,
  }) : _items = items,
       _orderDiscounts = orderDiscounts,
       _orderCharges = orderCharges,
       _payments = payments,
       _preparedBy = preparedBy,
       super._();

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  // Identification
  @override
  final String id;
  @override
  final String orderNumber;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String posDeviceId;
  // Order Type & Context
  @override
  @JsonKey()
  final OrderType orderType;
  @override
  final String? priceCategoryName;
  // Original price category name for reporting (e.g., "Catering", "VIP Service")
  @override
  @JsonKey()
  final OrderSource orderSource;
  @override
  final String? tableId;
  @override
  final String? tableName;
  // Snapshot for display
  // Customer Information
  @override
  final String customerId;
  @override
  final String customerName;
  // Snapshot
  @override
  final String? customerPhone;
  // Snapshot
  @override
  final String? customerEmail;
  // Snapshot
  // Delivery Information (for delivery orders)
  @override
  final String? deliveryAddressLine1;
  @override
  final String? deliveryAddressLine2;
  @override
  final String? deliveryCity;
  @override
  final String? deliveryPostalCode;
  @override
  final String? deliveryPhone;
  @override
  final String? deliveryInstructions;
  // Timing
  @override
  final DateTime orderedAt;
  @override
  final DateTime? confirmedAt;
  @override
  final DateTime? preparedAt;
  @override
  final DateTime? readyAt;
  @override
  final DateTime? servedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? cancelledAt;
  @override
  final DateTime? estimatedReadyTime;
  // Order Items
  final List<OrderItem> _items;
  // Order Items
  @override
  @JsonKey()
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  // Pricing (all amounts are final calculated values)
  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double taxAmount;
  @override
  @JsonKey()
  final double chargesAmount;
  // Total of all charges
  @override
  @JsonKey()
  final double deliveryCharge;
  // Deprecated - use charges list
  @override
  @JsonKey()
  final double serviceCharge;
  // Deprecated - use charges list
  @override
  @JsonKey()
  final double tipAmount;
  @override
  @JsonKey()
  final double roundOffAmount;
  @override
  final double total;
  // Discounts Applied
  final List<OrderDiscount> _orderDiscounts;
  // Discounts Applied
  @override
  @JsonKey()
  List<OrderDiscount> get orderDiscounts {
    if (_orderDiscounts is EqualUnmodifiableListView) return _orderDiscounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderDiscounts);
  }

  // Charges Applied
  final List<OrderCharge> _orderCharges;
  // Charges Applied
  @override
  @JsonKey()
  List<OrderCharge> get orderCharges {
    if (_orderCharges is EqualUnmodifiableListView) return _orderCharges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderCharges);
  }

  // Payment
  @override
  @JsonKey()
  final PaymentStatus paymentStatus;
  final List<OrderPayment> _payments;
  @override
  @JsonKey()
  List<OrderPayment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  @JsonKey()
  final double totalPaid;
  @override
  @JsonKey()
  final double changeAmount;
  // Status
  @override
  @JsonKey()
  final OrderStatus status;
  @override
  final KitchenStatus? kitchenStatus;
  // Staff Information
  @override
  final String createdBy;
  // User ID
  @override
  final String? createdByName;
  // Snapshot
  @override
  final String? servedBy;
  // Waiter ID
  @override
  final String? servedByName;
  // Snapshot
  final List<String> _preparedBy;
  // Snapshot
  @override
  @JsonKey()
  List<String> get preparedBy {
    if (_preparedBy is EqualUnmodifiableListView) return _preparedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preparedBy);
  }

  // Kitchen staff IDs
  // Notes
  @override
  final String? customerNotes;
  @override
  final String? kitchenNotes;
  @override
  final String? internalNotes;
  @override
  final String? cancellationReason;
  // Token/Queue Number (for takeaway/quick service)
  @override
  final String? tokenNumber;
  // Metadata
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;
  // Additional flags
  @override
  @JsonKey()
  final bool isPriority;
  @override
  @JsonKey()
  final bool isVoid;
  @override
  final String? voidReason;
  @override
  final DateTime? voidedAt;
  @override
  final String? voidedBy;
  // Analytics fields (calculated)
  @override
  final int? preparationTimeMinutes;
  @override
  final int? serviceTimeMinutes;
  @override
  final int? totalTimeMinutes;

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, businessId: $businessId, locationId: $locationId, posDeviceId: $posDeviceId, orderType: $orderType, priceCategoryName: $priceCategoryName, orderSource: $orderSource, tableId: $tableId, tableName: $tableName, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, deliveryAddressLine1: $deliveryAddressLine1, deliveryAddressLine2: $deliveryAddressLine2, deliveryCity: $deliveryCity, deliveryPostalCode: $deliveryPostalCode, deliveryPhone: $deliveryPhone, deliveryInstructions: $deliveryInstructions, orderedAt: $orderedAt, confirmedAt: $confirmedAt, preparedAt: $preparedAt, readyAt: $readyAt, servedAt: $servedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, estimatedReadyTime: $estimatedReadyTime, items: $items, subtotal: $subtotal, discountAmount: $discountAmount, taxAmount: $taxAmount, chargesAmount: $chargesAmount, deliveryCharge: $deliveryCharge, serviceCharge: $serviceCharge, tipAmount: $tipAmount, roundOffAmount: $roundOffAmount, total: $total, orderDiscounts: $orderDiscounts, orderCharges: $orderCharges, paymentStatus: $paymentStatus, payments: $payments, totalPaid: $totalPaid, changeAmount: $changeAmount, status: $status, kitchenStatus: $kitchenStatus, createdBy: $createdBy, createdByName: $createdByName, servedBy: $servedBy, servedByName: $servedByName, preparedBy: $preparedBy, customerNotes: $customerNotes, kitchenNotes: $kitchenNotes, internalNotes: $internalNotes, cancellationReason: $cancellationReason, tokenNumber: $tokenNumber, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges, isPriority: $isPriority, isVoid: $isVoid, voidReason: $voidReason, voidedAt: $voidedAt, voidedBy: $voidedBy, preparationTimeMinutes: $preparationTimeMinutes, serviceTimeMinutes: $serviceTimeMinutes, totalTimeMinutes: $totalTimeMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.posDeviceId, posDeviceId) ||
                other.posDeviceId == posDeviceId) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.priceCategoryName, priceCategoryName) ||
                other.priceCategoryName == priceCategoryName) &&
            (identical(other.orderSource, orderSource) ||
                other.orderSource == orderSource) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.deliveryAddressLine1, deliveryAddressLine1) ||
                other.deliveryAddressLine1 == deliveryAddressLine1) &&
            (identical(other.deliveryAddressLine2, deliveryAddressLine2) ||
                other.deliveryAddressLine2 == deliveryAddressLine2) &&
            (identical(other.deliveryCity, deliveryCity) ||
                other.deliveryCity == deliveryCity) &&
            (identical(other.deliveryPostalCode, deliveryPostalCode) ||
                other.deliveryPostalCode == deliveryPostalCode) &&
            (identical(other.deliveryPhone, deliveryPhone) ||
                other.deliveryPhone == deliveryPhone) &&
            (identical(other.deliveryInstructions, deliveryInstructions) ||
                other.deliveryInstructions == deliveryInstructions) &&
            (identical(other.orderedAt, orderedAt) ||
                other.orderedAt == orderedAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.preparedAt, preparedAt) ||
                other.preparedAt == preparedAt) &&
            (identical(other.readyAt, readyAt) || other.readyAt == readyAt) &&
            (identical(other.servedAt, servedAt) ||
                other.servedAt == servedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.estimatedReadyTime, estimatedReadyTime) ||
                other.estimatedReadyTime == estimatedReadyTime) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.chargesAmount, chargesAmount) ||
                other.chargesAmount == chargesAmount) &&
            (identical(other.deliveryCharge, deliveryCharge) ||
                other.deliveryCharge == deliveryCharge) &&
            (identical(other.serviceCharge, serviceCharge) ||
                other.serviceCharge == serviceCharge) &&
            (identical(other.tipAmount, tipAmount) ||
                other.tipAmount == tipAmount) &&
            (identical(other.roundOffAmount, roundOffAmount) ||
                other.roundOffAmount == roundOffAmount) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(
              other._orderDiscounts,
              _orderDiscounts,
            ) &&
            const DeepCollectionEquality().equals(
              other._orderCharges,
              _orderCharges,
            ) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.changeAmount, changeAmount) ||
                other.changeAmount == changeAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.kitchenStatus, kitchenStatus) ||
                other.kitchenStatus == kitchenStatus) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.servedBy, servedBy) ||
                other.servedBy == servedBy) &&
            (identical(other.servedByName, servedByName) ||
                other.servedByName == servedByName) &&
            const DeepCollectionEquality().equals(
              other._preparedBy,
              _preparedBy,
            ) &&
            (identical(other.customerNotes, customerNotes) ||
                other.customerNotes == customerNotes) &&
            (identical(other.kitchenNotes, kitchenNotes) ||
                other.kitchenNotes == kitchenNotes) &&
            (identical(other.internalNotes, internalNotes) ||
                other.internalNotes == internalNotes) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.tokenNumber, tokenNumber) ||
                other.tokenNumber == tokenNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges) &&
            (identical(other.isPriority, isPriority) ||
                other.isPriority == isPriority) &&
            (identical(other.isVoid, isVoid) || other.isVoid == isVoid) &&
            (identical(other.voidReason, voidReason) ||
                other.voidReason == voidReason) &&
            (identical(other.voidedAt, voidedAt) ||
                other.voidedAt == voidedAt) &&
            (identical(other.voidedBy, voidedBy) ||
                other.voidedBy == voidedBy) &&
            (identical(other.preparationTimeMinutes, preparationTimeMinutes) ||
                other.preparationTimeMinutes == preparationTimeMinutes) &&
            (identical(other.serviceTimeMinutes, serviceTimeMinutes) ||
                other.serviceTimeMinutes == serviceTimeMinutes) &&
            (identical(other.totalTimeMinutes, totalTimeMinutes) ||
                other.totalTimeMinutes == totalTimeMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    orderNumber,
    businessId,
    locationId,
    posDeviceId,
    orderType,
    priceCategoryName,
    orderSource,
    tableId,
    tableName,
    customerId,
    customerName,
    customerPhone,
    customerEmail,
    deliveryAddressLine1,
    deliveryAddressLine2,
    deliveryCity,
    deliveryPostalCode,
    deliveryPhone,
    deliveryInstructions,
    orderedAt,
    confirmedAt,
    preparedAt,
    readyAt,
    servedAt,
    completedAt,
    cancelledAt,
    estimatedReadyTime,
    const DeepCollectionEquality().hash(_items),
    subtotal,
    discountAmount,
    taxAmount,
    chargesAmount,
    deliveryCharge,
    serviceCharge,
    tipAmount,
    roundOffAmount,
    total,
    const DeepCollectionEquality().hash(_orderDiscounts),
    const DeepCollectionEquality().hash(_orderCharges),
    paymentStatus,
    const DeepCollectionEquality().hash(_payments),
    totalPaid,
    changeAmount,
    status,
    kitchenStatus,
    createdBy,
    createdByName,
    servedBy,
    servedByName,
    const DeepCollectionEquality().hash(_preparedBy),
    customerNotes,
    kitchenNotes,
    internalNotes,
    cancellationReason,
    tokenNumber,
    createdAt,
    updatedAt,
    lastSyncedAt,
    hasUnsyncedChanges,
    isPriority,
    isVoid,
    voidReason,
    voidedAt,
    voidedBy,
    preparationTimeMinutes,
    serviceTimeMinutes,
    totalTimeMinutes,
  ]);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(this);
  }
}

abstract class _Order extends Order {
  const factory _Order({
    required final String id,
    required final String orderNumber,
    required final String businessId,
    required final String locationId,
    required final String posDeviceId,
    final OrderType orderType,
    final String? priceCategoryName,
    final OrderSource orderSource,
    final String? tableId,
    final String? tableName,
    required final String customerId,
    required final String customerName,
    final String? customerPhone,
    final String? customerEmail,
    final String? deliveryAddressLine1,
    final String? deliveryAddressLine2,
    final String? deliveryCity,
    final String? deliveryPostalCode,
    final String? deliveryPhone,
    final String? deliveryInstructions,
    required final DateTime orderedAt,
    final DateTime? confirmedAt,
    final DateTime? preparedAt,
    final DateTime? readyAt,
    final DateTime? servedAt,
    final DateTime? completedAt,
    final DateTime? cancelledAt,
    final DateTime? estimatedReadyTime,
    final List<OrderItem> items,
    final double subtotal,
    final double discountAmount,
    final double taxAmount,
    final double chargesAmount,
    final double deliveryCharge,
    final double serviceCharge,
    final double tipAmount,
    final double roundOffAmount,
    required final double total,
    final List<OrderDiscount> orderDiscounts,
    final List<OrderCharge> orderCharges,
    final PaymentStatus paymentStatus,
    final List<OrderPayment> payments,
    final double totalPaid,
    final double changeAmount,
    final OrderStatus status,
    final KitchenStatus? kitchenStatus,
    required final String createdBy,
    final String? createdByName,
    final String? servedBy,
    final String? servedByName,
    final List<String> preparedBy,
    final String? customerNotes,
    final String? kitchenNotes,
    final String? internalNotes,
    final String? cancellationReason,
    final String? tokenNumber,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
    final bool isPriority,
    final bool isVoid,
    final String? voidReason,
    final DateTime? voidedAt,
    final String? voidedBy,
    final int? preparationTimeMinutes,
    final int? serviceTimeMinutes,
    final int? totalTimeMinutes,
  }) = _$OrderImpl;
  const _Order._() : super._();

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  // Identification
  @override
  String get id;
  @override
  String get orderNumber;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get posDeviceId; // Order Type & Context
  @override
  OrderType get orderType;
  @override
  String? get priceCategoryName; // Original price category name for reporting (e.g., "Catering", "VIP Service")
  @override
  OrderSource get orderSource;
  @override
  String? get tableId;
  @override
  String? get tableName; // Snapshot for display
  // Customer Information
  @override
  String get customerId;
  @override
  String get customerName; // Snapshot
  @override
  String? get customerPhone; // Snapshot
  @override
  String? get customerEmail; // Snapshot
  // Delivery Information (for delivery orders)
  @override
  String? get deliveryAddressLine1;
  @override
  String? get deliveryAddressLine2;
  @override
  String? get deliveryCity;
  @override
  String? get deliveryPostalCode;
  @override
  String? get deliveryPhone;
  @override
  String? get deliveryInstructions; // Timing
  @override
  DateTime get orderedAt;
  @override
  DateTime? get confirmedAt;
  @override
  DateTime? get preparedAt;
  @override
  DateTime? get readyAt;
  @override
  DateTime? get servedAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get cancelledAt;
  @override
  DateTime? get estimatedReadyTime; // Order Items
  @override
  List<OrderItem> get items; // Pricing (all amounts are final calculated values)
  @override
  double get subtotal;
  @override
  double get discountAmount;
  @override
  double get taxAmount;
  @override
  double get chargesAmount; // Total of all charges
  @override
  double get deliveryCharge; // Deprecated - use charges list
  @override
  double get serviceCharge; // Deprecated - use charges list
  @override
  double get tipAmount;
  @override
  double get roundOffAmount;
  @override
  double get total; // Discounts Applied
  @override
  List<OrderDiscount> get orderDiscounts; // Charges Applied
  @override
  List<OrderCharge> get orderCharges; // Payment
  @override
  PaymentStatus get paymentStatus;
  @override
  List<OrderPayment> get payments;
  @override
  double get totalPaid;
  @override
  double get changeAmount; // Status
  @override
  OrderStatus get status;
  @override
  KitchenStatus? get kitchenStatus; // Staff Information
  @override
  String get createdBy; // User ID
  @override
  String? get createdByName; // Snapshot
  @override
  String? get servedBy; // Waiter ID
  @override
  String? get servedByName; // Snapshot
  @override
  List<String> get preparedBy; // Kitchen staff IDs
  // Notes
  @override
  String? get customerNotes;
  @override
  String? get kitchenNotes;
  @override
  String? get internalNotes;
  @override
  String? get cancellationReason; // Token/Queue Number (for takeaway/quick service)
  @override
  String? get tokenNumber; // Metadata
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges; // Additional flags
  @override
  bool get isPriority;
  @override
  bool get isVoid;
  @override
  String? get voidReason;
  @override
  DateTime? get voidedAt;
  @override
  String? get voidedBy; // Analytics fields (calculated)
  @override
  int? get preparationTimeMinutes;
  @override
  int? get serviceTimeMinutes;
  @override
  int? get totalTimeMinutes;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
