import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/logger.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';

class CustomerDetailsView extends ConsumerWidget {
  final Customer customer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  
  const CustomerDetailsView({
    super.key,
    required this.customer,
    required this.onEdit,
    required this.onDelete,
  });
  
  static final _logger = Logger('CustomerDetailsView');
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');
    final transactionsAsync = ref.watch(customerTransactionsProvider(customer.id));
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: customer.isVip
                    ? Colors.amber
                    : theme.colorScheme.primaryContainer,
                child: Icon(
                  customer.isVip ? Icons.star : Icons.person,
                  size: 32,
                  color: customer.isVip
                      ? Colors.white
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          customer.displayName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (customer.isVip) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'VIP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        if (customer.creditStatus == 'blocked') ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'BLOCKED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Code: ${customer.customerCode}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    Text(
                      'Type: ${customer.customerType.toUpperCase()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Customer',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
                color: Colors.red,
                tooltip: 'Delete Customer',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          
          // Contact Information
          _buildSection(
            title: 'Contact Information',
            icon: Icons.contact_phone,
            children: [
              if (customer.phone != null)
                _buildInfoRow('Phone', customer.phone!),
              if (customer.alternatePhone != null)
                _buildInfoRow('Alternate Phone', customer.alternatePhone!),
              if (customer.whatsappNumber != null)
                _buildInfoRow(
                  'WhatsApp',
                  customer.whatsappNumber!,
                  trailing: IconButton(
                    icon: const Icon(Icons.chat, size: 20),
                    color: Colors.green,
                    onPressed: () {
                      // TODO: Open WhatsApp
                      _logger.info('Opening WhatsApp: ${customer.whatsAppUrl}');
                    },
                  ),
                ),
              if (customer.email != null)
                _buildInfoRow('Email', customer.email!),
              if (customer.website != null)
                _buildInfoRow('Website', customer.website!),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Address Information
          if (customer.fullAddress.isNotEmpty) ...[
            _buildSection(
              title: 'Address',
              icon: Icons.location_on,
              children: [
                _buildInfoRow('Billing', customer.fullAddress),
                if (!customer.useBillingForShipping && customer.fullShippingAddress.isNotEmpty)
                  _buildInfoRow('Shipping', customer.fullShippingAddress),
              ],
            ),
            const SizedBox(height: 24),
          ],
          
          // Credit Information
          _buildSection(
            title: 'Credit & Financial',
            icon: Icons.account_balance_wallet,
            children: [
              _buildInfoRow(
                'Credit Status',
                customer.creditStatus.toUpperCase(),
                valueColor: _getCreditStatusColor(customer.creditStatus),
              ),
              _buildInfoRow(
                'Credit Limit',
                '₹${customer.creditLimit.toStringAsFixed(2)}',
              ),
              _buildInfoRow(
                'Current Outstanding',
                '₹${customer.currentCredit.toStringAsFixed(2)}',
                valueColor: customer.isOverCreditLimit ? Colors.red : null,
              ),
              _buildInfoRow(
                'Available Credit',
                '₹${customer.availableCredit.toStringAsFixed(2)}',
                valueColor: Colors.green,
              ),
              if (customer.paymentTerms > 0)
                _buildInfoRow(
                  'Payment Terms',
                  '${customer.paymentTerms} days',
                ),
              if (customer.discountPercent > 0)
                _buildInfoRow(
                  'Default Discount',
                  '${customer.discountPercent}%',
                  valueColor: theme.colorScheme.primary,
                ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Business Metrics
          _buildSection(
            title: 'Business Metrics',
            icon: Icons.analytics,
            children: [
              _buildInfoRow(
                'Total Purchases',
                '₹${customer.totalPurchases.toStringAsFixed(2)}',
              ),
              _buildInfoRow(
                'Total Payments',
                '₹${customer.totalPayments.toStringAsFixed(2)}',
              ),
              _buildInfoRow(
                'Purchase Count',
                customer.purchaseCount.toString(),
              ),
              _buildInfoRow(
                'Average Order Value',
                '₹${customer.averageOrderValue.toStringAsFixed(2)}',
              ),
              if (customer.firstPurchaseDate != null)
                _buildInfoRow(
                  'First Purchase',
                  dateFormat.format(customer.firstPurchaseDate!),
                ),
              if (customer.lastPurchaseDate != null)
                _buildInfoRow(
                  'Last Purchase',
                  dateFormat.format(customer.lastPurchaseDate!),
                ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Preferences
          _buildSection(
            title: 'Preferences',
            icon: Icons.settings,
            children: [
              _buildInfoRow(
                'Contact Method',
                customer.preferredContactMethod?.toUpperCase() ?? 'PHONE',
              ),
              _buildInfoRow(
                'Marketing Consent',
                customer.marketingConsent ? 'YES' : 'NO',
                valueColor: customer.marketingConsent ? Colors.green : Colors.red,
              ),
              if (customer.taxId != null)
                _buildInfoRow('Tax ID', customer.taxId!),
              if (customer.taxExempt)
                _buildInfoRow(
                  'Tax Status',
                  'EXEMPT',
                  valueColor: Colors.orange,
                ),
            ],
          ),
          
          if (customer.notes != null && customer.notes!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSection(
              title: 'Internal Notes',
              icon: Icons.note,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(customer.notes!),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          
          // Recent Transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Navigate to full transaction history
                  _logger.info('View all transactions for ${customer.name}');
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('View All'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 48,
                          color: theme.colorScheme.outline.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No transactions yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              // Take only recent 5 transactions
              final recentTransactions = transactions.take(5).toList();
              
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Table header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Type',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Description',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Transaction rows
                    ...recentTransactions.map((transaction) {
                      final isCredit = transaction.transactionType == 'credit' ||
                          transaction.transactionType == 'payment';
                      
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: theme.colorScheme.outline.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                dateFormat.format(transaction.transactionDate),
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isCredit
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  transaction.transactionType.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isCredit ? Colors.green : Colors.orange,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                transaction.description ?? transaction.referenceNumber ?? '',
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '₹${transaction.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCredit ? Colors.green : null,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Text('Error loading transactions: $error'),
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Create new sale for this customer
                    _logger.info('Creating new sale for ${customer.name}');
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('New Sale'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Add payment
                    _logger.info('Adding payment for ${customer.name}');
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Add Payment'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Print statement
                    _logger.info('Printing statement for ${customer.name}');
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Statement'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
  
  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: valueColor,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color? _getCreditStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'hold':
        return Colors.orange;
      case 'blocked':
        return Colors.red;
      default:
        return null;
    }
  }
}