import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/kot_station.dart';
import '../domain/models/kot_template.dart';
import '../providers/kot_providers.dart';
import '../../kot_configuration/presentation/screens/kot_test_screen.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';

// Provider for KOT formatter service
final kotFormatterServiceProvider = Provider<KotFormatterService>((ref) {
  return KotFormatterService(ref);
});

class KotFormatterService {
  final Ref _ref;
  static final _logger = Logger('KotFormatterService');

  KotFormatterService(this._ref);

  /// Format KOT content using templates and variables
  Future<String> formatKOT({
    required MockOrder order,
    required KotStation station,
    required List<MockOrderItem> items,
  }) async {
    try {
      _logger.info('Formatting KOT for station: ${station.name}');

      // Get template for station type
      final template = await _getTemplateForStation(station);
      
      if (template == null) {
        // Use default format if no template found
        return _formatDefaultKOT(order, station, items);
      }

      // Process template with variables
      return _processTemplate(template, order, station, items);
    } catch (e, stackTrace) {
      _logger.error('Failed to format KOT', e, stackTrace);
      // Return basic format on error
      return _formatDefaultKOT(order, station, items);
    }
  }

  /// Process template by replacing variables with actual values
  String _processTemplate(
    KotTemplate template,
    MockOrder order,
    KotStation station,
    List<MockOrderItem> items,
  ) {
    try {
      String content = template.content;

      // Get business and location info
      final business = _ref.read(selectedBusinessProvider);
      final locationAsync = _ref.read(selectedLocationNotifierProvider);
      final location = locationAsync.valueOrNull;

      // Replace business variables
      content = content.replaceAll('{BUSINESS_NAME}', business?.name ?? 'Restaurant');
      content = content.replaceAll('{LOCATION_NAME}', location?.name ?? 'Main Location');

      // Replace order variables
      content = content.replaceAll('{ORDER_NUMBER}', order.orderNumber);
      content = content.replaceAll('{TABLE_NUMBER}', order.tableNumber ?? 'N/A');
      content = content.replaceAll('{CUSTOMER_NAME}', order.customerName ?? 'Walk-in');
      content = content.replaceAll('{TOKEN_NUMBER}', _generateTokenNumber(order.id));

      // Replace date/time variables
      final now = DateTime.now();
      content = content.replaceAll('{DATE}', DateFormat('dd/MM/yyyy').format(now));
      content = content.replaceAll('{TIME}', DateFormat('HH:mm').format(now));

      // Replace station variables
      content = content.replaceAll('{STATION_NAME}', station.name);
      content = content.replaceAll('{CASHIER_NAME}', 'POS User'); // TODO: Get from auth

      // Process items if template type is 'full'
      if (template.type == 'full') {
        // Find item section in template
        final itemSection = _extractItemSection(content);
        if (itemSection != null) {
          final formattedItems = _formatItems(items, itemSection);
          content = content.replaceAll(itemSection, formattedItems);
        }
      }

      return content;
    } catch (e) {
      _logger.error('Failed to process template', e);
      return template.content;
    }
  }

  /// Extract item section from template (between item variables)
  String? _extractItemSection(String content) {
    try {
      // Look for pattern with ITEM variables
      final itemPattern = RegExp(
        r'\{ITEM_QUANTITY\}.*?\{ITEM_NAME\}.*?(?:\{SPECIAL_INSTRUCTIONS\})?',
        multiLine: true,
        dotAll: true,
      );
      
      final match = itemPattern.firstMatch(content);
      return match?.group(0);
    } catch (e) {
      _logger.error('Failed to extract item section', e);
      return null;
    }
  }

