// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductStock _$ProductStockFromJson(Map<String, dynamic> json) {
  return _ProductStock.fromJson(json);
}

/// @nodoc
mixin _$ProductStock {
  String get id => throw _privateConstructorUsedError;
  String get productVariationId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  double get currentStock => throw _privateConstructorUsedError;
  double get reservedStock => throw _privateConstructorUsedError;
  double get alertQuantity => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError; // Sync fields
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this ProductStock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductStockCopyWith<ProductStock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductStockCopyWith<$Res> {
  factory $ProductStockCopyWith(
    ProductStock value,
    $Res Function(ProductStock) then,
  ) = _$ProductStockCopyWithImpl<$Res, ProductStock>;
  @useResult
  $Res call({
    String id,
    String productVariationId,
    String locationId,
    double currentStock,
    double reservedStock,
    double alertQuantity,
    DateTime lastUpdated,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$ProductStockCopyWithImpl<$Res, $Val extends ProductStock>
    implements $ProductStockCopyWith<$Res> {
  _$ProductStockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productVariationId = null,
    Object? locationId = null,
    Object? currentStock = null,
    Object? reservedStock = null,
    Object? alertQuantity = null,
    Object? lastUpdated = null,
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
            productVariationId:
                null == productVariationId
                    ? _value.productVariationId
                    : productVariationId // ignore: cast_nullable_to_non_nullable
                        as String,
            locationId:
                null == locationId
                    ? _value.locationId
                    : locationId // ignore: cast_nullable_to_non_nullable
                        as String,
            currentStock:
                null == currentStock
                    ? _value.currentStock
                    : currentStock // ignore: cast_nullable_to_non_nullable
                        as double,
            reservedStock:
                null == reservedStock
                    ? _value.reservedStock
                    : reservedStock // ignore: cast_nullable_to_non_nullable
                        as double,
            alertQuantity:
                null == alertQuantity
                    ? _value.alertQuantity
                    : alertQuantity // ignore: cast_nullable_to_non_nullable
                        as double,
            lastUpdated:
                null == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductStockImplCopyWith<$Res>
    implements $ProductStockCopyWith<$Res> {
  factory _$$ProductStockImplCopyWith(
    _$ProductStockImpl value,
    $Res Function(_$ProductStockImpl) then,
  ) = __$$ProductStockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productVariationId,
    String locationId,
    double currentStock,
    double reservedStock,
    double alertQuantity,
    DateTime lastUpdated,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$ProductStockImplCopyWithImpl<$Res>
    extends _$ProductStockCopyWithImpl<$Res, _$ProductStockImpl>
    implements _$$ProductStockImplCopyWith<$Res> {
  __$$ProductStockImplCopyWithImpl(
    _$ProductStockImpl _value,
    $Res Function(_$ProductStockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productVariationId = null,
    Object? locationId = null,
    Object? currentStock = null,
    Object? reservedStock = null,
    Object? alertQuantity = null,
    Object? lastUpdated = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$ProductStockImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        productVariationId:
            null == productVariationId
                ? _value.productVariationId
                : productVariationId // ignore: cast_nullable_to_non_nullable
                    as String,
        locationId:
            null == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                    as String,
        currentStock:
            null == currentStock
                ? _value.currentStock
                : currentStock // ignore: cast_nullable_to_non_nullable
                    as double,
        reservedStock:
            null == reservedStock
                ? _value.reservedStock
                : reservedStock // ignore: cast_nullable_to_non_nullable
                    as double,
        alertQuantity:
            null == alertQuantity
                ? _value.alertQuantity
                : alertQuantity // ignore: cast_nullable_to_non_nullable
                    as double,
        lastUpdated:
            null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductStockImpl extends _ProductStock {
  const _$ProductStockImpl({
    required this.id,
    required this.productVariationId,
    required this.locationId,
    required this.currentStock,
    this.reservedStock = 0.0,
    this.alertQuantity = 10.0,
    required this.lastUpdated,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : super._();

  factory _$ProductStockImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductStockImplFromJson(json);

  @override
  final String id;
  @override
  final String productVariationId;
  @override
  final String locationId;
  @override
  final double currentStock;
  @override
  @JsonKey()
  final double reservedStock;
  @override
  @JsonKey()
  final double alertQuantity;
  @override
  final DateTime lastUpdated;
  // Sync fields
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'ProductStock(id: $id, productVariationId: $productVariationId, locationId: $locationId, currentStock: $currentStock, reservedStock: $reservedStock, alertQuantity: $alertQuantity, lastUpdated: $lastUpdated, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductStockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productVariationId, productVariationId) ||
                other.productVariationId == productVariationId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.reservedStock, reservedStock) ||
                other.reservedStock == reservedStock) &&
            (identical(other.alertQuantity, alertQuantity) ||
                other.alertQuantity == alertQuantity) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
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
    productVariationId,
    locationId,
    currentStock,
    reservedStock,
    alertQuantity,
    lastUpdated,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductStockImplCopyWith<_$ProductStockImpl> get copyWith =>
      __$$ProductStockImplCopyWithImpl<_$ProductStockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductStockImplToJson(this);
  }
}

abstract class _ProductStock extends ProductStock {
  const factory _ProductStock({
    required final String id,
    required final String productVariationId,
    required final String locationId,
    required final double currentStock,
    final double reservedStock,
    final double alertQuantity,
    required final DateTime lastUpdated,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$ProductStockImpl;
  const _ProductStock._() : super._();

  factory _ProductStock.fromJson(Map<String, dynamic> json) =
      _$ProductStockImpl.fromJson;

  @override
  String get id;
  @override
  String get productVariationId;
  @override
  String get locationId;
  @override
  double get currentStock;
  @override
  double get reservedStock;
  @override
  double get alertQuantity;
  @override
  DateTime get lastUpdated; // Sync fields
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductStockImplCopyWith<_$ProductStockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
