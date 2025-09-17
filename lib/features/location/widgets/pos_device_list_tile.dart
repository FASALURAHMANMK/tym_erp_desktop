import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../models/pos_device.dart';
import '../models/business_location.dart'; // For SyncStatus

class POSDeviceListTile extends StatelessWidget {
  final POSDevice device;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetAsDefault;

  const POSDeviceListTile({
    super.key,
    required this.device,
    this.onEdit,
    this.onDelete,
    this.onSetAsDefault,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveDimensions.getCardPadding(context);

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Row(
          children: [
            // Device Icon and Status
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(cardPadding * 0.75),
                  decoration: BoxDecoration(
                    color: _getStatusColor(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.point_of_sale,
                    size: ResponsiveDimensions.getIconSize(context, baseSize: 32),
                    color: _getStatusColor(context),
                  ),
                ),
                ResponsiveSpacing.getVerticalSpacing(context, 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    device.statusText,
                    style: ResponsiveTypography.getScaledTextStyle(
                      context,
                      Theme.of(context).textTheme.labelSmall,
                    )?.copyWith(
                      color: _getStatusColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            ResponsiveSpacing.getHorizontalSpacing(context, 16),

            // Device Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device Name and Default Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          device.deviceName,
                          style: ResponsiveTypography.getScaledTextStyle(
                            context,
                            Theme.of(context).textTheme.titleMedium,
                          )?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (device.isDefault) ...[
                        ResponsiveSpacing.getHorizontalSpacing(context, 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Default',
                            style: ResponsiveTypography.getScaledTextStyle(
                              context,
                              Theme.of(context).textTheme.labelSmall,
                            )?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  ResponsiveSpacing.getVerticalSpacing(context, 4),

                  // Device Code
                  Row(
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: ResponsiveDimensions.getIconSize(context, baseSize: 16),
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      ResponsiveSpacing.getHorizontalSpacing(context, 4),
                      Text(
                        device.deviceCode,
                        style: ResponsiveTypography.getScaledTextStyle(
                          context,
                          Theme.of(context).textTheme.bodyMedium,
                        )?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),

                  if (device.description != null) ...[
                    ResponsiveSpacing.getVerticalSpacing(context, 4),
                    Text(
                      device.description!,
                      style: ResponsiveTypography.getScaledTextStyle(
                        context,
                        Theme.of(context).textTheme.bodySmall,
                      )?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  ResponsiveSpacing.getVerticalSpacing(context, 8),

                  // Metadata Row
                  Row(
                    children: [
                      // Sync Status
                      Icon(
                        _getSyncStatusIcon(),
                        size: ResponsiveDimensions.getIconSize(context, baseSize: 14),
                        color: _getSyncStatusColor(context),
                      ),
                      ResponsiveSpacing.getHorizontalSpacing(context, 4),
                      Text(
                        device.syncStatus.displayName,
                        style: ResponsiveTypography.getScaledTextStyle(
                          context,
                          Theme.of(context).textTheme.labelSmall,
                        )?.copyWith(
                          color: _getSyncStatusColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      ResponsiveSpacing.getHorizontalSpacing(context, 16),

                      // Last Updated
                      Icon(
                        Icons.schedule,
                        size: ResponsiveDimensions.getIconSize(context, baseSize: 14),
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      ResponsiveSpacing.getHorizontalSpacing(context, 4),
                      Text(
                        _formatDate(device.updatedAt),
                        style: ResponsiveTypography.getScaledTextStyle(
                          context,
                          Theme.of(context).textTheme.labelSmall,
                        )?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ResponsiveSpacing.getHorizontalSpacing(context, 16),

            // Actions Menu
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: ResponsiveDimensions.getIconSize(context, baseSize: 18),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        ResponsiveSpacing.getHorizontalSpacing(context, 12),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                if (onSetAsDefault != null)
                  PopupMenuItem(
                    value: 'default',
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: ResponsiveDimensions.getIconSize(context, baseSize: 18),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        ResponsiveSpacing.getHorizontalSpacing(context, 12),
                        const Text('Set as Default'),
                      ],
                    ),
                  ),
                if (onEdit != null || onSetAsDefault != null)
                  const PopupMenuDivider(),
                if (onDelete != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: ResponsiveDimensions.getIconSize(context, baseSize: 18),
                          color: Theme.of(context).colorScheme.error,
                        ),
                        ResponsiveSpacing.getHorizontalSpacing(context, 12),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit?.call();
                    break;
                  case 'default':
                    onSetAsDefault?.call();
                    break;
                  case 'delete':
                    onDelete?.call();
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    if (!device.isActive) {
      return Colors.red;
    } else if (device.isOnline) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }

  Color _getSyncStatusColor(BuildContext context) {
    switch (device.syncStatus) {
      case SyncStatus.synced:
        return Colors.green;
      case SyncStatus.pending:
        return Colors.orange;
      case SyncStatus.error:
        return Theme.of(context).colorScheme.error;
      case SyncStatus.conflict:
        return Colors.purple;
    }
  }

  IconData _getSyncStatusIcon() {
    switch (device.syncStatus) {
      case SyncStatus.synced:
        return Icons.cloud_done;
      case SyncStatus.pending:
        return Icons.cloud_sync;
      case SyncStatus.error:
        return Icons.cloud_off;
      case SyncStatus.conflict:
        return Icons.warning;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}