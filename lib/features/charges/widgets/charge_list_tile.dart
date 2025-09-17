import 'package:flutter/material.dart';

import '../models/charge.dart';

class ChargeListTile extends StatelessWidget {
  final Charge charge;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;

  const ChargeListTile({
    super.key,
    required this.charge,
    this.onTap,
    this.onEdit,
    this.onToggleStatus,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Charge icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getChargeColor(charge.chargeType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getChargeIcon(charge.chargeType),
                  color: _getChargeColor(charge.chargeType),
                ),
              ),
              const SizedBox(width: 12),
              // Charge details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          charge.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!charge.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'INACTIVE',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (charge.autoApply) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'AUTO',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        if (charge.isMandatory) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'MANDATORY',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Code: ${charge.code}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _getCalculationDisplay(charge),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (charge.description != null && charge.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        charge.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Charge value
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getChargeValueDisplay(charge),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;
                    case 'toggle':
                      onToggleStatus?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          charge.isActive ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(charge.isActive ? 'Deactivate' : 'Activate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCalculationDisplay(Charge charge) {
    switch (charge.calculationType) {
      case CalculationType.fixed:
        return 'Fixed Amount';
      case CalculationType.percentage:
        return 'Percentage';
      case CalculationType.tiered:
        return 'Tiered (${charge.tiers.length} levels)';
      case CalculationType.formula:
        return 'Formula Based';
    }
  }

  String _getChargeValueDisplay(Charge charge) {
    switch (charge.calculationType) {
      case CalculationType.fixed:
        return '₹${charge.value?.toStringAsFixed(2) ?? "0.00"}';
      case CalculationType.percentage:
        return '${charge.value?.toStringAsFixed(0) ?? "0"}%';
      case CalculationType.tiered:
        if (charge.tiers.isNotEmpty) {
          final firstTier = charge.tiers.first;
          final lastTier = charge.tiers.last;
          return '₹${firstTier.chargeValue} - ₹${lastTier.chargeValue}';
        }
        return 'Tiered';
      case CalculationType.formula:
        return 'Formula';
    }
  }

  IconData _getChargeIcon(ChargeType type) {
    switch (type) {
      case ChargeType.service:
        return Icons.room_service;
      case ChargeType.delivery:
        return Icons.delivery_dining;
      case ChargeType.packaging:
        return Icons.inventory_2;
      case ChargeType.convenience:
        return Icons.account_balance_wallet;
      case ChargeType.custom:
        return Icons.tune;
    }
  }

  Color _getChargeColor(ChargeType type) {
    switch (type) {
      case ChargeType.service:
        return Colors.blue;
      case ChargeType.delivery:
        return Colors.green;
      case ChargeType.packaging:
        return Colors.orange;
      case ChargeType.convenience:
        return Colors.purple;
      case ChargeType.custom:
        return Colors.grey;
    }
  }
}