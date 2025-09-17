import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import '../../../core/utils/logger.dart';

/// Manages print jobs in a queue to prevent printer overload
class PrinterQueueManager {
  static final _logger = Logger('PrinterQueueManager');
  
  // Singleton instance
  static final PrinterQueueManager _instance = PrinterQueueManager._internal();
  factory PrinterQueueManager() => _instance;
  PrinterQueueManager._internal();

  // Queue for each printer IP
  final Map<String, Queue<PrintJob>> _printQueues = {};
  
  // Track active print jobs
  final Map<String, bool> _isProcessing = {};
  
  // Connection timeout
  static const Duration _connectionTimeout = Duration(seconds: 10);
  
  // Delay between print jobs
  static const Duration _delayBetweenJobs = Duration(milliseconds: 500);
  
  // Retry configuration
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  /// Adds a print job to the queue for a specific printer
  static Future<void> addToPrintQueue(String printerIp, List<int> data) async {
    return _instance._addToQueue(printerIp, data);
  }

  Future<void> _addToQueue(String printerIp, List<int> data) async {
    try {
      _logger.info('Adding print job to queue for IP: $printerIp');
      
      // Initialize queue if needed
      _printQueues.putIfAbsent(printerIp, () => Queue<PrintJob>());
      
      // Create print job
      final job = PrintJob(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        printerIp: printerIp,
        data: Uint8List.fromList(data),
        timestamp: DateTime.now(),
      );
      
      // Add to queue
      _printQueues[printerIp]!.add(job);
      _logger.debug('Print job ${job.id} added to queue. Queue size: ${_printQueues[printerIp]!.length}');
      
      // Process queue if not already processing
      if (_isProcessing[printerIp] != true) {
        _processQueue(printerIp);
      }
    } catch (e) {
      _logger.error('Failed to add print job to queue', e);
      throw Exception('Failed to queue print job: $e');
    }
  }

  /// Processes the print queue for a specific printer
  Future<void> _processQueue(String printerIp) async {
    if (_isProcessing[printerIp] == true) {
      _logger.debug('Already processing queue for $printerIp');
      return;
    }

    _isProcessing[printerIp] = true;
    _logger.info('Starting queue processing for $printerIp');

    try {
      while (_printQueues[printerIp]?.isNotEmpty ?? false) {
        final job = _printQueues[printerIp]!.removeFirst();
        _logger.debug('Processing print job ${job.id}');
        
        // Attempt to print with retries
        bool success = false;
        for (int attempt = 1; attempt <= _maxRetries; attempt++) {
          try {
            await _sendToPrinter(job);
            success = true;
            _logger.info('Print job ${job.id} completed successfully');
            break;
          } catch (e) {
            _logger.warning('Print attempt $attempt failed for job ${job.id}: $e');
            
            if (attempt < _maxRetries) {
              _logger.debug('Retrying in ${_retryDelay.inSeconds} seconds...');
              await Future.delayed(_retryDelay);
            } else {
              _logger.error('Print job ${job.id} failed after $attempt attempts');
              // Could implement a failed jobs queue here for later retry
            }
          }
        }
        
        // Delay between jobs to prevent printer overload
        if (_printQueues[printerIp]?.isNotEmpty ?? false) {
          await Future.delayed(_delayBetweenJobs);
        }
      }
    } finally {
      _isProcessing[printerIp] = false;
      _logger.info('Queue processing completed for $printerIp');
    }
  }

  /// Sends data to the network printer
  Future<void> _sendToPrinter(PrintJob job) async {
    Socket? socket;
    
    try {
      _logger.debug('Connecting to printer at ${job.printerIp}:${job.port}');
      
      // Parse IP and port
      final parts = job.printerIp.split(':');
      final ip = parts[0];
      final port = parts.length > 1 ? int.tryParse(parts[1]) ?? 9100 : 9100;
      
      // Connect to printer
      socket = await Socket.connect(
        ip,
        port,
        timeout: _connectionTimeout,
      );
      
      _logger.debug('Connected to printer. Sending ${job.data.length} bytes');
      
      // Send data
      socket.add(job.data);
      await socket.flush();
      
      // Wait for data to be sent
      await socket.done;
      
      _logger.debug('Data sent successfully to printer');
    } catch (e) {
      _logger.error('Failed to send data to printer', e);
      throw Exception('Network printing failed: $e');
    } finally {
      // Close socket
      try {
        await socket?.close();
      } catch (e) {
        _logger.warning('Error closing socket', e);
      }
    }
  }

  /// Clears the queue for a specific printer
  static void clearQueue(String printerIp) {
    _instance._clearQueue(printerIp);
  }

  void _clearQueue(String printerIp) {
    _printQueues[printerIp]?.clear();
    _logger.info('Cleared print queue for $printerIp');
  }

  /// Gets the current queue size for a printer
  static int getQueueSize(String printerIp) {
    return _instance._printQueues[printerIp]?.length ?? 0;
  }

  /// Checks if a printer is currently processing jobs
  static bool isProcessing(String printerIp) {
    return _instance._isProcessing[printerIp] ?? false;
  }
}

/// Represents a print job in the queue
class PrintJob {
  final String id;
  final String printerIp;
  final Uint8List data;
  final DateTime timestamp;
  final int port;

  PrintJob({
    required this.id,
    required this.printerIp,
    required this.data,
    required this.timestamp,
    this.port = 9100, // Default ESC/POS network port
  });
}