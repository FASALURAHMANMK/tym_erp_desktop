import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../business/providers/business_provider.dart';
import '../domain/models/product_brand.dart';
import '../providers/product_providers.dart';

class BrandFormDialog extends ConsumerStatefulWidget {
  final ProductBrand? brand;

  const BrandFormDialog({
    super.key,
    this.brand,
  });

  @override
  ConsumerState<BrandFormDialog> createState() => _BrandFormDialogState();
}

class _BrandFormDialogState extends ConsumerState<BrandFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _displayOrderController = TextEditingController();
  final _logoUrlController = TextEditingController();
  
  bool _isActive = true;
  bool _isLoading = false;

  bool get _isEditing => widget.brand != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final brand = widget.brand!;
      _nameController.text = brand.name;
      _descriptionController.text = brand.description ?? '';
      _displayOrderController.text = brand.displayOrder.toString();
      _logoUrlController.text = brand.logoUrl ?? '';
      _isActive = brand.isActive;
    } else {
      _displayOrderController.text = '0';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _displayOrderController.dispose();
    _logoUrlController.dispose();
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
      title: Text(_isEditing ? 'Edit Brand' : 'Add Brand'),
      content: SizedBox(
        width: ResponsiveUtils.getScreenSize(context) == ScreenSize.small 
            ? double.maxFinite 
            : 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brand name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name *',
                    hintText: 'e.g., Nike, Apple, Samsung',
                    prefixIcon: Icon(Icons.branding_watermark),
                  ),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Brand name is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Brand name must be at least 2 characters';
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
                    hintText: 'Brief description of the brand',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 16),

                // Logo URL field
                TextFormField(
                  controller: _logoUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Logo URL',
                    hintText: 'https://example.com/logo.png',
                    prefixIcon: Icon(Icons.image),
                    helperText: 'URL of the brand logo image',
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final uri = Uri.tryParse(value);
                      if (uri == null || !uri.hasScheme) {
                        return 'Please enter a valid URL';
                      }
                    }
                    return null;
                  },
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 16),

                // Display order field
                TextFormField(
                  controller: _displayOrderController,
                  decoration: const InputDecoration(
                    labelText: 'Display Order',
                    hintText: 'Order in which brand appears',
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
                  subtitle: const Text('Brand is available for selection'),
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
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveBrand,
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

  Future<void> _saveBrand() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedBusiness = ref.read(selectedBusinessProvider);
      if (selectedBusiness == null) throw Exception('No business selected');

      final displayOrder = int.tryParse(_displayOrderController.text) ?? 0;

      final brand = ProductBrand(
        id: widget.brand?.id ?? '',
        businessId: selectedBusiness.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        logoUrl: _logoUrlController.text.trim().isEmpty 
            ? null 
            : _logoUrlController.text.trim(),
        isActive: _isActive,
        displayOrder: displayOrder,
        createdAt: widget.brand?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = _isEditing
          ? await ref.read(brandListNotifierProvider.notifier).updateBrand(brand)
          : await ref.read(brandListNotifierProvider.notifier).createBrand(brand);

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
          (brand) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isEditing 
                    ? 'Brand updated successfully' 
                    : 'Brand created successfully'),
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