import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tax_config.dart';
import '../providers/tax_provider.dart';
import '../../../core/utils/logger.dart';

class TaxManagementScreen extends ConsumerStatefulWidget {
  const TaxManagementScreen({super.key});

  @override
  ConsumerState<TaxManagementScreen> createState() => _TaxManagementScreenState();
}

class _TaxManagementScreenState extends ConsumerState<TaxManagementScreen> {
  static final _logger = Logger('TaxManagementScreen');
  TaxGroup? _selectedGroup;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taxGroupsAsync = ref.watch(taxGroupsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Management'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(taxGroupsProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: taxGroupsAsync.when(
        data: (taxGroups) {
          // Select first group if none selected
          if (_selectedGroup == null && taxGroups.isNotEmpty) {
            _selectedGroup = taxGroups.first;
          }
          
          return Row(
            children: [
              // Left sidebar - Tax Groups
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  border: Border(
                    right: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Tax Groups header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax Groups',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (taxGroups.isEmpty)
                                TextButton.icon(
                                  onPressed: () => _createDefaultTaxGroups(),
                                  icon: const Icon(Icons.auto_awesome, size: 16),
                                  label: const Text('Create Defaults'),
                                ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _showAddTaxGroupDialog(context),
                                tooltip: 'Add Tax Group',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Tax Groups list
                    Expanded(
                      child: taxGroups.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 64,
                                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No tax groups yet',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _createDefaultTaxGroups(),
                                    icon: const Icon(Icons.auto_awesome),
                                    label: const Text('Create Default Tax Groups'),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: taxGroups.length,
                              itemBuilder: (context, index) {
                                final group = taxGroups[index];
                                return _buildTaxGroupTile(context, group);
                              },
                            ),
                    ),
                  ],
                ),
              ),
              
              // Right side - Tax Rates
              Expanded(
                child: _selectedGroup == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select a tax group to view rates',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          // Tax Rates header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              border: Border(
                                bottom: BorderSide(
                                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedGroup!.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (_selectedGroup!.description != null)
                                      Text(
                                        _selectedGroup!.description!,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                  ],
                                ),
                                const Spacer(),
                                ElevatedButton.icon(
                                  onPressed: () => _showAddTaxRateDialog(context, _selectedGroup!),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Tax Rate'),
                                ),
                              ],
                            ),
                          ),
                          
