import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/kot_station.dart';
import '../domain/models/kot_item_routing.dart';
import '../providers/kot_providers.dart';
import '../../kot_configuration/presentation/screens/kot_test_screen.dart';

// Provider for KOT routing service
final kotRoutingServiceProvider = Provider<KotRoutingService>((ref) {
  return KotRoutingService(ref);
});

class KotRoutingService {
  final Ref _ref;
  static final _logger = Logger('KotRoutingService');

  KotRoutingService(this._ref);

  /// Route order items to appropriate stations based on configured rules
  Future<Map<KotStation, List<MockOrderItem>>> routeOrderItems(
    List<MockOrderItem> items,
  ) async {
    try {
      _logger.info('Routing ${items.length} items to stations');

      // Get routing rules and stations
      final routingRules = await _getActiveRoutingRules();
      final stations = await _getActiveStations();
      final defaultStation = await _getDefaultStation(stations);

      // Group items by station
      final Map<KotStation, List<MockOrderItem>> routedItems = {};

      for (final item in items) {
        final station = await _determineStation(
          item,
          routingRules,
          stations,
          defaultStation,
        );

        if (station != null) {
          routedItems.putIfAbsent(station, () => []).add(item);
        }
      }

      _logger.info('Routed items to ${routedItems.length} stations');
      return routedItems;
    } catch (e, stackTrace) {
      _logger.error('Failed to route order items', e, stackTrace);
      rethrow;
    }
  }

  /// Determine which station an item should be routed to
  Future<KotStation?> _determineStation(
    MockOrderItem item,
    List<KotItemRouting> routingRules,
    List<KotStation> stations,
    KotStation? defaultStation,
  ) async {
    try {
      // Sort routing rules by priority (lower number = higher priority)
      routingRules.sort((a, b) => a.priority.compareTo(b.priority));

      // Check variation-level routing first (most specific)
      if (item.variationId != null) {
        final variationRule = routingRules.firstWhere(
          (rule) => rule.variationId == item.variationId &&
                    rule.isActive,
          orElse: () => KotItemRouting(
            id: '',
            businessId: '',
            locationId: '',
            stationId: '',
            priority: 999,
            isActive: false,
          ),
        );

        if (variationRule.isActive) {
          final station = stations.firstWhere(
            (s) => s.id == variationRule.stationId,
            orElse: () => defaultStation!,
          );
          _logger.debug('Item "${item.productName}" routed to ${station.name} by variation rule');
          return station;
        }
      }

      // Check product-level routing
      final productRule = routingRules.firstWhere(
        (rule) => rule.productId == item.productId &&
                  rule.variationId == null && // Ensure it's product-level, not variation
                  rule.isActive,
        orElse: () => KotItemRouting(
          id: '',
          businessId: '',
          locationId: '',
          stationId: '',
          priority: 999,
          isActive: false,
        ),
      );

      if (productRule.isActive) {
        final station = stations.firstWhere(
          (s) => s.id == productRule.stationId,
          orElse: () => defaultStation!,
        );
        _logger.debug('Item "${item.productName}" routed to ${station.name} by product rule');
        return station;
      }

      // Check category-level routing (least specific)
      final categoryRule = routingRules.firstWhere(
        (rule) => rule.categoryId == item.categoryId &&
                  rule.productId == null && // Ensure it's category-level
                  rule.variationId == null &&
                  rule.isActive,
        orElse: () => KotItemRouting(
          id: '',
          businessId: '',
          locationId: '',
          stationId: '',
          priority: 999,
          isActive: false,
        ),
      );

      if (categoryRule.isActive) {
        final station = stations.firstWhere(
          (s) => s.id == categoryRule.stationId,
          orElse: () => defaultStation!,
        );
        _logger.debug('Item "${item.productName}" routed to ${station.name} by category rule');
        return station;
      }

      // Use default station if no rules match
      if (defaultStation != null) {
        _logger.debug('Item "${item.productName}" routed to default station ${defaultStation.name}');
      } else {
        _logger.warning('No station found for item "${item.productName}"');
      }
      
      return defaultStation;
    } catch (e) {
      _logger.error('Failed to determine station for item', e);
      return defaultStation;
    }
  }

  /// Get all active routing rules
  Future<List<KotItemRouting>> _getActiveRoutingRules() async {
    final routingsAsync = _ref.read(kotItemRoutingsProvider);
    
    return await routingsAsync.when(
      data: (routings) => routings.where((r) => r.isActive).toList(),
      loading: () => [],
      error: (_, __) => [],
    );
  }

  /// Get all active stations
  Future<List<KotStation>> _getActiveStations() async {
    final stationsAsync = _ref.read(kotStationsProvider);
    
    return await stationsAsync.when(
      data: (stations) => stations.where((s) => s.isActive).toList(),
      loading: () => [],
      error: (_, __) => [],
    );
  }

  /// Get default station (kitchen type or first active)
  Future<KotStation?> _getDefaultStation(List<KotStation> stations) async {
    if (stations.isEmpty) {
      _logger.warning('No stations available for default routing');
      return null;
    }

    // Try to find kitchen type station as default
    final kitchenStation = stations.firstWhere(
      (s) => s.type == 'kitchen' && s.isActive,
      orElse: () => stations.firstWhere(
        (s) => s.isActive,
        orElse: () => stations.first,
      ),
    );
    
    _logger.info('Using default station: ${kitchenStation.name} (ID: ${kitchenStation.id})');
    return kitchenStation;
  }

  /// Get station by ID
  Future<KotStation?> getStation(String stationId) async {
    final stationsAsync = _ref.read(kotStationsProvider);
    
    return await stationsAsync.when(
      data: (stations) {
        try {
          return stations.firstWhere((s) => s.id == stationId);
        } catch (_) {
          return null;
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }
}