import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../domain/models/product.dart';
import '../domain/models/product_category.dart';
import '../domain/repositories/product_repository.dart';
import 'product_image_service.dart';

class BulkProductUploadService {
  static final _logger = Logger('BulkProductUploadService');
  final ProductRepository _productRepository;
  final ProductImageService _imageService;
  final _uuid = const Uuid();

  BulkProductUploadService({
    required ProductRepository productRepository,
    required ProductImageService imageService,
  }) : _productRepository = productRepository,
       _imageService = imageService;

  /// Parse Excel or CSV file
  Future<List<Map<String, dynamic>>> parseFile(File file) async {
    final extension = file.path.split('.').last.toLowerCase();

    if (extension == 'csv') {
      return _parseCsvFile(file);
    } else if (extension == 'xlsx' || extension == 'xls') {
      return _parseExcelFile(file);
    } else {
      throw Exception('Unsupported file format: $extension');
    }
  }

  /// Parse CSV file
  Future<List<Map<String, dynamic>>> _parseCsvFile(File file) async {
    try {
      final input = file.readAsStringSync();
      final fields = const CsvToListConverter().convert(input);

      if (fields.isEmpty) {
        throw Exception('CSV file is empty');
      }

      // First row is headers
      final headers =
          fields.first
              .map((h) => h.toString().toLowerCase().replaceAll(' ', '_'))
              .toList();
      final products = <Map<String, dynamic>>[];

      // Process data rows
      for (int i = 1; i < fields.length; i++) {
        final row = fields[i];
        final product = <String, dynamic>{};

        for (int j = 0; j < headers.length && j < row.length; j++) {
          product[headers[j]] = row[j];
        }

        products.add(product);
      }

      _logger.info('Parsed ${products.length} products from CSV');
      return products;
    } catch (e, stackTrace) {
      _logger.error('Failed to parse CSV file', e, stackTrace);
      rethrow;
    }
  }