                          // Tax Rates table
                          Expanded(
                            child: _selectedGroup!.taxRates.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.percent,
                                          size: 48,
                                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No tax rates in this group',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton.icon(
                                          onPressed: () => _showAddTaxRateDialog(context, _selectedGroup!),
                                          icon: const Icon(Icons.add),
                                          label: const Text('Add First Tax Rate'),
                                        ),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                        columns: const [
                                          DataColumn(label: Text('Name')),
                                          DataColumn(label: Text('Rate')),
                                          DataColumn(label: Text('Type')),
                                          DataColumn(label: Text('Method')),
                                          DataColumn(label: Text('Status')),
                                          DataColumn(label: Text('Actions')),
                                        ],
                                        rows: _selectedGroup!.taxRates.map((rate) {
                                          return _buildTaxRateRow(rate);
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading tax groups: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(taxGroupsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTaxGroupTile(BuildContext context, TaxGroup group) {
    final theme = Theme.of(context);
    final isSelected = _selectedGroup?.id == group.id;
    
    return ListTile(
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      onTap: () {
        setState(() {
          _selectedGroup = group;
        });
      },
      title: Row(
        children: [
          Text(group.name),
          if (group.isDefault) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'DEFAULT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (group.description != null)
            Text(
              group.description!,
              style: theme.textTheme.bodySmall,
            ),
          Text(
            '${group.taxRates.length} tax rate${group.taxRates.length == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      trailing: group.isActive
          ? Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 20,
            )
          : Icon(
              Icons.cancel,
              color: theme.colorScheme.error,
              size: 20,
            ),
    );
  }
  
  DataRow _buildTaxRateRow(TaxRate rate) {
    return DataRow(
      cells: [
        DataCell(Text(rate.name)),
        DataCell(Text(rate.type == TaxType.percentage ? '${rate.rate}%' : '₹${rate.rate}')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: rate.type == TaxType.percentage
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              rate.type == TaxType.percentage ? 'Percentage' : 'Fixed',
              style: TextStyle(
                color: rate.type == TaxType.percentage ? Colors.blue : Colors.orange,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: rate.calculationMethod == TaxCalculationMethod.exclusive
                  ? Colors.purple.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              rate.calculationMethod == TaxCalculationMethod.exclusive ? 'Exclusive' : 'Inclusive',
              style: TextStyle(
                color: rate.calculationMethod == TaxCalculationMethod.exclusive
                    ? Colors.purple
                    : Colors.green,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Switch(
            value: rate.isActive,
            onChanged: (value) {
              // TODO: Toggle active status
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _showEditTaxRateDialog(context, rate),
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () => _confirmDeleteTaxRate(context, rate),
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Create default tax groups
  Future<void> _createDefaultTaxGroups() async {
    try {
      await ref.read(taxGroupsProvider.notifier).createDefaultTaxGroups();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Default tax groups created successfully')),
        );
      }
    } catch (e) {
      _logger.error('Failed to create default tax groups', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create default tax groups: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Show add tax group dialog
  void _showAddTaxGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isDefault = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Tax Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name *',
                  hintText: 'e.g., GST, VAT',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Goods and Services Tax',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Set as default'),
                value: isDefault,
                onChanged: (value) {
                  setState(() {
                    isDefault = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a group name')),
                  );
                  return;
                }
                
                try {
                  await ref.read(taxGroupsProvider.notifier).addTaxGroup(
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim().isEmpty
                        ? null
                        : descriptionController.text.trim(),
                    isDefault: isDefault,
                  );
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tax group added successfully')),
                    );
                  }
                } catch (e) {
                  _logger.error('Failed to add tax group', e);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add tax group: $e'),
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
  
  // Show add tax rate dialog
  void _showAddTaxRateDialog(BuildContext context, TaxGroup group) {
    final nameController = TextEditingController();
    final rateController = TextEditingController();
    TaxType type = TaxType.percentage;
    TaxCalculationMethod method = TaxCalculationMethod.exclusive;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Tax Rate to ${group.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Rate Name *',
                  hintText: 'e.g., CGST, SGST, IGST',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rateController,
                decoration: InputDecoration(
                  labelText: 'Rate Value *',
                  hintText: type == TaxType.percentage ? 'e.g., 9' : 'e.g., 100',
                  suffixText: type == TaxType.percentage ? '%' : '₹',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Type: '),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RadioListTile<TaxType>(
                      title: const Text('Percentage'),
                      value: TaxType.percentage,
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<TaxType>(
                      title: const Text('Fixed'),
                      value: TaxType.fixed,
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Method: '),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RadioListTile<TaxCalculationMethod>(
                      title: const Text('Exclusive'),
                      value: TaxCalculationMethod.exclusive,
                      groupValue: method,
                      onChanged: (value) {
                        setState(() {
                          method = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<TaxCalculationMethod>(
                      title: const Text('Inclusive'),
                      value: TaxCalculationMethod.inclusive,
                      groupValue: method,
                      onChanged: (value) {
                        setState(() {
                          method = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a rate name')),
                  );
                  return;
                }
                
                final rate = double.tryParse(rateController.text);
                if (rate == null || rate < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid rate')),
                  );
                  return;
                }
                
                try {
                  await ref.read(taxGroupsProvider.notifier).addTaxRate(
                    taxGroupId: group.id,
                    name: nameController.text.trim(),
                    rate: rate,
                    type: type,
                    calculationMethod: method,
                  );
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tax rate added successfully')),
                    );
                  }
                } catch (e) {
                  _logger.error('Failed to add tax rate', e);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add tax rate: $e'),
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
  
  // Show edit tax rate dialog
  void _showEditTaxRateDialog(BuildContext context, TaxRate rate) {
    // TODO: Implement edit functionality
    _logger.info('Edit tax rate: ${rate.name}');
  }
  
  // Confirm delete tax rate
  void _confirmDeleteTaxRate(BuildContext context, TaxRate rate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tax Rate'),
        content: Text('Are you sure you want to delete "${rate.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement delete functionality
              Navigator.of(context).pop();
              _logger.info('Delete tax rate: ${rate.name}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}