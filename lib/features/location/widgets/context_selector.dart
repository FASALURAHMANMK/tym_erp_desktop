import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../providers/location_provider.dart';
import '../models/business_location.dart';
import '../models/pos_device.dart';
import '../../business/providers/business_provider.dart';

class ContextSelector extends ConsumerWidget {
  const ContextSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final selectedLocationAsync = ref.watch(selectedLocationNotifierProvider);
    final selectedDeviceAsync = ref.watch(selectedPOSDeviceNotifierProvider);
    
    if (selectedBusiness == null) {
      return const SizedBox.shrink();
    }

    return selectedLocationAsync.when(
      data: (selectedLocation) => selectedDeviceAsync.when(
        data: (selectedDevice) => _buildSelector(
          context, 
          ref, 
          selectedBusiness.name,
          selectedLocation,
          selectedDevice,
        ),
        loading: () => _buildLoadingSelector(context, selectedBusiness.name),
        error: (_, __) => _buildErrorSelector(context, selectedBusiness.name),
      ),
      loading: () => _buildLoadingSelector(context, selectedBusiness.name),
      error: (_, __) => _buildErrorSelector(context, selectedBusiness.name),
    );
  }

  Widget _buildSelector(
    BuildContext context,
    WidgetRef ref,
    String businessName,
    BusinessLocation? selectedLocation,
    POSDevice? selectedDevice,
  ) {
    final cardPadding = ResponsiveDimensions.getCardPadding(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: cardPadding,
          vertical: cardPadding * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Business icon
            Icon(
              Icons.business,
              size: ResponsiveDimensions.getIconSize(context),
              color: Theme.of(context).colorScheme.primary,
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 12),
            
            // Context info
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business name
                Text(
                  businessName,
                  style: ResponsiveTypography.getScaledTextStyle(
                    context, 
                    Theme.of(context).textTheme.bodyMedium,
                  )?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 1),
                
                // Location and POS info
                Text(
                  _getContextText(selectedLocation, selectedDevice),
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.bodySmall,
                  )?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
              ],
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 8),
            
            // Dropdown arrow
            Icon(
              Icons.arrow_drop_down,
              size: ResponsiveDimensions.getIconSize(context),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSelector(BuildContext context, String businessName) {
    final cardPadding = ResponsiveDimensions.getCardPadding(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: cardPadding,
          vertical: cardPadding * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.business,
              size: ResponsiveDimensions.getIconSize(context),
              color: Theme.of(context).colorScheme.primary,
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.bodyMedium,
                  )?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 2),
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSelector(BuildContext context, String businessName) {
    final cardPadding = ResponsiveDimensions.getCardPadding(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: cardPadding,
          vertical: cardPadding * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.business,
              size: ResponsiveDimensions.getIconSize(context),
              color: Theme.of(context).colorScheme.primary,
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.bodyMedium,
                  )?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 2),
                Text(
                  'Setup required',
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    Theme.of(context).textTheme.bodySmall,
                  )?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 8),
            Icon(
              Icons.error_outline,
              size: ResponsiveDimensions.getIconSize(context) * 0.8,
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }

  String _getContextText(BusinessLocation? location, POSDevice? device) {
    if (location == null) return 'No location selected';
    if (device == null) return '${location.name} • No POS device';
    return '${location.name} • ${device.deviceCode}';
  }
}

class ContextSelectorButton extends ConsumerWidget {
  final VoidCallback? onTap;

  const ContextSelectorButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap ?? () => _showContextMenu(context, ref),
      borderRadius: BorderRadius.circular(8),
      child: const ContextSelector(),
    );
  }

  void _showContextMenu(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const ContextSelectorDialog(),
    );
  }
}

class ContextSelectorDialog extends ConsumerStatefulWidget {
  const ContextSelectorDialog({super.key});

  @override
  ConsumerState<ContextSelectorDialog> createState() => _ContextSelectorDialogState();
}

