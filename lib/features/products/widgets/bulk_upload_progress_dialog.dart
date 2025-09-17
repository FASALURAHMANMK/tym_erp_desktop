import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bulk_upload_provider.dart';

class BulkUploadProgressDialog extends ConsumerWidget {
  final int totalProducts;
  
  const BulkUploadProgressDialog({
    super.key,
    required this.totalProducts,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progress = ref.watch(bulkUploadProgressProvider);
    
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Importing Products',
              style: theme.textTheme.headlineSmall,
            ),
            
            const SizedBox(height: 24),
            
            // Progress indicator
            Column(
              children: [
                LinearProgressIndicator(
                  value: progress.percentage,
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Text(
                  '${progress.processed} / ${progress.total}',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Current product
            if (progress.currentProduct != null)
              Text(
                'Processing: ${progress.currentProduct}',
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            
            // Status
            if (progress.status != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  progress.status!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Cancel button (disabled during import)
            TextButton(
              onPressed: null, // Disabled for now
              child: const Text('Please wait...'),
            ),
          ],
        ),
      ),
    );
  }
}