import 'dart:developer' as developer;

/// Simple logger utility for the application
class Logger {
  final String name;

  Logger(this.name);

  void info(String message, [dynamic data]) {
    _log('INFO', message, data);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('ERROR', message, error);
    if (stackTrace != null) {
      developer.log('Stack trace: $stackTrace', 
          name: name, 
          level: 1000,
          error: error,
          stackTrace: stackTrace);
    }
  }

  void warning(String message, [dynamic data]) {
    _log('WARNING', message, data);
  }

  void debug(String message, [dynamic data]) {
    _log('DEBUG', message, data);
  }

  void _log(String level, String message, [dynamic data]) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] [$level] [$name] $message';
    final fullMessage = data != null ? '$logMessage\n  Data: $data' : logMessage;
    
    developer.log(fullMessage, name: name);
  }
}