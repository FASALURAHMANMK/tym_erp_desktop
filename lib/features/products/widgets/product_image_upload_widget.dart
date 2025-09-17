import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';

class ProductImageUploadWidget extends ConsumerWidget {
  final String? imageUrl;
  final String label;
  final Function() onUpload;
  final Function()? onRemove;
  final bool isLoading;
  
  const ProductImageUploadWidget({
    super.key,
    this.imageUrl,
    required this.label,
    required this.onUpload,
    this.onRemove,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = ResponsiveDimensionsExt.getImageUploadSize(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium,
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 8),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 2,
              style: imageUrl != null ? BorderStyle.none : BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Image or placeholder
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  _buildImage()
                else
                  _buildPlaceholder(context),
                
                // Loading overlay
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                
                // Action buttons
                if (!isLoading)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      children: [
                        if (imageUrl != null && onRemove != null) ...[
                          _buildActionButton(
                            icon: Icons.delete,
                            onPressed: onRemove!,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                        ],
                        _buildActionButton(
                          icon: imageUrl != null ? Icons.edit : Icons.add_photo_alternate,
                          onPressed: onUpload,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildImage() {
    // Check if it's a local file or network URL
    if (imageUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Icon(
            Icons.error,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    } else {
      // Local file
      return Image.file(
        File(imageUrl!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Icon(
            Icons.error,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }
  }
  
  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Click to upload',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'or drag & drop',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// Extension for responsive dimensions
extension ResponsiveDimensionsExt on ResponsiveDimensions {
  static double getImageUploadSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 200;
    } else if (screenWidth < 1200) {
      return 250;
    } else {
      return 300;
    }
  }
}