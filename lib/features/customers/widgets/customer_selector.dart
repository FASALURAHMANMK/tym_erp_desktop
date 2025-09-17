import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../business/providers/business_provider.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';
import 'quick_add_customer_dialog.dart';

class CustomerSelector extends ConsumerStatefulWidget {
  final Function(Customer?)? onCustomerSelected;
  
  const CustomerSelector({
    super.key,
    this.onCustomerSelected,
  });

  @override
  ConsumerState<CustomerSelector> createState() => _CustomerSelectorState();
}

class _CustomerSelectorState extends ConsumerState<CustomerSelector> {
  static final _logger = Logger('CustomerSelector');
  final _searchController = TextEditingController();
  bool _isSearching = false;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    
    if (selectedBusiness == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No business selected'),
        ),
      );
    }
    
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Customer',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (selectedCustomer != null && selectedCustomer.customerType != 'walk_in')
                  IconButton(
                    onPressed: () => _clearCustomer(),
                    icon: const Icon(Icons.clear),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
              ],
            ),
          ),
          
          // Customer display or search
          if (!_isSearching && selectedCustomer != null)
            _buildSelectedCustomer(selectedCustomer)
          else
            _buildCustomerSearch(selectedBusiness.id),
          
          // Actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                if (!_isSearching)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                      icon: const Icon(Icons.search, size: 16),
                      label: const Text('Search Customer'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showQuickAddDialog(context, selectedBusiness.id),
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('Quick Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSelectedCustomer(Customer customer) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer name and type
          Row(
            children: [
              Text(
                customer.displayName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              if (customer.isVip)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'VIP',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Contact info
          if (customer.phone != null || customer.whatsappNumber != null)
            Row(
              children: [
                if (customer.phone != null) ...[
                  Icon(Icons.phone, size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    customer.phone!,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                if (customer.whatsappNumber != null && customer.phone != null)
                  const SizedBox(width: 12),
                if (customer.hasWhatsApp) ...[
                  Icon(Icons.chat, size: 14, color: Colors.green[700]),
                  const SizedBox(width: 4),
                  Text(
                    customer.effectiveWhatsAppNumber!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ],
            ),
          
          // Credit info
          if (customer.creditLimit > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: customer.isOverCreditLimit 
                    ? Colors.red.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: customer.isOverCreditLimit 
                      ? Colors.red.withValues(alpha: 0.3)
                      : theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credit Limit',
                        style: theme.textTheme.labelSmall,
                      ),
                      Text(
                        '₹${customer.creditLimit.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Outstanding',
                        style: theme.textTheme.labelSmall,
                      ),
                      Text(
                        '₹${customer.currentCredit.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: customer.isOverCreditLimit ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Available',
                        style: theme.textTheme.labelSmall,
                      ),
                      Text(
                        '₹${customer.availableCredit.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          // Customer discount
          if (customer.discountPercent > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.discount, size: 14, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  'Customer Discount: ${customer.discountPercent}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildCustomerSearch(String businessId) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search by name, phone, or code...',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              setState(() {}); // Trigger rebuild for search results
            },
          ),
        ),
        
        // Search results
        if (_searchController.text.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Consumer(
              builder: (context, ref, child) {
                final searchParams = (
                  businessId: businessId,
                  query: _searchController.text,
                );
                final customersAsync = ref.watch(searchCustomersProvider(searchParams));
                
                return customersAsync.when(
                  data: (customers) {
                    if (customers.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No customers found',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        final customer = customers[index];
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                            child: Text(
                              customer.name.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(customer.displayName),
                          subtitle: Text(
                            '${customer.customerCode} • ${customer.phone ?? 'No phone'}',
                            style: theme.textTheme.bodySmall,
                          ),
                          trailing: customer.currentCredit > 0
                              ? Text(
                                  '₹${customer.currentCredit.toStringAsFixed(0)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.orange,
                                  ),
                                )
                              : null,
                          onTap: () => _selectCustomer(customer),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error: $error',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
  
  void _selectCustomer(Customer customer) {
    ref.read(selectedCustomerProvider.notifier).state = customer;
    widget.onCustomerSelected?.call(customer);
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    _logger.info('Customer selected: ${customer.displayName}');
  }
  
  void _clearCustomer() async {
    final businessId = ref.read(selectedBusinessProvider)?.id;
    if (businessId != null) {
      // Set to walk-in customer
      try {
        final walkInCustomer = await ref.read(walkInCustomerProvider(businessId).future);
        ref.read(selectedCustomerProvider.notifier).state = walkInCustomer;
        widget.onCustomerSelected?.call(walkInCustomer);
        _logger.info('Switched to walk-in customer');
      } catch (e) {
        _logger.error('Failed to get walk-in customer: $e');
      }
    }
  }
  
  void _showQuickAddDialog(BuildContext context, String businessId) {
    showDialog(
      context: context,
      builder: (context) => QuickAddCustomerDialog(
        businessId: businessId,
        onCustomerAdded: (customer) {
          _selectCustomer(customer);
        },
      ),
    );
  }
}