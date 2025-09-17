import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_category.freezed.dart';
part 'product_category.g.dart';

@freezed
class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    required String id,
    required String businessId,
    required String name,
    String? nameInAlternateLanguage,
    String? description,
    String? imageUrl,
    String? iconName,
    @Default(0) int displayOrder,
    @Default(true) bool isActive,
    String? parentCategoryId,
    
    // KOT settings
    String? defaultKotPrinterId,
    
    // Sync fields
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => 
      _$ProductCategoryFromJson(json);
      
  const ProductCategory._();
}