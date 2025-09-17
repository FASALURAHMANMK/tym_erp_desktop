import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/sync_service.dart';

/// Widget that displays current sync status
class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final syncStatusAsync = ref.watch(syncStatusProvider);

    return syncStatusAsync.when(
      data: (status) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(status, theme).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getStatusColor(status, theme).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status.isSyncing)
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStatusColor(status, theme),
                    ),
                  ),
                )
              else
                Icon(
                  _getStatusIcon(status),
                  size: 12,
                  color: _getStatusColor(status, theme),
                ),
              const SizedBox(width: 6),
              Text(
                _getStatusText(status),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getStatusColor(status, theme),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (status.lastSyncTime != null) ...[
                const SizedBox(width: 4),
                Text(
                  '(${_formatLastSync(status.lastSyncTime!)})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(
                      status,
                      theme,
                    ).withValues(alpha: 0.7),
                  ),
                ),
              ],
              FutureBuilder<int>(
                future: status.pendingChangesCount,
                builder: (context, pendingSnapshot) {
                  if (pendingSnapshot.hasData &&
                      pendingSnapshot.data! > 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${pendingSnapshot.data}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onError,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Color _getStatusColor(SyncStatus status, ThemeData theme) {
    if (status.isSyncing) {
      return theme.colorScheme.primary;
    } else if (status.isOnline) {
      return Colors.green;
    } else {
      return theme.colorScheme.error;
    }
  }

  IconData _getStatusIcon(SyncStatus status) {
    if (status.isOnline) {
      return Icons.cloud_done;
    } else {
      return Icons.cloud_off;
    }
  }

  String _getStatusText(SyncStatus status) {
    if (status.isSyncing) {
      return 'Syncing...';
    } else if (status.isOnline) {
      return 'Online';
    } else {
      return 'Offline';
    }
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Compact sync status indicator for app bars
class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final syncStatusAsync = ref.watch(syncStatusProvider);

    return syncStatusAsync.when(
      data: (status) {
        return FutureBuilder<int>(
          future: status.pendingChangesCount,
          builder: (context, pendingSnapshot) {
            final hasPending =
                pendingSnapshot.data != null && pendingSnapshot.data! > 0;

            return Stack(
              children: [
                IconButton(
                  onPressed: () async {
                    // Trigger manual sync
                    final result = await ref.read(
                      performManualSyncProvider.future,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message),
                          backgroundColor:
                              result.success
                                  ? null
                                  : theme.colorScheme.error,
                        ),
                      );
                    }
                  },
                  icon:
                      status.isSyncing
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          )
                          : Icon(
                            status.isOnline
                                ? Icons.sync
                                : Icons.sync_disabled,
                            color:
                                status.isOnline
                                    ? null
                                    : theme.colorScheme.error,
                          ),
                  tooltip: _getTooltip(status, pendingSnapshot.data),
                ),
                if (hasPending && !status.isSyncing)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
      loading: () => IconButton(onPressed: null, icon: const Icon(Icons.sync)),
      error: (_, __) => IconButton(onPressed: null, icon: const Icon(Icons.sync_problem)),
    );
  }

  String _getTooltip(SyncStatus status, int? pendingCount) {
    final parts = <String>[];

    if (status.isSyncing) {
      parts.add('Syncing...');
    } else if (status.isOnline) {
      parts.add('Online');
    } else {
      parts.add('Offline');
    }

    if (pendingCount != null && pendingCount > 0) {
      parts.add('$pendingCount pending changes');
    }

    if (status.lastSyncTime != null) {
      final now = DateTime.now();
      final difference = now.difference(status.lastSyncTime!);
      if (difference.inMinutes < 1) {
        parts.add('Synced just now');
      } else {
        parts.add('Last sync: ${difference.inMinutes} min ago');
      }
    }

    return parts.join(' • ');
  }
}