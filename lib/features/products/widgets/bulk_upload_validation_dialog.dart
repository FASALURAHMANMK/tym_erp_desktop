import 'package:flutter/material.dart';

class BulkUploadValidationDialog extends StatelessWidget {
  final List<String> errors;
  final VoidCallback onRetry;
  
  const BulkUploadValidationDialog({
    super.key,
    required this.errors,
    required this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Validation Errors',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Error list
            Expanded(
              child: ListView.builder(
                itemCount: errors.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(color: theme.colorScheme.error)),
                        Expanded(
                          child: Text(errors[index]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Actions
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Fix & Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}