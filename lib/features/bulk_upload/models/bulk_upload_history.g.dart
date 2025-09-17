// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_upload_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BulkUploadHistoryImpl _$$BulkUploadHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$BulkUploadHistoryImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String?,
  uploadedBy: json['uploadedBy'] as String,
  uploadType: json['uploadType'] as String,
  fileName: json['fileName'] as String,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  fileFormat: json['fileFormat'] as String?,
  totalRecords: (json['totalRecords'] as num?)?.toInt() ?? 0,
  successfulRecords: (json['successfulRecords'] as num?)?.toInt() ?? 0,
  failedRecords: (json['failedRecords'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? 'pending',
  errorDetails:
      (json['errorDetails'] as List<dynamic>?)
          ?.map((e) => UploadError.fromJson(e as Map<String, dynamic>))
          .toList(),
  uploadedData: json['uploadedData'] as Map<String, dynamic>?,
  resultSummary: json['resultSummary'] as Map<String, dynamic>?,
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedAt:
      json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
  processingTimeMs: (json['processingTimeMs'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$BulkUploadHistoryImplToJson(
  _$BulkUploadHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'locationId': instance.locationId,
  'uploadedBy': instance.uploadedBy,
  'uploadType': instance.uploadType,
  'fileName': instance.fileName,
  'fileSize': instance.fileSize,
  'fileFormat': instance.fileFormat,
  'totalRecords': instance.totalRecords,
  'successfulRecords': instance.successfulRecords,
  'failedRecords': instance.failedRecords,
  'status': instance.status,
  'errorDetails': instance.errorDetails,
  'uploadedData': instance.uploadedData,
  'resultSummary': instance.resultSummary,
  'startedAt': instance.startedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'processingTimeMs': instance.processingTimeMs,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$UploadErrorImpl _$$UploadErrorImplFromJson(Map<String, dynamic> json) =>
    _$UploadErrorImpl(
      rowNumber: (json['rowNumber'] as num).toInt(),
      field: json['field'] as String,
      message: json['message'] as String,
      severity: json['severity'] as String?,
    );

Map<String, dynamic> _$$UploadErrorImplToJson(_$UploadErrorImpl instance) =>
    <String, dynamic>{
      'rowNumber': instance.rowNumber,
      'field': instance.field,
      'message': instance.message,
      'severity': instance.severity,
    };

_$BulkUploadRecordImpl _$$BulkUploadRecordImplFromJson(
  Map<String, dynamic> json,
) => _$BulkUploadRecordImpl(
  id: json['id'] as String,
  uploadHistoryId: json['uploadHistoryId'] as String,
  rowNumber: (json['rowNumber'] as num).toInt(),
  recordType: json['recordType'] as String?,
  recordId: json['recordId'] as String?,
  status: json['status'] as String,
  errorMessage: json['errorMessage'] as String?,
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList(),
  originalData: json['originalData'] as Map<String, dynamic>,
  processedData: json['processedData'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$BulkUploadRecordImplToJson(
  _$BulkUploadRecordImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'uploadHistoryId': instance.uploadHistoryId,
  'rowNumber': instance.rowNumber,
  'recordType': instance.recordType,
  'recordId': instance.recordId,
  'status': instance.status,
  'errorMessage': instance.errorMessage,
  'warnings': instance.warnings,
  'originalData': instance.originalData,
  'processedData': instance.processedData,
  'createdAt': instance.createdAt.toIso8601String(),
};
