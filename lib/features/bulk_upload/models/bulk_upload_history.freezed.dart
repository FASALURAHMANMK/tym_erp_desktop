// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_upload_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BulkUploadHistory _$BulkUploadHistoryFromJson(Map<String, dynamic> json) {
  return _BulkUploadHistory.fromJson(json);
}

/// @nodoc
mixin _$BulkUploadHistory {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String? get locationId => throw _privateConstructorUsedError;
  String get uploadedBy => throw _privateConstructorUsedError; // Upload details
  String get uploadType =>
      throw _privateConstructorUsedError; // 'products', 'customers', 'inventory', etc.
  String get fileName => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  String? get fileFormat =>
      throw _privateConstructorUsedError; // Upload results
  int get totalRecords => throw _privateConstructorUsedError;
  int get successfulRecords => throw _privateConstructorUsedError;
  int get failedRecords => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'processing', 'completed', 'failed', 'partial'
  // Additional data
  List<UploadError>? get errorDetails => throw _privateConstructorUsedError;
  Map<String, dynamic>? get uploadedData =>
      throw _privateConstructorUsedError; // Original parsed data
  Map<String, dynamic>? get resultSummary =>
      throw _privateConstructorUsedError; // Summary of what was created/updated
  // Timestamps
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int? get processingTimeMs => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BulkUploadHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BulkUploadHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BulkUploadHistoryCopyWith<BulkUploadHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkUploadHistoryCopyWith<$Res> {
  factory $BulkUploadHistoryCopyWith(
    BulkUploadHistory value,
    $Res Function(BulkUploadHistory) then,
  ) = _$BulkUploadHistoryCopyWithImpl<$Res, BulkUploadHistory>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String? locationId,
    String uploadedBy,
    String uploadType,
    String fileName,
    int? fileSize,
    String? fileFormat,
    int totalRecords,
    int successfulRecords,
    int failedRecords,
    String status,
    List<UploadError>? errorDetails,
    Map<String, dynamic>? uploadedData,
    Map<String, dynamic>? resultSummary,
    DateTime startedAt,
    DateTime? completedAt,
    int? processingTimeMs,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$BulkUploadHistoryCopyWithImpl<$Res, $Val extends BulkUploadHistory>
    implements $BulkUploadHistoryCopyWith<$Res> {
  _$BulkUploadHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BulkUploadHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = freezed,
    Object? uploadedBy = null,
    Object? uploadType = null,
    Object? fileName = null,
    Object? fileSize = freezed,
    Object? fileFormat = freezed,
    Object? totalRecords = null,
    Object? successfulRecords = null,
    Object? failedRecords = null,
    Object? status = null,
    Object? errorDetails = freezed,
    Object? uploadedData = freezed,
    Object? resultSummary = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? processingTimeMs = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            businessId:
                null == businessId
                    ? _value.businessId
                    : businessId // ignore: cast_nullable_to_non_nullable
                        as String,
            locationId:
                freezed == locationId
                    ? _value.locationId
                    : locationId // ignore: cast_nullable_to_non_nullable
                        as String?,
            uploadedBy:
                null == uploadedBy
                    ? _value.uploadedBy
                    : uploadedBy // ignore: cast_nullable_to_non_nullable
                        as String,
            uploadType:
                null == uploadType
                    ? _value.uploadType
                    : uploadType // ignore: cast_nullable_to_non_nullable
                        as String,
            fileName:
                null == fileName
                    ? _value.fileName
                    : fileName // ignore: cast_nullable_to_non_nullable
                        as String,
            fileSize:
                freezed == fileSize
                    ? _value.fileSize
                    : fileSize // ignore: cast_nullable_to_non_nullable
                        as int?,
            fileFormat:
                freezed == fileFormat
                    ? _value.fileFormat
                    : fileFormat // ignore: cast_nullable_to_non_nullable
                        as String?,
            totalRecords:
                null == totalRecords
                    ? _value.totalRecords
                    : totalRecords // ignore: cast_nullable_to_non_nullable
                        as int,
            successfulRecords:
                null == successfulRecords
                    ? _value.successfulRecords
                    : successfulRecords // ignore: cast_nullable_to_non_nullable
                        as int,
            failedRecords:
                null == failedRecords
                    ? _value.failedRecords
                    : failedRecords // ignore: cast_nullable_to_non_nullable
                        as int,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            errorDetails:
                freezed == errorDetails
                    ? _value.errorDetails
                    : errorDetails // ignore: cast_nullable_to_non_nullable
                        as List<UploadError>?,
            uploadedData:
                freezed == uploadedData
                    ? _value.uploadedData
                    : uploadedData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            resultSummary:
                freezed == resultSummary
                    ? _value.resultSummary
                    : resultSummary // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            startedAt:
                null == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            processingTimeMs:
                freezed == processingTimeMs
                    ? _value.processingTimeMs
                    : processingTimeMs // ignore: cast_nullable_to_non_nullable
                        as int?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BulkUploadHistoryImplCopyWith<$Res>
    implements $BulkUploadHistoryCopyWith<$Res> {
  factory _$$BulkUploadHistoryImplCopyWith(
    _$BulkUploadHistoryImpl value,
    $Res Function(_$BulkUploadHistoryImpl) then,
  ) = __$$BulkUploadHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String? locationId,
    String uploadedBy,
    String uploadType,
    String fileName,
    int? fileSize,
    String? fileFormat,
    int totalRecords,
    int successfulRecords,
    int failedRecords,
    String status,
    List<UploadError>? errorDetails,
    Map<String, dynamic>? uploadedData,
    Map<String, dynamic>? resultSummary,
    DateTime startedAt,
    DateTime? completedAt,
    int? processingTimeMs,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$BulkUploadHistoryImplCopyWithImpl<$Res>
    extends _$BulkUploadHistoryCopyWithImpl<$Res, _$BulkUploadHistoryImpl>
    implements _$$BulkUploadHistoryImplCopyWith<$Res> {
  __$$BulkUploadHistoryImplCopyWithImpl(
    _$BulkUploadHistoryImpl _value,
    $Res Function(_$BulkUploadHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BulkUploadHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = freezed,
    Object? uploadedBy = null,
    Object? uploadType = null,
    Object? fileName = null,
    Object? fileSize = freezed,
    Object? fileFormat = freezed,
    Object? totalRecords = null,
    Object? successfulRecords = null,
    Object? failedRecords = null,
    Object? status = null,
    Object? errorDetails = freezed,
    Object? uploadedData = freezed,
    Object? resultSummary = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? processingTimeMs = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$BulkUploadHistoryImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        businessId:
            null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                    as String,
        locationId:
            freezed == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                    as String?,
        uploadedBy:
            null == uploadedBy
                ? _value.uploadedBy
                : uploadedBy // ignore: cast_nullable_to_non_nullable
                    as String,
        uploadType:
            null == uploadType
                ? _value.uploadType
                : uploadType // ignore: cast_nullable_to_non_nullable
                    as String,
        fileName:
            null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                    as String,
        fileSize:
            freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                    as int?,
        fileFormat:
            freezed == fileFormat
                ? _value.fileFormat
                : fileFormat // ignore: cast_nullable_to_non_nullable
                    as String?,
        totalRecords:
            null == totalRecords
                ? _value.totalRecords
                : totalRecords // ignore: cast_nullable_to_non_nullable
                    as int,
        successfulRecords:
            null == successfulRecords
                ? _value.successfulRecords
                : successfulRecords // ignore: cast_nullable_to_non_nullable
                    as int,
        failedRecords:
            null == failedRecords
                ? _value.failedRecords
                : failedRecords // ignore: cast_nullable_to_non_nullable
                    as int,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        errorDetails:
            freezed == errorDetails
                ? _value._errorDetails
                : errorDetails // ignore: cast_nullable_to_non_nullable
                    as List<UploadError>?,
        uploadedData:
            freezed == uploadedData
                ? _value._uploadedData
                : uploadedData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        resultSummary:
            freezed == resultSummary
                ? _value._resultSummary
                : resultSummary // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        startedAt:
            null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        processingTimeMs:
            freezed == processingTimeMs
                ? _value.processingTimeMs
                : processingTimeMs // ignore: cast_nullable_to_non_nullable
                    as int?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BulkUploadHistoryImpl implements _BulkUploadHistory {
  const _$BulkUploadHistoryImpl({
    required this.id,
    required this.businessId,
    this.locationId,
    required this.uploadedBy,
    required this.uploadType,
    required this.fileName,
    this.fileSize,
    this.fileFormat,
    this.totalRecords = 0,
    this.successfulRecords = 0,
    this.failedRecords = 0,
    this.status = 'pending',
    final List<UploadError>? errorDetails,
    final Map<String, dynamic>? uploadedData,
    final Map<String, dynamic>? resultSummary,
    required this.startedAt,
    this.completedAt,
    this.processingTimeMs,
    required this.createdAt,
    required this.updatedAt,
  }) : _errorDetails = errorDetails,
       _uploadedData = uploadedData,
       _resultSummary = resultSummary;

  factory _$BulkUploadHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BulkUploadHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String? locationId;
  @override
  final String uploadedBy;
  // Upload details
  @override
  final String uploadType;
  // 'products', 'customers', 'inventory', etc.
  @override
  final String fileName;
  @override
  final int? fileSize;
  @override
  final String? fileFormat;
  // Upload results
  @override
  @JsonKey()
  final int totalRecords;
  @override
  @JsonKey()
  final int successfulRecords;
  @override
  @JsonKey()
  final int failedRecords;
  @override
  @JsonKey()
  final String status;
  // 'pending', 'processing', 'completed', 'failed', 'partial'
  // Additional data
  final List<UploadError>? _errorDetails;
  // 'pending', 'processing', 'completed', 'failed', 'partial'
  // Additional data
  @override
  List<UploadError>? get errorDetails {
    final value = _errorDetails;
    if (value == null) return null;
    if (_errorDetails is EqualUnmodifiableListView) return _errorDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _uploadedData;
  @override
  Map<String, dynamic>? get uploadedData {
    final value = _uploadedData;
    if (value == null) return null;
    if (_uploadedData is EqualUnmodifiableMapView) return _uploadedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Original parsed data
  final Map<String, dynamic>? _resultSummary;
  // Original parsed data
  @override
  Map<String, dynamic>? get resultSummary {
    final value = _resultSummary;
    if (value == null) return null;
    if (_resultSummary is EqualUnmodifiableMapView) return _resultSummary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Summary of what was created/updated
  // Timestamps
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  final int? processingTimeMs;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BulkUploadHistory(id: $id, businessId: $businessId, locationId: $locationId, uploadedBy: $uploadedBy, uploadType: $uploadType, fileName: $fileName, fileSize: $fileSize, fileFormat: $fileFormat, totalRecords: $totalRecords, successfulRecords: $successfulRecords, failedRecords: $failedRecords, status: $status, errorDetails: $errorDetails, uploadedData: $uploadedData, resultSummary: $resultSummary, startedAt: $startedAt, completedAt: $completedAt, processingTimeMs: $processingTimeMs, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkUploadHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy) &&
            (identical(other.uploadType, uploadType) ||
                other.uploadType == uploadType) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.fileFormat, fileFormat) ||
                other.fileFormat == fileFormat) &&
            (identical(other.totalRecords, totalRecords) ||
                other.totalRecords == totalRecords) &&
            (identical(other.successfulRecords, successfulRecords) ||
                other.successfulRecords == successfulRecords) &&
            (identical(other.failedRecords, failedRecords) ||
                other.failedRecords == failedRecords) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._errorDetails,
              _errorDetails,
            ) &&
            const DeepCollectionEquality().equals(
              other._uploadedData,
              _uploadedData,
            ) &&
            const DeepCollectionEquality().equals(
              other._resultSummary,
              _resultSummary,
            ) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.processingTimeMs, processingTimeMs) ||
                other.processingTimeMs == processingTimeMs) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessId,
    locationId,
    uploadedBy,
    uploadType,
    fileName,
    fileSize,
    fileFormat,
    totalRecords,
    successfulRecords,
    failedRecords,
    status,
    const DeepCollectionEquality().hash(_errorDetails),
    const DeepCollectionEquality().hash(_uploadedData),
    const DeepCollectionEquality().hash(_resultSummary),
    startedAt,
    completedAt,
    processingTimeMs,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of BulkUploadHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkUploadHistoryImplCopyWith<_$BulkUploadHistoryImpl> get copyWith =>
      __$$BulkUploadHistoryImplCopyWithImpl<_$BulkUploadHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BulkUploadHistoryImplToJson(this);
  }
}

abstract class _BulkUploadHistory implements BulkUploadHistory {
  const factory _BulkUploadHistory({
    required final String id,
    required final String businessId,
    final String? locationId,
    required final String uploadedBy,
    required final String uploadType,
    required final String fileName,
    final int? fileSize,
    final String? fileFormat,
    final int totalRecords,
    final int successfulRecords,
    final int failedRecords,
    final String status,
    final List<UploadError>? errorDetails,
    final Map<String, dynamic>? uploadedData,
    final Map<String, dynamic>? resultSummary,
    required final DateTime startedAt,
    final DateTime? completedAt,
    final int? processingTimeMs,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$BulkUploadHistoryImpl;

  factory _BulkUploadHistory.fromJson(Map<String, dynamic> json) =
      _$BulkUploadHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String? get locationId;
  @override
  String get uploadedBy; // Upload details
  @override
  String get uploadType; // 'products', 'customers', 'inventory', etc.
  @override
  String get fileName;
  @override
  int? get fileSize;
  @override
  String? get fileFormat; // Upload results
  @override
  int get totalRecords;
  @override
  int get successfulRecords;
  @override
  int get failedRecords;
  @override
  String get status; // 'pending', 'processing', 'completed', 'failed', 'partial'
  // Additional data
  @override
  List<UploadError>? get errorDetails;
  @override
  Map<String, dynamic>? get uploadedData; // Original parsed data
  @override
  Map<String, dynamic>? get resultSummary; // Summary of what was created/updated
  // Timestamps
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  int? get processingTimeMs;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of BulkUploadHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulkUploadHistoryImplCopyWith<_$BulkUploadHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UploadError _$UploadErrorFromJson(Map<String, dynamic> json) {
  return _UploadError.fromJson(json);
}

/// @nodoc
mixin _$UploadError {
  int get rowNumber => throw _privateConstructorUsedError;
  String get field => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get severity => throw _privateConstructorUsedError;

  /// Serializes this UploadError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadErrorCopyWith<UploadError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadErrorCopyWith<$Res> {
  factory $UploadErrorCopyWith(
    UploadError value,
    $Res Function(UploadError) then,
  ) = _$UploadErrorCopyWithImpl<$Res, UploadError>;
  @useResult
  $Res call({int rowNumber, String field, String message, String? severity});
}

/// @nodoc
class _$UploadErrorCopyWithImpl<$Res, $Val extends UploadError>
    implements $UploadErrorCopyWith<$Res> {
  _$UploadErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rowNumber = null,
    Object? field = null,
    Object? message = null,
    Object? severity = freezed,
  }) {
    return _then(
      _value.copyWith(
            rowNumber:
                null == rowNumber
                    ? _value.rowNumber
                    : rowNumber // ignore: cast_nullable_to_non_nullable
                        as int,
            field:
                null == field
                    ? _value.field
                    : field // ignore: cast_nullable_to_non_nullable
                        as String,
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
            severity:
                freezed == severity
                    ? _value.severity
                    : severity // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UploadErrorImplCopyWith<$Res>
    implements $UploadErrorCopyWith<$Res> {
  factory _$$UploadErrorImplCopyWith(
    _$UploadErrorImpl value,
    $Res Function(_$UploadErrorImpl) then,
  ) = __$$UploadErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int rowNumber, String field, String message, String? severity});
}

/// @nodoc
class __$$UploadErrorImplCopyWithImpl<$Res>
    extends _$UploadErrorCopyWithImpl<$Res, _$UploadErrorImpl>
    implements _$$UploadErrorImplCopyWith<$Res> {
  __$$UploadErrorImplCopyWithImpl(
    _$UploadErrorImpl _value,
    $Res Function(_$UploadErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rowNumber = null,
    Object? field = null,
    Object? message = null,
    Object? severity = freezed,
  }) {
    return _then(
      _$UploadErrorImpl(
        rowNumber:
            null == rowNumber
                ? _value.rowNumber
                : rowNumber // ignore: cast_nullable_to_non_nullable
                    as int,
        field:
            null == field
                ? _value.field
                : field // ignore: cast_nullable_to_non_nullable
                    as String,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        severity:
            freezed == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadErrorImpl implements _UploadError {
  const _$UploadErrorImpl({
    required this.rowNumber,
    required this.field,
    required this.message,
    this.severity,
  });

  factory _$UploadErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadErrorImplFromJson(json);

  @override
  final int rowNumber;
  @override
  final String field;
  @override
  final String message;
  @override
  final String? severity;

  @override
  String toString() {
    return 'UploadError(rowNumber: $rowNumber, field: $field, message: $message, severity: $severity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadErrorImpl &&
            (identical(other.rowNumber, rowNumber) ||
                other.rowNumber == rowNumber) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.severity, severity) ||
                other.severity == severity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, rowNumber, field, message, severity);

  /// Create a copy of UploadError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadErrorImplCopyWith<_$UploadErrorImpl> get copyWith =>
      __$$UploadErrorImplCopyWithImpl<_$UploadErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadErrorImplToJson(this);
  }
}

abstract class _UploadError implements UploadError {
  const factory _UploadError({
    required final int rowNumber,
    required final String field,
    required final String message,
    final String? severity,
  }) = _$UploadErrorImpl;

  factory _UploadError.fromJson(Map<String, dynamic> json) =
      _$UploadErrorImpl.fromJson;

  @override
  int get rowNumber;
  @override
  String get field;
  @override
  String get message;
  @override
  String? get severity;

  /// Create a copy of UploadError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadErrorImplCopyWith<_$UploadErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BulkUploadRecord _$BulkUploadRecordFromJson(Map<String, dynamic> json) {
  return _BulkUploadRecord.fromJson(json);
}

/// @nodoc
mixin _$BulkUploadRecord {
  String get id => throw _privateConstructorUsedError;
  String get uploadHistoryId =>
      throw _privateConstructorUsedError; // Record details
  int get rowNumber => throw _privateConstructorUsedError;
  String? get recordType => throw _privateConstructorUsedError;
  String? get recordId =>
      throw _privateConstructorUsedError; // ID of created/updated record
  // Processing result
  String get status =>
      throw _privateConstructorUsedError; // 'success', 'failed', 'skipped'
  String? get errorMessage => throw _privateConstructorUsedError;
  List<String>? get warnings =>
      throw _privateConstructorUsedError; // Record data
  Map<String, dynamic> get originalData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get processedData => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BulkUploadRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BulkUploadRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BulkUploadRecordCopyWith<BulkUploadRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkUploadRecordCopyWith<$Res> {
  factory $BulkUploadRecordCopyWith(
    BulkUploadRecord value,
    $Res Function(BulkUploadRecord) then,
  ) = _$BulkUploadRecordCopyWithImpl<$Res, BulkUploadRecord>;
  @useResult
  $Res call({
    String id,
    String uploadHistoryId,
    int rowNumber,
    String? recordType,
    String? recordId,
    String status,
    String? errorMessage,
    List<String>? warnings,
    Map<String, dynamic> originalData,
    Map<String, dynamic>? processedData,
    DateTime createdAt,
  });
}

/// @nodoc
class _$BulkUploadRecordCopyWithImpl<$Res, $Val extends BulkUploadRecord>
    implements $BulkUploadRecordCopyWith<$Res> {
  _$BulkUploadRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BulkUploadRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uploadHistoryId = null,
    Object? rowNumber = null,
    Object? recordType = freezed,
    Object? recordId = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? warnings = freezed,
    Object? originalData = null,
    Object? processedData = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            uploadHistoryId:
                null == uploadHistoryId
                    ? _value.uploadHistoryId
                    : uploadHistoryId // ignore: cast_nullable_to_non_nullable
                        as String,
            rowNumber:
                null == rowNumber
                    ? _value.rowNumber
                    : rowNumber // ignore: cast_nullable_to_non_nullable
                        as int,
            recordType:
                freezed == recordType
                    ? _value.recordType
                    : recordType // ignore: cast_nullable_to_non_nullable
                        as String?,
            recordId:
                freezed == recordId
                    ? _value.recordId
                    : recordId // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            warnings:
                freezed == warnings
                    ? _value.warnings
                    : warnings // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            originalData:
                null == originalData
                    ? _value.originalData
                    : originalData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            processedData:
                freezed == processedData
                    ? _value.processedData
                    : processedData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BulkUploadRecordImplCopyWith<$Res>
    implements $BulkUploadRecordCopyWith<$Res> {
  factory _$$BulkUploadRecordImplCopyWith(
    _$BulkUploadRecordImpl value,
    $Res Function(_$BulkUploadRecordImpl) then,
  ) = __$$BulkUploadRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String uploadHistoryId,
    int rowNumber,
    String? recordType,
    String? recordId,
    String status,
    String? errorMessage,
    List<String>? warnings,
    Map<String, dynamic> originalData,
    Map<String, dynamic>? processedData,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$BulkUploadRecordImplCopyWithImpl<$Res>
    extends _$BulkUploadRecordCopyWithImpl<$Res, _$BulkUploadRecordImpl>
    implements _$$BulkUploadRecordImplCopyWith<$Res> {
  __$$BulkUploadRecordImplCopyWithImpl(
    _$BulkUploadRecordImpl _value,
    $Res Function(_$BulkUploadRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BulkUploadRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uploadHistoryId = null,
    Object? rowNumber = null,
    Object? recordType = freezed,
    Object? recordId = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? warnings = freezed,
    Object? originalData = null,
    Object? processedData = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$BulkUploadRecordImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        uploadHistoryId:
            null == uploadHistoryId
                ? _value.uploadHistoryId
                : uploadHistoryId // ignore: cast_nullable_to_non_nullable
                    as String,
        rowNumber:
            null == rowNumber
                ? _value.rowNumber
                : rowNumber // ignore: cast_nullable_to_non_nullable
                    as int,
        recordType:
            freezed == recordType
                ? _value.recordType
                : recordType // ignore: cast_nullable_to_non_nullable
                    as String?,
        recordId:
            freezed == recordId
                ? _value.recordId
                : recordId // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        warnings:
            freezed == warnings
                ? _value._warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        originalData:
            null == originalData
                ? _value._originalData
                : originalData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        processedData:
            freezed == processedData
                ? _value._processedData
                : processedData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BulkUploadRecordImpl implements _BulkUploadRecord {
  const _$BulkUploadRecordImpl({
    required this.id,
    required this.uploadHistoryId,
    required this.rowNumber,
    this.recordType,
    this.recordId,
    required this.status,
    this.errorMessage,
    final List<String>? warnings,
    required final Map<String, dynamic> originalData,
    final Map<String, dynamic>? processedData,
    required this.createdAt,
  }) : _warnings = warnings,
       _originalData = originalData,
       _processedData = processedData;

  factory _$BulkUploadRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$BulkUploadRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String uploadHistoryId;
  // Record details
  @override
  final int rowNumber;
  @override
  final String? recordType;
  @override
  final String? recordId;
  // ID of created/updated record
  // Processing result
  @override
  final String status;
  // 'success', 'failed', 'skipped'
  @override
  final String? errorMessage;
  final List<String>? _warnings;
  @override
  List<String>? get warnings {
    final value = _warnings;
    if (value == null) return null;
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // Record data
  final Map<String, dynamic> _originalData;
  // Record data
  @override
  Map<String, dynamic> get originalData {
    if (_originalData is EqualUnmodifiableMapView) return _originalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_originalData);
  }

  final Map<String, dynamic>? _processedData;
  @override
  Map<String, dynamic>? get processedData {
    final value = _processedData;
    if (value == null) return null;
    if (_processedData is EqualUnmodifiableMapView) return _processedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BulkUploadRecord(id: $id, uploadHistoryId: $uploadHistoryId, rowNumber: $rowNumber, recordType: $recordType, recordId: $recordId, status: $status, errorMessage: $errorMessage, warnings: $warnings, originalData: $originalData, processedData: $processedData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkUploadRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uploadHistoryId, uploadHistoryId) ||
                other.uploadHistoryId == uploadHistoryId) &&
            (identical(other.rowNumber, rowNumber) ||
                other.rowNumber == rowNumber) &&
            (identical(other.recordType, recordType) ||
                other.recordType == recordType) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            const DeepCollectionEquality().equals(
              other._originalData,
              _originalData,
            ) &&
            const DeepCollectionEquality().equals(
              other._processedData,
              _processedData,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    uploadHistoryId,
    rowNumber,
    recordType,
    recordId,
    status,
    errorMessage,
    const DeepCollectionEquality().hash(_warnings),
    const DeepCollectionEquality().hash(_originalData),
    const DeepCollectionEquality().hash(_processedData),
    createdAt,
  );

  /// Create a copy of BulkUploadRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkUploadRecordImplCopyWith<_$BulkUploadRecordImpl> get copyWith =>
      __$$BulkUploadRecordImplCopyWithImpl<_$BulkUploadRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BulkUploadRecordImplToJson(this);
  }
}

abstract class _BulkUploadRecord implements BulkUploadRecord {
  const factory _BulkUploadRecord({
    required final String id,
    required final String uploadHistoryId,
    required final int rowNumber,
    final String? recordType,
    final String? recordId,
    required final String status,
    final String? errorMessage,
    final List<String>? warnings,
    required final Map<String, dynamic> originalData,
    final Map<String, dynamic>? processedData,
    required final DateTime createdAt,
  }) = _$BulkUploadRecordImpl;

  factory _BulkUploadRecord.fromJson(Map<String, dynamic> json) =
      _$BulkUploadRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get uploadHistoryId; // Record details
  @override
  int get rowNumber;
  @override
  String? get recordType;
  @override
  String? get recordId; // ID of created/updated record
  // Processing result
  @override
  String get status; // 'success', 'failed', 'skipped'
  @override
  String? get errorMessage;
  @override
  List<String>? get warnings; // Record data
  @override
  Map<String, dynamic> get originalData;
  @override
  Map<String, dynamic>? get processedData;
  @override
  DateTime get createdAt;

  /// Create a copy of BulkUploadRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulkUploadRecordImplCopyWith<_$BulkUploadRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
