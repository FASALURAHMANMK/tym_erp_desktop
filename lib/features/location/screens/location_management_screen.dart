import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../providers/location_provider.dart';
import '../models/business_location.dart';
import '../../business/providers/business_provider.dart';
import '../widgets/location_form_dialog.dart';
import '../widgets/location_list_tile.dart';

class LocationManagementScreen extends ConsumerStatefulWidget {
  const LocationManagementScreen({super.key});

  @override
  ConsumerState<LocationManagementScreen> createState() => _LocationManagementScreenState();
}

class _LocationManagementScreenState extends ConsumerState<LocationManagementScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    
    if (selectedBusiness == null) {
      return const Scaffold(
        appBar: null,
        body: Center(
          child: Text('No business selected'),
        ),
      );
    }

    final locationsAsync = ref.watch(businessLocationsNotifierProvider(selectedBusiness.id));
    final contentPadding = ResponsiveDimensions.getContentPadding(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Locations',
          style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.headlineSmall),
        ),
        actions: [
          IconButton(
            onPressed: () => _showCreateLocationDialog(context),
            icon: const Icon(Icons.add_location),
            tooltip: 'Add Location',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          children: [
            // Search bar
            _buildSearchBar(context),
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            
            // Locations list
            Expanded(
              child: locationsAsync.when(
                data: (locations) => _buildLocationsList(context, locations),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: ResponsiveDimensions.getIconSize(context) * 2,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      ResponsiveSpacing.getVerticalSpacing(context, 16),
                      Text(
                        'Error loading locations',
                        style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.headlineSmall),
                      ),
                      ResponsiveSpacing.getVerticalSpacing(context, 8),
                      Text(
                        error.toString(),
                        style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodyMedium)?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ResponsiveSpacing.getVerticalSpacing(context, 16),
                      ElevatedButton.icon(
                        onPressed: () => ref.refresh(businessLocationsNotifierProvider(selectedBusiness.id)),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateLocationDialog(context),
        tooltip: 'Add Location',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveDimensions.getCardPadding(context),
          vertical: ResponsiveDimensions.getCardPadding(context) * 0.5,
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search locations...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: ResponsiveDimensions.getCardPadding(context) * 0.5,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),
      ),
    );
  }

  Widget _buildLocationsList(BuildContext context, List<BusinessLocation> locations) {
    if (locations.isEmpty) {
      return _buildEmptyState(context);
    }

    // Filter locations based on search query
    final filteredLocations = locations.where((location) {
      if (_searchQuery.isEmpty) return true;
      
      return location.name.toLowerCase().contains(_searchQuery) ||
             (location.address?.toLowerCase().contains(_searchQuery) ?? false) ||
             (location.phone?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();

    if (filteredLocations.isEmpty) {
      return _buildNoSearchResults(context);
    }

    return ListView.separated(
      itemCount: filteredLocations.length,
      separatorBuilder: (context, index) => ResponsiveSpacing.getVerticalSpacing(context, 8),
      itemBuilder: (context, index) {
        final location = filteredLocations[index];
        return LocationListTile(
          location: location,
          onTap: () => _showLocationDetails(context, location),
          onEdit: () => _showEditLocationDialog(context, location),
          onDelete: () => _showDeleteLocationDialog(context, location),
          onSetDefault: location.isDefault ? null : () => _setLocationAsDefault(location),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: ResponsiveDimensions.getIconSize(context) * 3,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          Text(
            'No locations found',
            style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.headlineSmall),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            'Create your first business location to get started.',
            style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodyLarge)?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateLocationDialog(context),
            icon: const Icon(Icons.add_location),
            label: const Text('Add Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: ResponsiveDimensions.getIconSize(context) * 2,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 16),
          Text(
            'No locations found',
            style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.headlineSmall),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            'Try adjusting your search terms.',
            style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodyMedium)?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LocationFormDialog(),
    );
  }

  void _showEditLocationDialog(BuildContext context, BusinessLocation location) {
    showDialog(
      context: context,
      builder: (context) => LocationFormDialog(location: location),
    );
  }

  void _showLocationDetails(BuildContext context, BusinessLocation location) {
    // TODO: Navigate to location details screen with POS devices
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location details for ${location.name} coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDeleteLocationDialog(BuildContext context, BusinessLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${location.name}"?'),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone. All POS devices at this location will also be removed.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
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
            onPressed: () => _deleteLocation(context, location),
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

  Future<void> _setLocationAsDefault(BusinessLocation location) async {
    try {
      await ref
          .read(businessLocationsNotifierProvider(location.businessId).notifier)
          .setAsDefault(location.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${location.name} set as default location'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting default location: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteLocation(BuildContext context, BusinessLocation location) async {
    Navigator.of(context).pop(); // Close dialog
    
    // Store references before async operation
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    
    try {
      await ref
          .read(businessLocationsNotifierProvider(location.businessId).notifier)
          .deleteLocation(location.id);
      
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${location.name} deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error deleting location: $e'),
            backgroundColor: errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}