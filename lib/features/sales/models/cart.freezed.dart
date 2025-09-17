// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Cart _$CartFromJson(Map<String, dynamic> json) {
  return _Cart.fromJson(json);
}

/// @nodoc
mixin _$Cart {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get posDeviceId => throw _privateConstructorUsedError;
  String get priceCategoryId => throw _privateConstructorUsedError;
  String? get priceCategoryName => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get tableId => throw _privateConstructorUsedError;
  String? get tableName => throw _privateConstructorUsedError;
  String? get orderId =>
      throw _privateConstructorUsedError; // Link to existing order for updates
  List<CartItem> get items => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get orderDiscountAmount =>
      throw _privateConstructorUsedError; // Manual order-level discount
  double get orderDiscountPercent =>
      throw _privateConstructorUsedError; // Manual order-level discount percentage
  String? get orderDiscountReason =>
      throw _privateConstructorUsedError; // Reason for manual order discount
  bool get manualDiscountApplied =>
      throw _privateConstructorUsedError; // Track if discount was manually selected
  List<AppliedCharge> get appliedCharges =>
      throw _privateConstructorUsedError; // Applied charges
  double get totalChargesAmount =>
      throw _privateConstructorUsedError; // Total charges amount
  double get taxAmount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get roundOffAmount => throw _privateConstructorUsedError;
  CartStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get referenceNumber => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Serializes this Cart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartCopyWith<Cart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCopyWith<$Res> {
  factory $CartCopyWith(Cart value, $Res Function(Cart) then) =
      _$CartCopyWithImpl<$Res, Cart>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String posDeviceId,
    String priceCategoryId,
    String? priceCategoryName,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? tableId,
    String? tableName,
    String? orderId,
    List<CartItem> items,
    double subtotal,
    double orderDiscountAmount,
    double orderDiscountPercent,
    String? orderDiscountReason,
    bool manualDiscountApplied,
    List<AppliedCharge> appliedCharges,
    double totalChargesAmount,
    double taxAmount,
    double totalAmount,
    double roundOffAmount,
    CartStatus status,
    String? notes,
    String? referenceNumber,
    Map<String, dynamic> metadata,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? createdBy,
  });
}

