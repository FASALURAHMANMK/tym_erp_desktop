import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/logger.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';
import '../../orders/models/order.dart';
import '../../orders/models/order_status.dart';
import '../../orders/providers/order_provider.dart';

part 'sales_provider.g.dart';

final _logger = Logger('SalesProvider');

/// Sales filter model for filtering completed orders
class SalesFilter {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? orderType;
  final String? paymentMethod;
  final String? searchQuery;

  const SalesFilter({
    this.fromDate,
    this.toDate,
    this.orderType,
    this.paymentMethod,
    this.searchQuery,
  });

  SalesFilter copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    String? orderType,
    String? paymentMethod,
    String? searchQuery,
  }) {
    return SalesFilter(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      orderType: orderType ?? this.orderType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Sales statistics model
class SalesStatistics {
  final int totalOrders;
  final double totalRevenue;
  final double totalTax;
  final double totalDiscounts;
  final double averageOrderValue;
  final Map<String, int> orderTypeBreakdown;
  final Map<String, double> paymentMethodBreakdown;

  const SalesStatistics({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalTax,
    required this.totalDiscounts,
    required this.averageOrderValue,
    required this.orderTypeBreakdown,
    required this.paymentMethodBreakdown,
  });

  factory SalesStatistics.empty() => const SalesStatistics(
        totalOrders: 0,
        totalRevenue: 0,
        totalTax: 0,
        totalDiscounts: 0,
        averageOrderValue: 0,
        orderTypeBreakdown: {},
        paymentMethodBreakdown: {},
      );
}

/// Provider for sales filter state
final salesFilterProvider = StateProvider<SalesFilter>((ref) {
  // Default to no filters - show all orders
  return const SalesFilter();
});

/// Provider for completed orders (sales)
@riverpod
Future<List<Order>> completedOrders(Ref ref) async {
  final selectedBusiness = ref.watch(selectedBusinessProvider);
  final selectedLocation = await ref.watch(
    selectedLocationNotifierProvider.future,
  );

  if (selectedBusiness == null || selectedLocation == null) {
    return [];
  }

  try {
    final repository = await ref.watch(orderRepositoryProvider.future);
    final result = await repository.getOrders(
      businessId: selectedBusiness.id,
      locationId: selectedLocation.id,
      status: OrderStatus.completed.value,
      limit: 1000, // Get more completed orders for sales analysis
    );

    return result.fold(
      (error) {
        _logger.error('Failed to load completed orders: $error');
        return <Order>[];
      },
      (orders) {
        _logger.info('Loaded ${orders.length} completed orders for sales');
        return orders;
      },
    );
  } catch (e) {
    _logger.error('Error loading completed orders', e);
    return [];
  }
}

/// Provider for filtered sales based on current filter
final filteredSalesProvider = Provider<List<Order>>((ref) {
  final completedOrdersAsync = ref.watch(completedOrdersProvider);
  final filter = ref.watch(salesFilterProvider);

  return completedOrdersAsync.when(
    data: (orders) {
      _logger.info('Raw completed orders count: ${orders.length}');
      _logger.info('Current filter: fromDate=${filter.fromDate}, toDate=${filter.toDate}');
      var filtered = orders;

      // Apply date range filter
      if (filter.fromDate != null) {
        filtered = filtered
            .where((order) => order.orderedAt.isAfter(filter.fromDate!) || 
                             order.orderedAt.isAtSameMomentAs(filter.fromDate!))
            .toList();
      }

      if (filter.toDate != null) {
        filtered = filtered
            .where((order) => order.orderedAt.isBefore(filter.toDate!) ||
                             order.orderedAt.isAtSameMomentAs(filter.toDate!))
            .toList();
      }

      // Apply order type filter (using price category name)
      if (filter.orderType != null && filter.orderType!.isNotEmpty) {
        filtered = filtered
            .where((order) =>
                order.priceCategoryName?.toLowerCase() ==
                filter.orderType!.toLowerCase())
            .toList();
      }

      // Apply payment method filter
      if (filter.paymentMethod != null && filter.paymentMethod!.isNotEmpty) {
        filtered = filtered.where((order) {
          return order.payments.any((payment) =>
              payment.paymentMethodCode.toLowerCase() ==
              filter.paymentMethod!.toLowerCase());
        }).toList();
      }

      // Apply search query
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        filtered = filtered.where((order) {
          return order.orderNumber.toLowerCase().contains(query) ||
              order.customerName.toLowerCase().contains(query) ||
              (order.customerPhone?.toLowerCase().contains(query) ?? false) ||
              (order.tokenNumber?.toLowerCase().contains(query) ?? false);
        }).toList();
      }

      // Sort by date (newest first)
      filtered.sort((a, b) => b.orderedAt.compareTo(a.orderedAt));

      _logger.info('Filtered orders count: ${filtered.length}');
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for sales statistics
final salesStatisticsProvider = Provider<SalesStatistics>((ref) {
  final completedOrdersAsync = ref.watch(completedOrdersProvider);

  return completedOrdersAsync.when(
    data: (orders) {
      if (orders.isEmpty) {
        return SalesStatistics.empty();
      }

      // Calculate basic metrics
      final totalOrders = orders.length;
      final totalRevenue = orders.fold<double>(0, (sum, order) => sum + order.total);
      final totalTax = orders.fold<double>(0, (sum, order) => sum + order.taxAmount);
      final totalDiscounts = orders.fold<double>(0, (sum, order) => sum + order.discountAmount);
      final averageOrderValue = totalRevenue / totalOrders;

      // Order type breakdown (using price category names)
      final orderTypeBreakdown = <String, int>{};
      for (final order in orders) {
        final orderType = order.priceCategoryName ?? order.orderType.displayName;
        orderTypeBreakdown[orderType] = (orderTypeBreakdown[orderType] ?? 0) + 1;
      }

      // Payment method breakdown
      final paymentMethodBreakdown = <String, double>{};
      for (final order in orders) {
        for (final payment in order.payments) {
          final method = payment.paymentMethodName;
          paymentMethodBreakdown[method] = 
              (paymentMethodBreakdown[method] ?? 0) + payment.totalAmount;
        }
      }

      return SalesStatistics(
        totalOrders: totalOrders,
        totalRevenue: totalRevenue,
        totalTax: totalTax,
        totalDiscounts: totalDiscounts,
        averageOrderValue: averageOrderValue,
        orderTypeBreakdown: orderTypeBreakdown,
        paymentMethodBreakdown: paymentMethodBreakdown,
      );
    },
    loading: () => SalesStatistics.empty(),
    error: (_, __) => SalesStatistics.empty(),
  );
});

/// Provider for today's sales
final todaysSalesProvider = Provider<List<Order>>((ref) {
  final completedOrdersAsync = ref.watch(completedOrdersProvider);

  return completedOrdersAsync.when(
    data: (orders) {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      return orders.where((order) {
        return order.orderedAt.isAfter(startOfDay) &&
               order.orderedAt.isBefore(endOfDay);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for today's sales statistics
final todaysSalesStatisticsProvider = Provider<SalesStatistics>((ref) {
  final todaysOrders = ref.watch(todaysSalesProvider);

  if (todaysOrders.isEmpty) {
    return SalesStatistics.empty();
  }

  // Calculate today's metrics
  final totalOrders = todaysOrders.length;
  final totalRevenue = todaysOrders.fold<double>(0, (sum, order) => sum + order.total);
  final totalTax = todaysOrders.fold<double>(0, (sum, order) => sum + order.taxAmount);
  final totalDiscounts = todaysOrders.fold<double>(0, (sum, order) => sum + order.discountAmount);
  final averageOrderValue = totalRevenue / totalOrders;

  // Order type breakdown
  final orderTypeBreakdown = <String, int>{};
  for (final order in todaysOrders) {
    final orderType = order.priceCategoryName ?? order.orderType.displayName;
    orderTypeBreakdown[orderType] = (orderTypeBreakdown[orderType] ?? 0) + 1;
  }

  // Payment method breakdown
  final paymentMethodBreakdown = <String, double>{};
  for (final order in todaysOrders) {
    for (final payment in order.payments) {
      final method = payment.paymentMethodName;
      paymentMethodBreakdown[method] = 
          (paymentMethodBreakdown[method] ?? 0) + payment.totalAmount;
    }
  }

  return SalesStatistics(
    totalOrders: totalOrders,
    totalRevenue: totalRevenue,
    totalTax: totalTax,
    totalDiscounts: totalDiscounts,
    averageOrderValue: averageOrderValue,
    orderTypeBreakdown: orderTypeBreakdown,
    paymentMethodBreakdown: paymentMethodBreakdown,
  );
});