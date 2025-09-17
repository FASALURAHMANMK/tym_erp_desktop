import 'dart:async';
import 'dart:io';

// Remove dropzone import as it's web-only
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../business/providers/business_provider.dart';
import '../providers/bulk_upload_provider.dart';

class BulkProductUploadScreen extends ConsumerStatefulWidget {
  const BulkProductUploadScreen({super.key});

  @override
  ConsumerState<BulkProductUploadScreen> createState() =>
      _BulkProductUploadScreenState();
}

class _BulkProductUploadScreenState
    extends ConsumerState<BulkProductUploadScreen> {
  // File states
  File? _selectedFile;
  final List<File> _imageFiles = [];
  final Map<String, List<String>> _imageMapping = {}; // SKU/Barcode -> Image paths

  // Data states
  List<Map<String, dynamic>> _parsedProducts = [];
  List<BulkUploadValidationError> _validationErrors = [];

  // UI states
  bool _isProcessing = false;
  bool _showPreview = false;
  int _currentStep = 0;

  final List<String> _steps = [
    'Upload Excel/CSV',
    'Map Images',
    'Validate Data',
    'Import Products',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);

    if (selectedBusiness == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bulk Product Upload')),
        body: const Center(child: Text('Please select a business first')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Product Upload'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case 'download_template':
                  await _downloadTemplate();
                  break;
                case 'export_products':
                  await _exportProducts();
                  break;
                case 'view_history':
                  _viewUploadHistory();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download_template',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Download Template'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'export_products',
                child: ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('Export Products'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'view_history',
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Upload History'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Progress Stepper
          _buildProgressStepper(theme),

          // Main Content
          Expanded(child: _buildStepContent(theme, selectedBusiness.id)),

          // Action Buttons
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildProgressStepper(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: List.generate(_steps.length, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                // Step indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Center(
                    child:
                        isCompleted
                            ? Icon(
                              Icons.check,
                              size: 16,
                              color: theme.colorScheme.onPrimary,
                            )
                            : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color:
                                    isActive
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                const SizedBox(width: 8),
                // Step label
                Expanded(
                  child: Text(
                    _steps[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color:
                          isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                // Connector
                if (index < _steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color:
                          isCompleted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(ThemeData theme, String businessId) {
    switch (_currentStep) {
      case 0:
        return _buildFileUploadStep(theme);
      case 1:
        return _buildImageMappingStep(theme);
      case 2:
        return _buildValidationStep(theme);
      case 3:
        return _buildImportStep(theme, businessId);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFileUploadStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Instructions with Download Template button
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Getting Started',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Download Template Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _downloadTemplate,
                      icon: const Icon(Icons.download),
                      label: const Text('Download Excel Template'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  
                  Text(
                    'Instructions:',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInstructionItem(
                    '1. Download the template Excel file',
                  ),
                  _buildInstructionItem(
                    '2. Fill in product details following the template format',
                  ),
                  _buildInstructionItem('3. Save the file and upload it here'),
                  _buildInstructionItem(
                    '4. Supported formats: .xlsx, .xls, .csv',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Required Fields: Name, Category, SKU, Selling Price',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // File Drop Zone
          Container(
            height: 300, // Fixed height for the drop zone
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.primaryContainer.withValues(
                alpha: 0.1,
              ),
            ),
            child:
                _selectedFile == null
                    ? _buildDropZone(theme)
                    : _buildFilePreview(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildDropZone(ThemeData theme) {
    return InkWell(
      onTap: _pickFile,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Drag and drop your Excel/CSV file here',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'or',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse Files'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(ThemeData theme) {
    return Column(
      children: [
        // File info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.description,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedFile!.path.split('/').last,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Size: ${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                      style: theme.textTheme.bodySmall,
                    ),
                    if (_parsedProducts.isNotEmpty)
                      Text(
                        'Products found: ${_parsedProducts.length}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _clearFile,
                icon: const Icon(Icons.close),
                tooltip: 'Remove file',
              ),
            ],
          ),
        ),

        // Data preview
        if (_showPreview && _parsedProducts.isNotEmpty)
          Flexible(child: _buildDataPreview(theme)),
      ],
    );
  }

  Widget _buildDataPreview(ThemeData theme) {
    final columns =
        _parsedProducts.isNotEmpty ? _parsedProducts.first.keys.toList() : [];

    return Card(
      margin: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns:
            columns
                .map(
                  (col) => DataColumn2(
                    label: Text(
                      col,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    size: ColumnSize.L,
                  ),
                )
                .toList(),
        rows:
            _parsedProducts.take(10).map((product) {
              return DataRow2(
                cells:
                    columns
                        .map(
                          (col) => DataCell(
                            Text(
                              product[col]?.toString() ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildImageMappingStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Instructions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.image, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Map Product Images',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Naming Patterns for Multiple Images:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInstructionItem('Single image: SKU.jpg (e.g., 1234.jpg)'),
                  _buildInstructionItem(
                    'Multiple images: SKU_1.jpg, SKU_2.jpg, SKU_main.jpg',
                  ),
                  _buildInstructionItem(
                    'Main image priority: Exact match > _main > _1 > alphabetical',
                  ),
                  _buildInstructionItem('Supported formats: JPG, PNG, WebP'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Example: For SKU "1234", use 1234.jpg, 1234_1.jpg, 1234_2.jpg',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Image upload area
          Expanded(
            child: Row(
              children: [
                // Image drop zone
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: _pickImages,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 64,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Drop images here or click to browse',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            if (_imageFiles.isNotEmpty)
                              Chip(
                                label: Text(
                                  '${_imageFiles.length} images selected',
                                ),
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 24),

                // Image list and mapping preview
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Selected Images & Mapping',
                                style: theme.textTheme.titleMedium,
                              ),
                              if (_imageFiles.isNotEmpty)
                                TextButton(
                                  onPressed: _clearImages,
                                  child: const Text('Clear All'),
                                ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child:
                              _imageFiles.isEmpty
                                  ? Center(
                                    child: Text(
                                      'No images selected',
                                      style: TextStyle(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: _imageFiles.length,
                                    itemBuilder: (context, index) {
                                      final image = _imageFiles[index];
                                      final fileName =
                                          image.path.split('/').last;
                                      
                                      // Find which product this image is mapped to
                                      String? mappedProduct;
                                      bool isMainImage = false;
                                      
                                      _imageMapping.forEach((productKey, imagePaths) {
                                        if (imagePaths.contains(image.path)) {
                                          mappedProduct = productKey;
                                          isMainImage = imagePaths.indexOf(image.path) == 0;
                                        }
                                      });

                                      return ListTile(
                                        leading: Stack(
                                          children: [
                                            Image.file(
                                              image,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            ),
                                            if (isMainImage)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: theme.colorScheme.primary,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Icon(
                                                    Icons.star,
                                                    size: 12,
                                                    color: theme.colorScheme.onPrimary,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        title: Text(fileName),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Size: ${(image.lengthSync() / 1024).toStringAsFixed(2)} KB',
                                            ),
                                            if (mappedProduct != null)
                                              Text(
                                                'Mapped to: $mappedProduct ${isMainImage ? "(Main)" : "(Additional)"}',
                                                style: TextStyle(
                                                  color: theme.colorScheme.primary,
                                                  fontSize: 12,
                                                ),
                                              )
                                            else
                                              Text(
                                                'Not mapped to any product',
                                                style: TextStyle(
                                                  color: theme.colorScheme.error,
                                                  fontSize: 12,
                                                ),
                                              ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () => _removeImage(index),
                                        ),
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
        ],
      ),
    );
  }

  Widget _buildValidationStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Validation summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_validationErrors.isEmpty)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 48,
                    )
                  else
                    Icon(
                      Icons.warning,
                      color: theme.colorScheme.error,
                      size: 48,
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _validationErrors.isEmpty
                              ? 'All products validated successfully!'
                              : '${_validationErrors.length} validation issues found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total products: ${_parsedProducts.length}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (_imageMapping.isNotEmpty) ...[
                          Text(
                            'Products with images: ${_imageMapping.length}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            'Total images: ${_imageMapping.values.fold(0, (sum, images) => sum + images.length)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_validationErrors.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: _fixValidationErrors,
                      icon: const Icon(Icons.auto_fix_high),
                      label: const Text('Auto Fix'),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Validation errors list
          if (_validationErrors.isNotEmpty)
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Validation Issues',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _validationErrors.length,
                        itemBuilder: (context, index) {
                          final error = _validationErrors[index];
                          return ListTile(
                            leading: Icon(
                              error.severity == 'error'
                                  ? Icons.error
                                  : Icons.warning,
                              color:
                                  error.severity == 'error'
                                      ? theme.colorScheme.error
                                      : Colors.orange,
                            ),
                            title: Text('Row ${error.row}: ${error.field}'),
                            subtitle: Text(error.message),
                            trailing:
                                error.canAutoFix
                                    ? IconButton(
                                      icon: const Icon(Icons.auto_fix_normal),
                                      onPressed: () => _fixSingleError(error),
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
    );
  }

  Widget _buildImportStep(ThemeData theme, String businessId) {
    final progress = ref.watch(bulkUploadProgressProvider);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isProcessing ? Icons.upload : Icons.upload_file,
              size: 128,
              color: _isProcessing 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              _isProcessing ? 'Importing Products' : 'Ready to Import', 
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            if (_isProcessing) ...[
              // Progress bar
              SizedBox(
                width: 300,
                child: LinearProgressIndicator(
                  value: progress.percentage,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${progress.processed} of ${progress.total} products imported',
                style: theme.textTheme.bodyMedium,
              ),
              if (progress.status != null)
                Text(
                  progress.status!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ] else ...[
              Text(
                '${_parsedProducts.length} products will be imported',
                style: theme.textTheme.titleMedium,
              ),
              if (_imageMapping.isNotEmpty)
                Text(
                  '${_imageMapping.length} products have images',
                  style: theme.textTheme.titleMedium,
                ),
            ],
            
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : () => _startImport(businessId),
              icon:
                  _isProcessing
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.upload),
              label: Text(_isProcessing ? 'Importing...' : 'Start Import'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (_currentStep > 0)
            OutlinedButton.icon(
              onPressed: _isProcessing ? null : _previousStep,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            )
          else
            const SizedBox.shrink(),

          // Next/Import button
          Row(
            children: [
              if (_currentStep < _steps.length - 1)
                ElevatedButton.icon(
                  onPressed: _canProceed() ? _nextStep : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedFile != null && _parsedProducts.isNotEmpty;
      case 1:
        return true; // Images are optional
      case 2:
        return _validationErrors.where((e) => e.severity == 'error').isEmpty;
      default:
        return false;
    }
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) _currentStep--;
    });
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < _steps.length - 1) {
        _currentStep++;

        // Run validation when entering validation step
        if (_currentStep == 2) {
          _validateData();
        }
      }
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = File(result.files.first.path!);
        _showPreview = false;
      });

      // Parse the file
      await _parseFile();
    }
  }

  Future<void> _parseFile() async {
    if (_selectedFile == null) return;

    setState(() => _isProcessing = true);

    try {
      final serviceAsync = await ref.read(bulkUploadServiceProvider.future);
      final products = await serviceAsync.parseFile(_selectedFile!);

      setState(() {
        _parsedProducts = products;
        _showPreview = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Found ${products.length} products in file'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Check if this is the "no data" error from uploading empty file
        final errorMessage = e.toString();
        if (errorMessage.contains('No product data found')) {
          // Show info dialog instead of error for empty template
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(Icons.warning_amber, size: 48),
              title: const Text('File is Empty'),
              content: const Text(
                'The uploaded file contains no data rows. Please ensure your Excel file has at least one row of product data.\n\n'
                'Tips:\n'
                '• The template includes an example product that can be imported\n'
                '• You can modify the example or add your own products\n'
                '• Ensure the file is saved properly before uploading',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _downloadTemplate();
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Template'),
                ),
              ],
            ),
          );
          // Clear the selected file
          setState(() {
            _selectedFile = null;
            _parsedProducts.clear();
          });
        } else {
          // Show regular error for other parsing errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error parsing file: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _clearFile() {
    setState(() {
      _selectedFile = null;
      _parsedProducts = [];
      _showPreview = false;
      _currentStep = 0;
    });
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _imageFiles.addAll(result.files.map((f) => File(f.path!)));
      });

      // Auto-map images based on filename
      _autoMapImages();
    }
  }

  void _autoMapImages() {
    _imageMapping.clear();

    for (final image in _imageFiles) {
      final fileName = image.path.split('/').last;
      final nameWithoutExt = fileName.split('.').first.toLowerCase();

      // Try to match with SKU or barcode using flexible pattern matching
      for (final product in _parsedProducts) {
        final sku = product['sku']?.toString().toLowerCase() ?? '';
        final barcode = product['barcode']?.toString().toLowerCase() ?? '';

        // Check if the image belongs to this product using flexible patterns
        bool matchesSku = false;
        bool matchesBarcode = false;

        if (sku.isNotEmpty) {
          // Exact match OR starts with SKU followed by underscore/hyphen
          matchesSku = nameWithoutExt == sku || 
                      nameWithoutExt.startsWith('${sku}_') ||
                      nameWithoutExt.startsWith('$sku-');
        }

        if (barcode.isNotEmpty && !matchesSku) {
          // Same pattern matching for barcode
          matchesBarcode = nameWithoutExt == barcode || 
                          nameWithoutExt.startsWith('${barcode}_') ||
                          nameWithoutExt.startsWith('$barcode-');
        }

        if (matchesSku) {
          _imageMapping.putIfAbsent(sku, () => []).add(image.path);
        } else if (matchesBarcode) {
          _imageMapping.putIfAbsent(barcode, () => []).add(image.path);
        }
      }
    }

    // Sort images for each product to ensure consistent main image selection
    _imageMapping.forEach((key, imagePaths) {
      imagePaths.sort((a, b) {
        final aName = a.split('/').last.split('.').first.toLowerCase();
        final bName = b.split('/').last.split('.').first.toLowerCase();
        
        // Priority order for main image:
        // 1. Exact match (just the SKU/barcode)
        // 2. Contains "main"
        // 3. Numbered files (lower numbers first)
        // 4. Alphabetical order
        
        if (aName == key.toLowerCase()) return -1;
        if (bName == key.toLowerCase()) return 1;
        
        if (aName.contains('main') && !bName.contains('main')) return -1;
        if (bName.contains('main') && !aName.contains('main')) return 1;
        
        // Extract numbers for comparison
        final aNumber = _extractNumber(aName);
        final bNumber = _extractNumber(bName);
        
        if (aNumber != null && bNumber != null) {
          return aNumber.compareTo(bNumber);
        }
        
        return aName.compareTo(bName);
      });
    });

    if (_imageMapping.isNotEmpty && mounted) {
      // Show detailed mapping information
      int totalImages = 0;
      _imageMapping.forEach((_, images) => totalImages += images.length);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mapped $totalImages images to ${_imageMapping.length} products',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Helper method to extract number from filename
  int? _extractNumber(String filename) {
    final match = RegExp(r'_(\d+)$').firstMatch(filename);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
      _autoMapImages();
    });
  }

  void _clearImages() {
    setState(() {
      _imageFiles.clear();
      _imageMapping.clear();
    });
  }

  void _validateData() {
    setState(() => _isProcessing = true);

    final errors = <BulkUploadValidationError>[];

    for (int i = 0; i < _parsedProducts.length; i++) {
      final product = _parsedProducts[i];
      final row = i + 2; // Excel rows start at 1, plus header

      // Required fields
      if (product['name']?.toString().trim().isEmpty ?? true) {
        errors.add(
          BulkUploadValidationError(
            row: row,
            field: 'Name',
            message: 'Product name is required',
            severity: 'error',
          ),
        );
      }

      if (product['category']?.toString().trim().isEmpty ?? true) {
        errors.add(
          BulkUploadValidationError(
            row: row,
            field: 'Category',
            message: 'Category is required',
            severity: 'error',
          ),
        );
      }

      if (product['sku']?.toString().trim().isEmpty ?? true) {
        errors.add(
          BulkUploadValidationError(
            row: row,
            field: 'SKU',
            message: 'SKU is required',
            severity: 'error',
            canAutoFix: true,
          ),
        );
      }

      // Price validation
      final sellingPrice = double.tryParse(
        product['selling_price']?.toString() ?? '',
      );
      if (sellingPrice == null || sellingPrice <= 0) {
        errors.add(
          BulkUploadValidationError(
            row: row,
            field: 'Selling Price',
            message: 'Valid selling price is required',
            severity: 'error',
          ),
        );
      }

      // MRP validation
      final mrp = double.tryParse(product['mrp']?.toString() ?? '');
      if (mrp != null && mrp < (sellingPrice ?? 0)) {
        errors.add(
          BulkUploadValidationError(
            row: row,
            field: 'MRP',
            message: 'MRP cannot be less than selling price',
            severity: 'warning',
            canAutoFix: true,
          ),
        );
      }
    }

    setState(() {
      _validationErrors = errors;
      _isProcessing = false;
    });
  }

  void _fixValidationErrors() {
    for (final error in _validationErrors.where((e) => e.canAutoFix)) {
      _fixSingleError(error);
    }
  }

  void _fixSingleError(BulkUploadValidationError error) {
    final product = _parsedProducts[error.row - 2];

    if (error.field == 'SKU' && (product['sku']?.toString().isEmpty ?? true)) {
      // Generate SKU
      product['sku'] =
          'SKU${DateTime.now().millisecondsSinceEpoch}${error.row}';
    } else if (error.field == 'MRP') {
      // Set MRP to selling price
      product['mrp'] = product['selling_price'];
    }

    // Re-validate
    _validateData();
  }

  Future<void> _startImport(String businessId) async {
    setState(() => _isProcessing = true);

    // Reset progress before starting
    ref.read(bulkUploadProgressProvider.notifier).reset();

    try {
      // First, get the service and start the import
      final service = await ref.read(bulkUploadServiceProvider.future);
      
      if (!mounted) return;
      
      // Do the actual import
      final result = await service.importProducts(
        businessId: businessId,
        products: _parsedProducts,
        imageMapping: _imageMapping,
        onProgress: (processed, total) {
          // Update progress state for UI
          ref.read(bulkUploadProgressProvider.notifier).updateProgress(
            processed, 
            total,
            status: 'Importing products...',
          );
        },
      );

      if (mounted) {
        // Show success message using SnackBar (safer than dialogs)
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '✅ Import completed: ${result.successCount} products imported successfully'
              '${result.failedCount > 0 ? ', ${result.failedCount} failed' : ''}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
        
        // Reset the form for another import
        setState(() {
          _selectedFile = null;
          _parsedProducts = [];
          _imageFiles.clear();
          _imageMapping.clear();
          _validationErrors = [];
          _showPreview = false;
          _currentStep = 0;
          _isProcessing = false;
        });
      }
      
    } catch (e) {
      if (mounted) {
        // Show error message
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text('❌ Import failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _downloadTemplate() async {
    try {
      final service = await ref.read(bulkUploadServiceProvider.future);
      final savedPath = await service.downloadTemplate();

      if (mounted) {
        if (savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Template saved to: $savedPath'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Template download cancelled'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download template: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _exportProducts() async {
    try {
      // Get the selected business first
      final selectedBusiness = ref.read(selectedBusinessProvider);
      if (selectedBusiness == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No business selected'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }
      
      // Show loading state in button or UI instead of dialog
      setState(() {
        _isProcessing = true;
      });
      
      // Export products using the service
      final exportService = await ref.read(productExportServiceProvider.future);
      final filePath = await exportService.exportProductsWithImageMapping(
        businessId: selectedBusiness.id,
      );
      
      // Reset processing state
      setState(() {
        _isProcessing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Products exported to: $filePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // Reset processing state
      setState(() {
        _isProcessing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export products: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _viewUploadHistory() {
    // TODO: Navigate to upload history screen
    // context.push('/erp/bulk-upload-history');
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload history feature coming soon!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class BulkUploadValidationError {
  final int row;
  final String field;
  final String message;
  final String severity; // 'error' or 'warning'
  final bool canAutoFix;

  BulkUploadValidationError({
    required this.row,
    required this.field,
    required this.message,
    required this.severity,
    this.canAutoFix = false,
  });
}
