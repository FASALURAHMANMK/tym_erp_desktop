import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../charges/models/charge.dart';
import '../../charges/providers/charge_provider.dart';
import '../providers/cart_provider.dart';

class CartChargesSection extends ConsumerStatefulWidget {
  const CartChargesSection({super.key});

  @override
  ConsumerState<CartChargesSection> createState() => _CartChargesSectionState();
}

class _CartChargesSectionState extends ConsumerState<CartChargesSection> {
  static final _logger = Logger('CartChargesSection');
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartNotifierProvider);
    final theme = Theme.of(context);

    if (cart == null) {
      return const SizedBox.shrink();
    }

    final hasCharges = cart.appliedCharges.isNotEmpty;
    final chargesAmount = cart.calculatedChargesAmount;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.add_card,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Charges',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (hasCharges) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '₹${chargesAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (_isExpanded) ...[
            const Divider(height: 1),

            // Applied charges list
            if (hasCharges) ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.appliedCharges.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final appliedCharge = cart.appliedCharges[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      appliedCharge.chargeName,
                      style: theme.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      appliedCharge.isManual 
                          ? 'Manual charge'
                          : '${appliedCharge.chargeType} - ${appliedCharge.calculationType}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${appliedCharge.chargeAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!appliedCharge.isManual) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'AUTO',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            ref
                                .read(cartNotifierProvider.notifier)
                                .removeCharge(appliedCharge.chargeId ?? appliedCharge.id);
                            _logger.info(
                              'Removed charge: ${appliedCharge.chargeName}',
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_card_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No charges applied',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Apply automatic charges button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await ref
                            .read(cartNotifierProvider.notifier)
                            .applyCharges();
                        _logger.info('Applied automatic charges');
                      },
                      icon: const Icon(Icons.auto_mode, size: 18),
                      label: const Text('Apply Auto'),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Add manual charge button
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        _showAddChargeDialog(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 8),
                          Text('Add Charge'),
                        ],
                      ),
                    ),
                  ),

                  // Clear all charges button
                  if (hasCharges) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(cartNotifierProvider.notifier)
                            .clearAllCharges();
                        _logger.info('Cleared all charges');
                      },
                      icon: const Icon(Icons.clear_all),
                      tooltip: 'Clear all charges',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showAddChargeDialog(BuildContext context) async {
    final charges = await ref.read(activeChargesProvider.future);
    final cart = ref.read(cartNotifierProvider);

    if (cart == null || charges.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No charges available to add')),
        );
      }
      return;
    }

    if (!mounted) return;

    await showDialog<Charge>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Charge'),
            content: SizedBox(
              width: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: charges.length,
                itemBuilder: (context, index) {
                  final charge = charges[index];
                  final isApplied = cart.appliedCharges.any(
                    (c) => c.chargeId == charge.id,
                  );

                  return ListTile(
                    leading: Icon(
                      Icons.add_card,
                      color:
                          isApplied
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5)
                              : Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      charge.name,
                      style: TextStyle(
                        color:
                            isApplied
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5)
                                : null,
                      ),
                    ),
                    subtitle: Text(
                      '${charge.chargeType.name} - ${_getChargeValueDisplay(charge)}',
                    ),
                    trailing:
                        isApplied
                            ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Applied',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            )
                            : null,
                    enabled: !isApplied,
                    onTap:
                        isApplied
                            ? null
                            : () {
                              ref
                                  .read(cartNotifierProvider.notifier)
                                  .addManualCharge(charge);
                              Navigator.of(context).pop();
                              _logger.info(
                                'Added manual charge: ${charge.name}',
                              );
                            },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  String _getChargeValueDisplay(Charge charge) {
    switch (charge.calculationType) {
      case CalculationType.fixed:
        return '₹${charge.value?.toStringAsFixed(2) ?? '0.00'}';
      case CalculationType.percentage:
        return '${charge.value ?? 0}%';
      case CalculationType.tiered:
        return 'Tiered';
      case CalculationType.formula:
        return 'Formula-based';
    }
  }
}
