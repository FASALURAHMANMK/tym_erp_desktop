import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../providers/product_image_provider.dart';
import 'product_image_upload_widget.dart';
import 'product_image_gallery_widget.dart';

class ProductImagesSection extends ConsumerStatefulWidget {
  final String? productId;
  final String businessId;
  final String? initialMainImage;
  final List<String> initialAdditionalImages;
  final Function(String? mainImage, List<String> additionalImages) onImagesChanged;
  
  const ProductImagesSection({
    super.key,
    this.productId,
    required this.businessId,
    this.initialMainImage,
    this.initialAdditionalImages = const [],
    required this.onImagesChanged,
  });
  
  @override
  ConsumerState<ProductImagesSection> createState() => _ProductImagesSectionState();
}

class _ProductImagesSectionState extends ConsumerState<ProductImagesSection> {
  String? _mainImageUrl;
  List<String> _additionalImageUrls = [];
  bool _isLoadingMain = false;
  bool _isLoadingAdditional = false;
  
  @override
  void initState() {
    super.initState();
    _mainImageUrl = widget.initialMainImage;
    _additionalImageUrls = List.from(widget.initialAdditionalImages);
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.getContentPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with multi-upload button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.image,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Product Images',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                // Multi-upload button
                ElevatedButton.icon(
                  onPressed: _isLoadingAdditional ? null : _handleMultiImageUpload,
                  icon: const Icon(Icons.add_photo_alternate, size: 20),
                  label: const Text('Upload Multiple'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
            
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            
            // Info message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Use "Upload Multiple" to select many images at once. First image will be set as main image if none exists. You can change the main image by clicking on any thumbnail.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            ResponsiveSpacing.getVerticalSpacing(context, 24),
            
            // Main content - responsive layout
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main image
                  Expanded(
                    flex: 2,
                    child: ProductImageUploadWidget(
                      imageUrl: _mainImageUrl,
                      label: 'Main Product Image',
                      isLoading: _isLoadingMain,
                      onUpload: _handleMainImageUpload,
                      onRemove: _mainImageUrl != null ? _handleMainImageRemove : null,
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Additional images
                  Expanded(
                    flex: 3,
                    child: ProductImageGalleryWidget(
                      imageUrls: _additionalImageUrls,
                      maxImages: 10,
                      isLoading: _isLoadingAdditional,
                      onAddImage: _handleAdditionalImageUpload,
                      onRemoveImage: _handleAdditionalImageRemove,
                      onSetAsMain: _setAsMainImage,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  // Main image
                  ProductImageUploadWidget(
                    imageUrl: _mainImageUrl,
                    label: 'Main Product Image',
                    isLoading: _isLoadingMain,
                    onUpload: _handleMainImageUpload,
                    onRemove: _mainImageUrl != null ? _handleMainImageRemove : null,
                  ),
                  ResponsiveSpacing.getVerticalSpacing(context, 24),
                  // Additional images
                  ProductImageGalleryWidget(
                    imageUrls: _additionalImageUrls,
                    maxImages: 10,
                    isLoading: _isLoadingAdditional,
                    onAddImage: _handleAdditionalImageUpload,
                    onRemoveImage: _handleAdditionalImageRemove,
                    onSetAsMain: _setAsMainImage,
                  ),
                ],
              ),
            
            // Upload tips
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            _buildUploadTips(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUploadTips(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image Guidelines:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          _buildTipRow('Supported formats: JPG, PNG, WebP, GIF'),
          _buildTipRow('Recommended size: 1024x1024 pixels'),
          _buildTipRow('Maximum file size: 5MB per image'),
          _buildTipRow('Main image will be used as thumbnail in product lists'),
        ],
      ),
    );
  }
  
  Widget _buildTipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _handleMainImageUpload() async {
    setState(() => _isLoadingMain = true);
    
    try {
      final imageServiceAsync = await ref.read(productImageServiceProvider.future);
      final result = await imageServiceAsync.pickAndUploadImage(
        businessId: widget.businessId,
        productId: widget.productId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
        isMainImage: true,
      );
      
      result.fold(
        (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message ?? 'An error occurred'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        (imageUrl) {
          if (imageUrl.isNotEmpty) {  // Only update if not cancelled
            setState(() {
              _mainImageUrl = imageUrl;
            });
            widget.onImagesChanged(_mainImageUrl, _additionalImageUrls);
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingMain = false);
      }
    }
  }
  
  Future<void> _handleMainImageRemove() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Main Image'),
        content: const Text('Are you sure you want to remove the main product image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    setState(() => _isLoadingMain = true);
    
    try {
      if (_mainImageUrl != null) {
        final imageService = await ref.read(productImageServiceProvider.future);
        await imageService.deleteImage(
          imageUrl: _mainImageUrl!,
          productId: widget.productId ?? '',
        );
      }
      
      setState(() {
        _mainImageUrl = null;
      });
      widget.onImagesChanged(_mainImageUrl, _additionalImageUrls);
    } finally {
      if (mounted) {
        setState(() => _isLoadingMain = false);
      }
    }
  }
  
  Future<void> _handleAdditionalImageUpload() async {
    if (_additionalImageUrls.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 10 additional images allowed'),
        ),
      );
      return;
    }
    
    setState(() => _isLoadingAdditional = true);
    
    try {
      final imageService = await ref.read(productImageServiceProvider.future);
      final result = await imageService.pickAndUploadImage(
        businessId: widget.businessId,
        productId: widget.productId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
        isMainImage: false,
      );
      
      result.fold(
        (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message ?? 'An error occurred'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        (imageUrl) {
          if (imageUrl.isNotEmpty) {  // Only update if not cancelled
            setState(() {
              _additionalImageUrls.add(imageUrl);
            });
            widget.onImagesChanged(_mainImageUrl, _additionalImageUrls);
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingAdditional = false);
      }
    }
  }
  
  Future<void> _handleAdditionalImageRemove(int index) async {
    if (index < 0 || index >= _additionalImageUrls.length) return;
    
    setState(() => _isLoadingAdditional = true);
    
    try {
      final imageUrl = _additionalImageUrls[index];
      final imageService = await ref.read(productImageServiceProvider.future);
      await imageService.deleteImage(
        imageUrl: imageUrl,
        productId: widget.productId ?? '',
      );
      
      setState(() {
        _additionalImageUrls.removeAt(index);
      });
      widget.onImagesChanged(_mainImageUrl, _additionalImageUrls);
    } finally {
      if (mounted) {
        setState(() => _isLoadingAdditional = false);
      }
    }
  }
  
  Future<void> _handleMultiImageUpload() async {
    setState(() => _isLoadingAdditional = true);
    
    try {
      final imageServiceAsync = await ref.read(productImageServiceProvider.future);
      final result = await imageServiceAsync.pickAndUploadMultipleImages(
        businessId: widget.businessId,
        productId: widget.productId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      result.fold(
        (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message ?? 'Failed to upload images'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        (imageUrls) async {
          if (imageUrls.isEmpty) return; // User cancelled
          
          // If no main image exists, set the first one as main
          if (_mainImageUrl == null && imageUrls.isNotEmpty) {
            setState(() {
              _mainImageUrl = imageUrls.first;
              _additionalImageUrls.addAll(imageUrls.skip(1));
            });
          } else {
            // All images go to additional
            setState(() {
              _additionalImageUrls.addAll(imageUrls);
            });
          }
          
          // Limit to 10 additional images
          if (_additionalImageUrls.length > 10) {
            setState(() {
              _additionalImageUrls = _additionalImageUrls.take(10).toList();
            });
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Limited to 10 additional images. ${_additionalImageUrls.length + imageUrls.length - 10} images were not added.'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
          
          widget.onImagesChanged(_mainImageUrl, _additionalImageUrls);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${imageUrls.length} images uploaded successfully'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingAdditional = false);
      }
    }
  }
  
  void _setAsMainImage(int additionalImageIndex) {
    if (additionalImageIndex < 0 || additionalImageIndex >= _additionalImageUrls.length) return;
    
    setState(() {
      final newMainImage = _additionalImageUrls[additionalImageIndex];
      _additionalImageUrls.removeAt(additionalImageIndex);
      
      // If there was a previous main image, add it to additional images
      if (_mainImageUrl != null) {
        _additionalImageUrls.insert(0, _mainImageUrl!);
      }
      
      _mainImageUrl = newMainImage;
    });
    
    widget.onImagesChanged(_mainImageUrl, _additionalImageUrls);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image set as main product image'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}