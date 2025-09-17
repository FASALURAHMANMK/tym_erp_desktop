import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/responsive_utils.dart';
import '../../models/erp_module.dart';

class ManageScreen extends ConsumerWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final module = ERPModule.manage;
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  module.icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  module.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              module.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: ResponsiveLayout.getGridColumns(context),
                childAspectRatio: 1.5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildManagementCard(
                    context: context,
                    title: 'Products',
                    description: 'Manage your product catalog',
                    icon: Icons.inventory_2,
                    onTap: () => context.go('/products'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Categories',
                    description: 'Organize products by categories',
                    icon: Icons.category,
                    onTap: () => context.go('/categories'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Brands',
                    description: 'Manage product brands',
                    icon: Icons.branding_watermark,
                    onTap: () => context.go('/brands'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Price Categories',
                    description: 'Configure pricing categories',
                    icon: Icons.price_change,
                    onTap: () => context.go('/price-categories'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Locations',
                    description: 'Manage business locations',
                    icon: Icons.location_on,
                    onTap: () => context.go('/locations'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'POS Devices',
                    description: 'Configure POS terminals',
                    icon: Icons.devices,
                    onTap: () => context.go('/pos-devices'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Tables & Floors',
                    description: 'Manage restaurant tables',
                    icon: Icons.table_restaurant,
                    onTap: () => context.go('/table-management'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'KOT Configuration',
                    description: 'Configure KOT printers and stations',
                    icon: Icons.print,
                    onTap: () => context.go('/kot-configuration'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Tax Settings',
                    description: 'Configure tax rates and groups',
                    icon: Icons.receipt_long,
                    onTap: () => context.go('/tax-management'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Discounts',
                    description: 'Manage discount rules and coupons',
                    icon: Icons.discount,
                    onTap: () => context.go('/discount-management'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Charges',
                    description: 'Configure service and delivery charges',
                    icon: Icons.add_card,
                    onTap: () => context.go('/charges-management'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Payment Methods',
                    description: 'Configure payment options',
                    icon: Icons.payment,
                    onTap: () => context.go('/payment-methods'),
                  ),
                  _buildManagementCard(
                    context: context,
                    title: 'Business Info',
                    description: 'Update business details',
                    icon: Icons.business,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Business info management coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}