// ignore_for_file: dangling_library_doc_comments

/// Custom exception types for offline-first architecture
/// Provides standardized error handling across all services

/// Base exception for offline-first operations
abstract class OfflineFirstException implements Exception {
  final String message;
  final String operation;
  final dynamic originalError;
  final DateTime? timestamp;

  const OfflineFirstException(
    this.message,
    this.operation, [
    this.originalError,
  ]) : timestamp = null;

  OfflineFirstException.withTimestamp(
    this.message,
    this.operation, [
    this.originalError,
  ]) : timestamp = DateTime.now();

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('$runtimeType: $message')
      ..write(' (Operation: $operation)');
    
    if (originalError != null) {
      buffer.write(' - Original error: $originalError');
    }
    
    if (timestamp != null) {
      buffer.write(' at ${timestamp!.toIso8601String()}');
    }
    
    return buffer.toString();
  }
}

/// Exception for local database operations
class LocalDatabaseException extends OfflineFirstException {
  final String? tableName;
  final String? recordId;

  const LocalDatabaseException(
    String message,
    String operation, {
    this.tableName,
    this.recordId,
    dynamic originalError,
  }) : super(message, operation, originalError);

  @override
  String toString() {
    final buffer = StringBuffer()..write(super.toString());
    
    if (tableName != null) {
      buffer.write(' (Table: $tableName)');
    }
    
    if (recordId != null) {
      buffer.write(' (Record: $recordId)');
    }
    
    return buffer.toString();
  }
}

/// Exception for cloud service operations
class CloudServiceException extends OfflineFirstException {
  final int? statusCode;
  final String? endpoint;

  const CloudServiceException(
    String message,
    String operation, {
    this.statusCode,
    this.endpoint,
    dynamic originalError,
  }) : super(message, operation, originalError);

  @override
  String toString() {
    final buffer = StringBuffer()..write(super.toString());
    
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    
    if (endpoint != null) {
      buffer.write(' (Endpoint: $endpoint)');
    }
    
    return buffer.toString();
  }
}

/// Exception for sync operations
class SyncException extends OfflineFirstException {
  final String? syncDirection; // 'upload', 'download', 'bidirectional'
  final String? conflictType; // 'timestamp', 'data', 'constraint'

  const SyncException(
    String message,
    String operation, {
    this.syncDirection,
    this.conflictType,
    dynamic originalError,
  }) : super(message, operation, originalError);

  @override
  String toString() {
    final buffer = StringBuffer()..write(super.toString());
    
    if (syncDirection != null) {
      buffer.write(' (Direction: $syncDirection)');
    }
    
    if (conflictType != null) {
      buffer.write(' (Conflict: $conflictType)');
    }
    
    return buffer.toString();
  }
}

/// Exception for validation operations
class ValidationException extends OfflineFirstException {
  final String? fieldName;
  final dynamic fieldValue;

  const ValidationException(
    String message,
    String operation, {
    this.fieldName,
    this.fieldValue,
    dynamic originalError,
  }) : super(message, operation, originalError);

  @override
  String toString() {
    final buffer = StringBuffer()..write(super.toString());
    
    if (fieldName != null) {
      buffer.write(' (Field: $fieldName');
      if (fieldValue != null) {
        buffer.write(' = $fieldValue');
      }
      buffer.write(')');
    }
    
    return buffer.toString();
  }
}

/// Exception for business logic operations
class BusinessLogicException extends OfflineFirstException {
  final String? entityType; // 'location', 'device', 'business'
  final String? businessRule; // 'unique_default', 'required_field', etc.

  const BusinessLogicException(
    String message,
    String operation, {
    this.entityType,
    this.businessRule,
    dynamic originalError,
  }) : super(message, operation, originalError);

  @override
  String toString() {
    final buffer = StringBuffer()..write(super.toString());
    
    if (entityType != null) {
      buffer.write(' (Entity: $entityType)');
    }
    
    if (businessRule != null) {
      buffer.write(' (Rule: $businessRule)');
    }
    
    return buffer.toString();
  }
}

