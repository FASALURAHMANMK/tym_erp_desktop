// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeImpl _$$EmployeeImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      businessId: json['businessId'] as String,
      employeeCode: json['employeeCode'] as String,
      displayName: json['displayName'] as String?,
      primaryRole: $enumDecode(_$EmployeeRoleEnumMap, json['primaryRole']),
      assignedLocations:
          (json['assignedLocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      canAccessAllLocations: json['canAccessAllLocations'] as bool? ?? false,
      employmentStatus:
          $enumDecodeNullable(
            _$EmploymentStatusEnumMap,
            json['employmentStatus'],
          ) ??
          EmploymentStatus.active,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      terminatedAt:
          json['terminatedAt'] == null
              ? null
              : DateTime.parse(json['terminatedAt'] as String),
      terminationReason: json['terminationReason'] as String?,
      workPhone: json['workPhone'] as String?,
      workEmail: json['workEmail'] as String?,
      emergencyContact:
          json['emergencyContact'] as Map<String, dynamic>? ?? const {},
      permissions: json['permissions'] as Map<String, dynamic>? ?? const {},
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      defaultShiftStart: json['defaultShiftStart'] as String?,
      defaultShiftEnd: json['defaultShiftEnd'] as String?,
      workingDays:
          (json['workingDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [1, 2, 3, 4, 5],
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      monthlySalary: (json['monthlySalary'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
      lastSyncedAt:
          json['lastSyncedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncedAt'] as String),
    );

Map<String, dynamic> _$$EmployeeImplToJson(_$EmployeeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'businessId': instance.businessId,
      'employeeCode': instance.employeeCode,
      'displayName': instance.displayName,
      'primaryRole': _$EmployeeRoleEnumMap[instance.primaryRole]!,
      'assignedLocations': instance.assignedLocations,
      'canAccessAllLocations': instance.canAccessAllLocations,
      'employmentStatus': _$EmploymentStatusEnumMap[instance.employmentStatus]!,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'terminatedAt': instance.terminatedAt?.toIso8601String(),
      'terminationReason': instance.terminationReason,
      'workPhone': instance.workPhone,
      'workEmail': instance.workEmail,
      'emergencyContact': instance.emergencyContact,
      'permissions': instance.permissions,
      'settings': instance.settings,
      'defaultShiftStart': instance.defaultShiftStart,
      'defaultShiftEnd': instance.defaultShiftEnd,
      'workingDays': instance.workingDays,
      'hourlyRate': instance.hourlyRate,
      'monthlySalary': instance.monthlySalary,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'lastModifiedBy': instance.lastModifiedBy,
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
    };

const _$EmployeeRoleEnumMap = {
  EmployeeRole.owner: 'owner',
  EmployeeRole.manager: 'manager',
  EmployeeRole.cashier: 'cashier',
  EmployeeRole.waiter: 'waiter',
  EmployeeRole.kitchenStaff: 'kitchen_staff',
  EmployeeRole.delivery: 'delivery',
  EmployeeRole.accountant: 'accountant',
};

const _$EmploymentStatusEnumMap = {
  EmploymentStatus.active: 'active',
  EmploymentStatus.inactive: 'inactive',
  EmploymentStatus.suspended: 'suspended',
  EmploymentStatus.terminated: 'terminated',
};
