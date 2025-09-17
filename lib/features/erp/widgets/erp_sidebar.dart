import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../models/erp_module.dart';

class ERPSidebar extends ConsumerWidget {
  final bool isExpanded;
  final ERPModule? currentModule;

  const ERPSidebar({super.key, required this.isExpanded, this.currentModule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedWidth = ResponsiveDimensions.getSidebarExpandedWidth(context);
    final collapsedWidth = ResponsiveDimensions.getSidebarCollapsedWidth(
      context,
    );
    final logoAreaHeight = ResponsiveDimensions.getLogoAreaHeight(context);
    final navItemHeight = ResponsiveDimensions.getNavItemHeight(context);
    final contentPadding = ResponsiveDimensions.getContentPadding(context);
    final iconSize = ResponsiveDimensions.getIconSize(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isExpanded ? expandedWidth : collapsedWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Only show expanded content when width is sufficient
          final showExpandedContent = constraints.maxWidth > (collapsedWidth + 20);
          
          return Material(
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
              // Logo/Brand Area
              Container(
                height: logoAreaHeight,
                padding: EdgeInsets.all(showExpandedContent ? contentPadding : 4.0),
                child: Row(
                  mainAxisAlignment: showExpandedContent ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Container(
                      width: showExpandedContent ? iconSize * 1.6 : iconSize * 1.2,
                      height: showExpandedContent ? iconSize * 1.6 : iconSize * 1.2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.business,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: showExpandedContent ? iconSize : iconSize * 0.8,
                      ),
                    ),
                    if (showExpandedContent) ...[
                      ResponsiveSpacing.getHorizontalSpacing(context, 12),
                      Expanded(
                        child: Text(
                          'TYM ERP',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Divider(height: 1),

              // Navigation Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: contentPadding * 0.5),
                  children: [
                    // ERP Modules
                    ...ERPModule.values.map((module) {
                        final isSelected = currentModule == module;

                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: contentPadding * 0.5,
                            vertical: 2,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => context.go(module.route),
                              child: Container(
                                height: navItemHeight,
                                padding: EdgeInsets.symmetric(
                                  horizontal: showExpandedContent ? contentPadding : 4.0,
                                  vertical: contentPadding * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: showExpandedContent ? MainAxisAlignment.start : MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      module.icon,
                                      size: showExpandedContent ? iconSize : iconSize * 0.9,
                                      color:
                                          isSelected
                                              ? Theme.of(
                                                context,
                                              ).colorScheme.onPrimaryContainer
                                              : Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                    ),
                                    if (showExpandedContent) ...[
                                      ResponsiveSpacing.getHorizontalSpacing(
                                        context,
                                        16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          module.displayName,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color:
                                                isSelected
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                    // Management Section Divider
                    if (showExpandedContent)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: contentPadding,
                          vertical: contentPadding * 0.75,
                        ),
                        child: Text(
                          'MANAGEMENT',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                    // Locations Management
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: contentPadding * 0.5,
                        vertical: 2,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => context.pushNamed('locations'),
                          child: Container(
                            height: navItemHeight,
                            padding: EdgeInsets.symmetric(
                              horizontal: showExpandedContent ? contentPadding : 4.0,
                              vertical: contentPadding * 0.75,
                            ),
                            child: Row(
                              mainAxisAlignment: showExpandedContent ? MainAxisAlignment.start : MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: showExpandedContent ? iconSize : iconSize * 0.9,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                if (showExpandedContent) ...[
                                  ResponsiveSpacing.getHorizontalSpacing(context, 16),
                                  Expanded(
                                    child: Text(
                                      'Locations',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // POS Devices Management
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: contentPadding * 0.5,
                        vertical: 2,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => context.pushNamed('posDevices'),
                          child: Container(
                            height: navItemHeight,
                            padding: EdgeInsets.symmetric(
                              horizontal: showExpandedContent ? contentPadding : 4.0,
                              vertical: contentPadding * 0.75,
                            ),
                            child: Row(
                              mainAxisAlignment: showExpandedContent ? MainAxisAlignment.start : MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.point_of_sale,
                                  size: showExpandedContent ? iconSize : iconSize * 0.9,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                if (showExpandedContent) ...[
                                  ResponsiveSpacing.getHorizontalSpacing(context, 16),
                                  Expanded(
                                    child: Text(
                                      'POS Devices',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Version Info
              if (showExpandedContent)
                Container(
                  padding: EdgeInsets.all(contentPadding),
                  child: Text(
                    'v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
