import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/data_seeding_service.dart';
import '../services/sync_service.dart';

/// Dialog to show data seeding progress after login
class DataSeedingProgressDialog extends ConsumerStatefulWidget {
  const DataSeedingProgressDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DataSeedingProgressDialog(),
    );
  }

  @override
  ConsumerState<DataSeedingProgressDialog> createState() => _DataSeedingProgressDialogState();
}

class _DataSeedingProgressDialogState extends ConsumerState<DataSeedingProgressDialog> {
  Stream<DataSeedingProgress>? _progressStream;
  bool _isComplete = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Get the progress stream from sync service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final syncService = ref.read(syncServiceProvider);
      setState(() {
        _progressStream = syncService.dataSeedingProgress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopScope(
      canPop: _isComplete, // Only allow closing when complete
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _error != null 
                    ? Icons.error_outline
                    : _isComplete 
                      ? Icons.check_circle_outline
                      : Icons.cloud_download_outlined,
                  size: 32,
                  color: _error != null
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Title
              Text(
                _error != null
                  ? 'Download Failed'
                  : _isComplete
                    ? 'Download Complete!'
                    : 'Setting Up Your Workspace',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              if (!_isComplete && _error == null)
                Text(
                  'Please wait while we download your business data...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              
              const SizedBox(height: 24),
              
              // Progress content
              if (_progressStream != null && _error == null)
                StreamBuilder<DataSeedingProgress>(
                  stream: _progressStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Initializing...'),
                        ],
                      );
                    }
                    
                    final progress = snapshot.data!;
                    
                    // Update completion state
                    if (progress.isComplete && !_isComplete) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        setState(() {
                          _isComplete = true;
                        });
                        // Auto-close after 2 seconds
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        });
                      });
                    }
                    
                    // Update error state
                    if (progress.error != null && _error == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _error = progress.error;
                        });
                      });
                    }
                    
                    return Column(
                      children: [
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress.percentage / 100,
                            minHeight: 8,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Progress text
                        Text(
                          '${progress.percentage.toStringAsFixed(0)}%',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Current task
                        Text(
                          progress.currentTask,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        
                        // Step counter
                        Text(
                          'Step ${progress.completedSteps} of ${progress.totalSteps}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              
              // Error message
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Some data could not be downloaded. You can still use the app offline.',
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Action buttons
              if (_isComplete || _error != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_error != null)
                      TextButton(
                        onPressed: () {
                          // Retry download
                          setState(() {
                            _error = null;
                            _isComplete = false;
                          });
                          ref.read(syncServiceProvider).downloadInitialData();
                        },
                        child: const Text('Retry'),
                      ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(_error != null ? 'Continue Anyway' : 'Continue'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}