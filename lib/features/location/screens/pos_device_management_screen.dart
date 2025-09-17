import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../business/providers/business_provider.dart';
import '../models/pos_device.dart';
import '../providers/location_provider.dart';
import '../widgets/pos_device_form_dialog.dart';
import '../widgets/pos_device_list_tile.dart';

class POSDeviceManagementScreen extends ConsumerStatefulWidget {
  final String? locationId;

  const POSDeviceManagementScreen({super.key, this.locationId});

  @override
  ConsumerState<POSDeviceManagementScreen> createState() =>
      _POSDeviceManagementScreenState();
}

class _POSDeviceManagementScreenState
    extends ConsumerState<POSDeviceManagementScreen> {
  String? _selectedLocationId;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.locationId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final contentPadding = ResponsiveDimensions.getContentPadding(context);
    final screenPadding = ResponsiveDimensions.getScreenPadding(context);

    if (selectedBusiness == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('POS Device Management')),
        body: const Center(child: Text('No business selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('POS Device Management'),
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage POS Devices',
                        style: ResponsiveTypography.getScaledTextStyle(
                          context,
                          Theme.of(context).textTheme.headlineSmall,
                        )?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      ResponsiveSpacing.getVerticalSpacing(context, 4),
                      Text(
                        'Configure POS devices for your business locations',
                        style: ResponsiveTypography.getScaledTextStyle(
                          context,
                          Theme.of(context).textTheme.bodyMedium,
                        )?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed:
                      _selectedLocationId != null
                          ? _showCreateDeviceDialog
                          : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Device'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: contentPadding,
                      vertical: contentPadding * 0.75,
                    ),
                  ),
                ),
              ],
            ),

            ResponsiveSpacing.getVerticalSpacing(context, 24),

            // Location Selector & Search
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildLocationSelector(selectedBusiness.id),
                ),
                ResponsiveSpacing.getHorizontalSpacing(context, 16),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search devices by name or code...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
              ],
            ),

            ResponsiveSpacing.getVerticalSpacing(context, 24),

            // Device List
            Expanded(
              child:
                  _selectedLocationId == null
                      ? _buildNoLocationSelected()
                      : _buildDeviceList(_selectedLocationId!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSelector(String businessId) {
    final locationsAsync = ref.watch(
      businessLocationsNotifierProvider(businessId),
    );

    return locationsAsync.when(
      data: (locations) {
        if (locations.isEmpty) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveDimensions.getCardPadding(context),
              ),
              child: const Text('No locations found. Create a location first.'),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: _selectedLocationId,
          decoration: InputDecoration(
            labelText: 'Select Location',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          items:
              locations.map((location) {
                return DropdownMenuItem(
                  value: location.id,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: ResponsiveDimensions.getIconSize(
                            context,
                            baseSize: 18,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        ResponsiveSpacing.getHorizontalSpacing(context, 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                location.name,
                                style: ResponsiveTypography.getScaledTextStyle(
                                  context,
                                  Theme.of(context).textTheme.bodyMedium,
                                )?.copyWith(fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // if (location.address != null && location.address!.isNotEmpty) ...[
                              //   Text(
                              //     location.address!,
                              //     style: ResponsiveTypography.getScaledTextStyle(
                              //       context,
                              //       Theme.of(context).textTheme.bodySmall,
                              //     )?.copyWith(
                              //       color: Theme.of(context).colorScheme.onSurfaceVariant,
                              //     ),
                              //     maxLines: 1,
                              //     overflow: TextOverflow.ellipsis,
                              //   ),
                              // ],
                            ],
                          ),
                        ),
                        if (location.isDefault) ...[
                          ResponsiveSpacing.getHorizontalSpacing(context, 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Default',
                              style: ResponsiveTypography.getScaledTextStyle(
                                context,
                                Theme.of(context).textTheme.labelSmall,
                              )?.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLocationId = value;
            });
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, _) => Card(
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveDimensions.getCardPadding(context),
              ),
              child: Text('Error loading locations: $error'),
            ),
          ),
    );
  }

  Widget _buildNoLocationSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: ResponsiveDimensions.getIconSize(context, baseSize: 64),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 16),
          Text(
            'Select a Location',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.titleLarge,
            )?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            'Choose a business location to manage its POS devices',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium,
            )?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(String locationId) {
    final devicesAsync = ref.watch(
      locationPOSDevicesNotifierProvider(locationId),
    );

    return devicesAsync.when(
      data: (devices) {
        // Filter devices based on search query
        final filteredDevices =
            devices.where((device) {
              if (_searchQuery.isEmpty) return true;
              return device.deviceName.toLowerCase().contains(_searchQuery) ||
                  device.deviceCode.toLowerCase().contains(_searchQuery);
            }).toList();

        if (filteredDevices.isEmpty) {
          return _buildEmptyDeviceList();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(locationPOSDevicesNotifierProvider(locationId).notifier)
                .refreshDevices();
          },
          child: ListView.separated(
            padding: EdgeInsets.only(
              bottom: ResponsiveDimensions.getScreenPadding(context),
            ),
            itemCount: filteredDevices.length,
            separatorBuilder:
                (context, index) =>
                    ResponsiveSpacing.getVerticalSpacing(context, 8),
            itemBuilder: (context, index) {
              final device = filteredDevices[index];
              return POSDeviceListTile(
                device: device,
                onEdit: () => _showEditDeviceDialog(device),
                onDelete: () => _showDeleteDeviceDialog(device),
                onSetAsDefault:
                    device.isDefault ? null : () => _setDeviceAsDefault(device),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: ResponsiveDimensions.getIconSize(context, baseSize: 64),
                  color: Theme.of(context).colorScheme.error,
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 16),
                Text(
                  'Error Loading Devices',
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.titleLarge,
                  )?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 8),
                Text(
                  error.toString(),
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.bodyMedium,
                  )?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(
                      locationPOSDevicesNotifierProvider(locationId),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildEmptyDeviceList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.point_of_sale,
            size: ResponsiveDimensions.getIconSize(context, baseSize: 64),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 16),
          Text(
            _searchQuery.isEmpty ? 'No POS Devices' : 'No Matching Devices',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.titleLarge,
            )?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            _searchQuery.isEmpty
                ? 'Add your first POS device to get started'
                : 'Try adjusting your search terms',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium,
            )?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            ElevatedButton.icon(
              onPressed: _showCreateDeviceDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add POS Device'),
            ),
          ],
        ],
      ),
    );
  }

  void _showCreateDeviceDialog() {
    if (_selectedLocationId == null) return;

    showDialog(
      context: context,
      builder:
          (context) => POSDeviceFormDialog(locationId: _selectedLocationId!),
    );
  }

  void _showEditDeviceDialog(POSDevice device) {
    showDialog(
      context: context,
      builder:
          (context) => POSDeviceFormDialog(
            locationId: device.locationId,
            device: device,
          ),
    );
  }

  void _showDeleteDeviceDialog(POSDevice device) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete POS Device'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you sure you want to delete this POS device?'),
                ResponsiveSpacing.getVerticalSpacing(context, 12),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveDimensions.getCardPadding(context) * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.errorContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.point_of_sale,
                        color: Theme.of(context).colorScheme.error,
                        size: ResponsiveDimensions.getIconSize(
                          context,
                          baseSize: 20,
                        ),
                      ),
                      ResponsiveSpacing.getHorizontalSpacing(context, 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              device.deviceName,
                              style: ResponsiveTypography.getScaledTextStyle(
                                context,
                                Theme.of(context).textTheme.bodyMedium,
                              )?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            Text(
                              device.deviceCode,
                              style: ResponsiveTypography.getScaledTextStyle(
                                context,
                                Theme.of(context).textTheme.bodySmall,
                              )?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 12),
                Text(
                  'This action cannot be undone.',
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.bodySmall,
                  )?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
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
                  Navigator.of(context).pop();
                  await _deleteDevice(device);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteDevice(POSDevice device) async {
    try {
      await ref
          .read(locationPOSDevicesNotifierProvider(device.locationId).notifier)
          .deleteDevice(device.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'POS device "${device.deviceName}" deleted successfully',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting device: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _setDeviceAsDefault(POSDevice device) async {
    try {
      await ref
          .read(locationPOSDevicesNotifierProvider(device.locationId).notifier)
          .setAsDefault(device.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${device.deviceName} set as default device'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting default device: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
