import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../business/providers/business_provider.dart';
import '../domain/models/product_category.dart';
import '../providers/product_providers.dart';

class CategoryFormDialog extends ConsumerStatefulWidget {
  final ProductCategory? category;

  const CategoryFormDialog({
    super.key,
    this.category,
  });

  @override
  ConsumerState<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends ConsumerState<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _displayOrderController = TextEditingController();
  
  bool _isActive = true;
  bool _isLoading = false;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final category = widget.category!;
      _nameController.text = category.name;
      _descriptionController.text = category.description ?? '';
      _displayOrderController.text = category.displayOrder.toString();
      _isActive = category.isActive;
    } else {
      _displayOrderController.text = '0';
    }
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
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    
    if (selectedBusiness == null) {
      return const AlertDialog(
        title: Text('Error'),
        content: Text('No business selected'),
      );
    }

    return AlertDialog(
      title: Text(_isEditing ? 'Edit Category' : 'Add Category'),
      content: SizedBox(
        width: ResponsiveUtils.getScreenSize(context) == ScreenSize.small 
            ? double.maxFinite 
            : 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name *',
                  hintText: 'e.g., Beverages, Main Course',
                  prefixIcon: Icon(Icons.category),
                ),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Category name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of the category',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Display order field
              TextFormField(
                controller: _displayOrderController,
                decoration: const InputDecoration(
                  labelText: 'Display Order',
                  hintText: 'Order in which category appears',
                  prefixIcon: Icon(Icons.sort),
                  helperText: 'Lower numbers appear first',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Display order is required';
                  }
                  return null;
                },
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Active status
              SwitchListTile(
                title: const Text('Active'),
                subtitle: const Text('Category is available for selection'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveCategory,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedBusiness = ref.read(selectedBusinessProvider);
      if (selectedBusiness == null) throw Exception('No business selected');

      final displayOrder = int.tryParse(_displayOrderController.text) ?? 0;

      final category = ProductCategory(
        id: widget.category?.id ?? '',
        businessId: selectedBusiness.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        isActive: _isActive,
        displayOrder: displayOrder,
        createdAt: widget.category?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = _isEditing
          ? await ref.read(categoryListNotifierProvider.notifier).updateCategory(category)
          : await ref.read(categoryListNotifierProvider.notifier).createCategory(category);

      if (mounted) {
        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${failure.message}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
          (category) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isEditing 
                    ? 'Category updated successfully' 
                    : 'Category created successfully'),
              ),
            );
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}