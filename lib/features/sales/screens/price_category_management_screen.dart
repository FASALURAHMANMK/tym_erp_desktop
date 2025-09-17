import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/utils/logger.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';
import '../models/price_category.dart';
import '../providers/price_category_provider.dart';

class PriceCategoryManagementScreen extends ConsumerStatefulWidget {
  const PriceCategoryManagementScreen({super.key});

  @override
  ConsumerState<PriceCategoryManagementScreen> createState() => 
      _PriceCategoryManagementScreenState();
}

class _PriceCategoryManagementScreenState 
    extends ConsumerState<PriceCategoryManagementScreen> {
  static final _logger = Logger('PriceCategoryManagementScreen');

  @override
  Widget build(BuildContext context) {
    final business = ref.watch(selectedBusinessProvider);
    final selectedLocationAsync = ref.watch(selectedLocationNotifierProvider);
    
    return selectedLocationAsync.when(
      data: (selectedLocation) {
        if (business == null || selectedLocation == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Price Category Management'),
            ),
            body: const Center(
              child: Text('Please select a business and location'),
            ),
          );
        }

        final priceCategoriesAsync = ref.watch(
          priceCategoriesProvider((business.id, selectedLocation.id)),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Category Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Use canPop to check if we can pop, otherwise use go
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/erp/sales');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
            tooltip: 'Help',
          ),
        ],
      ),
      body: priceCategoriesAsync.when(
        data: (categories) => _buildBody(categories),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading price categories: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(priceCategoriesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomCategoryDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Custom Category'),
      ),
    );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Price Category Management'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Price Category Management'),
        ),
        body: Center(
          child: Text('Error loading location: $error'),
        ),
      ),
    );
  }

  Widget _buildBody(List<PriceCategory> categories) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No price categories found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Price categories are created automatically with each location',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Separate default and custom categories
    final defaultCategories = categories.where((c) => c.isDefault).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    final customCategories = categories.where((c) => !c.isDefault).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveDimensions.getContentPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info card
          _buildInfoCard(),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          
          // Default categories section
          _buildSectionHeader('Default Categories', Icons.lock_outline),
          const SizedBox(height: 16),
          _buildCategoriesGrid(defaultCategories, isDefault: true),
          
          if (customCategories.isNotEmpty) ...[
            ResponsiveSpacing.getVerticalSpacing(context, 32),
            _buildSectionHeader('Custom Categories', Icons.star),
            const SizedBox(height: 16),
            _buildCategoriesGrid(customCategories, isDefault: false),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Price Categories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price categories allow you to set different prices for the same product based on the type of service (Dine-In, Parcel, Delivery, etc.). '
                    'Default categories cannot be deleted but can be hidden from the sell screen.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(List<PriceCategory> categories, {required bool isDefault}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200 ? 4 :
                              constraints.maxWidth > 800 ? 3 :
                              constraints.maxWidth > 500 ? 2 : 1;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(categories[index], isDefault);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(PriceCategory category, bool isDefault) {
    final color = _getCategoryColor(category);
    
    return Card(
      elevation: category.isVisible ? 2 : 0,
      color: category.isVisible 
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: InkWell(
        onTap: isDefault ? null : () => _showEditCategoryDialog(category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(category),
                      color: color,
                      size: 24,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) => _handleCategoryAction(value, category),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'toggle_visibility',
                        child: Row(
                          children: [
                            Icon(
                              category.isVisible 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(category.isVisible ? 'Hide' : 'Show'),
                          ],
                        ),
                      ),
                      if (!isDefault) ...[
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: category.isVisible ? null : TextDecoration.lineThrough,
                ),
              ),
              if (category.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  category.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  if (category.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'DEFAULT',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Icon(
                    category.isVisible ? Icons.visibility : Icons.visibility_off,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(PriceCategory category) {
    // Try to parse custom icon if provided
    if (category.iconName != null) {
      // You could implement a mapping of icon names to IconData here
    }
    
    switch (category.type) {
      case PriceCategoryType.dineIn:
        return Icons.restaurant;
      case PriceCategoryType.takeaway:
        return Icons.takeout_dining;
      case PriceCategoryType.delivery:
        return Icons.delivery_dining;
      case PriceCategoryType.catering:
        return Icons.celebration;
      case PriceCategoryType.custom:
        return Icons.star;
    }
  }

  Color _getCategoryColor(PriceCategory category) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (category.colorHex != null) {
      try {
        return Color(int.parse(category.colorHex!.replaceAll('#', '0xFF')));
      } catch (_) {
        // Fall through to default colors
      }
    }
    
    switch (category.type) {
      case PriceCategoryType.dineIn:
        return colorScheme.primary;
      case PriceCategoryType.takeaway:
        return Colors.orange;
      case PriceCategoryType.delivery:
        return Colors.blue;
      case PriceCategoryType.catering:
        return Colors.purple;
      case PriceCategoryType.custom:
        return colorScheme.tertiary;
    }
  }

  void _handleCategoryAction(String action, PriceCategory category) async {
    switch (action) {
      case 'toggle_visibility':
        await _toggleCategoryVisibility(category);
        break;
      case 'edit':
        _showEditCategoryDialog(category);
        break;
      case 'delete':
        _showDeleteConfirmation(category);
        break;
    }
  }

  Future<void> _toggleCategoryVisibility(PriceCategory category) async {
    try {
      final service = ref.read(priceCategoryServiceProvider);
      await service.toggleCategoryVisibility(category);
      
      // Refresh the list
      ref.invalidate(priceCategoriesProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              category.isVisible 
                  ? '${category.name} hidden from sell screen' 
                  : '${category.name} shown on sell screen',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _logger.error('Error toggling category visibility', e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddCustomCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(
        onSave: (name, description, iconName, colorHex, displayOrder) async {
          try {
            final business = ref.read(selectedBusinessProvider);
            final selectedLocationAsync = ref.read(selectedLocationNotifierProvider);
            
            selectedLocationAsync.whenData((location) async {
            
            if (business == null || location == null) return;
            
            final service = ref.read(priceCategoryServiceProvider);
            await service.createCustomCategory(
              businessId: business.id,
              locationId: location.id,
              name: name,
              description: description.isEmpty ? null : description,
              iconName: iconName.isEmpty ? null : iconName,
              colorHex: colorHex.isEmpty ? null : colorHex,
              displayOrder: displayOrder,
            );
            
            // Refresh the list
            ref.invalidate(priceCategoriesProvider);
            
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Custom category created successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            });
          } catch (e) {
            _logger.error('Error creating custom category', e);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showEditCategoryDialog(PriceCategory category) {
    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(
        category: category,
        onSave: (name, description, iconName, colorHex, displayOrder) async {
          try {
            final service = ref.read(priceCategoryServiceProvider);
            final updatedCategory = category.copyWith(
              name: name,
              description: description.isEmpty ? null : description,
              iconName: iconName.isEmpty ? null : iconName,
              colorHex: colorHex.isEmpty ? null : colorHex,
              displayOrder: displayOrder,
            );
            
            await service.updateCategory(updatedCategory);
            
            // Refresh the list
            ref.invalidate(priceCategoriesProvider);
            
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category updated successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (e) {
            _logger.error('Error updating category', e);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(PriceCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteCategory(category);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(PriceCategory category) async {
    try {
      final service = ref.read(priceCategoryServiceProvider);
      await service.deleteCategory(category.id);
      
      // Refresh the list
      ref.invalidate(priceCategoriesProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _logger.error('Error deleting category', e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Price Categories Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'What are Price Categories?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Price categories allow you to set different prices for products based on the service type. '
                'For example, you might charge different prices for Dine-In vs Delivery.',
              ),
              SizedBox(height: 16),
              Text(
                'Default Categories:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Dine-In: For customers eating at your restaurant\n'
                '• Parcel: For takeaway orders\n'
                '• Delivery: For home delivery orders\n'
                '• Catering: For bulk/catering orders',
              ),
              SizedBox(height: 16),
              Text(
                'Custom Categories:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You can create custom categories for special pricing scenarios like:\n'
                '• Happy Hour\n'
                '• Member Pricing\n'
                '• Special Events\n'
                '• VIP Customers',
              ),
              SizedBox(height: 16),
              Text(
                'Tips:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Hide unused categories to simplify the sell screen\n'
                '• Set display order to control the tab order\n'
                '• Use colors to make categories easily identifiable',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

// Dialog for adding/editing categories
class _CategoryDialog extends StatefulWidget {
  final PriceCategory? category;
  final Function(String name, String description, String iconName, String colorHex, int displayOrder) onSave;

  const _CategoryDialog({
    this.category,
    required this.onSave,
  });

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _displayOrderController;
  String _selectedColor = '#2196F3';
  String _selectedIcon = 'star';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController = TextEditingController(text: widget.category?.description ?? '');
    _displayOrderController = TextEditingController(
      text: widget.category?.displayOrder.toString() ?? '999',
    );
    _selectedColor = widget.category?.colorHex ?? '#2196F3';
    _selectedIcon = widget.category?.iconName ?? 'star';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Category' : 'Add Custom Category'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _displayOrderController,
                decoration: const InputDecoration(
                  labelText: 'Display Order',
                  border: OutlineInputBorder(),
                  helperText: 'Lower numbers appear first',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a display order';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Color picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Color'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      '#2196F3', // Blue
                      '#4CAF50', // Green
                      '#FF9800', // Orange
                      '#9C27B0', // Purple
                      '#F44336', // Red
                      '#00BCD4', // Cyan
                      '#FF5722', // Deep Orange
                      '#795548', // Brown
                    ].map((color) {
                      return InkWell(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(int.parse(color.replaceAll('#', '0xFF'))),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedColor == color 
                                  ? Theme.of(context).colorScheme.primary 
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: _selectedColor == color 
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _nameController.text.trim(),
                _descriptionController.text.trim(),
                _selectedIcon,
                _selectedColor,
                int.parse(_displayOrderController.text),
              );
              Navigator.of(context).pop();
            }
          },
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}