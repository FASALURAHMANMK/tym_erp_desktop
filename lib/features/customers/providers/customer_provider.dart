import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../models/customer.dart';
import '../models/customer_group.dart';
import '../models/customer_transaction.dart';
import '../repositories/customer_repository.dart';

part 'customer_provider.g.dart';

// Logger instance
final _logger = Logger('CustomerProvider');

// Customer repository provider
@riverpod
Future<CustomerRepository> customerRepository(Ref ref) async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;
  
  final repository = CustomerRepository(
    localDatabase: database,
    supabase: Supabase.instance.client,
    syncQueueService: SyncQueueService(),
  );
  
  // Initialize tables
  await repository.initializeLocalTables();
  
  return repository;
}

// Initialize customer tables
final initializeCustomerTablesProvider = FutureProvider<void>((ref) async {
  await ref.watch(customerRepositoryProvider.future);
  _logger.info('Customer tables initialized');
});

// Customers list provider with search and filtering
final customersProvider = FutureProvider.family<List<Customer>, String>(
  (ref, businessId) async {
    final repository = await ref.watch(customerRepositoryProvider.future);
    
    final result = await repository.getCustomers(
      businessId: businessId,
      activeOnly: true,
    );
    
    return result.fold(
      (error) {
        _logger.error('Failed to load customers: $error');
        throw Exception(error);
      },
      (customers) => customers,
    );
  },
);

// Search customers provider
final searchCustomersProvider = FutureProvider.family<List<Customer>, ({String businessId, String query})>(
  (ref, params) async {
    if (params.query.isEmpty) {
      return ref.watch(customersProvider(params.businessId)).value ?? [];
    }
    
    final repository = await ref.watch(customerRepositoryProvider.future);
    
    final result = await repository.getCustomers(
      businessId: params.businessId,
      activeOnly: true,
      searchQuery: params.query,
    );
    
    return result.fold(
      (error) {
        _logger.error('Failed to search customers: $error');
        throw Exception(error);
      },
      (customers) => customers,
    );
  },
);

// Walk-in customer provider
final walkInCustomerProvider = FutureProvider.family<Customer, String>(
  (ref, businessId) async {
    final repository = await ref.watch(customerRepositoryProvider.future);
    
    final result = await repository.ensureWalkInCustomer(
      businessId: businessId,
    );
    
    return result.fold(
      (error) {
        _logger.error('Failed to get walk-in customer: $error');
        throw Exception(error);
      },
      (customer) => customer,
    );
  },
);

// Customer groups provider
final customerGroupsProvider = FutureProvider.family<List<CustomerGroup>, String>(
  (ref, businessId) async {
    final repository = await ref.watch(customerRepositoryProvider.future);
    
    final result = await repository.getCustomerGroups(
      businessId: businessId,
    );
    
    return result.fold(
      (error) {
        _logger.error('Failed to load customer groups: $error');
        throw Exception(error);
      },
      (groups) => groups,
    );
  },
);

// Customer transactions provider
final customerTransactionsProvider = FutureProvider.family<List<CustomerTransaction>, String>(
  (ref, customerId) async {
    final repository = await ref.watch(customerRepositoryProvider.future);
    
    final result = await repository.getCustomerTransactions(
      customerId: customerId,
    );
    
    return result.fold(
      (error) {
        _logger.error('Failed to load customer transactions: $error');
        throw Exception(error);
      },
      (transactions) => transactions,
    );
  },
);

// Selected customer state provider
final selectedCustomerProvider = StateProvider<Customer?>((ref) => null);

// Customer management notifier
class CustomerNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  CustomerNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> addCustomer(Customer customer) async {
    state = const AsyncValue.loading();
    
    final repository = await _ref.read(customerRepositoryProvider.future);
    final result = await repository.addCustomer(customer: customer);
    
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
        _logger.error('Failed to add customer: $error');
      },
      (newCustomer) {
        state = const AsyncValue.data(null);
        // Invalidate customers list to refresh
        final businessId = customer.businessId;
        _ref.invalidate(customersProvider(businessId));
        _logger.info('Customer added successfully: ${newCustomer.name}');
      },
    );
  }

  Future<void> updateCustomer(Customer customer) async {
    state = const AsyncValue.loading();
    
    final repository = await _ref.read(customerRepositoryProvider.future);
    final result = await repository.updateCustomer(customer: customer);
    
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
        _logger.error('Failed to update customer: $error');
      },
      (updatedCustomer) {
        state = const AsyncValue.data(null);
        // Update selected customer if it's the same
        final selectedCustomer = _ref.read(selectedCustomerProvider);
        if (selectedCustomer?.id == updatedCustomer.id) {
          _ref.read(selectedCustomerProvider.notifier).state = updatedCustomer;
        }
        // Invalidate customers list to refresh
        _ref.invalidate(customersProvider(customer.businessId));
        _logger.info('Customer updated successfully: ${updatedCustomer.name}');
      },
    );
  }

  Future<void> addTransaction({
    required CustomerTransaction transaction,
    required String customerId,
  }) async {
    state = const AsyncValue.loading();
    
    final repository = await _ref.read(customerRepositoryProvider.future);
    final result = await repository.addTransaction(
      transaction: transaction,
      customerId: customerId,
    );
    
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
        _logger.error('Failed to add transaction: $error');
      },
      (newTransaction) {
        state = const AsyncValue.data(null);
        // Invalidate transactions list to refresh
        _ref.invalidate(customerTransactionsProvider(customerId));
        // Also invalidate customer to refresh credit balance
        final customer = _ref.read(selectedCustomerProvider);
        if (customer != null) {
          _ref.invalidate(customersProvider(customer.businessId));
        }
        _logger.info('Transaction added successfully: ${newTransaction.transactionType}');
      },
    );
  }

  Future<bool> canMakeCreditPurchase({
    required String customerId,
    required double purchaseAmount,
  }) async {
    final repository = await _ref.read(customerRepositoryProvider.future);
    final result = await repository.canMakeCreditPurchase(
      customerId: customerId,
      purchaseAmount: purchaseAmount,
    );
    
    return result.fold(
      (error) {
        _logger.error('Failed to check credit eligibility: $error');
        return false;
      },
      (canPurchase) => canPurchase,
    );
  }
}

