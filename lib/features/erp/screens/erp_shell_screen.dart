import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../business/providers/business_provider.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/screens/subscription_management_screen.dart';
import '../../subscription/widgets/subscription_status_card.dart';
import '../../theme/models/theme_state.dart';
import '../../theme/providers/theme_provider.dart';
import '../models/erp_module.dart';
import '../widgets/erp_header.dart';
import '../widgets/erp_sidebar.dart';

class ERPShellScreen extends ConsumerStatefulWidget {
  final Widget child;
  final String location;

  const ERPShellScreen({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  ConsumerState<ERPShellScreen> createState() => _ERPShellScreenState();
}

class _ERPShellScreenState extends ConsumerState<ERPShellScreen> {
  bool? _isSidebarExpanded;

  ERPModule? _getCurrentModule() {
    for (final module in ERPModule.values) {
      if (widget.location.startsWith(module.route)) {
        return module;
      }
    }
    return null;
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !(_isSidebarExpanded ?? _getDefaultSidebarState());
    });
  }

  bool _getDefaultSidebarState() {
    return !ResponsiveLayout.shouldCollapseSidebar(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeNotifierProvider);
    final currentModule = _getCurrentModule();
    final screenPadding = ResponsiveDimensions.getScreenPadding(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);

    // Initialize sidebar state based on screen size if not set
    _isSidebarExpanded ??= _getDefaultSidebarState();

    // Check subscription status for current business
    if (selectedBusiness == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'No Business Selected',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Please select a business to continue',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Watch subscription status
    final canAccessAsync = ref.watch(canAccessERPProvider(selectedBusiness.id));

    return canAccessAsync.when(
      data: (canAccess) {
        if (!canAccess) {
          return _buildSubscriptionBlockedView(context, selectedBusiness.id);
        }
        return _buildERPShell(
          context,
          themeState,
          currentModule,
          screenPadding,
        );
      },
      loading:
          () => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Checking subscription status...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
      error:
          (error, _) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Subscription Check Failed',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => ref.invalidate(
                          canAccessERPProvider(selectedBusiness.id),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSubscriptionBlockedView(
    BuildContext context,
    String businessId,
  ) {
    final screenPadding = ResponsiveDimensions.getScreenPadding(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 96,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Subscription Required',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your subscription has expired or is not active. Please renew your subscription to continue using TYM ERP.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Subscription Status Card
                SubscriptionStatusCard(
                  businessId: businessId,
                  onManageSubscription:
                      () => _navigateToSubscriptionManagement(businessId),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed:
                          () =>
                              ref.invalidate(canAccessERPProvider(businessId)),
                      child: const Text('Refresh Status'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed:
                          () => _navigateToSubscriptionManagement(businessId),
                      child: const Text('Manage Subscription'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildERPShell(
    BuildContext context,
    dynamic themeState,
    ERPModule? currentModule,
    double screenPadding,
  ) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          ERPHeader(onMenuToggle: _toggleSidebar),

          // Main Content Area
          Expanded(
            child: Row(
              children: [
                // Sidebar
                ERPSidebar(
                  isExpanded: _isSidebarExpanded!,
                  currentModule: currentModule,
                ),

                // Main Content
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    child: Column(
                      children: [
                        // Theme Customization Panel (when active)
                        if (themeState.isCustomizing)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(screenPadding),
                            child: _buildThemeCustomizationPanel(context, ref),
                          ),

                        // Module Content
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: screenPadding,
                              right: screenPadding,
                              bottom: screenPadding,
                              top: themeState.isCustomizing ? 0 : screenPadding,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.shadow.withValues(alpha: 0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: widget.child,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCustomizationPanel(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final themeState = ref.watch(themeNotifierProvider);
    final cardPadding = ResponsiveDimensions.getCardPadding(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                ResponsiveSpacing.getHorizontalSpacing(context, 8),
                Text(
                  'Theme Customization',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => themeNotifier.toggleCustomizing(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                ),
              ],
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 16),

            // Theme Mode Selection
            Text(
              'Theme Mode',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 8),
            Row(
              children:
                  AppThemeMode.values.map((mode) {
                    final isSelected = themeState.themeMode == mode;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(mode.icon, size: 16),
                            ResponsiveSpacing.getHorizontalSpacing(context, 4),
                            Text(mode.displayName),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (_) => themeNotifier.setThemeMode(mode),
                      ),
                    );
                  }).toList(),
            ),

            ResponsiveSpacing.getVerticalSpacing(context, 16),

            // Color Scheme Selection
            Text(
              'Color Scheme',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  AppColorScheme.values.map((colorScheme) {
                    final isSelected = themeState.colorScheme == colorScheme;
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          ResponsiveSpacing.getHorizontalSpacing(context, 8),
                          Text(colorScheme.displayName),
                        ],
                      ),
                      selected: isSelected,
                      onSelected:
                          (_) => themeNotifier.setColorScheme(colorScheme),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSubscriptionManagement(String businessId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => SubscriptionManagementScreen(businessId: businessId),
      ),
    );
  }
}
