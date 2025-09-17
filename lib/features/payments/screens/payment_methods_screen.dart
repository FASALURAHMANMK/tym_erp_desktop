import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../models/payment_method.dart';
import '../providers/payment_method_provider.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  static final _logger = Logger('PaymentMethodsScreen');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(paymentMethodsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: paymentMethodsAsync.when(
        data: (methods) {
          if (methods.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No payment methods found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPaymentMethodDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Payment Method'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: methods.length,
            itemBuilder: (context, index) {
              final method = methods[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: method.isActive
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      _getIconData(method.displayIcon),
                      color: method.isActive
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(method.name),
                      if (method.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code: ${method.code}'),
                      if (method.requiresReference)
                        Text(
                          'Requires reference number',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      if (method.requiresApproval)
                        Text(
                          'Requires approval',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange,
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: method.isActive,
                        onChanged: (value) {
                          ref
                              .read(paymentMethodsProvider.notifier)
                              .togglePaymentMethodStatus(method.id, value);
                        },
                      ),
                      if (!method.isDefault)
                        PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditPaymentMethodDialog(context, method);
                            } else if (value == 'delete') {
                              _confirmDelete(context, method);
                            }
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          _logger.error('Failed to load payment methods', error, stack);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load payment methods: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(paymentMethodsProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPaymentMethodDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getIconData(String icon) {
    switch (icon) {
      case 'cash':
        return Icons.payments;
      case 'credit_card':
        return Icons.credit_card;
      case 'account_balance':
        return Icons.account_balance;
      case 'receipt':
        return Icons.receipt;
      case 'smartphone':
        return Icons.smartphone;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'wallet':
        return Icons.wallet;
      default:
        return Icons.payment;
    }
  }

  void _showAddPaymentMethodDialog(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    String selectedIcon = 'payment';
    bool requiresReference = false;
    bool requiresApproval = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Payment Method'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g., UPI, PayPal, Bank Transfer',
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Code',
                      hintText: 'e.g., upi, paypal, bank_transfer',
                      helperText: 'Unique identifier (lowercase, no spaces)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Icon selector
                  DropdownButtonFormField<String>(
                    value: selectedIcon,
                    decoration: const InputDecoration(
                      labelText: 'Icon',
                    ),
                    items: [
                      'payment',
                      'smartphone',
                      'wallet',
                      'account_balance_wallet',
                      'credit_card',
                      'cash',
                    ].map((icon) {
                      return DropdownMenuItem(
                        value: icon,
                        child: Row(
                          children: [
                            Icon(_getIconData(icon)),
                            const SizedBox(width: 8),
                            Text(icon.replaceAll('_', ' ').toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedIcon = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Requires Reference Number'),
                    subtitle: const Text('e.g., Transaction ID, Cheque No.'),
                    value: requiresReference,
                    onChanged: (value) {
                      setState(() {
                        requiresReference = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Requires Approval'),
                    subtitle: const Text('Manager approval needed'),
                    value: requiresApproval,
                    onChanged: (value) {
                      setState(() {
                        requiresApproval = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final code = codeController.text.trim().toLowerCase().replaceAll(' ', '_');

                if (name.isEmpty || code.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  await ref.read(paymentMethodsProvider.notifier).addPaymentMethod(
                    name: name,
                    code: code,
                    icon: selectedIcon,
                    requiresReference: requiresReference,
                    requiresApproval: requiresApproval,
                  );

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Payment method "$name" added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  _logger.error('Failed to add payment method', e);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add payment method: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPaymentMethodDialog(BuildContext context, PaymentMethod method) {
    final nameController = TextEditingController(text: method.name);
    String selectedIcon = method.icon ?? 'payment';
    bool requiresReference = method.requiresReference;
    bool requiresApproval = method.requiresApproval;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Payment Method'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Code',
                      hintText: method.code,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedIcon,
                    decoration: const InputDecoration(
                      labelText: 'Icon',
                    ),
                    items: [
                      'payment',
                      'smartphone',
                      'wallet',
                      'account_balance_wallet',
                      'credit_card',
                      'cash',
                    ].map((icon) {
                      return DropdownMenuItem(
                        value: icon,
                        child: Row(
                          children: [
                            Icon(_getIconData(icon)),
                            const SizedBox(width: 8),
                            Text(icon.replaceAll('_', ' ').toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedIcon = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Requires Reference Number'),
                    value: requiresReference,
                    onChanged: (value) {
                      setState(() {
                        requiresReference = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Requires Approval'),
                    value: requiresApproval,
                    onChanged: (value) {
                      setState(() {
                        requiresApproval = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name cannot be empty'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  await ref.read(paymentMethodsProvider.notifier).updatePaymentMethod(
                    methodId: method.id,
                    name: name,
                    icon: selectedIcon,
                    requiresReference: requiresReference,
                    requiresApproval: requiresApproval,
                  );

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment method updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  _logger.error('Failed to update payment method', e);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text('Are you sure you want to delete "${method.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                await ref.read(paymentMethodsProvider.notifier).deletePaymentMethod(method.id);
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment method deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                _logger.error('Failed to delete payment method', e);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}