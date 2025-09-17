import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../providers/location_provider.dart';
import '../models/pos_device.dart';
import '../models/business_location.dart'; // For SyncStatus

class POSDeviceFormDialog extends ConsumerStatefulWidget {
  final String locationId;
  final POSDevice? device; // null for create, populated for edit

  const POSDeviceFormDialog({
    super.key,
    required this.locationId,
    this.device,
  });

  @override
  ConsumerState<POSDeviceFormDialog> createState() => _POSDeviceFormDialogState();
}

class _POSDeviceFormDialogState extends ConsumerState<POSDeviceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  final _deviceCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isDefault = false;
  bool _isLoading = false;
  
  bool get _isEditing => widget.device != null;

  @override
  void initState() {
    super.initState();
    
    if (_isEditing) {
      _deviceNameController.text = widget.device!.deviceName;
      _deviceCodeController.text = widget.device!.deviceCode;
      _descriptionController.text = widget.device!.description ?? '';
      _isDefault = widget.device!.isDefault;
    }
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _deviceCodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentPadding = ResponsiveDimensions.getContentPadding(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.point_of_sale,
            color: Theme.of(context).colorScheme.primary,
            size: ResponsiveDimensions.getIconSize(context, baseSize: 24),
          ),
          ResponsiveSpacing.getHorizontalSpacing(context, 12),
          Text(_isEditing ? 'Edit POS Device' : 'Add POS Device'),
        ],
      ),
      content: SizedBox(
        width: ResponsiveUtils.getResponsiveValue(
          context,
          small: 400.0,
          medium: 500.0,
          large: 600.0,
          extraLarge: 700.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Name Field
              TextFormField(
                controller: _deviceNameController,
                decoration: InputDecoration(
                  labelText: 'Device Name *',
                  hintText: 'e.g., Counter 1, Kitchen Terminal',
                  prefixIcon: const Icon(Icons.devices),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Device name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Device name must be at least 2 characters';
                  }
                  if (value.trim().length > 50) {
                    return 'Device name must be less than 50 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                enabled: !_isLoading,
              ),

              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Device Code Field
              TextFormField(
                controller: _deviceCodeController,
                decoration: InputDecoration(
                  labelText: 'Device Code',
                  hintText: 'Auto-generated if left empty',
                  prefixIcon: const Icon(Icons.qr_code),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (value.trim().length < 3) {
                      return 'Device code must be at least 3 characters';
                    }
                    if (value.trim().length > 20) {
                      return 'Device code must be less than 20 characters';
                    }
                    // Check for valid characters (alphanumeric and hyphens)
                    if (!RegExp(r'^[a-zA-Z0-9-_]+$').hasMatch(value.trim())) {
                      return 'Device code can only contain letters, numbers, hyphens, and underscores';
                    }
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.characters,
                enabled: !_isLoading,
              ),

              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Optional description for this device',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value != null && value.trim().length > 200) {
                    return 'Description must be less than 200 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
                enabled: !_isLoading,
              ),

              ResponsiveSpacing.getVerticalSpacing(context, 16),

              // Default Device Checkbox
              CheckboxListTile(
                value: _isDefault,
                onChanged: _isLoading ? null : (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                title: Text(
                  'Set as Default Device',
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.bodyMedium,
                  )?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'This device will be automatically selected for this location',
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.bodySmall,
                  )?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              ResponsiveSpacing.getVerticalSpacing(context, 8),

              // Info Card
              Container(
                padding: EdgeInsets.all(contentPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: ResponsiveDimensions.getIconSize(context, baseSize: 20),
                    ),
                    ResponsiveSpacing.getHorizontalSpacing(context, 12),
                    Expanded(
                      child: Text(
                        _isEditing
                            ? 'Changes will be synchronized across all devices'
                            : 'A unique device code will be generated if not provided',
                        style: ResponsiveTypography.getScaledTextStyle(
                          context,
                          Theme.of(context).textTheme.bodySmall,
                        )?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
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
          onPressed: _isLoading ? null : _saveDevice,
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

  Future<void> _saveDevice() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final deviceName = _deviceNameController.text.trim();
      final deviceCode = _deviceCodeController.text.trim();
      final description = _descriptionController.text.trim();

      if (_isEditing) {
        // Update existing device
        final updatedDevice = widget.device!.copyWith(
          deviceName: deviceName,
          deviceCode: deviceCode.isEmpty ? widget.device!.deviceCode : deviceCode,
          description: description.isEmpty ? null : description,
          isDefault: _isDefault,
          syncStatus: SyncStatus.pending,
          updatedAt: DateTime.now(),
        );

        await ref
            .read(locationPOSDevicesNotifierProvider(widget.locationId).notifier)
            .updateDevice(updatedDevice);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('POS device "$deviceName" updated successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Create new device
        await ref
            .read(locationPOSDevicesNotifierProvider(widget.locationId).notifier)
            .createDevice(
              deviceName: deviceName,
              deviceCode: deviceCode.isEmpty ? null : deviceCode,
              isDefault: _isDefault,
            );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('POS device "$deviceName" created successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_isEditing ? 'Error updating' : 'Error creating'} device: $e',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}