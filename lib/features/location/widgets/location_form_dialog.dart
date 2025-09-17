import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../providers/location_provider.dart';
import '../models/business_location.dart';
import '../../business/providers/business_provider.dart';

class LocationFormDialog extends ConsumerStatefulWidget {
  final BusinessLocation? location; // null for create, location for edit

  const LocationFormDialog({
    super.key,
    this.location,
  });

  @override
  ConsumerState<LocationFormDialog> createState() => _LocationFormDialogState();
}

class _LocationFormDialogState extends ConsumerState<LocationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isDefault = false;
  bool _isLoading = false;

  bool get _isEditing => widget.location != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final location = widget.location!;
      _nameController.text = location.name;
      _addressController.text = location.address ?? '';
      _phoneController.text = location.phone ?? '';
      _isDefault = location.isDefault;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
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
      title: Text(_isEditing ? 'Edit Location' : 'Add Location'),
      content: SizedBox(
        width: ResponsiveUtils.getScreenSize(context) == ScreenSize.small 
            ? double.maxFinite 
            : 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Location name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Location Name *',
                  hintText: 'e.g., Main Branch, Downtown Store',
                  prefixIcon: Icon(Icons.location_on),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Location name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Location name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Address field
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'e.g., 123 Main St, City, State',
                  prefixIcon: Icon(Icons.place),
                ),
                textInputAction: TextInputAction.next,
                maxLines: 2,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty && value.trim().length < 10) {
                    return 'Address must be at least 10 characters if provided';
                  }
                  return null;
                },
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Phone field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'e.g., +1 (555) 123-4567',
                  prefixIcon: Icon(Icons.phone),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    // Basic phone validation - at least 10 digits
                    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                    if (digitsOnly.length < 10) {
                      return 'Phone number must have at least 10 digits';
                    }
                  }
                  return null;
                },
              ),
              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Default location checkbox
              CheckboxListTile(
                title: const Text('Set as default location'),
                subtitle: const Text('This will be the primary location for your business'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveLocation,
          child: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : Text(_isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _saveLocation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedBusiness = ref.read(selectedBusinessProvider);
      if (selectedBusiness == null) {
        throw Exception('No business selected');
      }

      if (_isEditing) {
        // Update existing location
        final updatedLocation = widget.location!.copyWith(
          name: _nameController.text.trim(),
          address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          isDefault: _isDefault,
        );

        await ref
            .read(businessLocationsNotifierProvider(selectedBusiness.id).notifier)
            .updateLocation(updatedLocation);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${updatedLocation.name} updated successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Create new location
        await ref
            .read(businessLocationsNotifierProvider(selectedBusiness.id).notifier)
            .createLocation(
              name: _nameController.text.trim(),
              address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
              phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
              isDefault: _isDefault,
            );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_nameController.text.trim()} created successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${_isEditing ? 'updating' : 'creating'} location: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
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