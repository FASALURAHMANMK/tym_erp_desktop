import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../models/business_location.dart';
import '../providers/location_provider.dart';
import '../models/pos_device.dart'; // For POSDevice

class LocationListTile extends ConsumerWidget {
  final BusinessLocation location;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const LocationListTile({
    super.key,
    required this.location,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(locationPOSDevicesNotifierProvider(location.id));
    final cardPadding = ResponsiveDimensions.getCardPadding(context);
    final iconSize = ResponsiveDimensions.getIconSize(context);

    return Card(
      elevation: location.isDefault ? 3 : 1,
      color: location.isDefault 
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with location info and actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location icon and default badge
                  Column(
                    children: [
                      Icon(
                        location.isDefault ? Icons.location_on : Icons.location_on_outlined,
                        color: location.isDefault 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: iconSize,
                      ),
                      if (location.isDefault) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  ResponsiveSpacing.getHorizontalSpacing(context, 12),
                  
                  // Location details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location name
                        Text(
                          location.name,
                          style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodyLarge)?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: location.isDefault 
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                        
                        // Address
                        if (location.address != null) ...[
                          ResponsiveSpacing.getVerticalSpacing(context, 4),
                          Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                size: iconSize * 0.8,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location.address!,
                                  style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodySmall)?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        
                        // Phone
                        if (location.phone != null) ...[
                          ResponsiveSpacing.getVerticalSpacing(context, 4),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: iconSize * 0.8,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location.phone!,
                                style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodySmall)?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Actions menu
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(context, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: ListTile(
                          leading: Icon(Icons.visibility),
                          title: Text('View Details'),
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                          dense: true,
                        ),
                      ),
                      if (!location.isDefault)
                        const PopupMenuItem(
                          value: 'default',
                          child: ListTile(
                            leading: Icon(Icons.star),
                            title: Text('Set as Default'),
                            dense: true,
                          ),
                        ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                          dense: true,
                        ),
                      ),
                    ],
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              
              ResponsiveSpacing.getVerticalSpacing(context, 12),
              
              // POS devices info
              devicesAsync.when(
                data: (devices) => _buildPOSDevicesInfo(context, devices),
                loading: () => _buildPOSDevicesLoading(context),
                error: (_, __) => _buildPOSDevicesError(context),
              ),
              
              // Sync status indicator
              if (location.syncStatus != SyncStatus.synced) ...[
                ResponsiveSpacing.getVerticalSpacing(context, 8),
                _buildSyncStatus(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPOSDevicesInfo(BuildContext context, List<POSDevice> devices) {
    final iconSize = ResponsiveDimensions.getIconSize(context);
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.point_of_sale,
            size: iconSize * 0.9,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              devices.isEmpty 
                  ? 'No POS devices'
                  : '${devices.length} POS device${devices.length == 1 ? '' : 's'}',
              style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodySmall)?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (devices.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              () {
                final defaultDevice = devices.where((d) => d.isDefault).firstOrNull;
                return defaultDevice?.deviceCode ?? devices.firstOrNull?.deviceCode ?? 'N/A';
              }(),
              style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodySmall)?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPOSDevicesLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading devices...',
            style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodySmall)?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPOSDevicesError(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Text(
            'Error loading devices',
            style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodySmall)?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncStatus(BuildContext context) {
    IconData icon;
    Color color;
    String text;

    switch (location.syncStatus) {
      case SyncStatus.pending:
        icon = Icons.sync;
        color = Theme.of(context).colorScheme.primary;
        text = 'Sync pending';
        break;
      case SyncStatus.error:
        icon = Icons.sync_problem;
        color = Theme.of(context).colorScheme.error;
        text = 'Sync error';
        break;
      case SyncStatus.conflict:
        icon = Icons.warning;
        color = Theme.of(context).colorScheme.tertiary;
        text = 'Sync conflict';
        break;
      case SyncStatus.synced:
        return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: ResponsiveTypography.getScaledTextStyle(context, Theme.of(context).textTheme.bodySmall)?.copyWith(
            color: color,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'view':
        onTap?.call();
        break;
      case 'edit':
        onEdit?.call();
        break;
      case 'default':
        onSetDefault?.call();
        break;
      case 'delete':
        onDelete?.call();
        break;
    }
  }
}