/// @nodoc
class _$CartCopyWithImpl<$Res, $Val extends Cart>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? posDeviceId = null,
    Object? priceCategoryId = null,
    Object? priceCategoryName = freezed,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? tableId = freezed,
    Object? tableName = freezed,
    Object? orderId = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? orderDiscountAmount = null,
    Object? orderDiscountPercent = null,
    Object? orderDiscountReason = freezed,
    Object? manualDiscountApplied = null,
    Object? appliedCharges = null,
    Object? totalChargesAmount = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? roundOffAmount = null,
    Object? status = null,
    Object? notes = freezed,
    Object? referenceNumber = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
    Object? createdBy = freezed,
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
            posDeviceId:
                null == posDeviceId
                    ? _value.posDeviceId
                    : posDeviceId // ignore: cast_nullable_to_non_nullable
                        as String,
            priceCategoryId:
                null == priceCategoryId
                    ? _value.priceCategoryId
                    : priceCategoryId // ignore: cast_nullable_to_non_nullable
                        as String,
            priceCategoryName:
                freezed == priceCategoryName
                    ? _value.priceCategoryName
                    : priceCategoryName // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerName:
                freezed == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerPhone:
                freezed == customerPhone
                    ? _value.customerPhone
                    : customerPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            orderId:
                freezed == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String?,
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<CartItem>,
            subtotal:
                null == subtotal
                    ? _value.subtotal
                    : subtotal // ignore: cast_nullable_to_non_nullable
                        as double,
            orderDiscountAmount:
                null == orderDiscountAmount
                    ? _value.orderDiscountAmount
                    : orderDiscountAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            orderDiscountPercent:
                null == orderDiscountPercent
                    ? _value.orderDiscountPercent
                    : orderDiscountPercent // ignore: cast_nullable_to_non_nullable
                        as double,
            orderDiscountReason:
                freezed == orderDiscountReason
                    ? _value.orderDiscountReason
                    : orderDiscountReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            manualDiscountApplied:
                null == manualDiscountApplied
                    ? _value.manualDiscountApplied
                    : manualDiscountApplied // ignore: cast_nullable_to_non_nullable
                        as bool,
            appliedCharges:
                null == appliedCharges
                    ? _value.appliedCharges
                    : appliedCharges // ignore: cast_nullable_to_non_nullable
                        as List<AppliedCharge>,
            totalChargesAmount:
                null == totalChargesAmount
                    ? _value.totalChargesAmount
                    : totalChargesAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            taxAmount:
                null == taxAmount
                    ? _value.taxAmount
                    : taxAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            totalAmount:
                null == totalAmount
                    ? _value.totalAmount
                    : totalAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            roundOffAmount:
                null == roundOffAmount
                    ? _value.roundOffAmount
                    : roundOffAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as CartStatus,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            referenceNumber:
                freezed == referenceNumber
                    ? _value.referenceNumber
                    : referenceNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            metadata:
                null == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartImplCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$$CartImplCopyWith(
    _$CartImpl value,
    $Res Function(_$CartImpl) then,
  ) = __$$CartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String posDeviceId,
    String priceCategoryId,
    String? priceCategoryName,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? tableId,
    String? tableName,
    String? orderId,
    List<CartItem> items,
    double subtotal,
    double orderDiscountAmount,
    double orderDiscountPercent,
    String? orderDiscountReason,
    bool manualDiscountApplied,
    List<AppliedCharge> appliedCharges,
    double totalChargesAmount,
    double taxAmount,
    double totalAmount,
    double roundOffAmount,
    CartStatus status,
    String? notes,
    String? referenceNumber,
    Map<String, dynamic> metadata,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? createdBy,
  });
}

