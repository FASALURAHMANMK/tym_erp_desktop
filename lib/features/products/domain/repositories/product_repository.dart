import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/offline_first_exceptions.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/product_brand.dart';
import '../models/product_stock.dart';

abstract class ProductRepository {
  // Product operations
  Future<Either<OfflineFirstException, List<Product>>> getProducts({
    required String businessId,
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? searchQuery,
  });
  
  Future<Either<OfflineFirstException, Product>> getProductById(String productId);
  
  Future<Either<OfflineFirstException, Product>> createProduct(Product product);
  
  Future<Either<OfflineFirstException, Product>> updateProduct(Product product);
  
  Future<Either<OfflineFirstException, void>> deleteProduct(String productId);
  
  // Product variation operations
  Future<Either<OfflineFirstException, Product>> addProductVariation({
    required String productId,
    required ProductVariation variation,
  });
  
  Future<Either<OfflineFirstException, Product>> updateProductVariation({
    required String productId,
    required ProductVariation variation,
  });
  
  Future<Either<OfflineFirstException, Product>> deleteProductVariation({
    required String productId,
    required String variationId,
  });
  
  // Category operations
  Future<Either<OfflineFirstException, List<ProductCategory>>> getCategories({
    required String businessId,
    bool? isActive,
  });
  
  Future<Either<OfflineFirstException, ProductCategory>> createCategory(
    ProductCategory category,
  );
  
  Future<Either<OfflineFirstException, ProductCategory>> updateCategory(
    ProductCategory category,
  );
  
  Future<Either<OfflineFirstException, void>> deleteCategory(String categoryId);
  
  // Brand operations
  Future<Either<OfflineFirstException, List<ProductBrand>>> getBrands({
    required String businessId,
    bool? isActive,
  });
  
  Future<Either<OfflineFirstException, ProductBrand>> createBrand(
    ProductBrand brand,
  );
  
  Future<Either<OfflineFirstException, ProductBrand>> updateBrand(
    ProductBrand brand,
  );
  
  Future<Either<OfflineFirstException, void>> deleteBrand(String brandId);
  
  // Stock operations
  Future<Either<OfflineFirstException, List<ProductStock>>> getStockLevels({
    required String locationId,
    String? productId,
    bool? lowStockOnly,
  });
  
  Future<Either<OfflineFirstException, ProductStock>> updateStock({
    required String productVariationId,
    required String locationId,
    required double quantity,
    required String operation, // 'set', 'add', 'subtract'
  });
  
  Future<Either<OfflineFirstException, void>> setStockAlertLevel({
    required String productVariationId,
    required String locationId,
    required double alertQuantity,
  });
  
  // Sync operations
  Future<Either<OfflineFirstException, void>> syncProducts({
    required String businessId,
  });
  
  Future<Either<OfflineFirstException, void>> downloadProductsForBusiness({
    required String businessId,
  });
  
  Future<Either<OfflineFirstException, void>> syncPendingChanges();
  
  Future<int> getPendingChangesCount();
}