  /// Parse Excel file
  Future<List<Map<String, dynamic>>> _parseExcelFile(File file) async {
    try {
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      // Log available sheets
      _logger.info('Available sheets: ${excel.tables.keys.toList()}');
      
      // Try to get 'Products' sheet first, fallback to first sheet
      Sheet? sheet;
      if (excel.tables.containsKey('Products')) {
        sheet = excel.tables['Products'];
        _logger.info('Using Products sheet');
      } else if (excel.tables.isNotEmpty) {
        final sheetName = excel.tables.keys.first;
        sheet = excel.tables.values.first;
        _logger.info('Using first sheet: $sheetName');
      }

      if (sheet == null) {
        throw Exception('No sheets found in Excel file');
      }
      
      _logger.info('Sheet has ${sheet.rows.length} rows');
      
      if (sheet.rows.isEmpty) {
        throw Exception('Excel sheet has no data');
      }
      
      // Check if we have at least headers
      if (sheet.rows.length < 1) {
        throw Exception('Excel file must have at least headers row');
      }

      // First row is headers
      final headers =
          sheet.rows.first
              .map(
                (cell) =>
                    cell?.value?.toString().toLowerCase().replaceAll(
                      ' ',
                      '_',
                    ) ??
                    '',
              )
              .where((h) => h.isNotEmpty)
              .toList();

      final products = <Map<String, dynamic>>[];

      // Process data rows
      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        final product = <String, dynamic>{};

        for (int j = 0; j < headers.length && j < row.length; j++) {
          final cellValue = row[j]?.value;
          product[headers[j]] = cellValue?.toString() ?? '';
        }

        // Skip completely empty rows only
        if (product.values.any((v) => v.toString().isNotEmpty)) {
          products.add(product);
        }
      }

      _logger.info('Parsed ${products.length} products from Excel');
      
      // If no products found (completely empty file)
      if (products.isEmpty) {
        throw Exception('No product data found in the file. Please ensure the file contains at least one row of data.');
      }
      
      return products;
    } catch (e, stackTrace) {
      _logger.error('Failed to parse Excel file', e, stackTrace);
      rethrow;
    }
  }

  /// Import products with images
  Future<BulkImportResult> importProducts({
    required String businessId,
    required List<Map<String, dynamic>> products,
    required Map<String, List<String>> imageMapping,
    Function(int processed, int total)? onProgress,
  }) async {
    final result = BulkImportResult();
    final categoryCache = <String, String>{}; // category name -> id

    // Get existing categories
    final categoriesResult = await _productRepository.getCategories(
      businessId: businessId,
    );

    if (categoriesResult.isRight()) {
      final categories = categoriesResult.getOrElse(() => []);
      for (final cat in categories) {
        categoryCache[cat.name.toLowerCase()] = cat.id;
      }
    }

    // Process each product
    for (int i = 0; i < products.length; i++) {
      try {
        final productData = products[i];

        // Get or create category
        String? categoryId = await _getOrCreateCategory(
          businessId: businessId,
          categoryName: productData['category']?.toString() ?? '',
          categoryCache: categoryCache,
        );

        if (categoryId == null) {
          result.failedCount++;
          result.errors.add(
            'Row ${i + 2}: Category not found or could not be created',
          );
          continue;
        }

        // Create product
        final product = Product(
          id: _uuid.v4(),
          businessId: businessId,
          name: productData['name']?.toString() ?? '',
          nameInAlternateLanguage: productData['name_alt']?.toString(),
          description: productData['description']?.toString(),
          categoryId: categoryId,
          brandId: productData['brand_id']?.toString(),
          unitOfMeasure: _parseUnitOfMeasure(productData['unit']?.toString()),
          barcode: productData['barcode']?.toString(),
          hsn: productData['hsn']?.toString(),
          taxRate:
              double.tryParse(productData['tax_rate']?.toString() ?? '') ?? 0,
          shortCode: productData['short_code']?.toString(),
          tags: _parseTags(productData['tags']?.toString()),
          productType: _parseProductType(
            productData['product_type']?.toString(),
          ),
          trackInventory: _parseBool(
            productData['track_inventory']?.toString(),
            true,
          ),
          isActive: _parseBool(productData['is_active']?.toString(), true),
          displayOrder:
              int.tryParse(productData['display_order']?.toString() ?? '') ?? 0,
          availableInPos: _parseBool(
            productData['available_in_pos']?.toString(),
            true,
          ),
          availableInOnlineStore: _parseBool(
            productData['available_in_online_store']?.toString(),
            false,
          ),
          availableInCatalog: _parseBool(
            productData['available_in_catalog']?.toString(),
            true,
          ),
          skipKot: _parseBool(productData['skip_kot']?.toString(), false),
          variations: [
            ProductVariation(
              id: _uuid.v4(),
              productId: '',
              // Will be set by repository
              name: productData['variation_name']?.toString() ?? 'Default',
              sku: productData['sku']?.toString() ?? _generateSku(),
              mrp:
                  double.tryParse(productData['mrp']?.toString() ?? '') ??
                  double.tryParse(
                    productData['selling_price']?.toString() ?? '',
                  ) ??
                  0,
              sellingPrice:
                  double.tryParse(
                    productData['selling_price']?.toString() ?? '',
                  ) ??
                  0,
              purchasePrice: double.tryParse(
                productData['purchase_price']?.toString() ?? '',
              ),
              barcode: productData['variation_barcode']?.toString(),
              isDefault: true,
              isActive: true,
              displayOrder: 0,
              isForSale: true,
              isForPurchase: _parseBool(
                productData['is_for_purchase']?.toString(),
                false,
              ),
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Create product
        final createResult = await _productRepository.createProduct(product);

        if (createResult.isRight()) {
          final createdProduct = createResult.getOrElse(
            () => throw Exception(),
          );
          result.successCount++;

          // Upload images if mapped
          await _uploadProductImages(
            businessId: businessId,
            productId: createdProduct.id,
            sku: productData['sku']?.toString() ?? '',
            barcode: productData['barcode']?.toString() ?? '',
            imageMapping: imageMapping,
          );
        } else {
          result.failedCount++;
          final error = createResult.fold(
            (l) => l.message,
            (r) => 'Unknown error',
          );
          result.errors.add('Row ${i + 2}: $error');
        }

        // Report progress
        onProgress?.call(i + 1, products.length);
      } catch (e) {
        result.failedCount++;
        result.errors.add('Row ${i + 2}: $e');
        _logger.error('Failed to import product at row ${i + 2}', e);
      }
    }

    _logger.info(
      'Bulk import complete: ${result.successCount} success, ${result.failedCount} failed',
    );
    return result;
  }

  /// Get or create category
  Future<String?> _getOrCreateCategory({
    required String businessId,
    required String categoryName,
    required Map<String, String> categoryCache,
  }) async {
    if (categoryName.isEmpty) return null;

    final nameLower = categoryName.toLowerCase();

    // Check cache
    if (categoryCache.containsKey(nameLower)) {
      return categoryCache[nameLower];
    }

    // Create new category
    final category = ProductCategory(
      id: _uuid.v4(),
      businessId: businessId,
      name: categoryName,
      isActive: true,
      displayOrder: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _productRepository.createCategory(category);

    if (result.isRight()) {
      final created = result.getOrElse(() => throw Exception());
      categoryCache[nameLower] = created.id;
      return created.id;
    }

    return null;
  }

  /// Upload product images
  Future<void> _uploadProductImages({
    required String businessId,
    required String productId,
    required String sku,
    required String barcode,
    required Map<String, List<String>> imageMapping,
  }) async {
    final imagePaths = <String>[];

    // Check for SKU mapping
    if (sku.isNotEmpty && imageMapping.containsKey(sku)) {
      imagePaths.addAll(imageMapping[sku]!);
    }

    // Check for barcode mapping
    if (barcode.isNotEmpty && imageMapping.containsKey(barcode)) {
      imagePaths.addAll(imageMapping[barcode]!);
    }

    if (imagePaths.isEmpty) return;

    // Upload images and collect URLs
    String? mainImageUrl;
    final additionalImageUrls = <String>[];

    for (int i = 0; i < imagePaths.length; i++) {
      try {
        final uploadResult = await _imageService.uploadImage(
          filePath: imagePaths[i],
          businessId: businessId,
          productId: productId,
          isMainImage: i == 0, // First image is main
        );

        uploadResult.fold(
          (error) => _logger.error('Failed to upload image: ${error.message}'),
          (url) {
            if (i == 0) {
              mainImageUrl = url;
            } else {
              additionalImageUrls.add(url);
            }
          },
        );
      } catch (e) {
        _logger.error('Failed to upload image for product $productId', e);
      }
    }

    // Update product with image URLs if any were uploaded successfully
    if (mainImageUrl != null || additionalImageUrls.isNotEmpty) {
      try {
        // Get the current product
        final productResult = await _productRepository.getProductById(
          productId,
        );

        if (productResult.isRight()) {
          final product = productResult.getOrElse(() => throw Exception());

          // Update the product with image URLs
          final updatedProduct = product.copyWith(
            imageUrl: mainImageUrl ?? product.imageUrl,
            additionalImageUrls:
                additionalImageUrls.isNotEmpty
                    ? additionalImageUrls
                    : product.additionalImageUrls,
          );

          // Save the updated product
          await _productRepository.updateProduct(updatedProduct);
          _logger.info(
            'Updated product $productId with ${additionalImageUrls.length + (mainImageUrl != null ? 1 : 0)} images',
          );
        }
      } catch (e) {
        _logger.error('Failed to update product with image URLs', e);
      }
    }
  }

  /// Parse unit of measure
  UnitOfMeasure _parseUnitOfMeasure(String? value) {
    switch (value?.toLowerCase()) {
      case 'kg':
        return UnitOfMeasure.kg;
      case 'g':
      case 'gram':
        return UnitOfMeasure.gram;
      case 'l':
      case 'liter':
        return UnitOfMeasure.liter;
      case 'ml':
        return UnitOfMeasure.ml;
      case 'piece':
      case 'pcs':
        return UnitOfMeasure.piece;
      case 'dozen':
        return UnitOfMeasure.dozen;
      case 'box':
        return UnitOfMeasure.box;
      case 'pack':
        return UnitOfMeasure.pack;
      default:
        return UnitOfMeasure.count;
    }
  }

  /// Parse product type
  ProductType _parseProductType(String? value) {
    switch (value?.toLowerCase()) {
      case 'physical':
        return ProductType.physical;
      case 'digital':
        return ProductType.digital;
      case 'service':
        return ProductType.service;
      default:
        return ProductType.physical;
    }
  }

  /// Parse boolean value
  bool _parseBool(String? value, bool defaultValue) {
    if (value == null || value.isEmpty) return defaultValue;

    final lower = value.toLowerCase();
    if (lower == 'true' || lower == 'yes' || lower == '1') return true;
    if (lower == 'false' || lower == 'no' || lower == '0') return false;

    return defaultValue;
  }

  /// Parse tags
  List<String> _parseTags(String? value) {
    if (value == null || value.isEmpty) return [];

    return value
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  /// Generate SKU
  String _generateSku() {
    return 'SKU${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Download template Excel file
  Future<String?> downloadTemplate() async {
    try {
      // Create Excel workbook
      final excel = Excel.createExcel();
      final sheet = excel['Products'];

      // Headers - comprehensive list matching export format
      final headers = [
        'Name',
        'Name Alt',
        'Description',
        'Category',
        'Brand',
        'SKU',
        'Barcode',
        'MRP',
        'Selling Price',
        'Purchase Price',
        'Unit',
        'HSN',
        'Tax Rate',
        'Short Code',
        'Tags',
        'Product Type',
        'Track Inventory',
        'Is Active',
        'Display Order',
        'Available In POS',
        'Available In Online Store',
        'Available In Catalog',
        'Skip KOT',
        'Variation Name',
        'Variation Barcode',
        'Is For Sale',
        'Is For Purchase',
        'Primary Image URL',
        'Additional Image URLs',
      ];

      // Add headers with styling
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.blue300,
          fontColorHex: ExcelColor.white,
        );
        // Set column width
        sheet.setColumnWidth(i, 15.0);
      }

      // Add example data row with clear indication it's an example
      final sampleData = [
        'EXAMPLE - Chocolate Cake',  // Clear product name
        'كعكة الشوكولاتة',
        'Delicious homemade chocolate cake with rich frosting',
        'Food',  // Valid category that likely exists
        'Example Brand',
        'EXAMPLE-SKU-001',  // Clear that it's an example SKU
        '1234567890123',
        '150',  // MRP
        '120',  // Selling Price
        '80',   // Purchase Price
        'piece',
        'HSN123456',
        '18',
        'CAKE01',
        'dessert, chocolate, cake',
        'physical',
        'true',
        'true',
        '1',
        'true',
        'false',
        'true',
        'false',
        'Default',
        'EXAMPLE-VAR-001',
        'true',
        'true',
        'https://example.com/images/chocolate-cake.jpg',
        'https://example.com/cake1.jpg, https://example.com/cake2.jpg',
      ];

      for (int i = 0; i < sampleData.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1))
            .value = TextCellValue(sampleData[i]);
      }

      // Get Excel bytes
      final excelBytes = excel.save();
      if (excelBytes != null) {
        // On macOS, bytes parameter is not supported, so we need to get path first then write
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Product Import Template',
          fileName: 'product_import_template.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
        );

        if (result != null) {
          // Write the file to the selected path
          final file = File(result);
          await file.writeAsBytes(excelBytes);
          _logger.info('Template saved to: $result');
          return result;
        }
      }
      return null;
    } catch (e, stackTrace) {
      _logger.error('Failed to create template', e, stackTrace);
      rethrow;
    }
  }
}

class BulkImportResult {
  int successCount = 0;
  int failedCount = 0;
  List<String> errors = [];

  int get totalCount => successCount + failedCount;
}