/// Exception for device code generation
class DeviceCodeException extends OfflineFirstException {
  final String? proposedCode;
  final String? businessId;

  const DeviceCodeException(
    String message,
    String operation, {
    this.proposedCode,
    this.businessId,
    dynamic originalError,
  }) : super(message, operation, originalError);

  @override
  String toString() {
    final buffer = StringBuffer()..write(super.toString());
    
    if (proposedCode != null) {
      buffer.write(' (Code: $proposedCode)');
    }
    
    if (businessId != null) {
      buffer.write(' (Business: $businessId)');
    }
    
    return buffer.toString();
  }
}

/// Exception for default item management
class DefaultItemException extends OfflineFirstException {
  final String? tableName;
  final String? parentId;
  final String? itemId;

  const DefaultItemException(
    String message,
    String operation, {
    this.tableName,
    this.parentId,
    this.itemId,
    dynamic originalError,
  }) : super(message, operation, originalError);

  @override
  String toString() {
    final buffer = StringBuffer()..write(super.toString());
    
    if (tableName != null) {
      buffer.write(' (Table: $tableName)');
    }
    
    if (parentId != null) {
      buffer.write(' (Parent: $parentId)');
    }
    
    if (itemId != null) {
      buffer.write(' (Item: $itemId)');
    }
    
    return buffer.toString();
  }
}

/// Utility class for creating standardized exceptions
class ExceptionFactory {
  /// Create a local database exception
  static LocalDatabaseException localDatabase(
    String message,
    String operation, {
    String? tableName,
    String? recordId,
    dynamic originalError,
  }) {
    return LocalDatabaseException(
      message,
      operation,
      tableName: tableName,
      recordId: recordId,
      originalError: originalError,
    );
  }

  /// Create a cloud service exception
  static CloudServiceException cloudService(
    String message,
    String operation, {
    int? statusCode,
    String? endpoint,
    dynamic originalError,
  }) {
    return CloudServiceException(
      message,
      operation,
      statusCode: statusCode,
      endpoint: endpoint,
      originalError: originalError,
    );
  }

  /// Create a sync exception
  static SyncException sync(
    String message,
    String operation, {
    String? syncDirection,
    String? conflictType,
    dynamic originalError,
  }) {
    return SyncException(
      message,
      operation,
      syncDirection: syncDirection,
      conflictType: conflictType,
      originalError: originalError,
    );
  }

  /// Create a validation exception
  static ValidationException validation(
    String message,
    String operation, {
    String? fieldName,
    dynamic fieldValue,
    dynamic originalError,
  }) {
    return ValidationException(
      message,
      operation,
      fieldName: fieldName,
      fieldValue: fieldValue,
      originalError: originalError,
    );
  }

  /// Create a business logic exception
  static BusinessLogicException businessLogic(
    String message,
    String operation, {
    String? entityType,
    String? businessRule,
    dynamic originalError,
  }) {
    return BusinessLogicException(
      message,
      operation,
      entityType: entityType,
      businessRule: businessRule,
      originalError: originalError,
    );
  }

  /// Create a device code exception
  static DeviceCodeException deviceCode(
    String message,
    String operation, {
    String? proposedCode,
    String? businessId,
    dynamic originalError,
  }) {
    return DeviceCodeException(
      message,
      operation,
      proposedCode: proposedCode,
      businessId: businessId,
      originalError: originalError,
    );
  }

  /// Create a default item exception
  static DefaultItemException defaultItem(
    String message,
    String operation, {
    String? tableName,
    String? parentId,
    String? itemId,
    dynamic originalError,
  }) {
    return DefaultItemException(
      message,
      operation,
      tableName: tableName,
      parentId: parentId,
      itemId: itemId,
      originalError: originalError,
    );
  }
}