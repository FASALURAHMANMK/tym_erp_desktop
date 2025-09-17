import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../domain/models/product.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActive;

  const ProductListTile({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = !ResponsiveUtils.isSmallScreen(context);
    
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: _buildProductImage(context),
        title: Text(
          product.name,
          style: ResponsiveTypography.getScaledTextStyle(
            context,
            theme.textTheme.titleMedium,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.defaultVariation?.sku != null)
              Text(
                'SKU: ${product.defaultVariation!.sku}',
                style: ResponsiveTypography.getScaledTextStyle(
                  context,
                  theme.textTheme.bodySmall,
                ),
              ),
            _buildPriceInfo(context),
            if (!product.isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
          ],
        ),
        trailing: isDesktop 
          ? _buildDesktopActions(context)
          : _buildMobileActions(context),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    final size = ResponsiveDimensions.getIconSize(context) * 2;
    
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(product.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.inventory_2,
        size: ResponsiveDimensions.getIconSize(context),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    final theme = Theme.of(context);
    final defaultVariation = product.defaultVariation;
    final hasMultipleVariations = product.hasMultipleVariations;
    
    // Handle products without variations
    if (defaultVariation == null) {
      return Text(
        'No pricing available',
        style: ResponsiveTypography.getScaledTextStyle(
          context,
          theme.textTheme.bodySmall,
        )?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }
    
    return Row(
      children: [
        if (defaultVariation.mrp > defaultVariation.sellingPrice) ...[
          Text(
            '₹${defaultVariation.mrp.toStringAsFixed(2)}',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              theme.textTheme.bodySmall,
            )?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          '₹${defaultVariation.sellingPrice.toStringAsFixed(2)}',
          style: ResponsiveTypography.getScaledTextStyle(
            context,
            theme.textTheme.bodyMedium,
          )?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        if (hasMultipleVariations) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${product.variations.length} variations',
              style: ResponsiveTypography.getScaledTextStyle(
                context,
                theme.textTheme.bodySmall,
              )?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onToggleActive,
          icon: Icon(
            product.isActive 
              ? Icons.visibility_off 
              : Icons.visibility,
          ),
          tooltip: product.isActive 
            ? 'Deactivate Product' 
            : 'Activate Product',
        ),
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
          tooltip: 'Edit Product',
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
          tooltip: 'Delete Product',
        ),
      ],
    );
  }

  Widget _buildMobileActions(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'toggle_active':
            onToggleActive?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'toggle_active',
          child: ListTile(
            leading: Icon(
              product.isActive 
                ? Icons.visibility_off 
                : Icons.visibility,
            ),
            title: Text(
              product.isActive 
                ? 'Deactivate' 
                : 'Activate',
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            title: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}