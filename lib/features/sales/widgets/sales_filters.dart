import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/sales_provider.dart';

class SalesFilters extends ConsumerStatefulWidget {
  const SalesFilters({super.key});

  @override
  ConsumerState<SalesFilters> createState() => _SalesFiltersState();
}

class _SalesFiltersState extends ConsumerState<SalesFilters> {
  final _searchController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  // Quick date filters
  final _quickFilters = [
    {'label': 'Today', 'days': 0},
    {'label': 'Yesterday', 'days': 1},
    {'label': 'Last 7 days', 'days': 7},
    {'label': 'Last 30 days', 'days': 30},
  ];

  String? _selectedQuickFilter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _updateSearchQuery();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyQuickFilter(String filterLabel) {
    final now = DateTime.now();
    DateTime? fromDate;
    DateTime? toDate;

    switch (filterLabel) {
      case 'Today':
        fromDate = DateTime(now.year, now.month, now.day);
        toDate = fromDate.add(const Duration(days: 1));
        break;
      case 'Yesterday':
        fromDate = DateTime(now.year, now.month, now.day - 1);
        toDate = fromDate.add(const Duration(days: 1));
        break;
      case 'Last 7 days':
        fromDate = DateTime(now.year, now.month, now.day - 7);
        toDate = DateTime(now.year, now.month, now.day + 1);
        break;
      case 'Last 30 days':
        fromDate = DateTime(now.year, now.month, now.day - 30);
        toDate = DateTime(now.year, now.month, now.day + 1);
        break;
    }

    final currentFilter = ref.read(salesFilterProvider);
    ref.read(salesFilterProvider.notifier).state = currentFilter.copyWith(
      fromDate: fromDate,
      toDate: toDate,
    );

    setState(() {
      _selectedQuickFilter = filterLabel;
    });
  }

  void _updateSearchQuery() {
    final currentFilter = ref.read(salesFilterProvider);
    ref.read(salesFilterProvider.notifier).state = currentFilter.copyWith(
      searchQuery: _searchController.text.trim().isEmpty 
          ? null 
          : _searchController.text.trim(),
    );
  }

  void _showCustomDatePicker() async {
    final currentFilter = ref.read(salesFilterProvider);
    
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: currentFilter.fromDate != null && currentFilter.toDate != null
          ? DateTimeRange(
              start: currentFilter.fromDate!,
              end: currentFilter.toDate!.subtract(const Duration(days: 1)),
            )
          : null,
    );

    if (dateRange != null) {
      ref.read(salesFilterProvider.notifier).state = currentFilter.copyWith(
        fromDate: dateRange.start,
        toDate: dateRange.end.add(const Duration(days: 1)),
      );
      
      setState(() {
        _selectedQuickFilter = null;
      });
    }
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(salesFilterProvider.notifier).state = const SalesFilter();
    setState(() {
      _selectedQuickFilter = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentFilter = ref.watch(salesFilterProvider);
    final sales = ref.watch(filteredSalesProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // First row: Search and quick filters
          Row(
            children: [
              // Search field
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by order number, customer name, or phone...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _updateSearchQuery();
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Quick date filters
              ...(_quickFilters.map((filter) {
                final isSelected = _selectedQuickFilter == filter['label'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter['label'] as String),
                    selected: isSelected,
                    onSelected: (_) => _applyQuickFilter(filter['label'] as String),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    checkmarkColor: theme.colorScheme.primary,
                  ),
                );
              })),

              // Custom date range
              FilterChip(
                label: const Text('Custom Range'),
                selected: _selectedQuickFilter == null && 
                         currentFilter.fromDate != null,
                onSelected: (_) => _showCustomDatePicker(),
                backgroundColor: theme.colorScheme.surface,
                selectedColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                checkmarkColor: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),

              // Clear filters
              if (currentFilter.searchQuery != null ||
                  currentFilter.orderType != null ||
                  currentFilter.paymentMethod != null)
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
            ],
          ),

          // Second row: Date range display and additional filters
          if (currentFilter.fromDate != null || currentFilter.toDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getDateRangeText(currentFilter),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${sales.length} orders found',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getDateRangeText(SalesFilter filter) {
    if (filter.fromDate == null) return '';
    
    final from = _dateFormat.format(filter.fromDate!);
    if (filter.toDate == null) return 'From $from';
    
    final to = _dateFormat.format(filter.toDate!.subtract(const Duration(days: 1)));
    return '$from - $to';
  }
}