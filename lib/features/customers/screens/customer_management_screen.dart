import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../business/providers/business_provider.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_form_dialog.dart';
import '../widgets/customer_details_view.dart';

class CustomerManagementScreen extends ConsumerStatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  ConsumerState<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends ConsumerState<CustomerManagementScreen> {
  static final _logger = Logger('CustomerManagementScreen');
  
  final TextEditingController _searchController = TextEditingController();
  Customer? _selectedCustomer;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CustomerFormDialog(),
    ).then((result) {
      if (result != null && result is Customer) {
        setState(() {
          _selectedCustomer = result;
        });
      }
    });
  }
  
  void _showEditCustomerDialog(Customer customer) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomerFormDialog(customer: customer),
    ).then((result) {
      if (result != null && result is Customer) {
        setState(() {
          _selectedCustomer = result;
        });
      }
    });
  }
  
  void _deleteCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text('Are you sure you want to delete ${customer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Mark customer as inactive instead of deleting
              final updatedCustomer = customer.copyWith(
                isActive: false,
                updatedAt: DateTime.now(),
              );
              
              await ref.read(customerNotifierProvider.notifier)
                  .updateCustomer(updatedCustomer);
              
              setState(() {
                if (_selectedCustomer?.id == customer.id) {
                  _selectedCustomer = null;
                }
              });
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${customer.name} has been deleted'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    
    if (selectedBusiness == null) {
      return const Center(
        child: Text('Please select a business first'),
      );
    }
    
    final customersAsync = ref.watch(
      _searchController.text.isEmpty
          ? customersProvider(selectedBusiness.id)
          : searchCustomersProvider((
              businessId: selectedBusiness.id,
              query: _searchController.text,
            )),
    );
    
    final filter = ref.watch(customerFilterProvider);
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer Management',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddCustomerDialog,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Customer'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Search and filters
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, phone, email, or code...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 16),
                
                // Filter buttons
                SegmentedButton<String?>(
                  segments: const [
                    ButtonSegment(
                      value: null,
                      label: Text('All'),
                      icon: Icon(Icons.people),
                    ),
                    ButtonSegment(
                      value: 'active',
                      label: Text('Active'),
                      icon: Icon(Icons.check_circle),
                    ),
                    ButtonSegment(
                      value: 'blocked',
                      label: Text('Blocked'),
                      icon: Icon(Icons.block),
                    ),
                    ButtonSegment(
                      value: 'vip',
                      label: Text('VIP'),
                      icon: Icon(Icons.star),
                    ),
                  ],
                  selected: {filter.creditStatus},
                  onSelectionChanged: (value) {
                    ref.read(customerFilterProvider.notifier).state = filter.copyWith(
                      creditStatus: value.first,
                    );
                  },
                ),
                
                const SizedBox(width: 16),
                
                // More filters dropdown
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'More filters',
                  itemBuilder: (context) => [
                    CheckedPopupMenuItem(
                      value: 'has_outstanding',
                      checked: filter.hasOutstanding == true,
                      child: const Text('Has Outstanding'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'is_vip',
                      checked: filter.isVip == true,
                      child: const Text('VIP Only'),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'has_outstanding':
                        ref.read(customerFilterProvider.notifier).state = filter.copyWith(
                          hasOutstanding: filter.hasOutstanding != true ? true : null,
                        );
                        break;
                      case 'is_vip':
                        ref.read(customerFilterProvider.notifier).state = filter.copyWith(
                          isVip: filter.isVip != true ? true : null,
                        );
                        break;
                    }
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Content area
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer list
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Column(
                        children: [
                          // List header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              border: Border(
                                bottom: BorderSide(
                                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Customer',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Contact',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Credit',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                const SizedBox(width: 48), // Space for actions
                              ],
                            ),
                          ),
                          
                          // Customer list
                          Expanded(
                            child: customersAsync.when(
                              data: (customers) {
                                // Apply filters
                                final filteredCustomers = ref.watch(
                                  filteredCustomersProvider(selectedBusiness.id),
                                );
                                
                                if (filteredCustomers.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          size: 64,
                                          color: theme.colorScheme.outline.withValues(alpha: 0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          _searchController.text.isNotEmpty
                                              ? 'No customers found'
                                              : 'No customers yet',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            color: theme.colorScheme.outline,
                                          ),
                                        ),
                                        if (_searchController.text.isEmpty) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            'Add your first customer to get started',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: theme.colorScheme.outline,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                }
                                
                                return ListView.builder(
                                  itemCount: filteredCustomers.length,
                                  itemBuilder: (context, index) {
                                    final customer = filteredCustomers[index];
                                    final isSelected = _selectedCustomer?.id == customer.id;
                                    
                                    // Skip walk-in customer from list
                                    if (customer.customerType == 'walk_in') {
                                      return const SizedBox.shrink();
                                    }
                                    
                                    return ListTile(
                                      selected: isSelected,
                                      onTap: () {
                                        setState(() {
                                          _selectedCustomer = customer;
                                        });
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: customer.isVip
                                            ? Colors.amber
                                            : theme.colorScheme.primaryContainer,
                                        child: Icon(
                                          customer.isVip ? Icons.star : Icons.person,
                                          color: customer.isVip
                                              ? Colors.white
                                              : theme.colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  customer.displayName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  customer.customerCode,
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: theme.colorScheme.outline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (customer.phone != null)
                                                  Text(
                                                    customer.phone!,
                                                    style: theme.textTheme.bodySmall,
                                                  ),
                                                if (customer.email != null)
                                                  Text(
                                                    customer.email!,
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: theme.colorScheme.outline,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                if (customer.currentCredit > 0)
                                                  Text(
                                                    '₹${customer.currentCredit.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: customer.isOverCreditLimit
                                                          ? Colors.red
                                                          : null,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                if (customer.creditLimit > 0)
                                                  Text(
                                                    'Limit: ₹${customer.creditLimit.toStringAsFixed(0)}',
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: theme.colorScheme.outline,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (customer.hasWhatsApp)
                                            IconButton(
                                              icon: const Icon(Icons.chat, size: 20),
                                              color: Colors.green,
                                              onPressed: () {
                                                // TODO: Open WhatsApp
                                                _logger.info('Opening WhatsApp for ${customer.name}');
                                              },
                                            ),
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 20),
                                            onPressed: () => _showEditCustomerDialog(customer),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, size: 20),
                                            color: Colors.red,
                                            onPressed: () => _deleteCustomer(customer),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (error, _) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Error: $error'),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref.invalidate(customersProvider(selectedBusiness.id));
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Customer details
                  Expanded(
                    flex: 3,
                    child: Card(
                      child: _selectedCustomer != null
                          ? CustomerDetailsView(
                              customer: _selectedCustomer!,
                              onEdit: () => _showEditCustomerDialog(_selectedCustomer!),
                              onDelete: () => _deleteCustomer(_selectedCustomer!),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 64,
                                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Select a customer to view details',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Statistics footer
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: customersAsync.when(
                data: (customers) {
                  final totalCustomers = customers.where((c) => c.customerType != 'walk_in').length;
                  final totalCredit = customers.fold<double>(
                    0,
                    (sum, c) => sum + c.currentCredit,
                  );
                  final vipCount = customers.where((c) => c.isVip).length;
                  final blockedCount = customers.where((c) => c.creditStatus == 'blocked').length;
                  
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Total Customers',
                        totalCustomers.toString(),
                        Icons.people,
                        theme.colorScheme.primary,
                      ),
                      _buildStatCard(
                        'Total Outstanding',
                        '₹${totalCredit.toStringAsFixed(2)}',
                        Icons.account_balance_wallet,
                        Colors.orange,
                      ),
                      _buildStatCard(
                        'VIP Customers',
                        vipCount.toString(),
                        Icons.star,
                        Colors.amber,
                      ),
                      _buildStatCard(
                        'Blocked',
                        blockedCount.toString(),
                        Icons.block,
                        Colors.red,
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}