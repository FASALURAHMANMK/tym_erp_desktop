// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return _Employee.fromJson(json);
}

/// @nodoc
mixin _$Employee {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError; // Basic Info
  String get employeeCode => throw _privateConstructorUsedError;
  String? get displayName =>
      throw _privateConstructorUsedError; // Role & Access
  EmployeeRole get primaryRole => throw _privateConstructorUsedError;
  List<String> get assignedLocations => throw _privateConstructorUsedError;
  bool get canAccessAllLocations =>
      throw _privateConstructorUsedError; // Employment
  EmploymentStatus get employmentStatus => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;
  DateTime? get terminatedAt => throw _privateConstructorUsedError;
  String? get terminationReason =>
      throw _privateConstructorUsedError; // Contact
  String? get workPhone => throw _privateConstructorUsedError;
  String? get workEmail => throw _privateConstructorUsedError;
  Map<String, dynamic> get emergencyContact =>
      throw _privateConstructorUsedError; // Settings & Permissions
  Map<String, dynamic> get permissions => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings =>
      throw _privateConstructorUsedError; // Shift & Schedule
  String? get defaultShiftStart =>
      throw _privateConstructorUsedError; // Store as string "09:00"
  String? get defaultShiftEnd =>
      throw _privateConstructorUsedError; // Store as string "17:00"
  List<int> get workingDays =>
      throw _privateConstructorUsedError; // 1=Monday, 7=Sunday
  // Compensation
  double? get hourlyRate => throw _privateConstructorUsedError;
  double? get monthlySalary => throw _privateConstructorUsedError; // Meta
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get lastModifiedBy =>
      throw _privateConstructorUsedError; // Sync fields
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Serializes this Employee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeCopyWith<Employee> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeCopyWith<$Res> {
  factory $EmployeeCopyWith(Employee value, $Res Function(Employee) then) =
      _$EmployeeCopyWithImpl<$Res, Employee>;
  @useResult
  $Res call({
    String id,
    String userId,
    String businessId,
    String employeeCode,
    String? displayName,
    EmployeeRole primaryRole,
    List<String> assignedLocations,
    bool canAccessAllLocations,
    EmploymentStatus employmentStatus,
    DateTime joinedAt,
    DateTime? terminatedAt,
    String? terminationReason,
    String? workPhone,
    String? workEmail,
    Map<String, dynamic> emergencyContact,
    Map<String, dynamic> permissions,
    Map<String, dynamic> settings,
    String? defaultShiftStart,
    String? defaultShiftEnd,
    List<int> workingDays,
    double? hourlyRate,
    double? monthlySalary,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    String? lastModifiedBy,
    bool hasUnsyncedChanges,
    DateTime? lastSyncedAt,
  });
}

/// @nodoc
class _$EmployeeCopyWithImpl<$Res, $Val extends Employee>
    implements $EmployeeCopyWith<$Res> {
  _$EmployeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? businessId = null,
    Object? employeeCode = null,
    Object? displayName = freezed,
    Object? primaryRole = null,
    Object? assignedLocations = null,
    Object? canAccessAllLocations = null,
    Object? employmentStatus = null,
    Object? joinedAt = null,
    Object? terminatedAt = freezed,
    Object? terminationReason = freezed,
    Object? workPhone = freezed,
    Object? workEmail = freezed,
    Object? emergencyContact = null,
    Object? permissions = null,
    Object? settings = null,
    Object? defaultShiftStart = freezed,
    Object? defaultShiftEnd = freezed,
    Object? workingDays = null,
    Object? hourlyRate = freezed,
    Object? monthlySalary = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? lastModifiedBy = freezed,
    Object? hasUnsyncedChanges = null,
    Object? lastSyncedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            businessId:
                null == businessId
                    ? _value.businessId
                    : businessId // ignore: cast_nullable_to_non_nullable
                        as String,
            employeeCode:
                null == employeeCode
                    ? _value.employeeCode
                    : employeeCode // ignore: cast_nullable_to_non_nullable
                        as String,
            displayName:
                freezed == displayName
                    ? _value.displayName
                    : displayName // ignore: cast_nullable_to_non_nullable
                        as String?,
            primaryRole:
                null == primaryRole
                    ? _value.primaryRole
                    : primaryRole // ignore: cast_nullable_to_non_nullable
                        as EmployeeRole,
            assignedLocations:
                null == assignedLocations
                    ? _value.assignedLocations
                    : assignedLocations // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            canAccessAllLocations:
                null == canAccessAllLocations
                    ? _value.canAccessAllLocations
                    : canAccessAllLocations // ignore: cast_nullable_to_non_nullable
                        as bool,
            employmentStatus:
                null == employmentStatus
                    ? _value.employmentStatus
                    : employmentStatus // ignore: cast_nullable_to_non_nullable
                        as EmploymentStatus,
            joinedAt:
                null == joinedAt
                    ? _value.joinedAt
                    : joinedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            terminatedAt:
                freezed == terminatedAt
                    ? _value.terminatedAt
                    : terminatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            terminationReason:
                freezed == terminationReason
                    ? _value.terminationReason
                    : terminationReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            workPhone:
                freezed == workPhone
                    ? _value.workPhone
                    : workPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            workEmail:
                freezed == workEmail
                    ? _value.workEmail
                    : workEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            emergencyContact:
                null == emergencyContact
                    ? _value.emergencyContact
                    : emergencyContact // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            permissions:
                null == permissions
                    ? _value.permissions
                    : permissions // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            settings:
                null == settings
                    ? _value.settings
                    : settings // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            defaultShiftStart:
                freezed == defaultShiftStart
                    ? _value.defaultShiftStart
                    : defaultShiftStart // ignore: cast_nullable_to_non_nullable
                        as String?,
            defaultShiftEnd:
                freezed == defaultShiftEnd
                    ? _value.defaultShiftEnd
                    : defaultShiftEnd // ignore: cast_nullable_to_non_nullable
                        as String?,
            workingDays:
                null == workingDays
                    ? _value.workingDays
                    : workingDays // ignore: cast_nullable_to_non_nullable
                        as List<int>,
            hourlyRate:
                freezed == hourlyRate
                    ? _value.hourlyRate
                    : hourlyRate // ignore: cast_nullable_to_non_nullable
                        as double?,
            monthlySalary:
                freezed == monthlySalary
                    ? _value.monthlySalary
                    : monthlySalary // ignore: cast_nullable_to_non_nullable
                        as double?,
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
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastModifiedBy:
                freezed == lastModifiedBy
                    ? _value.lastModifiedBy
                    : lastModifiedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            hasUnsyncedChanges:
                null == hasUnsyncedChanges
                    ? _value.hasUnsyncedChanges
                    : hasUnsyncedChanges // ignore: cast_nullable_to_non_nullable
                        as bool,
            lastSyncedAt:
                freezed == lastSyncedAt
                    ? _value.lastSyncedAt
                    : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeImplCopyWith<$Res>
    implements $EmployeeCopyWith<$Res> {
  factory _$$EmployeeImplCopyWith(
    _$EmployeeImpl value,
    $Res Function(_$EmployeeImpl) then,
  ) = __$$EmployeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String businessId,
    String employeeCode,
    String? displayName,
    EmployeeRole primaryRole,
    List<String> assignedLocations,
    bool canAccessAllLocations,
    EmploymentStatus employmentStatus,
    DateTime joinedAt,
    DateTime? terminatedAt,
    String? terminationReason,
    String? workPhone,
    String? workEmail,
    Map<String, dynamic> emergencyContact,
    Map<String, dynamic> permissions,
    Map<String, dynamic> settings,
    String? defaultShiftStart,
    String? defaultShiftEnd,
    List<int> workingDays,
    double? hourlyRate,
    double? monthlySalary,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    String? lastModifiedBy,
    bool hasUnsyncedChanges,
    DateTime? lastSyncedAt,
  });
}

