import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

enum ProductType { 
  @JsonValue('physical') physical, 
  @JsonValue('service') service, 
  @JsonValue('digital') digital 
}

enum UnitOfMeasure { 
  @JsonValue('count') count, 
  @JsonValue('kg') kg, 
  @JsonValue('gram') gram, 
  @JsonValue('liter') liter, 
  @JsonValue('ml') ml, 
  @JsonValue('meter') meter, 
  @JsonValue('cm') cm, 
  @JsonValue('piece') piece, 
  @JsonValue('box') box, 
  @JsonValue('dozen') dozen,
  @JsonValue('pack') pack
}

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String businessId,
    required String name,
    String? nameInAlternateLanguage,
    String? description,
    String? descriptionInAlternateLanguage,
    required String categoryId,
    String? brandId,
    String? imageUrl,
    @Default([]) List<String> additionalImageUrls,
    @Default(UnitOfMeasure.count) UnitOfMeasure unitOfMeasure,
    String? barcode,
    String? hsn,
    @Default(0.0) double taxRate, // Deprecated - use taxRateId instead
    String? taxGroupId, // Deprecated - use taxRateId instead
    String? taxRateId, // Reference to specific tax_rates table entry
    String? shortCode,
    @Default([]) List<String> tags,
    @Default(ProductType.physical) ProductType productType,
    @Default(true) bool trackInventory,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    
    // Availability flags
    @Default(true) bool availableInPos,
    @Default(false) bool availableInOnlineStore,
    @Default(true) bool availableInCatalog,
    
    // KOT settings
    @Default(false) bool skipKot,
    
    // Always has at least one variation
    required List<ProductVariation> variations,
    
    // Sync fields
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _Product;

  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  
  // Helper getters
  bool get hasMultipleVariations => variations.length > 1;
  
  ProductVariation? get defaultVariation {
    if (variations.isEmpty) {
      return null;
    }
    try {
      return variations.firstWhere((v) => v.isDefault);
    } catch (_) {
      // Fallback to first variation if no default found
      return variations.first;
    }
  }
  
  double get defaultSellingPrice => defaultVariation?.sellingPrice ?? 0.0;
  double get defaultMrp => defaultVariation?.mrp ?? 0.0;
  
  // Create a new product with default variation
  factory Product.createNew({
    required String businessId,
    required String name,
    required String categoryId,
    required double mrp,
    required double sellingPrice,
    double? purchasePrice,
    UnitOfMeasure unitOfMeasure = UnitOfMeasure.count,
    ProductType productType = ProductType.physical,
    double taxRate = 0.0, // Deprecated
    String? taxGroupId, // Deprecated
    String? taxRateId,
    bool trackInventory = true,
  }) {
    final now = DateTime.now();
    final productId = 'prod_${DateTime.now().millisecondsSinceEpoch}';
    
    return Product(
      id: productId,
      businessId: businessId,
      name: name,
      categoryId: categoryId,
      unitOfMeasure: unitOfMeasure,
      productType: productType,
      taxRate: taxRate, // Deprecated
      taxGroupId: taxGroupId, // Deprecated
      taxRateId: taxRateId,
      trackInventory: trackInventory,
      createdAt: now,
      updatedAt: now,
      variations: [
        ProductVariation(
          id: '${productId}_default',
          productId: productId,
          name: name,
          mrp: mrp,
          sellingPrice: sellingPrice,
          purchasePrice: purchasePrice,
          isDefault: true,
          isActive: true,
          displayOrder: 0,
          isForSale: true,
          isForPurchase: purchasePrice != null,
        ),
      ],
    );
  }
}

@freezed
class ProductVariation with _$ProductVariation {
  const factory ProductVariation({
    required String id,
    required String productId,
    required String name,
    String? sku,
    required double mrp,
    required double sellingPrice,
    double? purchasePrice,
    String? barcode,
    @Default(false) bool isDefault,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    
    // Inventory flags
    @Default(true) bool isForSale,
    @Default(false) bool isForPurchase,
    
    // Price category overrides
    // Map of priceCategoryId to price
    @Default({}) Map<String, double> categoryPrices,
    
    // Table-specific price overrides (optional)
    // Map of tableId to price
    @Default({}) Map<String, double> tablePrices,
  }) = _ProductVariation;

  const ProductVariation._();

  factory ProductVariation.fromJson(Map<String, dynamic> json) => 
      _$ProductVariationFromJson(json);
  
  // Helper method to get price for a specific category
  double getPriceForCategory(String? priceCategoryId) {
    if (priceCategoryId != null && categoryPrices.containsKey(priceCategoryId)) {
      return categoryPrices[priceCategoryId]!;
    }
    return sellingPrice; // Default price if no override exists
  }
  
  // Helper method to get price for a specific table
  double getPriceForTable(String? tableId, String? priceCategoryId) {
    // First check table-specific price
    if (tableId != null && tablePrices.containsKey(tableId)) {
      return tablePrices[tableId]!;
    }
    // Then check category price
    return getPriceForCategory(priceCategoryId);
  }
  
  // Check if variation has custom pricing
  bool get hasCustomPricing => categoryPrices.isNotEmpty || tablePrices.isNotEmpty;
}