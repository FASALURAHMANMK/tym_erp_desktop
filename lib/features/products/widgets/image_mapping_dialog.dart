import 'package:flutter/material.dart';

class ImageMappingDialog extends StatefulWidget {
  final List<String> products;
  final List<String> images;
  final Map<String, List<String>> initialMapping;
  
  const ImageMappingDialog({
    super.key,
    required this.products,
    required this.images,
    this.initialMapping = const {},
  });
  
  @override
  State<ImageMappingDialog> createState() => _ImageMappingDialogState();
}

class _ImageMappingDialogState extends State<ImageMappingDialog> {
  late Map<String, List<String>> _mapping;
  
  @override
  void initState() {
    super.initState();
    _mapping = Map.from(widget.initialMapping);
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Map Images to Products',
              style: theme.textTheme.headlineSmall,
            ),
            
            const SizedBox(height: 16),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Drag and drop images to the corresponding products, or use auto-mapping based on SKU/barcode matching.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Mapping area
            Expanded(
              child: Row(
                children: [
                  // Products list
                  Expanded(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Products',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.products.length,
                              itemBuilder: (context, index) {
                                final product = widget.products[index];
                                final mappedImages = _mapping[product] ?? [];
                                
                                return ListTile(
                                  title: Text(product),
                                  subtitle: mappedImages.isNotEmpty
                                      ? Text('${mappedImages.length} images')
                                      : null,
                                  trailing: mappedImages.isNotEmpty
                                      ? Icon(
                                          Icons.check_circle,
                                          color: theme.colorScheme.primary,
                                        )
                                      : null,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Images list
                  Expanded(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Available Images',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.images.length,
                              itemBuilder: (context, index) {
                                final image = widget.images[index];
                                final isMapped = _mapping.values
                                    .any((list) => list.contains(image));
                                
                                return ListTile(
                                  leading: const Icon(Icons.image),
                                  title: Text(image.split('/').last),
                                  trailing: isMapped
                                      ? Icon(
                                          Icons.link,
                                          color: theme.colorScheme.primary,
                                        )
                                      : null,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Actions
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _autoMap,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Auto Map'),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(_mapping),
                      child: const Text('Apply Mapping'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _autoMap() {
    // Simple auto-mapping based on name matching
    setState(() {
      _mapping.clear();
      
      for (final product in widget.products) {
        final productLower = product.toLowerCase();
        final matchingImages = widget.images.where((image) {
          final imageName = image.split('/').last.toLowerCase();
          return imageName.contains(productLower) || 
                 productLower.contains(imageName.split('.').first);
        }).toList();
        
        if (matchingImages.isNotEmpty) {
          _mapping[product] = matchingImages;
        }
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Auto-mapped images to ${_mapping.length} products'),
      ),
    );
  }
}