/// @nodoc
class __$$EmployeeImplCopyWithImpl<$Res>
    extends _$EmployeeCopyWithImpl<$Res, _$EmployeeImpl>
    implements _$$EmployeeImplCopyWith<$Res> {
  __$$EmployeeImplCopyWithImpl(
    _$EmployeeImpl _value,
    $Res Function(_$EmployeeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? businessId = null,
    Object? employeeCode = null,
    Object? displayName = freezed,
    Object? primaryRole = null,
    Object? assignedLocations = null,
    Object? canAccessAllLocations = null,
    Object? employmentStatus = null,
    Object? joinedAt = null,
    Object? terminatedAt = freezed,
    Object? terminationReason = freezed,
    Object? workPhone = freezed,
    Object? workEmail = freezed,
    Object? emergencyContact = null,
    Object? permissions = null,
    Object? settings = null,
    Object? defaultShiftStart = freezed,
    Object? defaultShiftEnd = freezed,
    Object? workingDays = null,
    Object? hourlyRate = freezed,
    Object? monthlySalary = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? lastModifiedBy = freezed,
    Object? hasUnsyncedChanges = null,
    Object? lastSyncedAt = freezed,
  }) {
    return _then(
      _$EmployeeImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        businessId:
            null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                    as String,
        employeeCode:
            null == employeeCode
                ? _value.employeeCode
                : employeeCode // ignore: cast_nullable_to_non_nullable
                    as String,
        displayName:
            freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                    as String?,
        primaryRole:
            null == primaryRole
                ? _value.primaryRole
                : primaryRole // ignore: cast_nullable_to_non_nullable
                    as EmployeeRole,
        assignedLocations:
            null == assignedLocations
                ? _value._assignedLocations
                : assignedLocations // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        canAccessAllLocations:
            null == canAccessAllLocations
                ? _value.canAccessAllLocations
                : canAccessAllLocations // ignore: cast_nullable_to_non_nullable
                    as bool,
        employmentStatus:
            null == employmentStatus
                ? _value.employmentStatus
                : employmentStatus // ignore: cast_nullable_to_non_nullable
                    as EmploymentStatus,
        joinedAt:
            null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        terminatedAt:
            freezed == terminatedAt
                ? _value.terminatedAt
                : terminatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        terminationReason:
            freezed == terminationReason
                ? _value.terminationReason
                : terminationReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        workPhone:
            freezed == workPhone
                ? _value.workPhone
                : workPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        workEmail:
            freezed == workEmail
                ? _value.workEmail
                : workEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        emergencyContact:
            null == emergencyContact
                ? _value._emergencyContact
                : emergencyContact // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        permissions:
            null == permissions
                ? _value._permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        settings:
            null == settings
                ? _value._settings
                : settings // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        defaultShiftStart:
            freezed == defaultShiftStart
                ? _value.defaultShiftStart
                : defaultShiftStart // ignore: cast_nullable_to_non_nullable
                    as String?,
        defaultShiftEnd:
            freezed == defaultShiftEnd
                ? _value.defaultShiftEnd
                : defaultShiftEnd // ignore: cast_nullable_to_non_nullable
                    as String?,
        workingDays:
            null == workingDays
                ? _value._workingDays
                : workingDays // ignore: cast_nullable_to_non_nullable
                    as List<int>,
        hourlyRate:
            freezed == hourlyRate
                ? _value.hourlyRate
                : hourlyRate // ignore: cast_nullable_to_non_nullable
                    as double?,
        monthlySalary:
            freezed == monthlySalary
                ? _value.monthlySalary
                : monthlySalary // ignore: cast_nullable_to_non_nullable
                    as double?,
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
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastModifiedBy:
            freezed == lastModifiedBy
                ? _value.lastModifiedBy
                : lastModifiedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        hasUnsyncedChanges:
            null == hasUnsyncedChanges
                ? _value.hasUnsyncedChanges
                : hasUnsyncedChanges // ignore: cast_nullable_to_non_nullable
                    as bool,
        lastSyncedAt:
            freezed == lastSyncedAt
                ? _value.lastSyncedAt
                : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeImpl extends _Employee {
  const _$EmployeeImpl({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.employeeCode,
    this.displayName,
    required this.primaryRole,
    final List<String> assignedLocations = const [],
    this.canAccessAllLocations = false,
    this.employmentStatus = EmploymentStatus.active,
    required this.joinedAt,
    this.terminatedAt,
    this.terminationReason,
    this.workPhone,
    this.workEmail,
    final Map<String, dynamic> emergencyContact = const {},
    final Map<String, dynamic> permissions = const {},
    final Map<String, dynamic> settings = const {},
    this.defaultShiftStart,
    this.defaultShiftEnd,
    final List<int> workingDays = const [1, 2, 3, 4, 5],
    this.hourlyRate,
    this.monthlySalary,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.lastModifiedBy,
    this.hasUnsyncedChanges = false,
    this.lastSyncedAt,
  }) : _assignedLocations = assignedLocations,
       _emergencyContact = emergencyContact,
       _permissions = permissions,
       _settings = settings,
       _workingDays = workingDays,
       super._();

  factory _$EmployeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String businessId;
  // Basic Info
  @override
  final String employeeCode;
  @override
  final String? displayName;
  // Role & Access
  @override
  final EmployeeRole primaryRole;
  final List<String> _assignedLocations;
  @override
  @JsonKey()
  List<String> get assignedLocations {
    if (_assignedLocations is EqualUnmodifiableListView)
      return _assignedLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedLocations);
  }

  @override
  @JsonKey()
  final bool canAccessAllLocations;
  // Employment
  @override
  @JsonKey()
  final EmploymentStatus employmentStatus;
  @override
  final DateTime joinedAt;
  @override
  final DateTime? terminatedAt;
  @override
  final String? terminationReason;
  // Contact
  @override
  final String? workPhone;
  @override
  final String? workEmail;
  final Map<String, dynamic> _emergencyContact;
  @override
  @JsonKey()
  Map<String, dynamic> get emergencyContact {
    if (_emergencyContact is EqualUnmodifiableMapView) return _emergencyContact;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_emergencyContact);
  }

  // Settings & Permissions
  final Map<String, dynamic> _permissions;
  // Settings & Permissions
  @override
  @JsonKey()
  Map<String, dynamic> get permissions {
    if (_permissions is EqualUnmodifiableMapView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_permissions);
  }

  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  // Shift & Schedule
  @override
  final String? defaultShiftStart;
  // Store as string "09:00"
  @override
  final String? defaultShiftEnd;
  // Store as string "17:00"
  final List<int> _workingDays;
  // Store as string "17:00"
  @override
  @JsonKey()
  List<int> get workingDays {
    if (_workingDays is EqualUnmodifiableListView) return _workingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workingDays);
  }

  // 1=Monday, 7=Sunday
  // Compensation
  @override
  final double? hourlyRate;
  @override
  final double? monthlySalary;
  // Meta
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? createdBy;
  @override
  final String? lastModifiedBy;
  // Sync fields
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;
  @override
  final DateTime? lastSyncedAt;

  @override
  String toString() {
    return 'Employee(id: $id, userId: $userId, businessId: $businessId, employeeCode: $employeeCode, displayName: $displayName, primaryRole: $primaryRole, assignedLocations: $assignedLocations, canAccessAllLocations: $canAccessAllLocations, employmentStatus: $employmentStatus, joinedAt: $joinedAt, terminatedAt: $terminatedAt, terminationReason: $terminationReason, workPhone: $workPhone, workEmail: $workEmail, emergencyContact: $emergencyContact, permissions: $permissions, settings: $settings, defaultShiftStart: $defaultShiftStart, defaultShiftEnd: $defaultShiftEnd, workingDays: $workingDays, hourlyRate: $hourlyRate, monthlySalary: $monthlySalary, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, hasUnsyncedChanges: $hasUnsyncedChanges, lastSyncedAt: $lastSyncedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.employeeCode, employeeCode) ||
                other.employeeCode == employeeCode) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.primaryRole, primaryRole) ||
                other.primaryRole == primaryRole) &&
            const DeepCollectionEquality().equals(
              other._assignedLocations,
              _assignedLocations,
            ) &&
            (identical(other.canAccessAllLocations, canAccessAllLocations) ||
                other.canAccessAllLocations == canAccessAllLocations) &&
            (identical(other.employmentStatus, employmentStatus) ||
                other.employmentStatus == employmentStatus) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.terminatedAt, terminatedAt) ||
                other.terminatedAt == terminatedAt) &&
            (identical(other.terminationReason, terminationReason) ||
                other.terminationReason == terminationReason) &&
            (identical(other.workPhone, workPhone) ||
                other.workPhone == workPhone) &&
            (identical(other.workEmail, workEmail) ||
                other.workEmail == workEmail) &&
            const DeepCollectionEquality().equals(
              other._emergencyContact,
              _emergencyContact,
            ) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.defaultShiftStart, defaultShiftStart) ||
                other.defaultShiftStart == defaultShiftStart) &&
            (identical(other.defaultShiftEnd, defaultShiftEnd) ||
                other.defaultShiftEnd == defaultShiftEnd) &&
            const DeepCollectionEquality().equals(
              other._workingDays,
              _workingDays,
            ) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.monthlySalary, monthlySalary) ||
                other.monthlySalary == monthlySalary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.lastModifiedBy, lastModifiedBy) ||
                other.lastModifiedBy == lastModifiedBy) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    businessId,
    employeeCode,
    displayName,
    primaryRole,
    const DeepCollectionEquality().hash(_assignedLocations),
    canAccessAllLocations,
    employmentStatus,
    joinedAt,
    terminatedAt,
    terminationReason,
    workPhone,
    workEmail,
    const DeepCollectionEquality().hash(_emergencyContact),
    const DeepCollectionEquality().hash(_permissions),
    const DeepCollectionEquality().hash(_settings),
    defaultShiftStart,
    defaultShiftEnd,
    const DeepCollectionEquality().hash(_workingDays),
    hourlyRate,
    monthlySalary,
    createdAt,
    updatedAt,
    createdBy,
    lastModifiedBy,
    hasUnsyncedChanges,
    lastSyncedAt,
  ]);

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeImplCopyWith<_$EmployeeImpl> get copyWith =>
      __$$EmployeeImplCopyWithImpl<_$EmployeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeImplToJson(this);
  }
}

