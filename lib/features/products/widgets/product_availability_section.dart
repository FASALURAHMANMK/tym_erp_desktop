import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';

class ProductAvailabilitySection extends StatelessWidget {
  final bool availableInPos;
  final bool availableInOnlineStore;
  final bool availableInCatalog;
  final bool skipKot;
  final ValueChanged<bool> onPosChanged;
  final ValueChanged<bool> onOnlineStoreChanged;
  final ValueChanged<bool> onCatalogChanged;
  final ValueChanged<bool> onSkipKotChanged;

  const ProductAvailabilitySection({
    super.key,
    required this.availableInPos,
    required this.availableInOnlineStore,
    required this.availableInCatalog,
    required this.skipKot,
    required this.onPosChanged,
    required this.onOnlineStoreChanged,
    required this.onCatalogChanged,
    required this.onSkipKotChanged,
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
              'Availability Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Control where this product is available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // POS Availability
            SwitchListTile(
              title: const Text('Available in POS'),
              subtitle: const Text('Product can be sold through Point of Sale'),
              value: availableInPos,
              onChanged: onPosChanged,
              secondary: Icon(
                Icons.point_of_sale,
                color: availableInPos 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(),

            // Online Store Availability
            SwitchListTile(
              title: const Text('Available in Online Store'),
              subtitle: const Text('Product can be sold through online channels'),
              value: availableInOnlineStore,
              onChanged: onOnlineStoreChanged,
              secondary: Icon(
                Icons.shopping_cart,
                color: availableInOnlineStore 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(),

            // Catalog Availability
            SwitchListTile(
              title: const Text('Available in Catalog'),
              subtitle: const Text('Product appears in product catalogs and reports'),
              value: availableInCatalog,
              onChanged: onCatalogChanged,
              secondary: Icon(
                Icons.menu_book,
                color: availableInCatalog 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // KOT Settings Header
            Text(
              'Kitchen Order Ticket (KOT) Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Skip KOT
            SwitchListTile(
              title: const Text('Skip KOT'),
              subtitle: const Text('Do not send this product to kitchen printers'),
              value: skipKot,
              onChanged: onSkipKotChanged,
              secondary: Icon(
                skipKot ? Icons.print_disabled : Icons.print,
                color: skipKot 
                    ? Theme.of(context).colorScheme.error 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            if (!skipKot) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'KOT printer routing can be configured in the Manage section '
                        'after creating the product.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}