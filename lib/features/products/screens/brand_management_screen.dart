import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../business/providers/business_provider.dart';
import '../domain/models/product_brand.dart';
import '../providers/product_providers.dart';
import '../providers/product_repository_provider.dart';
import '../widgets/brand_form_dialog.dart';

class BrandManagementScreen extends ConsumerStatefulWidget {
  const BrandManagementScreen({super.key});

  @override
  ConsumerState<BrandManagementScreen> createState() => _BrandManagementScreenState();
}

class _BrandManagementScreenState extends ConsumerState<BrandManagementScreen> {
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

    final brandState = ref.watch(brandListNotifierProvider);
    final contentPadding = ResponsiveDimensions.getContentPadding(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Brands',
          style: ResponsiveTypography.getScaledTextStyle(
            context, 
            Theme.of(context).textTheme.headlineSmall
          ),
        ),
        actions: [
          // Sync button with pending indicator
          FutureBuilder<int>(
            future: () async {
              final repository = await ref.read(productRepositoryFutureProvider.future);
              return repository.getPendingChangesCount();
            }(),
            builder: (context, snapshot) {
              final hasPendingChanges = (snapshot.data ?? 0) > 0;
              
              return Stack(
                children: [
                  IconButton(
                    onPressed: () async {
                      final repository = await ref.read(productRepositoryFutureProvider.future);
                      final result = await repository.syncPendingChanges();
                      
                      if (mounted) {
                        result.fold(
                          (failure) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sync failed: ${failure.message}'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sync completed successfully'),
                              ),
                            );
                            // Reload brands to reflect any changes
                            ref.read(brandListNotifierProvider.notifier).loadBrands();
                          },
                        );
                      }
                    },
                    icon: const Icon(Icons.sync),
                    tooltip: hasPendingChanges 
                      ? 'Sync to Cloud (${snapshot.data} pending)' 
                      : 'Sync to Cloud',
                  ),
                  if (hasPendingChanges)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () => _showBrandDialog(context),
            icon: const Icon(Icons.add),
            tooltip: 'Add Brand',
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
            
            // Brands list
            Expanded(
              child: brandState.isLoading 
                ? const Center(child: CircularProgressIndicator())
                : brandState.error != null
                  ? _buildErrorState(context, brandState.error!)
                  : _buildBrandsList(context, brandState.brands),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBrandDialog(context),
        tooltip: 'Add Brand',
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
            hintText: 'Search brands...',
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

  Widget _buildBrandsList(BuildContext context, List<ProductBrand> brands) {
    if (brands.isEmpty) {
      return _buildEmptyState(context);
    }

    // Filter brands based on search
    final filteredBrands = brands.where((brand) {
      if (_searchQuery.isEmpty) return true;
      
      return brand.name.toLowerCase().contains(_searchQuery) ||
             (brand.description?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();

    if (filteredBrands.isEmpty) {
      return _buildNoSearchResults(context);
    }

    // Sort by display order, then by name
    filteredBrands.sort((a, b) {
      final orderCompare = a.displayOrder.compareTo(b.displayOrder);
      if (orderCompare != 0) return orderCompare;
      return a.name.compareTo(b.name);
    });

    return ListView.separated(
      itemCount: filteredBrands.length,
      separatorBuilder: (context, index) => 
          ResponsiveSpacing.getVerticalSpacing(context, 8),
      itemBuilder: (context, index) {
        final brand = filteredBrands[index];
        return _buildBrandTile(context, brand);
      },
    );
  }

  Widget _buildBrandTile(BuildContext context, ProductBrand brand) {
    final theme = Theme.of(context);
    
    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: brand.logoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    brand.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.branding_watermark,
                        color: theme.colorScheme.onPrimaryContainer,
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.branding_watermark,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
        ),
        title: Text(
          brand.name,
          style: ResponsiveTypography.getScaledTextStyle(
            context,
            theme.textTheme.titleMedium,
          ),
        ),
        subtitle: brand.description != null
            ? Text(
                brand.description!,
                style: ResponsiveTypography.getScaledTextStyle(
                  context,
                  theme.textTheme.bodySmall,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!brand.isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Inactive',
                  style: ResponsiveTypography.getScaledTextStyle(
                    context,
                    theme.textTheme.bodySmall,
                  )?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            IconButton(
              onPressed: () => _showBrandDialog(context, brand: brand),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Brand',
            ),
            IconButton(
              onPressed: () => _showDeleteDialog(context, brand),
              icon: const Icon(Icons.delete),
              color: theme.colorScheme.error,
              tooltip: 'Delete Brand',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.branding_watermark_outlined,
            size: ResponsiveDimensions.getIconSize(context) * 3,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          Text(
            'No brands yet',
            style: ResponsiveTypography.getScaledTextStyle(
              context, 
              Theme.of(context).textTheme.headlineSmall
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            'Add brands to organize your products',
            style: ResponsiveTypography.getScaledTextStyle(
              context, 
              Theme.of(context).textTheme.bodyMedium
            )?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          ElevatedButton.icon(
            onPressed: () => _showBrandDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Brand'),
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
            size: ResponsiveDimensions.getIconSize(context) * 3,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          Text(
            'No brands found',
            style: ResponsiveTypography.getScaledTextStyle(
              context, 
              Theme.of(context).textTheme.headlineSmall
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            'Try adjusting your search',
            style: ResponsiveTypography.getScaledTextStyle(
              context, 
              Theme.of(context).textTheme.bodyMedium
            )?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
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
            'Error loading brands',
            style: ResponsiveTypography.getScaledTextStyle(
              context, 
              Theme.of(context).textTheme.headlineSmall
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            error,
            style: ResponsiveTypography.getScaledTextStyle(
              context, 
              Theme.of(context).textTheme.bodyMedium
            )?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 16),
          ElevatedButton.icon(
            onPressed: () => ref.read(brandListNotifierProvider.notifier)
                .loadBrands(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showBrandDialog(BuildContext context, {ProductBrand? brand}) {
    showDialog(
      context: context,
      builder: (context) => BrandFormDialog(brand: brand),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductBrand brand) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Brand'),
        content: Text(
          'Are you sure you want to delete "${brand.name}"?\n\n'
          'Note: You cannot delete a brand that has products assigned to it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final result = await ref.read(brandListNotifierProvider.notifier)
                  .deleteBrand(brand.id);
              
              if (mounted) {
                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${failure.message}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  (_) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Brand deleted successfully')),
                  ),
                );
              }
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
}