abstract class _Employee extends Employee {
  const factory _Employee({
    required final String id,
    required final String userId,
    required final String businessId,
    required final String employeeCode,
    final String? displayName,
    required final EmployeeRole primaryRole,
    final List<String> assignedLocations,
    final bool canAccessAllLocations,
    final EmploymentStatus employmentStatus,
    required final DateTime joinedAt,
    final DateTime? terminatedAt,
    final String? terminationReason,
    final String? workPhone,
    final String? workEmail,
    final Map<String, dynamic> emergencyContact,
    final Map<String, dynamic> permissions,
    final Map<String, dynamic> settings,
    final String? defaultShiftStart,
    final String? defaultShiftEnd,
    final List<int> workingDays,
    final double? hourlyRate,
    final double? monthlySalary,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? createdBy,
    final String? lastModifiedBy,
    final bool hasUnsyncedChanges,
    final DateTime? lastSyncedAt,
  }) = _$EmployeeImpl;
  const _Employee._() : super._();

  factory _Employee.fromJson(Map<String, dynamic> json) =
      _$EmployeeImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get businessId; // Basic Info
  @override
  String get employeeCode;
  @override
  String? get displayName; // Role & Access
  @override
  EmployeeRole get primaryRole;
  @override
  List<String> get assignedLocations;
  @override
  bool get canAccessAllLocations; // Employment
  @override
  EmploymentStatus get employmentStatus;
  @override
  DateTime get joinedAt;
  @override
  DateTime? get terminatedAt;
  @override
  String? get terminationReason; // Contact
  @override
  String? get workPhone;
  @override
  String? get workEmail;
  @override
  Map<String, dynamic> get emergencyContact; // Settings & Permissions
  @override
  Map<String, dynamic> get permissions;
  @override
  Map<String, dynamic> get settings; // Shift & Schedule
  @override
  String? get defaultShiftStart; // Store as string "09:00"
  @override
  String? get defaultShiftEnd; // Store as string "17:00"
  @override
  List<int> get workingDays; // 1=Monday, 7=Sunday
  // Compensation
  @override
  double? get hourlyRate;
  @override
  double? get monthlySalary; // Meta
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get lastModifiedBy; // Sync fields
  @override
  bool get hasUnsyncedChanges;
  @override
  DateTime? get lastSyncedAt;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeImplCopyWith<_$EmployeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
