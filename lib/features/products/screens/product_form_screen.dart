import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../business/providers/business_provider.dart';
import '../domain/models/product.dart';
import '../providers/product_providers.dart';
import '../widgets/product_basic_info_section.dart';
import '../widgets/product_variations_section.dart';
import '../widgets/product_inventory_section.dart';
import '../widgets/product_availability_section.dart';
import '../widgets/product_pricing_section.dart';
import '../widgets/product_images_section.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;

  const ProductFormScreen({
    super.key,
    this.productId,
  });

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _nameAltController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionAltController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _hsnController = TextEditingController();
  final _shortCodeController = TextEditingController();
  final _tagsController = TextEditingController();
  final _displayOrderController = TextEditingController();
  
  // Form state
  String? _selectedCategoryId;
  String? _selectedBrandId;
  String? _selectedTaxGroupId; // Deprecated
  String? _selectedTaxRateId;
  UnitOfMeasure _unitOfMeasure = UnitOfMeasure.count;
  ProductType _productType = ProductType.physical;
  double _taxRate = 0.0; // Deprecated
  bool _trackInventory = true;
  bool _isActive = true;
  bool _availableInPos = true;
  bool _availableInOnlineStore = false;
  bool _availableInCatalog = true;
  bool _skipKot = false;
  
  // Variations state
  List<ProductVariation> _variations = [];
  
  // Images state
  String? _mainImageUrl;
  List<String> _additionalImageUrls = [];
  
  // UI state
  int _currentPage = 0;
  bool _isLoading = false;
  Product? _loadedProduct;
  
  bool get _isEditing => widget.productId != null;
  
  @override
  void initState() {
    super.initState();
    if (!_isEditing) {
      // Initialize with default variation
      _variations = [
        ProductVariation(
          id: '',
          productId: '',
          name: 'Default',
          sku: '',
          mrp: 0.0,
          sellingPrice: 0.0,
          isDefault: true,
          isActive: true,
          displayOrder: 0,
          isForSale: true,
          isForPurchase: false,
        ),
      ];
    }
  }
  
  void _loadProductData(Product product) {
    _loadedProduct = product;
    _nameController.text = product.name;
    _nameAltController.text = product.nameInAlternateLanguage ?? '';
    _descriptionController.text = product.description ?? '';
    _descriptionAltController.text = product.descriptionInAlternateLanguage ?? '';
    _selectedCategoryId = product.categoryId;
    _selectedBrandId = product.brandId;
    _barcodeController.text = product.barcode ?? '';
    _hsnController.text = product.hsn ?? '';
    _shortCodeController.text = product.shortCode ?? '';
    _tagsController.text = product.tags.join(', ');
    _displayOrderController.text = product.displayOrder.toString();
    _unitOfMeasure = product.unitOfMeasure;
    _productType = product.productType;
    _taxRate = product.taxRate; // Deprecated
    _selectedTaxGroupId = product.taxGroupId; // Deprecated
    _selectedTaxRateId = product.taxRateId;
    _trackInventory = product.trackInventory;
    _isActive = product.isActive;
    _availableInPos = product.availableInPos;
    _availableInOnlineStore = product.availableInOnlineStore;
    _availableInCatalog = product.availableInCatalog;
    _skipKot = product.skipKot;
    _variations = List.from(product.variations);
    _mainImageUrl = product.imageUrl;
    _additionalImageUrls = List.from(product.additionalImageUrls);
  }
  
  void _resetForm() {
    setState(() {
      // Clear all text controllers
      _nameController.clear();
      _nameAltController.clear();
      _descriptionController.clear();
      _descriptionAltController.clear();
      _barcodeController.clear();
      _hsnController.clear();
      _shortCodeController.clear();
      _tagsController.clear();
      _displayOrderController.text = '0';
      
      // Reset selections and flags to defaults
      _selectedCategoryId = null;
      _selectedBrandId = null;
      _unitOfMeasure = UnitOfMeasure.count;
      _productType = ProductType.physical;
      _taxRate = 0.0;
      _selectedTaxGroupId = null;
      _selectedTaxRateId = null;
      _trackInventory = true;  // Match initial default
      _isActive = true;
      _availableInPos = true;
      _availableInOnlineStore = false;
      _availableInCatalog = true;  // Match initial default
      _skipKot = false;
      
      // Reset variations with default variation
      _variations = [
        ProductVariation(
          id: '',
          productId: '',
          name: 'Default',
          sku: '',
          mrp: 0.0,
          sellingPrice: 0.0,
          isDefault: true,
          isActive: true,
          displayOrder: 0,
          isForSale: true,
          isForPurchase: false,
        ),
      ];
      
      // Clear images
      _mainImageUrl = null;
      _additionalImageUrls = [];
      
      // Reset to first page
      _currentPage = 0;
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _nameAltController.dispose();
    _descriptionController.dispose();
    _descriptionAltController.dispose();
    _barcodeController.dispose();
    _hsnController.dispose();
    _shortCodeController.dispose();
    _tagsController.dispose();
    _displayOrderController.dispose();
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    
    if (selectedBusiness == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Form'),
        ),
        body: const Center(
          child: Text('No business selected'),
        ),
      );
    }
    
    // Load product data if editing
    if (_isEditing && _loadedProduct == null) {
      final productAsync = ref.watch(productByIdProvider(widget.productId!));
      
      return productAsync.when(
        data: (product) {
          if (product != null && _loadedProduct == null) {
            // Load product data in next frame to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _loadProductData(product);
                });
              }
            });
          }
          return _buildForm(selectedBusiness);
        },
        loading: () => Scaffold(
          appBar: AppBar(
            title: const Text('Loading Product...'),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: Center(
            child: Text('Failed to load product: $error'),
          ),
        ),
      );
    }
    
    return _buildForm(selectedBusiness);
  }
  
  Widget _buildForm(dynamic selectedBusiness) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveProduct,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            
            // Info banner for quick save
            if (!_isEditing) // Only show for new products
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tip: You can save the product from any section. Only name and category are required.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Form content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // Page 1: Basic Information
                  SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveDimensions.getContentPadding(context)),
                    child: ProductBasicInfoSection(
                      nameController: _nameController,
                      nameAltController: _nameAltController,
                      descriptionController: _descriptionController,
                      descriptionAltController: _descriptionAltController,
                      barcodeController: _barcodeController,
                      hsnController: _hsnController,
                      shortCodeController: _shortCodeController,
                      tagsController: _tagsController,
                      selectedCategoryId: _selectedCategoryId,
                      selectedBrandId: _selectedBrandId,
                      unitOfMeasure: _unitOfMeasure,
                      productType: _productType,
                      taxRate: _taxRate, // Deprecated
                      taxGroupId: _selectedTaxGroupId, // Deprecated
                      taxRateId: _selectedTaxRateId,
                      isActive: _isActive,
                      onCategoryChanged: (value) => setState(() => _selectedCategoryId = value),
                      onBrandChanged: (value) => setState(() => _selectedBrandId = value),
                      onUnitChanged: (value) => setState(() => _unitOfMeasure = value!),
                      onProductTypeChanged: (value) => setState(() => _productType = value!),
                      onTaxRateChanged: (value) => setState(() => _taxRate = value), // Deprecated
                      onTaxGroupChanged: (value) => setState(() => _selectedTaxGroupId = value), // Deprecated
                      onSpecificTaxRateChanged: (value) => setState(() => _selectedTaxRateId = value),
                      onActiveChanged: (value) => setState(() => _isActive = value),
                    ),
                  ),
                  
                  // Page 2: Images
                  SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveDimensions.getContentPadding(context)),
                    child: ProductImagesSection(
                      productId: widget.productId,
                      businessId: selectedBusiness.id,
                      initialMainImage: _mainImageUrl,
                      initialAdditionalImages: _additionalImageUrls,
                      onImagesChanged: (mainImage, additionalImages) {
                        setState(() {
                          _mainImageUrl = mainImage;
                          _additionalImageUrls = additionalImages;
                        });
                      },
                    ),
                  ),
                  
                  // Page 3: Variations
                  SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveDimensions.getContentPadding(context)),
                    child: ProductVariationsSection(
                      variations: _variations,
                      onVariationsChanged: (variations) {
                        setState(() {
                          _variations = variations;
                        });
                      },
                    ),
                  ),
                  
                  // Page 4: Pricing
                  SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveDimensions.getContentPadding(context)),
                    child: ProductPricingSection(
                      variations: _variations,
                      onVariationsChanged: (variations) {
                        setState(() {
                          _variations = variations;
                        });
                      },
                    ),
                  ),
                  
                  // Page 5: Inventory & Availability
                  SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveDimensions.getContentPadding(context)),
                    child: Column(
                      children: [
                        ProductInventorySection(
                          trackInventory: _trackInventory,
                          displayOrderController: _displayOrderController,
                          onTrackInventoryChanged: (value) => setState(() => _trackInventory = value),
                        ),
                        ResponsiveSpacing.getVerticalSpacing(context, 24),
                        ProductAvailabilitySection(
                          availableInPos: _availableInPos,
                          availableInOnlineStore: _availableInOnlineStore,
                          availableInCatalog: _availableInCatalog,
                          skipKot: _skipKot,
                          onPosChanged: (value) => setState(() => _availableInPos = value),
                          onOnlineStoreChanged: (value) => setState(() => _availableInOnlineStore = value),
                          onCatalogChanged: (value) => setState(() => _availableInCatalog = value),
                          onSkipKotChanged: (value) => setState(() => _skipKot = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildProgressStep(0, 'Basic Info'),
          _buildProgressConnector(0),
          _buildProgressStep(1, 'Images'),
          _buildProgressConnector(1),
          _buildProgressStep(2, 'Variations'),
          _buildProgressConnector(2),
          _buildProgressStep(3, 'Pricing'),
          _buildProgressConnector(3),
          _buildProgressStep(4, 'Settings'),
        ],
      ),
    );
  }
  
  Widget _buildProgressStep(int step, String label) {
    final isActive = _currentPage >= step;
    final isCompleted = _currentPage > step;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressConnector(int step) {
    final isActive = _currentPage > step;
    
    return Container(
      height: 2,
      width: 40,
      color: isActive
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
  
  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button (shown on all pages except first)
          if (_currentPage > 0)
            OutlinedButton.icon(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            )
          else
            const SizedBox.shrink(),
          
          // Right side buttons
          Row(
            children: [
              // Next button (shown on all pages except last)
              if (_currentPage < 4)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  ),
                ),
              
              // Save Product button (shown on ALL pages)
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveProduct,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Saving...' : 'Save Product'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Future<void> _saveProduct() async {
    // Store context references at the beginning
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    
    // Validate basic info (Page 0)
    if (!_formKey.currentState!.validate()) {
      // Check which fields are causing validation to fail
      // Most required fields are on page 0 (Basic Info)
      if (_nameController.text.trim().isEmpty || _selectedCategoryId == null) {
        _pageController.animateToPage(
          0, // Navigate to Basic Info page
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields in Basic Info'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    // Validate category selection (Page 0 - Basic Info)
    if (_selectedCategoryId == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      _pageController.animateToPage(
        0, // Navigate to Basic Info page
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    
    // Validate variations (Page 2 - Variations)
    if (_variations.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Product must have at least one variation. Please add a variation in the Variations tab.'),
          backgroundColor: Colors.orange,
        ),
      );
      _pageController.animateToPage(
        2, // Navigate to Variations page
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final selectedBusiness = ref.read(selectedBusinessProvider);
      if (selectedBusiness == null) throw Exception('No business selected');
      
      // Parse tags
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
      
      // Parse display order
      final displayOrder = int.tryParse(_displayOrderController.text) ?? 0;
      
      // Create or update product
      final product = Product(
        id: _loadedProduct?.id ?? '',
        businessId: selectedBusiness.id,
        name: _nameController.text.trim(),
        nameInAlternateLanguage: _nameAltController.text.trim().isEmpty 
            ? null 
            : _nameAltController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        descriptionInAlternateLanguage: _descriptionAltController.text.trim().isEmpty 
            ? null 
            : _descriptionAltController.text.trim(),
        categoryId: _selectedCategoryId!,
        brandId: _selectedBrandId,
        imageUrl: _mainImageUrl,
        additionalImageUrls: _additionalImageUrls,
        unitOfMeasure: _unitOfMeasure,
        barcode: _barcodeController.text.trim().isEmpty 
            ? null 
            : _barcodeController.text.trim(),
        hsn: _hsnController.text.trim().isEmpty 
            ? null 
            : _hsnController.text.trim(),
        taxRate: _taxRate, // Deprecated
        taxGroupId: _selectedTaxGroupId, // Deprecated
        taxRateId: _selectedTaxRateId,
        shortCode: _shortCodeController.text.trim().isEmpty 
            ? null 
            : _shortCodeController.text.trim(),
        tags: tags,
        productType: _productType,
        trackInventory: _trackInventory,
        isActive: _isActive,
        displayOrder: displayOrder,
        availableInPos: _availableInPos,
        availableInOnlineStore: _availableInOnlineStore,
        availableInCatalog: _availableInCatalog,
        skipKot: _skipKot,
        variations: _variations,
        createdAt: _loadedProduct?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final errorColor = Theme.of(context).colorScheme.error;
      final navigator = context;
      
      final result = _isEditing
          ? await ref.read(productListNotifierProvider.notifier).updateProduct(product)
          : await ref.read(productListNotifierProvider.notifier).createProduct(product);
      
      result.fold(
        (failure) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Error: ${failure.message}'),
              backgroundColor: errorColor,
            ),
          );
        },
        (product) async {
          if (_isEditing) {
            // For editing, just show success and go back
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Product updated successfully'),
              ),
            );
            navigator.go('/products');
          } else {
            // For new products, offer to add another
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: const Text('Product created successfully'),
                action: SnackBarAction(
                  label: 'Add Another',
                  onPressed: () {
                    // Reset form for new product
                    _resetForm();
                  },
                ),
                duration: const Duration(seconds: 4),
              ),
            );
            
            // Ask if user wants to add another product
            if (!mounted) return;
            final addAnother = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Product Created'),
                content: const Text('Would you like to add another product?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('No, Go Back'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text('Yes, Add Another'),
                  ),
                ],
              ),
            );
            
            if (addAnother == true) {
              _resetForm();
            } else {
              if (mounted) {
                context.go('/products');
              }
            }
          }
        },
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}