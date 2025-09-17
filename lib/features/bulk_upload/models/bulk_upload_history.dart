import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_upload_history.freezed.dart';
part 'bulk_upload_history.g.dart';

@freezed
class BulkUploadHistory with _$BulkUploadHistory {
  const factory BulkUploadHistory({
    required String id,
    required String businessId,
    String? locationId,
    required String uploadedBy,

    // Upload details
    required String uploadType, // 'products', 'customers', 'inventory', etc.
    required String fileName,
    int? fileSize,
    String? fileFormat,

    // Upload results
    @Default(0) int totalRecords,
    @Default(0) int successfulRecords,
    @Default(0) int failedRecords,
    @Default('pending')
    String status, // 'pending', 'processing', 'completed', 'failed', 'partial'
    // Additional data
    List<UploadError>? errorDetails,
    Map<String, dynamic>? uploadedData, // Original parsed data
    Map<String, dynamic>? resultSummary, // Summary of what was created/updated
    // Timestamps
    required DateTime startedAt,
    DateTime? completedAt,
    int? processingTimeMs,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BulkUploadHistory;

  factory BulkUploadHistory.fromJson(Map<String, dynamic> json) =>
      _$BulkUploadHistoryFromJson(json);
}

@freezed
class UploadError with _$UploadError {
  const factory UploadError({
    required int rowNumber,
    required String field,
    required String message,
    String? severity, // 'error', 'warning'
  }) = _UploadError;

  factory UploadError.fromJson(Map<String, dynamic> json) =>
      _$UploadErrorFromJson(json);
}

@freezed
class BulkUploadRecord with _$BulkUploadRecord {
  const factory BulkUploadRecord({
    required String id,
    required String uploadHistoryId,

    // Record details
    required int rowNumber,
    String? recordType,
    String? recordId, // ID of created/updated record
    // Processing result
    required String status, // 'success', 'failed', 'skipped'
    String? errorMessage,
    List<String>? warnings,

    // Record data
    required Map<String, dynamic> originalData,
    Map<String, dynamic>? processedData,

    required DateTime createdAt,
  }) = _BulkUploadRecord;

  factory BulkUploadRecord.fromJson(Map<String, dynamic> json) =>
      _$BulkUploadRecordFromJson(json);
}

// Enum for upload types
enum UploadType {
  products('products'),
  customers('customers'),
  inventory('inventory'),
  suppliers('suppliers'),
  employees('employees');

  final String value;

  const UploadType(this.value);
}

// Enum for upload status
enum UploadStatus {
  pending('pending'),
  processing('processing'),
  completed('completed'),
  failed('failed'),
  partial('partial');

  final String value;

  const UploadStatus(this.value);
}

// Enum for record status
enum RecordStatus {
  success('success'),
  failed('failed'),
  skipped('skipped');

  final String value;

  const RecordStatus(this.value);
}