class _ContextSelectorDialogState extends ConsumerState<ContextSelectorDialog> {
  @override
  Widget build(BuildContext context) {
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    
    if (selectedBusiness == null) {
      return const AlertDialog(
        title: Text('No Business Selected'),
        content: Text('Please select a business first.'),
      );
    }

    final locationsAsync = ref.watch(businessLocationsNotifierProvider(selectedBusiness.id));
    
    return AlertDialog(
      title: Text('Select Location & POS Device'),
      content: SizedBox(
        width: 500,
        height: 400,
        child: locationsAsync.when(
          data: (locations) => _buildLocationList(context, locations),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Error loading locations: $error'),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () => _showLocationManagement(context),
          child: const Text('Manage Locations'),
        ),
      ],
    );
  }

  Widget _buildLocationList(BuildContext context, List<BusinessLocation> locations) {
    if (locations.isEmpty) {
      return const Center(
        child: Text('No locations found. Create a location first.'),
      );
    }

    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return _buildLocationTile(context, location);
      },
    );
  }

  Widget _buildLocationTile(BuildContext context, BusinessLocation location) {
    final selectedLocationAsync = ref.watch(selectedLocationNotifierProvider);
    final devicesAsync = ref.watch(locationPOSDevicesNotifierProvider(location.id));
    
    return selectedLocationAsync.when(
      data: (selectedLocation) {
        final isSelected = selectedLocation?.id == location.id;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: ExpansionTile(
            leading: Icon(
              Icons.location_on,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              location.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            subtitle: location.address != null 
                ? Text(location.address!)
                : null,
            children: [
              devicesAsync.when(
                data: (devices) => _buildDeviceList(context, location, devices),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error loading devices: $error'),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _buildLocationTileLoading(context, location),
      error: (_, __) => _buildLocationTileLoading(context, location),
    );
  }

  Widget _buildLocationTileLoading(BuildContext context, BusinessLocation location) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: Text(location.name),
        subtitle: location.address != null ? Text(location.address!) : null,
        trailing: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildDeviceList(BuildContext context, BusinessLocation location, List<POSDevice> devices) {
    if (devices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('No POS devices found for this location.'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _createDevice(location),
              icon: const Icon(Icons.add),
              label: const Text('Create POS Device'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: devices.map((device) => _buildDeviceTile(context, location, device)).toList(),
    );
  }

  Widget _buildDeviceTile(BuildContext context, BusinessLocation location, POSDevice device) {
    final selectedDeviceAsync = ref.watch(selectedPOSDeviceNotifierProvider);
    
    return selectedDeviceAsync.when(
      data: (selectedDevice) {
        final isSelected = selectedDevice?.id == device.id;
        
        return ListTile(
          leading: Icon(
            Icons.point_of_sale,
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          title: Text(
            device.displayName,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          subtitle: Text(device.statusText),
          trailing: isSelected 
              ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                )
              : null,
          onTap: () => _selectContext(location, device),
        );
      },
      loading: () => ListTile(
        leading: const Icon(Icons.point_of_sale, size: 20),
        title: Text(device.displayName),
        subtitle: Text(device.statusText),
        trailing: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => ListTile(
        leading: const Icon(Icons.point_of_sale, size: 20),
        title: Text(device.displayName),
        subtitle: const Text('Error'),
      ),
    );
  }

  Future<void> _selectContext(BusinessLocation location, POSDevice device) async {
    try {
      await ref.read(selectedLocationNotifierProvider.notifier).selectLocation(location);
      await ref.read(selectedPOSDeviceNotifierProvider.notifier).selectDevice(device);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected ${location.name} • ${device.deviceCode}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting context: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _createDevice(BusinessLocation location) {
    Navigator.of(context).pop();
    context.pushNamed(
      'posDevices',
      extra: {'locationId': location.id},
    );
  }

  void _showLocationManagement(BuildContext context) {
    Navigator.of(context).pop();
    context.pushNamed('locations');
  }
}
