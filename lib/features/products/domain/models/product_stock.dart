import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_stock.freezed.dart';
part 'product_stock.g.dart';

@freezed
class ProductStock with _$ProductStock {
  const factory ProductStock({
    required String id,
    required String productVariationId,
    required String locationId,
    required double currentStock,
    @Default(0.0) double reservedStock,
    @Default(10.0) double alertQuantity,
    required DateTime lastUpdated,
    
    // Sync fields
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _ProductStock;

  factory ProductStock.fromJson(Map<String, dynamic> json) => 
      _$ProductStockFromJson(json);
      
  const ProductStock._();
  
  double get availableStock => currentStock - reservedStock;
  bool get isLowStock => availableStock <= alertQuantity;
}