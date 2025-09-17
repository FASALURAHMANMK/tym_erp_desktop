import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/price_category.dart';
import '../providers/price_category_provider.dart';
import '../widgets/enhanced_tables_view.dart';
import '../widgets/product_grid_view.dart';
import '../widgets/cart_view.dart';
import '../widgets/on_hold_view.dart';
import '../widgets/settlement_view.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';
import '../../../core/utils/logger.dart';

class NewSellScreen extends ConsumerStatefulWidget {
  const NewSellScreen({super.key});

  @override
  ConsumerState<NewSellScreen> createState() => _NewSellScreenState();
}

class _NewSellScreenState extends ConsumerState<NewSellScreen>
    with TickerProviderStateMixin {
  static final _logger = Logger('NewSellScreen');
  
  late TabController _tabController;
  final List<_TabInfo> _tabs = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeTabs(List<PriceCategory> priceCategories) {
    if (_isInitialized && _tabs.length == priceCategories.length + 2) return;
    
    _tabs.clear();
    
    // Add dynamic price category tabs
    for (final category in priceCategories) {
      // Special handling for Dine-In category - show as "Tables"
      if (category.type == PriceCategoryType.dineIn) {
        _tabs.add(_TabInfo(
          id: category.id,
          label: 'Tables',
          icon: Icons.table_restaurant,
          type: _TabType.tables,
          priceCategory: category,
        ));
      } else {
        // Regular price category tabs
        _tabs.add(_TabInfo(
          id: category.id,
          label: category.name,
          icon: _getIconForCategory(category.type),
          type: _TabType.priceCategory,
          priceCategory: category,
        ));
      }
    }
    
    // Add system tabs based on preferences
    // TODO: Check preferences to show/hide these tabs
    _tabs.add(_TabInfo(
      id: 'on_hold',
      label: 'On Hold',
      icon: Icons.pause_circle_outline,
      type: _TabType.onHold,
    ));
    
    _tabs.add(_TabInfo(
      id: 'settlement',
      label: 'Settlement',
      icon: Icons.payment,
      type: _TabType.settlement,
    ));
    
    // Only recreate tab controller if not initialized or tab count changed
    if (!_isInitialized || _tabController.length != _tabs.length) {
      // Store current index if possible
      final currentIndex = _isInitialized ? _tabController.index : 0;
      
      // Dispose old controller if exists
      if (_isInitialized) {
        _tabController.removeListener(_onTabChanged);
        _tabController.dispose();
      }
      
      // Create new controller
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.addListener(_onTabChanged);
      
      // Restore index or select first price category tab
      if (_tabs.isNotEmpty) {
        if (_isInitialized && currentIndex < _tabs.length) {
          _tabController.index = currentIndex;
        } else {
          final firstPriceCategoryIndex = _tabs.indexWhere(
            (tab) => tab.type == _TabType.priceCategory || tab.type == _TabType.tables
          );
          if (firstPriceCategoryIndex >= 0) {
            _tabController.index = firstPriceCategoryIndex;
          }
        }
        // Defer the initial tab change notification to avoid provider updates during build
        Future.microtask(() {
          if (mounted) {
            _onTabChanged();
          }
        });
      }
      
      _isInitialized = true;
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    
    final selectedTab = _tabs[_tabController.index];
    
    // Update selected price category if it's a price category tab
    // Defer the update to avoid modifying provider during build
    if (selectedTab.priceCategory != null) {
      Future.microtask(() {
        if (mounted) {
          ref.read(selectedPriceCategoryProvider.notifier).selectCategory(
            selectedTab.priceCategory!,
          );
        }
      });
    }
    
    _logger.info('Tab changed to: ${selectedTab.label}');
  }

  IconData _getIconForCategory(PriceCategoryType type) {
    switch (type) {
      case PriceCategoryType.dineIn:
        return Icons.restaurant;
      case PriceCategoryType.takeaway:
        return Icons.takeout_dining;
      case PriceCategoryType.delivery:
        return Icons.delivery_dining;
      case PriceCategoryType.catering:
        return Icons.dining;
      case PriceCategoryType.custom:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final selectedLocationAsync = ref.watch(selectedLocationNotifierProvider);
    
    return selectedLocationAsync.when(
      data: (selectedLocation) {
        if (selectedBusiness == null || selectedLocation == null) {
          return const Scaffold(
            body: Center(
              child: Text('Please select a business and location'),
            ),
          );
        }
        
        // Watch visible price categories
        final priceCategoriesAsync = ref.watch(
          visiblePriceCategoriesProvider((selectedBusiness.id, selectedLocation.id)),
        );
        
        return Scaffold(
          body: priceCategoriesAsync.when(
            data: (priceCategories) {
              _initializeTabs(priceCategories);
              
              return Column(
            children: [
              // Tab Bar
              Container(
                color: theme.colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  indicatorColor: theme.colorScheme.primary,
                  tabs: _tabs.map((tab) {
                    return Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tab.icon, size: 18),
                          const SizedBox(width: 8),
                          Text(tab.label),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Main Content Area
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs.map((tab) {
                    switch (tab.type) {
                      case _TabType.tables:
                        // Tables view handles its own layout
                        return const EnhancedTablesView();
                      case _TabType.priceCategory:
                        // Regular price category with cart on right
                        return Row(
                          children: [
                            Expanded(
                              flex: 60,
                              child: Container(
                                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                child: ProductGridView(
                                  priceCategory: tab.priceCategory!,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  border: Border(
                                    left: BorderSide(
                                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const CartView(),
                              ),
                            ),
                          ],
                        );
                      case _TabType.onHold:
                        return Row(
                          children: [
                            Expanded(
                              flex: 60,
                              child: Container(
                                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                child: const OnHoldView(),
                              ),
                            ),
                            Expanded(
                              flex: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  border: Border(
                                    left: BorderSide(
                                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const CartView(),
                              ),
                            ),
                          ],
                        );
                      case _TabType.settlement:
                        return Row(
                          children: [
                            Expanded(
                              flex: 60,
                              child: Container(
                                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                child: const SettlementView(),
                              ),
                            ),
                            Expanded(
                              flex: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  border: Border(
                                    left: BorderSide(
                                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const CartView(),
                              ),
                            ),
                          ],
                        );
                    }
                  }).toList(),
                ),
              ),
            ],
          );
            },
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading price categories: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(visiblePriceCategoriesProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading location: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(selectedLocationNotifierProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tab type enum
enum _TabType {
  tables,
  priceCategory,
  onHold,
  settlement,
}

// Tab info class
class _TabInfo {
  final String id;
  final String label;
  final IconData icon;
  final _TabType type;
  final PriceCategory? priceCategory;

  _TabInfo({
    required this.id,
    required this.label,
    required this.icon,
    required this.type,
    this.priceCategory,
  });
}