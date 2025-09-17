import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/responsive/responsive_utils.dart';

class ProductInventorySection extends StatelessWidget {
  final bool trackInventory;
  final TextEditingController displayOrderController;
  final ValueChanged<bool> onTrackInventoryChanged;

  const ProductInventorySection({
    super.key,
    required this.trackInventory,
    required this.displayOrderController,
    required this.onTrackInventoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.getCardPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Configure how inventory is tracked for this product',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Track Inventory Switch
            SwitchListTile(
              title: const Text('Track Inventory'),
              subtitle: const Text('Enable stock tracking for this product'),
              value: trackInventory,
              onChanged: onTrackInventoryChanged,
              secondary: Icon(
                trackInventory ? Icons.inventory : Icons.inventory_2_outlined,
                color: trackInventory 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            if (trackInventory) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Stock levels are managed per variation at each location. '
                        'You can set stock levels after creating the product.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Display Order
            TextFormField(
              controller: displayOrderController,
              decoration: const InputDecoration(
                labelText: 'Display Order',
                hintText: 'Order in which product appears (0 = first)',
                prefixIcon: Icon(Icons.sort),
                helperText: 'Lower numbers appear first in product lists',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ],
        ),
      ),
    );
  }
}