/// @nodoc
class __$$CartImplCopyWithImpl<$Res>
    extends _$CartCopyWithImpl<$Res, _$CartImpl>
    implements _$$CartImplCopyWith<$Res> {
  __$$CartImplCopyWithImpl(_$CartImpl _value, $Res Function(_$CartImpl) _then)
    : super(_value, _then);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? posDeviceId = null,
    Object? priceCategoryId = null,
    Object? priceCategoryName = freezed,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? tableId = freezed,
    Object? tableName = freezed,
    Object? orderId = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? orderDiscountAmount = null,
    Object? orderDiscountPercent = null,
    Object? orderDiscountReason = freezed,
    Object? manualDiscountApplied = null,
    Object? appliedCharges = null,
    Object? totalChargesAmount = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? roundOffAmount = null,
    Object? status = null,
    Object? notes = freezed,
    Object? referenceNumber = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(
      _$CartImpl(
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
        posDeviceId:
            null == posDeviceId
                ? _value.posDeviceId
                : posDeviceId // ignore: cast_nullable_to_non_nullable
                    as String,
        priceCategoryId:
            null == priceCategoryId
                ? _value.priceCategoryId
                : priceCategoryId // ignore: cast_nullable_to_non_nullable
                    as String,
        priceCategoryName:
            freezed == priceCategoryName
                ? _value.priceCategoryName
                : priceCategoryName // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerName:
            freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerPhone:
            freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        orderId:
            freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String?,
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<CartItem>,
        subtotal:
            null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                    as double,
        orderDiscountAmount:
            null == orderDiscountAmount
                ? _value.orderDiscountAmount
                : orderDiscountAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        orderDiscountPercent:
            null == orderDiscountPercent
                ? _value.orderDiscountPercent
                : orderDiscountPercent // ignore: cast_nullable_to_non_nullable
                    as double,
        orderDiscountReason:
            freezed == orderDiscountReason
                ? _value.orderDiscountReason
                : orderDiscountReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        manualDiscountApplied:
            null == manualDiscountApplied
                ? _value.manualDiscountApplied
                : manualDiscountApplied // ignore: cast_nullable_to_non_nullable
                    as bool,
        appliedCharges:
            null == appliedCharges
                ? _value._appliedCharges
                : appliedCharges // ignore: cast_nullable_to_non_nullable
                    as List<AppliedCharge>,
        totalChargesAmount:
            null == totalChargesAmount
                ? _value.totalChargesAmount
                : totalChargesAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        taxAmount:
            null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        totalAmount:
            null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        roundOffAmount:
            null == roundOffAmount
                ? _value.roundOffAmount
                : roundOffAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as CartStatus,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        referenceNumber:
            freezed == referenceNumber
                ? _value.referenceNumber
                : referenceNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        metadata:
            null == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartImpl extends _Cart {
  const _$CartImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.posDeviceId,
    required this.priceCategoryId,
    this.priceCategoryName,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.tableId,
    this.tableName,
    this.orderId,
    final List<CartItem> items = const [],
    this.subtotal = 0.0,
    this.orderDiscountAmount = 0.0,
    this.orderDiscountPercent = 0.0,
    this.orderDiscountReason,
    this.manualDiscountApplied = false,
    final List<AppliedCharge> appliedCharges = const [],
    this.totalChargesAmount = 0.0,
    this.taxAmount = 0.0,
    this.totalAmount = 0.0,
    this.roundOffAmount = 0.0,
    this.status = CartStatus.active,
    this.notes,
    this.referenceNumber,
    final Map<String, dynamic> metadata = const {},
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.createdBy,
  }) : _items = items,
       _appliedCharges = appliedCharges,
       _metadata = metadata,
       super._();

  factory _$CartImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String posDeviceId;
  @override
  final String priceCategoryId;
  @override
  final String? priceCategoryName;
  @override
  final String? customerId;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? tableId;
  @override
  final String? tableName;
  @override
  final String? orderId;
  // Link to existing order for updates
  final List<CartItem> _items;
  // Link to existing order for updates
  @override
  @JsonKey()
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey()
  final double orderDiscountAmount;
  // Manual order-level discount
  @override
  @JsonKey()
  final double orderDiscountPercent;
  // Manual order-level discount percentage
  @override
  final String? orderDiscountReason;
  // Reason for manual order discount
  @override
  @JsonKey()
  final bool manualDiscountApplied;
  // Track if discount was manually selected
  final List<AppliedCharge> _appliedCharges;
  // Track if discount was manually selected
  @override
  @JsonKey()
  List<AppliedCharge> get appliedCharges {
    if (_appliedCharges is EqualUnmodifiableListView) return _appliedCharges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appliedCharges);
  }

  // Applied charges
  @override
  @JsonKey()
  final double totalChargesAmount;
  // Total charges amount
  @override
  @JsonKey()
  final double taxAmount;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final double roundOffAmount;
  @override
  @JsonKey()
  final CartStatus status;
  @override
  final String? notes;
  @override
  final String? referenceNumber;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'Cart(id: $id, businessId: $businessId, locationId: $locationId, posDeviceId: $posDeviceId, priceCategoryId: $priceCategoryId, priceCategoryName: $priceCategoryName, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, tableId: $tableId, tableName: $tableName, orderId: $orderId, items: $items, subtotal: $subtotal, orderDiscountAmount: $orderDiscountAmount, orderDiscountPercent: $orderDiscountPercent, orderDiscountReason: $orderDiscountReason, manualDiscountApplied: $manualDiscountApplied, appliedCharges: $appliedCharges, totalChargesAmount: $totalChargesAmount, taxAmount: $taxAmount, totalAmount: $totalAmount, roundOffAmount: $roundOffAmount, status: $status, notes: $notes, referenceNumber: $referenceNumber, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.posDeviceId, posDeviceId) ||
                other.posDeviceId == posDeviceId) &&
            (identical(other.priceCategoryId, priceCategoryId) ||
                other.priceCategoryId == priceCategoryId) &&
            (identical(other.priceCategoryName, priceCategoryName) ||
                other.priceCategoryName == priceCategoryName) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.orderDiscountAmount, orderDiscountAmount) ||
                other.orderDiscountAmount == orderDiscountAmount) &&
            (identical(other.orderDiscountPercent, orderDiscountPercent) ||
                other.orderDiscountPercent == orderDiscountPercent) &&
            (identical(other.orderDiscountReason, orderDiscountReason) ||
                other.orderDiscountReason == orderDiscountReason) &&
            (identical(other.manualDiscountApplied, manualDiscountApplied) ||
                other.manualDiscountApplied == manualDiscountApplied) &&
            const DeepCollectionEquality().equals(
              other._appliedCharges,
              _appliedCharges,
            ) &&
            (identical(other.totalChargesAmount, totalChargesAmount) ||
                other.totalChargesAmount == totalChargesAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.roundOffAmount, roundOffAmount) ||
                other.roundOffAmount == roundOffAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessId,
    locationId,
    posDeviceId,
    priceCategoryId,
    priceCategoryName,
    customerId,
    customerName,
    customerPhone,
    tableId,
    tableName,
    orderId,
    const DeepCollectionEquality().hash(_items),
    subtotal,
    orderDiscountAmount,
    orderDiscountPercent,
    orderDiscountReason,
    manualDiscountApplied,
    const DeepCollectionEquality().hash(_appliedCharges),
    totalChargesAmount,
    taxAmount,
    totalAmount,
    roundOffAmount,
    status,
    notes,
    referenceNumber,
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
    updatedAt,
    completedAt,
    createdBy,
  ]);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      __$$CartImplCopyWithImpl<_$CartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartImplToJson(this);
  }
}

