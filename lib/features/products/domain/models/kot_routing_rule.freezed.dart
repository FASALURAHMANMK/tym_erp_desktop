// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kot_routing_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KotRoutingRule _$KotRoutingRuleFromJson(Map<String, dynamic> json) {
  return _KotRoutingRule.fromJson(json);
}

/// @nodoc
mixin _$KotRoutingRule {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get printerId => throw _privateConstructorUsedError;
  String? get instruction => throw _privateConstructorUsedError;
  int get copies => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  bool get isActive =>
      throw _privateConstructorUsedError; // Optional conditions
  String? get orderType =>
      throw _privateConstructorUsedError; // dine_in, takeaway, delivery
  String? get timeRange =>
      throw _privateConstructorUsedError; // breakfast, lunch, dinner
  // Sync fields
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this KotRoutingRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KotRoutingRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KotRoutingRuleCopyWith<KotRoutingRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KotRoutingRuleCopyWith<$Res> {
  factory $KotRoutingRuleCopyWith(
    KotRoutingRule value,
    $Res Function(KotRoutingRule) then,
  ) = _$KotRoutingRuleCopyWithImpl<$Res, KotRoutingRule>;
  @useResult
  $Res call({
    String id,
    String productId,
    String printerId,
    String? instruction,
    int copies,
    int priority,
    bool isActive,
    String? orderType,
    String? timeRange,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$KotRoutingRuleCopyWithImpl<$Res, $Val extends KotRoutingRule>
    implements $KotRoutingRuleCopyWith<$Res> {
  _$KotRoutingRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KotRoutingRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? printerId = null,
    Object? instruction = freezed,
    Object? copies = null,
    Object? priority = null,
    Object? isActive = null,
    Object? orderType = freezed,
    Object? timeRange = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            productId:
                null == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String,
            printerId:
                null == printerId
                    ? _value.printerId
                    : printerId // ignore: cast_nullable_to_non_nullable
                        as String,
            instruction:
                freezed == instruction
                    ? _value.instruction
                    : instruction // ignore: cast_nullable_to_non_nullable
                        as String?,
            copies:
                null == copies
                    ? _value.copies
                    : copies // ignore: cast_nullable_to_non_nullable
                        as int,
            priority:
                null == priority
                    ? _value.priority
                    : priority // ignore: cast_nullable_to_non_nullable
                        as int,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            orderType:
                freezed == orderType
                    ? _value.orderType
                    : orderType // ignore: cast_nullable_to_non_nullable
                        as String?,
            timeRange:
                freezed == timeRange
                    ? _value.timeRange
                    : timeRange // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            lastSyncedAt:
                freezed == lastSyncedAt
                    ? _value.lastSyncedAt
                    : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            hasUnsyncedChanges:
                null == hasUnsyncedChanges
                    ? _value.hasUnsyncedChanges
                    : hasUnsyncedChanges // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KotRoutingRuleImplCopyWith<$Res>
    implements $KotRoutingRuleCopyWith<$Res> {
  factory _$$KotRoutingRuleImplCopyWith(
    _$KotRoutingRuleImpl value,
    $Res Function(_$KotRoutingRuleImpl) then,
  ) = __$$KotRoutingRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productId,
    String printerId,
    String? instruction,
    int copies,
    int priority,
    bool isActive,
    String? orderType,
    String? timeRange,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$KotRoutingRuleImplCopyWithImpl<$Res>
    extends _$KotRoutingRuleCopyWithImpl<$Res, _$KotRoutingRuleImpl>
    implements _$$KotRoutingRuleImplCopyWith<$Res> {
  __$$KotRoutingRuleImplCopyWithImpl(
    _$KotRoutingRuleImpl _value,
    $Res Function(_$KotRoutingRuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KotRoutingRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? printerId = null,
    Object? instruction = freezed,
    Object? copies = null,
    Object? priority = null,
    Object? isActive = null,
    Object? orderType = freezed,
    Object? timeRange = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$KotRoutingRuleImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        productId:
            null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String,
        printerId:
            null == printerId
                ? _value.printerId
                : printerId // ignore: cast_nullable_to_non_nullable
                    as String,
        instruction:
            freezed == instruction
                ? _value.instruction
                : instruction // ignore: cast_nullable_to_non_nullable
                    as String?,
        copies:
            null == copies
                ? _value.copies
                : copies // ignore: cast_nullable_to_non_nullable
                    as int,
        priority:
            null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                    as int,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        orderType:
            freezed == orderType
                ? _value.orderType
                : orderType // ignore: cast_nullable_to_non_nullable
                    as String?,
        timeRange:
            freezed == timeRange
                ? _value.timeRange
                : timeRange // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        lastSyncedAt:
            freezed == lastSyncedAt
                ? _value.lastSyncedAt
                : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        hasUnsyncedChanges:
            null == hasUnsyncedChanges
                ? _value.hasUnsyncedChanges
                : hasUnsyncedChanges // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KotRoutingRuleImpl extends _KotRoutingRule {
  const _$KotRoutingRuleImpl({
    required this.id,
    required this.productId,
    required this.printerId,
    this.instruction,
    this.copies = 1,
    this.priority = 1,
    this.isActive = true,
    this.orderType,
    this.timeRange,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : super._();

  factory _$KotRoutingRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$KotRoutingRuleImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String printerId;
  @override
  final String? instruction;
  @override
  @JsonKey()
  final int copies;
  @override
  @JsonKey()
  final int priority;
  @override
  @JsonKey()
  final bool isActive;
  // Optional conditions
  @override
  final String? orderType;
  // dine_in, takeaway, delivery
  @override
  final String? timeRange;
  // breakfast, lunch, dinner
  // Sync fields
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'KotRoutingRule(id: $id, productId: $productId, printerId: $printerId, instruction: $instruction, copies: $copies, priority: $priority, isActive: $isActive, orderType: $orderType, timeRange: $timeRange, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KotRoutingRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.printerId, printerId) ||
                other.printerId == printerId) &&
            (identical(other.instruction, instruction) ||
                other.instruction == instruction) &&
            (identical(other.copies, copies) || other.copies == copies) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    printerId,
    instruction,
    copies,
    priority,
    isActive,
    orderType,
    timeRange,
    createdAt,
    updatedAt,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of KotRoutingRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KotRoutingRuleImplCopyWith<_$KotRoutingRuleImpl> get copyWith =>
      __$$KotRoutingRuleImplCopyWithImpl<_$KotRoutingRuleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KotRoutingRuleImplToJson(this);
  }
}

abstract class _KotRoutingRule extends KotRoutingRule {
  const factory _KotRoutingRule({
    required final String id,
    required final String productId,
    required final String printerId,
    final String? instruction,
    final int copies,
    final int priority,
    final bool isActive,
    final String? orderType,
    final String? timeRange,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$KotRoutingRuleImpl;
  const _KotRoutingRule._() : super._();

  factory _KotRoutingRule.fromJson(Map<String, dynamic> json) =
      _$KotRoutingRuleImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get printerId;
  @override
  String? get instruction;
  @override
  int get copies;
  @override
  int get priority;
  @override
  bool get isActive; // Optional conditions
  @override
  String? get orderType; // dine_in, takeaway, delivery
  @override
  String? get timeRange; // breakfast, lunch, dinner
  // Sync fields
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of KotRoutingRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KotRoutingRuleImplCopyWith<_$KotRoutingRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
