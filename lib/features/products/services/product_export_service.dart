import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/utils/logger.dart';
import '../domain/models/product.dart';
import '../domain/repositories/product_repository.dart';

class ProductExportService {
  static final _logger = Logger('ProductExportService');
  final ProductRepository _productRepository;

  ProductExportService({required ProductRepository productRepository})
    : _productRepository = productRepository;

  /// Export products to Excel file
  Future<String> exportProductsToExcel({
    required String businessId,
    String? categoryId,
    String? brandId,
    bool includeInactive = false,
  }) async {
    try {
      _logger.info('Starting product export for business: $businessId');

      // Fetch products from repository
      final productsResult = await _productRepository.getProducts(
        businessId: businessId,
        categoryId: categoryId,
        brandId: brandId,
        isActive: includeInactive ? null : true,
      );

      if (productsResult.isLeft()) {
        throw Exception('Failed to fetch products');
      }

      final products = productsResult.getOrElse(() => []);
      _logger.info('Exporting ${products.length} products');

      // Fetch categories and brands for mapping
      final categoriesResult = await _productRepository.getCategories(
        businessId: businessId,
      );
      final categories = categoriesResult.getOrElse(() => []);
      final categoryMap = {
        for (var cat in categories) cat.id: cat.name
      };

      final brandsResult = await _productRepository.getBrands(
        businessId: businessId,
      );
      final brands = brandsResult.getOrElse(() => []);
      final brandMap = {
        for (var brand in brands) brand.id: brand.name
      };

      // Create Excel workbook
      final excel = Excel.createExcel();

      // Remove default sheet and create Products sheet
      excel.delete('Sheet1');
      final sheet = excel['Products'];

      // Define headers - matching template format exactly
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

      // Add headers to sheet
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = TextCellValue(headers[i]);

        // Style the header
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.blue300,
          fontColorHex: ExcelColor.white,
        );
      }

      // Add data rows
      int rowIndex = 1;
      for (final product in products) {
        // Export each variation as a separate row
        for (final variation in product.variations) {
          final rowData = [
            product.name,
            product.nameInAlternateLanguage ?? '',
            product.description ?? '',
            categoryMap[product.categoryId] ?? '', // Get category name from map
            product.brandId != null ? (brandMap[product.brandId] ?? '') : '', // Get brand name from map
            variation.sku ?? '',
            product.barcode ?? '',
            variation.mrp.toString(),
            variation.sellingPrice.toString(),
            variation.purchasePrice?.toString() ?? '',
            product.unitOfMeasure.name,
            product.hsn ?? '',
            product.taxRate.toString(),
            product.shortCode ?? '',
            product.tags.join(', '),
            product.productType.name,
            product.trackInventory.toString(),
            product.isActive.toString(),
            product.displayOrder.toString(),
            product.availableInPos.toString(),
            product.availableInOnlineStore.toString(),
            product.availableInCatalog.toString(),
            product.skipKot.toString(),
            variation.name,
            variation.barcode ?? '',
            variation.isForSale.toString(),
            variation.isForPurchase.toString(),
            product.imageUrl ?? '',
            product.additionalImageUrls.join(', '),
          ];

          // Add row data to sheet
          for (int i = 0; i < rowData.length; i++) {
            sheet
                .cell(
                  CellIndex.indexByColumnRow(
                    columnIndex: i,
                    rowIndex: rowIndex,
                  ),
                )
                .value = TextCellValue(rowData[i]);
          }

          rowIndex++;
        }
      }

      // Auto-size columns (approximate)
      for (int i = 0; i < headers.length; i++) {
        sheet.setColumnWidth(i, 15.0);
      }

      // Save file using file picker
      final excelBytes = excel.save();
      if (excelBytes != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        // On macOS, bytes parameter is not supported, so we need to get path first then write
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Products Export',
          fileName: 'products_export_$timestamp.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
        );

        if (result != null) {
          // Write the file to the selected path
          final file = File(result);
          await file.writeAsBytes(excelBytes);
          _logger.info('Excel file saved to: $result');
          return result;
        } else {
          throw Exception('Export cancelled by user');
        }
      } else {
        throw Exception('Failed to generate Excel file');
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to export products', e, stackTrace);
      rethrow;
    }
  }

  /// Export products with images mapping (now same as main export)
  Future<String> exportProductsWithImageMapping({
    required String businessId,
    String? categoryId,
    String? brandId,
    bool includeInactive = false,
  }) async {
    // Since the main export now includes image URLs, just call it directly
    return exportProductsToExcel(
      businessId: businessId,
      categoryId: categoryId,
      brandId: brandId,
      includeInactive: includeInactive,
    );
  }

}
