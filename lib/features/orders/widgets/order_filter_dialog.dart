import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_status.dart';

class OrderFilterDialog extends StatefulWidget {
  final PaymentStatus? initialPaymentStatus;
  final DateTime? initialFromDate;
  final DateTime? initialToDate;
  
  const OrderFilterDialog({
    super.key,
    this.initialPaymentStatus,
    this.initialFromDate,
    this.initialToDate,
  });

  @override
  State<OrderFilterDialog> createState() => _OrderFilterDialogState();
}

class _OrderFilterDialogState extends State<OrderFilterDialog> {
  PaymentStatus? _paymentStatus;
  DateTime? _fromDate;
  DateTime? _toDate;
  
  final _dateFormat = DateFormat('dd MMM yyyy');
  
  @override
  void initState() {
    super.initState();
    _paymentStatus = widget.initialPaymentStatus;
    _fromDate = widget.initialFromDate;
    _toDate = widget.initialToDate;
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advanced Filters',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Payment status filter
            Text(
              'Payment Status',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _paymentStatus == null,
                  onSelected: (selected) {
                    setState(() {
                      _paymentStatus = null;
                    });
                  },
                ),
                ...PaymentStatus.values.map((status) {
                  return FilterChip(
                    label: Text(status.displayName),
                    selected: _paymentStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        _paymentStatus = selected ? status : null;
                      });
                    },
                  );
                }),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Date range filter
            Text(
              'Date Range',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                // From date
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(true),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _fromDate != null
                                  ? _dateFormat.format(_fromDate!)
                                  : 'From Date',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _fromDate != null
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          if (_fromDate != null)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _fromDate = null;
                                });
                              },
                              icon: const Icon(Icons.clear, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // To date
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(false),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _toDate != null
                                  ? _dateFormat.format(_toDate!)
                                  : 'To Date',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _toDate != null
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          if (_toDate != null)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _toDate = null;
                                });
                              },
                              icon: const Icon(Icons.clear, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Quick date presets
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Today'),
                  onPressed: () {
                    setState(() {
                      _fromDate = DateTime.now();
                      _toDate = DateTime.now();
                    });
                  },
                ),
                ActionChip(
                  label: const Text('Yesterday'),
                  onPressed: () {
                    final yesterday = DateTime.now().subtract(const Duration(days: 1));
                    setState(() {
                      _fromDate = yesterday;
                      _toDate = yesterday;
                    });
                  },
                ),
                ActionChip(
                  label: const Text('Last 7 Days'),
                  onPressed: () {
                    setState(() {
                      _fromDate = DateTime.now().subtract(const Duration(days: 7));
                      _toDate = DateTime.now();
                    });
                  },
                ),
                ActionChip(
                  label: const Text('Last 30 Days'),
                  onPressed: () {
                    setState(() {
                      _fromDate = DateTime.now().subtract(const Duration(days: 30));
                      _toDate = DateTime.now();
                    });
                  },
                ),
                ActionChip(
                  label: const Text('This Month'),
                  onPressed: () {
                    final now = DateTime.now();
                    setState(() {
                      _fromDate = DateTime(now.year, now.month, 1);
                      _toDate = DateTime(now.year, now.month + 1, 0);
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _paymentStatus = null;
                      _fromDate = null;
                      _toDate = null;
                    });
                  },
                  child: const Text('Clear All'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'paymentStatus': _paymentStatus,
                      'fromDate': _fromDate,
                      'toDate': _toDate,
                    });
                  },
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _selectDate(bool isFromDate) async {
    final initialDate = isFromDate ? _fromDate : _toDate;
    final firstDate = isFromDate 
        ? DateTime(2020) 
        : (_fromDate ?? DateTime(2020));
    final lastDate = isFromDate 
        ? (_toDate ?? DateTime.now())
        : DateTime.now();
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }
}