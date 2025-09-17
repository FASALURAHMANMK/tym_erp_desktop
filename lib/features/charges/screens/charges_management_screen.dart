import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/charge.dart';
import '../providers/charge_provider.dart';
import '../widgets/charge_form_dialog.dart';
import '../widgets/charge_list_tile.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/utils/logger.dart';

class ChargesManagementScreen extends ConsumerStatefulWidget {
  const ChargesManagementScreen({super.key});

  @override
  ConsumerState<ChargesManagementScreen> createState() => _ChargesManagementScreenState();
}

class _ChargesManagementScreenState extends ConsumerState<ChargesManagementScreen> {
  static final _logger = Logger('ChargesManagementScreen');
  final _searchController = TextEditingController();
  String _searchQuery = '';
  ChargeType? _filterType;
  bool _showInactiveCharges = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chargesAsync = ref.watch(chargesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charges Management'),
        elevation: 2,
        actions: [
          // Toggle inactive charges
          IconButton(
            onPressed: () {
              setState(() {
                _showInactiveCharges = !_showInactiveCharges;
              });
            },
            icon: Icon(
              _showInactiveCharges ? Icons.visibility : Icons.visibility_off,
            ),
            tooltip: _showInactiveCharges ? 'Hide Inactive' : 'Show Inactive',
          ),
          // Add new charge button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              onPressed: () => _showChargeFormDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Charge'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                // Search field
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search charges...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Type filter
                Expanded(
                  child: DropdownButtonFormField<ChargeType?>(
                    value: _filterType,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Types'),
                      ),
                      ...ChargeType.values.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(_getChargeTypeName(type)),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filterType = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Charges list
          Expanded(
            child: chargesAsync.when(
              data: (charges) {
                // Filter charges
                final filteredCharges = charges.where((charge) {
                  // Filter by active status
                  if (!_showInactiveCharges && !charge.isActive) {
                    return false;
                  }
                  
                  // Filter by search query
                  if (_searchQuery.isNotEmpty) {
                    final searchLower = _searchQuery.toLowerCase();
                    if (!charge.name.toLowerCase().contains(searchLower) &&
                        !charge.code.toLowerCase().contains(searchLower) &&
                        !(charge.description?.toLowerCase().contains(searchLower) ?? false)) {
                      return false;
                    }
                  }
                  
                  // Filter by type
                  if (_filterType != null && charge.chargeType != _filterType) {
                    return false;
                  }
                  
                  return true;
                }).toList();

                if (filteredCharges.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.receipt_long,
                    title: 'No Charges Found',
                    subtitle: _searchQuery.isNotEmpty || _filterType != null
                        ? 'Try adjusting your filters'
                        : 'Add your first charge to get started',
                    actionLabel: 'Add Charge',
                    onAction: () => _showChargeFormDialog(context),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredCharges.length,
                  itemBuilder: (context, index) {
                    final charge = filteredCharges[index];
                    return ChargeListTile(
                      charge: charge,
                      onTap: () => _showChargeDetails(context, charge),
                      onEdit: () => _showChargeFormDialog(context, charge: charge),
                      onToggleStatus: () => _toggleChargeStatus(charge),
                      onDelete: () => _confirmDeleteCharge(context, charge),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => ErrorStateWidget(
                error: error.toString(),
                onRetry: () => ref.invalidate(chargesNotifierProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChargeFormDialog(BuildContext context, {Charge? charge}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChargeFormDialog(
        charge: charge,
        onSave: (updatedCharge) async {
          try {
            final notifier = ref.read(chargesNotifierProvider.notifier);
            
            if (charge == null) {
              // Create new charge
              await notifier.addCharge(
                code: updatedCharge.code,
                name: updatedCharge.name,
                chargeType: updatedCharge.chargeType,
                calculationType: updatedCharge.calculationType,
                description: updatedCharge.description,
                value: updatedCharge.value,
                scope: updatedCharge.scope,
                autoApply: updatedCharge.autoApply,
                isMandatory: updatedCharge.isMandatory,
                isTaxable: updatedCharge.isTaxable,
                applyBeforeDiscount: updatedCharge.applyBeforeDiscount,
                minimumOrderValue: updatedCharge.minimumOrderValue,
                maximumOrderValue: updatedCharge.maximumOrderValue,
                validFrom: updatedCharge.validFrom,
                validUntil: updatedCharge.validUntil,
                displayOrder: updatedCharge.displayOrder,
                tiers: updatedCharge.tiers,
                formula: updatedCharge.formula,
              );
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Charge "${updatedCharge.name}" created successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              // Update existing charge
              await notifier.updateCharge(
                chargeId: charge.id,
                name: updatedCharge.name,
                chargeType: updatedCharge.chargeType,
                calculationType: updatedCharge.calculationType,
                description: updatedCharge.description,
                value: updatedCharge.value,
                scope: updatedCharge.scope,
                autoApply: updatedCharge.autoApply,
                isMandatory: updatedCharge.isMandatory,
                isTaxable: updatedCharge.isTaxable,
                applyBeforeDiscount: updatedCharge.applyBeforeDiscount,
                minimumOrderValue: updatedCharge.minimumOrderValue,
                maximumOrderValue: updatedCharge.maximumOrderValue,
                validFrom: updatedCharge.validFrom,
                validUntil: updatedCharge.validUntil,
                displayOrder: updatedCharge.displayOrder,
                isActive: updatedCharge.isActive,
                tiers: updatedCharge.tiers,
                formula: updatedCharge.formula,
              );
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Charge "${updatedCharge.name}" updated successfully'),
                    backgroundColor: Colors.blue,
                  ),
                );
              }
            }
            
            if (mounted) {
              Navigator.of(context).pop();
            }
          } catch (e) {
            _logger.error('Failed to save charge', e);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save charge: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showChargeDetails(BuildContext context, Charge charge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            _getChargeIcon(charge.chargeType),
            const SizedBox(width: 8),
            Text(charge.name),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Code', charge.code),
              _buildDetailRow('Type', _getChargeTypeName(charge.chargeType)),
              _buildDetailRow('Calculation', _getCalculationTypeName(charge.calculationType)),
              if (charge.value != null)
                _buildDetailRow(
                  'Value',
                  charge.calculationType == CalculationType.percentage
                      ? '${charge.value}%'
                      : '₹${charge.value?.toStringAsFixed(2)}',
                ),
              _buildDetailRow('Scope', charge.scope.name.toUpperCase()),
              _buildDetailRow('Auto Apply', charge.autoApply ? 'Yes' : 'No'),
              _buildDetailRow('Mandatory', charge.isMandatory ? 'Yes' : 'No'),
              _buildDetailRow('Taxable', charge.isTaxable ? 'Yes' : 'No'),
              if (charge.minimumOrderValue != null)
                _buildDetailRow('Min Order', '₹${charge.minimumOrderValue}'),
              if (charge.maximumOrderValue != null)
                _buildDetailRow('Max Order', '₹${charge.maximumOrderValue}'),
              if (charge.description != null)
                _buildDetailRow('Description', charge.description!),
              if (charge.tiers.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Tiers:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...charge.tiers.map((tier) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                    '• ${tier.tierName ?? "Tier"}: ₹${tier.minValue} - '
                    '${tier.maxValue != null ? "₹${tier.maxValue}" : "Above"} '
                    '= ₹${tier.chargeValue}',
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showChargeFormDialog(context, charge: charge);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _toggleChargeStatus(Charge charge) async {
    try {
      await ref.read(chargesNotifierProvider.notifier).toggleChargeStatus(
        charge.id,
        !charge.isActive,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Charge "${charge.name}" ${!charge.isActive ? "activated" : "deactivated"}',
            ),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to toggle charge status', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update charge: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDeleteCharge(BuildContext context, Charge charge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Charge'),
        content: Text('Are you sure you want to delete "${charge.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(chargesNotifierProvider.notifier).deleteCharge(charge.id);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Charge "${charge.name}" deleted'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                _logger.error('Failed to delete charge', e);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete charge: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getChargeTypeName(ChargeType type) {
    switch (type) {
      case ChargeType.service:
        return 'Service Charge';
      case ChargeType.delivery:
        return 'Delivery Charge';
      case ChargeType.packaging:
        return 'Packaging Charge';
      case ChargeType.convenience:
        return 'Convenience Fee';
      case ChargeType.custom:
        return 'Custom Charge';
    }
  }

  String _getCalculationTypeName(CalculationType type) {
    switch (type) {
      case CalculationType.fixed:
        return 'Fixed Amount';
      case CalculationType.percentage:
        return 'Percentage';
      case CalculationType.tiered:
        return 'Tiered';
      case CalculationType.formula:
        return 'Formula Based';
    }
  }

  Widget _getChargeIcon(ChargeType type) {
    IconData iconData;
    Color color;
    
    switch (type) {
      case ChargeType.service:
        iconData = Icons.room_service;
        color = Colors.blue;
        break;
      case ChargeType.delivery:
        iconData = Icons.delivery_dining;
        color = Colors.green;
        break;
      case ChargeType.packaging:
        iconData = Icons.inventory_2;
        color = Colors.orange;
        break;
      case ChargeType.convenience:
        iconData = Icons.account_balance_wallet;
        color = Colors.purple;
        break;
      case ChargeType.custom:
        iconData = Icons.tune;
        color = Colors.grey;
        break;
    }
    
    return Icon(iconData, color: color, size: 20);
  }
}