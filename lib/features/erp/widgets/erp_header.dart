import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../debug/clean_duplicate_sync_entries.dart';
import '../../../debug/fix_datetime_sync_queue.dart';
import '../../../debug/fix_pos_device_codes.dart';
import '../../../services/sync_service.dart';
import '../../../widgets/sync_status_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../../business/providers/business_provider.dart';
import '../../location/widgets/context_selector.dart';
import '../../sales/debug/debug_price_categories.dart';
import '../../theme/models/theme_state.dart';
import '../../theme/providers/theme_provider.dart';

class ERPHeader extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onMenuToggle;

  const ERPHeader({super.key, required this.onMenuToggle});

  @override
  Size get preferredSize => const Size.fromHeight(72); // Will be dynamic in build method

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final themeState = ref.watch(themeNotifierProvider);
    final user = ref.watch(currentUserProvider);
    final selectedBusiness = ref.watch(selectedBusinessProvider);

    final headerHeight = ResponsiveDimensions.getHeaderHeight(context);
    final contentPadding = ResponsiveDimensions.getContentPadding(context);

    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: contentPadding),
        child: Row(
          children: [
            // Menu Toggle Button
            IconButton(
              onPressed: onMenuToggle,
              icon: const Icon(Icons.menu),
              tooltip: 'Toggle Sidebar',
            ),

            ResponsiveSpacing.getHorizontalSpacing(context, 16),

            // Business Name and Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        selectedBusiness?.name ?? 'TYM ERP',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (selectedBusiness != null) ...[
                        ResponsiveSpacing.getHorizontalSpacing(context, 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            selectedBusiness.businessType.displayName,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(
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
                  ResponsiveSpacing.getVerticalSpacing(context, 2),
                  Row(
                    children: [
                      // Sync Status Widget
                      const SyncStatusWidget(),
                      if (user != null) ...[
                        ResponsiveSpacing.getHorizontalSpacing(context, 12),
                        Text(
                          'Welcome, ${user.fullName}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Location and POS Device Context
            if (selectedBusiness != null) ...[
              ResponsiveSpacing.getHorizontalSpacing(context, 16),
              const ContextSelectorButton(),
            ],

            // Header Actions
            Row(
              children: [
                // Sync Status Indicator
                const SyncStatusIndicator(),

                // Manual Sync Button
                IconButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final syncService = ref.read(syncServiceProvider);
                    final result = await syncService.performSync();
                    if (context.mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(result.message),
                          backgroundColor:
                              result.success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.sync),
                  tooltip: 'Manual Sync (Force)',
                ),

                // Debug: Comprehensive Debug Screen
                IconButton(
                  onPressed: () => context.pushNamed('debug'),
                  icon: const Icon(Icons.developer_mode),
                  tooltip: 'Debug & Development Tools',
                  color: Theme.of(context).colorScheme.error,
                ),
                
                // Debug: Sync Queue Inspector (only in debug mode)
                IconButton(
                  onPressed: () => context.pushNamed('sync-queue'),
                  icon: const Icon(Icons.bug_report),
                  tooltip: 'Inspect Sync Queue',
                ),

                // Debug: Fix POS Device Codes
                IconButton(
                  onPressed: () async {
                    await FixPOSDeviceCodes.resetStuckDeviceCode();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Reset stuck POS device code to POS001 - now run SQL migration in Supabase',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.devices),
                  tooltip: 'Fix POS Device Code Conflicts',
                ),

                // Debug: Fix DateTime Issues
                IconButton(
                  onPressed: () async {
                    await FixDateTimeSyncQueue.analyzeDateTimeIssues();
                    await FixDateTimeSyncQueue.fixAllDateTimeFields();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Fixed DateTime issues - check console and try sync',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.access_time),
                  tooltip: 'Fix DateTime Issues in Sync Queue',
                ),

                // Debug: Clean duplicates
                IconButton(
                  onPressed: () async {
                    await CleanDuplicateSyncEntries.cleanFailedPriceCategoryDuplicates();
                    await CleanDuplicateSyncEntries.printSyncQueueSummary();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Cleaned duplicate sync entries - check console',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.cleaning_services),
                  tooltip: 'Clean Duplicate Sync Entries',
                ),

                ResponsiveSpacing.getHorizontalSpacing(context, 4),

                // Debug: Check Price Categories (only in debug mode)
                if (selectedBusiness != null) ...[
                  IconButton(
                    onPressed: () async {
                      await DebugPriceCategories.checkBusinessPriceCategories(
                        selectedBusiness.id,
                      );
                      await DebugPriceCategories.printAllPriceCategories();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Check console for price categories debug info',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.bug_report),
                    tooltip: 'Debug Price Categories',
                  ),
                  ResponsiveSpacing.getHorizontalSpacing(context, 4),
                ],

                // Contact Support
                IconButton(
                  onPressed: () {
                    // TODO: Implement contact support functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contact support feature coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.help_outline),
                  tooltip: 'Contact Support',
                ),

                ResponsiveSpacing.getHorizontalSpacing(context, 4),

                // Theme Toggle
                IconButton(
                  onPressed: () => themeNotifier.toggleTheme(),
                  icon: Icon(themeState.themeMode.icon),
                  tooltip: 'Toggle Theme (${themeState.themeMode.displayName})',
                ),

                ResponsiveSpacing.getHorizontalSpacing(context, 4),

                // Theme Customization
                IconButton(
                  onPressed: () => themeNotifier.toggleCustomizing(),
                  icon: Icon(
                    themeState.isCustomizing ? Icons.close : Icons.palette,
                  ),
                  tooltip:
                      themeState.isCustomizing
                          ? 'Close Customization'
                          : 'Customize Theme',
                ),

                ResponsiveSpacing.getHorizontalSpacing(context, 8),

                // User Profile/Logout
                PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: ResponsiveDimensions.getIconSize(
                            context,
                            baseSize: 12,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Text(
                            user?.fullName.isNotEmpty == true
                                ? user!.fullName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize:
                                  ResponsiveTypography.getResponsiveFontSize(
                                    context,
                                    12,
                                  ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ResponsiveSpacing.getHorizontalSpacing(context, 8),
                        Icon(
                          Icons.expand_more,
                          size: ResponsiveDimensions.getIconSize(
                            context,
                            baseSize: 16,
                          ),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'profile',
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: ResponsiveDimensions.getIconSize(
                                  context,
                                  baseSize: 18,
                                ),
                              ),
                              ResponsiveSpacing.getHorizontalSpacing(
                                context,
                                12,
                              ),
                              const Text('Profile'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings_outlined,
                                size: ResponsiveDimensions.getIconSize(
                                  context,
                                  baseSize: 18,
                                ),
                              ),
                              ResponsiveSpacing.getHorizontalSpacing(
                                context,
                                12,
                              ),
                              const Text('Settings'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'debug',
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings_accessibility_outlined,
                                size: ResponsiveDimensions.getIconSize(
                                  context,
                                  baseSize: 18,
                                ),
                              ),
                              ResponsiveSpacing.getHorizontalSpacing(
                                context,
                                12,
                              ),
                              const Text('Debug Button'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: ResponsiveDimensions.getIconSize(
                                  context,
                                  baseSize: 18,
                                ),
                                color: Colors.red.shade600,
                              ),
                              ResponsiveSpacing.getHorizontalSpacing(
                                context,
                                12,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(color: Colors.red.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                  onSelected: (value) async {
                    switch (value) {
                      case 'profile':
                        // TODO: Navigate to profile screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile feature coming soon'),
                          ),
                        );
                        break;
                      case 'settings':
                        // TODO: Navigate to settings screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings feature coming soon'),
                          ),
                        );
                        break;
                      case 'logout':
                        try {
                          await authNotifier.signOut();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                        break;
                      case 'debug':
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => TYMWaiterApp(),
                        //   ),
                        // );
                        break;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