abstract class _Cart extends Cart {
  const factory _Cart({
    required final String id,
    required final String businessId,
    required final String locationId,
    required final String posDeviceId,
    required final String priceCategoryId,
    final String? priceCategoryName,
    final String? customerId,
    final String? customerName,
    final String? customerPhone,
    final String? tableId,
    final String? tableName,
    final String? orderId,
    final List<CartItem> items,
    final double subtotal,
    final double orderDiscountAmount,
    final double orderDiscountPercent,
    final String? orderDiscountReason,
    final bool manualDiscountApplied,
    final List<AppliedCharge> appliedCharges,
    final double totalChargesAmount,
    final double taxAmount,
    final double totalAmount,
    final double roundOffAmount,
    final CartStatus status,
    final String? notes,
    final String? referenceNumber,
    final Map<String, dynamic> metadata,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final DateTime? completedAt,
    final String? createdBy,
  }) = _$CartImpl;
  const _Cart._() : super._();

  factory _Cart.fromJson(Map<String, dynamic> json) = _$CartImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get posDeviceId;
  @override
  String get priceCategoryId;
  @override
  String? get priceCategoryName;
  @override
  String? get customerId;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get tableId;
  @override
  String? get tableName;
  @override
  String? get orderId; // Link to existing order for updates
  @override
  List<CartItem> get items;
  @override
  double get subtotal;
  @override
  double get orderDiscountAmount; // Manual order-level discount
  @override
  double get orderDiscountPercent; // Manual order-level discount percentage
  @override
  String? get orderDiscountReason; // Reason for manual order discount
  @override
  bool get manualDiscountApplied; // Track if discount was manually selected
  @override
  List<AppliedCharge> get appliedCharges; // Applied charges
  @override
  double get totalChargesAmount; // Total charges amount
  @override
  double get taxAmount;
  @override
  double get totalAmount;
  @override
  double get roundOffAmount;
  @override
  CartStatus get status;
  @override
  String? get notes;
  @override
  String? get referenceNumber;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get createdBy;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
