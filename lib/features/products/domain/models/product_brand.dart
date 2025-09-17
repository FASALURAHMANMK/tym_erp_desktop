import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_brand.freezed.dart';
part 'product_brand.g.dart';

@freezed
class ProductBrand with _$ProductBrand {
  const factory ProductBrand({
    required String id,
    required String businessId,
    required String name,
    String? description,
    String? logoUrl,
    @Default(0) int displayOrder,
    @Default(true) bool isActive,
    
    // Sync fields
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _ProductBrand;

  factory ProductBrand.fromJson(Map<String, dynamic> json) => 
      _$ProductBrandFromJson(json);
      
  const ProductBrand._();
}