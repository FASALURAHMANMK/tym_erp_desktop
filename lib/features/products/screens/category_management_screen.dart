import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../services/sync_queue_service.dart';
import '../../business/providers/business_provider.dart';
import '../domain/models/product_category.dart';
import '../providers/product_providers.dart';
import '../providers/product_repository_provider.dart';
import '../widgets/category_form_dialog.dart';

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState
    extends ConsumerState<CategoryManagementScreen> {
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
        body: Center(child: Text('No business selected')),
      );
    }

    final categoryState = ref.watch(categoryListNotifierProvider);
    final contentPadding = ResponsiveDimensions.getContentPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Categories',
          style: ResponsiveTypography.getScaledTextStyle(
            context,
            Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        actions: [
          // Clear old sync queue items (temporary)
          IconButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Sync Queue?'),
                  content: const Text('This will clear all pending sync items. Use this to remove old invalid entries.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              
              if (confirm == true) {
                await SyncQueueService().clearQueue();
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Sync queue cleared')),
                  );
                }
              }
            },
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear Sync Queue',
          ),
          IconButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final errorColor = Theme.of(context).colorScheme.error;
              
              try {
                final repository = await ref.read(productRepositoryFutureProvider.future);
                final result = await repository.syncPendingChanges();
                
                if (mounted) {
                  result.fold(
                    (failure) => scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Sync failed: ${failure.message}'),
                        backgroundColor: errorColor,
                      ),
                    ),
                    (_) => scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Sync completed successfully')),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Sync failed: $e'),
                      backgroundColor: errorColor,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.sync),
            tooltip: 'Sync to Cloud',
          ),
          IconButton(
            onPressed: () => _showCategoryDialog(context),
            icon: const Icon(Icons.add),
            tooltip: 'Add Category',
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

            // Categories list
            Expanded(
              child:
                  categoryState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : categoryState.error != null
                      ? _buildErrorState(context, categoryState.error!)
                      : _buildCategoriesList(context, categoryState.categories),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context),
        tooltip: 'Add Category',
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
            hintText: 'Search categories...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                _searchQuery.isNotEmpty
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

  Widget _buildCategoriesList(
    BuildContext context,
    List<ProductCategory> categories,
  ) {
    if (categories.isEmpty) {
      return _buildEmptyState(context);
    }

    // Filter categories based on search
    final filteredCategories =
        categories.where((category) {
          if (_searchQuery.isEmpty) return true;

          return category.name.toLowerCase().contains(_searchQuery) ||
              (category.description?.toLowerCase().contains(_searchQuery) ??
                  false);
        }).toList();

    if (filteredCategories.isEmpty) {
      return _buildNoSearchResults(context);
    }

    // Sort by display order, then by name
    filteredCategories.sort((a, b) {
      final orderCompare = a.displayOrder.compareTo(b.displayOrder);
      if (orderCompare != 0) return orderCompare;
      return a.name.compareTo(b.name);
    });

    return ListView.separated(
      itemCount: filteredCategories.length,
      separatorBuilder:
          (context, index) => ResponsiveSpacing.getVerticalSpacing(context, 8),
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return _buildCategoryTile(context, category);
      },
    );
  }

  Widget _buildCategoryTile(BuildContext context, ProductCategory category) {
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
          child: Icon(
            Icons.category,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          category.name,
          style: ResponsiveTypography.getScaledTextStyle(
            context,
            theme.textTheme.titleMedium,
          ),
        ),
        subtitle:
            category.description != null
                ? Text(
                  category.description!,
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
            if (!category.isActive)
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
                  )?.copyWith(color: theme.colorScheme.error),
                ),
              ),
            IconButton(
              onPressed: () => _showCategoryDialog(context, category: category),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Category',
            ),
            IconButton(
              onPressed: () => _showDeleteDialog(context, category),
              icon: const Icon(Icons.delete),
              color: theme.colorScheme.error,
              tooltip: 'Delete Category',
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
            Icons.category_outlined,
            size: ResponsiveDimensions.getIconSize(context) * 3,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          Text(
            'No categories yet',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            'Add your first category to organize products',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium,
            )?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          ElevatedButton.icon(
            onPressed: () => _showCategoryDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
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
            'No categories found',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            'Try adjusting your search',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium,
            )?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
            'Error loading categories',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            error,
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium,
            )?.copyWith(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 16),
          ElevatedButton.icon(
            onPressed:
                () =>
                    ref
                        .read(categoryListNotifierProvider.notifier)
                        .loadCategories(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, {ProductCategory? category}) {
    showDialog(
      context: context,
      builder: (context) => CategoryFormDialog(category: category),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductCategory category) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Category'),
            content: Text(
              'Are you sure you want to delete "${category.name}"?\n\n'
              'Note: You cannot delete a category that has products assigned to it.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  final result = await ref
                      .read(categoryListNotifierProvider.notifier)
                      .deleteCategory(category.id);

                  if (mounted) {
                    result.fold(
                      (failure) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${failure.message}'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      (_) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category deleted successfully'),
                        ),
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