// Customer notifier provider
final customerNotifierProvider = StateNotifierProvider<CustomerNotifier, AsyncValue<void>>((ref) {
  return CustomerNotifier(ref);
});

// Customer statistics provider
final customerStatisticsProvider = Provider.family<CustomerStatistics, Customer>(
  (ref, customer) {
    return CustomerStatistics(
      totalCustomers: 1, // This would be calculated from all customers
      activeCustomers: customer.isActive ? 1 : 0,
      totalCredit: customer.currentCredit,
      overdueAmount: customer.isOverCreditLimit ? customer.currentCredit - customer.creditLimit : 0,
      averageOrderValue: customer.averageOrderValue,
      totalRevenue: customer.totalPurchases,
    );
  },
);

// Customer statistics model
class CustomerStatistics {
  final int totalCustomers;
  final int activeCustomers;
  final double totalCredit;
  final double overdueAmount;
  final double averageOrderValue;
  final double totalRevenue;

  CustomerStatistics({
    required this.totalCustomers,
    required this.activeCustomers,
    required this.totalCredit,
    required this.overdueAmount,
    required this.averageOrderValue,
    required this.totalRevenue,
  });
}

// Quick customer add provider for POS
final quickAddCustomerProvider = FutureProvider.family<Customer, QuickCustomerData>(
  (ref, data) async {
    final repository = await ref.watch(customerRepositoryProvider.future);
    
    // Generate customer code
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final customerCode = 'CUST-${timestamp.substring(timestamp.length - 8)}';
    
    final customer = Customer(
      id: '', // Will be set by repository
      businessId: data.businessId,
      customerCode: customerCode,
      name: data.name,
      phone: data.phone,
      whatsappNumber: data.whatsapp ?? data.phone,
      email: data.email,
      customerType: 'individual',
      creditLimit: 0,
      paymentTerms: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final result = await repository.addCustomer(customer: customer);
    
    return result.fold(
      (error) {
        _logger.error('Failed to quick add customer: $error');
        throw Exception(error);
      },
      (newCustomer) {
        // Set as selected customer
        ref.read(selectedCustomerProvider.notifier).state = newCustomer;
        // Invalidate customers list
        ref.invalidate(customersProvider(data.businessId));
        return newCustomer;
      },
    );
  },
);

// Quick customer data model
class QuickCustomerData {
  final String businessId;
  final String name;
  final String phone;
  final String? whatsapp;
  final String? email;

  QuickCustomerData({
    required this.businessId,
    required this.name,
    required this.phone,
    this.whatsapp,
    this.email,
  });
}

// Customer filter state
class CustomerFilter {
  final String? groupId;
  final String? creditStatus;
  final bool? hasOutstanding;
  final bool? isVip;
  final String? searchQuery;

  CustomerFilter({
    this.groupId,
    this.creditStatus,
    this.hasOutstanding,
    this.isVip,
    this.searchQuery,
  });

  CustomerFilter copyWith({
    String? groupId,
    String? creditStatus,
    bool? hasOutstanding,
    bool? isVip,
    String? searchQuery,
  }) {
    return CustomerFilter(
      groupId: groupId ?? this.groupId,
      creditStatus: creditStatus ?? this.creditStatus,
      hasOutstanding: hasOutstanding ?? this.hasOutstanding,
      isVip: isVip ?? this.isVip,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Customer filter provider
final customerFilterProvider = StateProvider<CustomerFilter>((ref) {
  return CustomerFilter();
});

// Filtered customers provider
final filteredCustomersProvider = Provider.family<List<Customer>, String>(
  (ref, businessId) {
    final customersAsync = ref.watch(customersProvider(businessId));
    final filter = ref.watch(customerFilterProvider);
    
    return customersAsync.when(
      data: (customers) {
        var filtered = customers;
        
        // Apply group filter
        if (filter.groupId != null) {
          filtered = filtered.where((c) => c.groupId == filter.groupId).toList();
        }
        
        // Apply credit status filter
        if (filter.creditStatus != null) {
          filtered = filtered.where((c) => c.creditStatus == filter.creditStatus).toList();
        }
        
        // Apply outstanding filter
        if (filter.hasOutstanding == true) {
          filtered = filtered.where((c) => c.currentCredit > 0).toList();
        }
        
        // Apply VIP filter
        if (filter.isVip == true) {
          filtered = filtered.where((c) => c.isVip).toList();
        }
        
        // Apply search query
        if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
          final query = filter.searchQuery!.toLowerCase();
          filtered = filtered.where((c) =>
            c.name.toLowerCase().contains(query) ||
            c.customerCode.toLowerCase().contains(query) ||
            (c.phone?.toLowerCase().contains(query) ?? false) ||
            (c.email?.toLowerCase().contains(query) ?? false) ||
            (c.companyName?.toLowerCase().contains(query) ?? false)
          ).toList();
        }
        
        return filtered;
      },
      loading: () => [],
      error: (_, __) => [],
    );
  },
);