  /// Format items using template pattern
  String _formatItems(List<MockOrderItem> items, String itemPattern) {
    final formattedItems = <String>[];

    for (final item in items) {
      String itemText = itemPattern;
      
      // Replace item variables
      itemText = itemText.replaceAll('{ITEM_QUANTITY}', item.quantity.toStringAsFixed(0));
      itemText = itemText.replaceAll('{ITEM_NAME}', item.productName);
      
      if (item.variationName != null && item.variationName!.isNotEmpty) {
        itemText = itemText.replaceAll(
          item.productName,
          '${item.productName} (${item.variationName})',
        );
      }
      
      // Handle special instructions
      if (item.specialInstructions != null) {
        itemText = itemText.replaceAll(
          '{SPECIAL_INSTRUCTIONS}',
          '  Note: ${item.specialInstructions}',
        );
      } else {
        itemText = itemText.replaceAll('{SPECIAL_INSTRUCTIONS}', '');
      }
      
      formattedItems.add(itemText.trim());
    }

    return formattedItems.join('\n\n');
  }

  /// Format default KOT when no template is available
  String _formatDefaultKOT(
    MockOrder order,
    KotStation station,
    List<MockOrderItem> items,
  ) {
    final business = _ref.read(selectedBusinessProvider);
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm');
    
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('=' * 32);
    buffer.writeln('      ${business?.name ?? "RESTAURANT"}'.toUpperCase());
    buffer.writeln('        ${station.name}'.toUpperCase());
    buffer.writeln('=' * 32);
    buffer.writeln('Order: ${order.orderNumber}');
    
    if (order.tableNumber != null) {
      buffer.writeln('Table: ${order.tableNumber}');
    }
    
    if (order.customerName != null) {
      buffer.writeln('Customer: ${order.customerName}');
    }
    
    buffer.writeln('Time: ${timeFormat.format(now)}');
    buffer.writeln('-' * 32);
    buffer.writeln();
    
    // Items
    for (final item in items) {
      buffer.write('${item.quantity.toStringAsFixed(0)} x ');
      buffer.write(item.productName);
      
      if (item.variationName != null && item.variationName!.isNotEmpty) {
        buffer.write(' (${item.variationName})');
      }
      
      buffer.writeln();
      
      if (item.specialInstructions != null) {
        buffer.writeln('  Note: ${item.specialInstructions}');
      }
      
      buffer.writeln();
    }
    
    // Footer
    buffer.writeln('-' * 32);
    buffer.writeln('Token: ${_generateTokenNumber(order.id)}');
    buffer.writeln('=' * 32);
    
    return buffer.toString();
  }

  /// Get template for station
  Future<KotTemplate?> _getTemplateForStation(KotStation station) async {
    final templatesAsync = _ref.read(kotTemplatesProvider);
    
    return await templatesAsync.when(
      data: (templates) {
        // Filter active templates
        final activeTemplates = templates.where((t) => t.isActive).toList();
        
        if (activeTemplates.isEmpty) return null;
        
        // Try to find default template of type 'full'
        final defaultTemplate = activeTemplates.firstWhere(
          (t) => t.type == 'full' && t.isDefault,
          orElse: () => activeTemplates.firstWhere(
            (t) => t.type == 'full',
            orElse: () => activeTemplates.first,
          ),
        );
        
        return defaultTemplate;
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Generate a token number from order ID
  String _generateTokenNumber(String orderId) {
    // Extract last 3-4 digits from order ID for token
    final digits = orderId.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 4) {
      return digits.substring(digits.length - 4);
    } else if (digits.length >= 3) {
      return digits.substring(digits.length - 3);
    }
    return digits.padLeft(3, '0');
  }

  /// Get styling configuration for KOT
  Map<String, dynamic> getStylingConfig() {
    // TODO: Load from user preferences/configuration
    return {
      'headerSize': 'large',
      'itemSize': 'medium',
      'footerSize': 'medium',
      'boldHeaders': true,
      'underlineHeaders': false,
      'itemSpacing': 'normal',
      'showBorders': true,
      'borderStyle': '=',
      'dividerStyle': '-',
    };
  }

  /// Apply styling to formatted KOT
  String applyStying(String content, Map<String, dynamic> styling) {
    // This would be enhanced based on printer capabilities
    // For now, return content as-is
    return content;
  }
}