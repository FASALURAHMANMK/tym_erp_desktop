import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';

class ProductImageGalleryWidget extends ConsumerWidget {
  final List<String> imageUrls;
  final int maxImages;
  final Function() onAddImage;
  final Function(int index) onRemoveImage;
  final Function(int index)? onSetAsMain;
  final bool isLoading;
  
  const ProductImageGalleryWidget({
    super.key,
    required this.imageUrls,
    this.maxImages = 10,
    required this.onAddImage,
    required this.onRemoveImage,
    this.onSetAsMain,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final crossAxisCount = _getCrossAxisCount(context);
    final itemSize = _getItemSize(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Additional Images',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              '${imageUrls.length}/$maxImages',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 8),
        if (imageUrls.isEmpty && !isLoading)
          _buildEmptyState(context)
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: imageUrls.length + (imageUrls.length < maxImages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == imageUrls.length && imageUrls.length < maxImages) {
                // Add button
                return _buildAddButton(context, itemSize);
              }
              
              // Image tile
              return _buildImageTile(
                context: context,
                imageUrl: imageUrls[index],
                index: index,
                size: itemSize,
              );
            },
          ),
        
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
          // style: BorderStyle.dashed, // Not supported, using solid with dashed effect
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.collections_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No additional images',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onAddImage,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Images'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAddButton(BuildContext context, double size) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onAddImage,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 2,
              // style: BorderStyle.dashed, // Not supported, using solid with dashed effect
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildImageTile({
    required BuildContext context,
    required String imageUrl,
    required int index,
    required double size,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Image
            if (imageUrl.startsWith('http'))
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.errorContainer,
                  child: Icon(
                    Icons.error,
                    color: theme.colorScheme.error,
                  ),
                ),
              )
            else
              Image.file(
                File(imageUrl),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.colorScheme.errorContainer,
                  child: Icon(
                    Icons.error,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            
            // Remove button
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => onRemoveImage(index),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            
            // Set as Main button (if callback provided)
            if (onSetAsMain != null)
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => onSetAsMain!(index),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Set as Main',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              // Index badge (if Set as Main not available)
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 3;
    } else if (screenWidth < 1200) {
      return 4;
    } else {
      return 5;
    }
  }
  
  double _getItemSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(context);
    final padding = ResponsiveDimensions.getContentPadding(context);
    final spacing = 12.0 * (crossAxisCount - 1);
    
    return (screenWidth - (padding * 2) - spacing) / crossAxisCount;
  }
}