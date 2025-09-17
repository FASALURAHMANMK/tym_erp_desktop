// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tax_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaxGroup _$TaxGroupFromJson(Map<String, dynamic> json) {
  return _TaxGroup.fromJson(json);
}

/// @nodoc
mixin _$TaxGroup {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  List<TaxRate> get taxRates => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaxGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxGroupCopyWith<TaxGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxGroupCopyWith<$Res> {
  factory $TaxGroupCopyWith(TaxGroup value, $Res Function(TaxGroup) then) =
      _$TaxGroupCopyWithImpl<$Res, TaxGroup>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? description,
    bool isDefault,
    bool isActive,
    int displayOrder,
    List<TaxRate> taxRates,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TaxGroupCopyWithImpl<$Res, $Val extends TaxGroup>
    implements $TaxGroupCopyWith<$Res> {
  _$TaxGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? description = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? taxRates = null,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
                        as bool,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            taxRates:
                null == taxRates
                    ? _value.taxRates
                    : taxRates // ignore: cast_nullable_to_non_nullable
                        as List<TaxRate>,
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
abstract class _$$TaxGroupImplCopyWith<$Res>
    implements $TaxGroupCopyWith<$Res> {
  factory _$$TaxGroupImplCopyWith(
    _$TaxGroupImpl value,
    $Res Function(_$TaxGroupImpl) then,
  ) = __$$TaxGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? description,
    bool isDefault,
    bool isActive,
    int displayOrder,
    List<TaxRate> taxRates,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TaxGroupImplCopyWithImpl<$Res>
    extends _$TaxGroupCopyWithImpl<$Res, _$TaxGroupImpl>
    implements _$$TaxGroupImplCopyWith<$Res> {
  __$$TaxGroupImplCopyWithImpl(
    _$TaxGroupImpl _value,
    $Res Function(_$TaxGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaxGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? description = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? taxRates = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TaxGroupImpl(
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
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                    as bool,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        taxRates:
            null == taxRates
                ? _value._taxRates
                : taxRates // ignore: cast_nullable_to_non_nullable
                    as List<TaxRate>,
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
class _$TaxGroupImpl implements _TaxGroup {
  const _$TaxGroupImpl({
    required this.id,
    required this.businessId,
    required this.name,
    this.description,
    this.isDefault = false,
    this.isActive = true,
    this.displayOrder = 0,
    final List<TaxRate> taxRates = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : _taxRates = taxRates;

  factory _$TaxGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int displayOrder;
  final List<TaxRate> _taxRates;
  @override
  @JsonKey()
  List<TaxRate> get taxRates {
    if (_taxRates is EqualUnmodifiableListView) return _taxRates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taxRates);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaxGroup(id: $id, businessId: $businessId, name: $name, description: $description, isDefault: $isDefault, isActive: $isActive, displayOrder: $displayOrder, taxRates: $taxRates, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            const DeepCollectionEquality().equals(other._taxRates, _taxRates) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    name,
    description,
    isDefault,
    isActive,
    displayOrder,
    const DeepCollectionEquality().hash(_taxRates),
    createdAt,
    updatedAt,
  );

  /// Create a copy of TaxGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxGroupImplCopyWith<_$TaxGroupImpl> get copyWith =>
      __$$TaxGroupImplCopyWithImpl<_$TaxGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxGroupImplToJson(this);
  }
}

abstract class _TaxGroup implements TaxGroup {
  const factory _TaxGroup({
    required final String id,
    required final String businessId,
    required final String name,
    final String? description,
    final bool isDefault,
    final bool isActive,
    final int displayOrder,
    final List<TaxRate> taxRates,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TaxGroupImpl;

  factory _TaxGroup.fromJson(Map<String, dynamic> json) =
      _$TaxGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  String? get description;
  @override
  bool get isDefault;
  @override
  bool get isActive;
  @override
  int get displayOrder;
  @override
  List<TaxRate> get taxRates;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TaxGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxGroupImplCopyWith<_$TaxGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaxRate _$TaxRateFromJson(Map<String, dynamic> json) {
  return _TaxRate.fromJson(json);
}

/// @nodoc
mixin _$TaxRate {
  String get id => throw _privateConstructorUsedError;
  String get taxGroupId => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get rate =>
      throw _privateConstructorUsedError; // Percentage or fixed amount
  TaxType get type => throw _privateConstructorUsedError;
  TaxCalculationMethod get calculationMethod =>
      throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  String? get applyOn =>
      throw _privateConstructorUsedError; // 'base_price', 'after_discount', etc.
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaxRate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxRateCopyWith<TaxRate> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxRateCopyWith<$Res> {
  factory $TaxRateCopyWith(TaxRate value, $Res Function(TaxRate) then) =
      _$TaxRateCopyWithImpl<$Res, TaxRate>;
  @useResult
  $Res call({
    String id,
    String taxGroupId,
    String businessId,
    String name,
    double rate,
    TaxType type,
    TaxCalculationMethod calculationMethod,
    bool isActive,
    int displayOrder,
    String? applyOn,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TaxRateCopyWithImpl<$Res, $Val extends TaxRate>
    implements $TaxRateCopyWith<$Res> {
  _$TaxRateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taxGroupId = null,
    Object? businessId = null,
    Object? name = null,
    Object? rate = null,
    Object? type = null,
    Object? calculationMethod = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? applyOn = freezed,
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
            taxGroupId:
                null == taxGroupId
                    ? _value.taxGroupId
                    : taxGroupId // ignore: cast_nullable_to_non_nullable
                        as String,
            businessId:
                null == businessId
                    ? _value.businessId
                    : businessId // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            rate:
                null == rate
                    ? _value.rate
                    : rate // ignore: cast_nullable_to_non_nullable
                        as double,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as TaxType,
            calculationMethod:
                null == calculationMethod
                    ? _value.calculationMethod
                    : calculationMethod // ignore: cast_nullable_to_non_nullable
                        as TaxCalculationMethod,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            applyOn:
                freezed == applyOn
                    ? _value.applyOn
                    : applyOn // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaxRateImplCopyWith<$Res> implements $TaxRateCopyWith<$Res> {
  factory _$$TaxRateImplCopyWith(
    _$TaxRateImpl value,
    $Res Function(_$TaxRateImpl) then,
  ) = __$$TaxRateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String taxGroupId,
    String businessId,
    String name,
    double rate,
    TaxType type,
    TaxCalculationMethod calculationMethod,
    bool isActive,
    int displayOrder,
    String? applyOn,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TaxRateImplCopyWithImpl<$Res>
    extends _$TaxRateCopyWithImpl<$Res, _$TaxRateImpl>
    implements _$$TaxRateImplCopyWith<$Res> {
  __$$TaxRateImplCopyWithImpl(
    _$TaxRateImpl _value,
    $Res Function(_$TaxRateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taxGroupId = null,
    Object? businessId = null,
    Object? name = null,
    Object? rate = null,
    Object? type = null,
    Object? calculationMethod = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? applyOn = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TaxRateImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        taxGroupId:
            null == taxGroupId
                ? _value.taxGroupId
                : taxGroupId // ignore: cast_nullable_to_non_nullable
                    as String,
        businessId:
            null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        rate:
            null == rate
                ? _value.rate
                : rate // ignore: cast_nullable_to_non_nullable
                    as double,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as TaxType,
        calculationMethod:
            null == calculationMethod
                ? _value.calculationMethod
                : calculationMethod // ignore: cast_nullable_to_non_nullable
                    as TaxCalculationMethod,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        applyOn:
            freezed == applyOn
                ? _value.applyOn
                : applyOn // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaxRateImpl extends _TaxRate {
  const _$TaxRateImpl({
    required this.id,
    required this.taxGroupId,
    required this.businessId,
    required this.name,
    required this.rate,
    this.type = TaxType.percentage,
    this.calculationMethod = TaxCalculationMethod.exclusive,
    this.isActive = true,
    this.displayOrder = 0,
    this.applyOn,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$TaxRateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxRateImplFromJson(json);

  @override
  final String id;
  @override
  final String taxGroupId;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final double rate;
  // Percentage or fixed amount
  @override
  @JsonKey()
  final TaxType type;
  @override
  @JsonKey()
  final TaxCalculationMethod calculationMethod;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final String? applyOn;
  // 'base_price', 'after_discount', etc.
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaxRate(id: $id, taxGroupId: $taxGroupId, businessId: $businessId, name: $name, rate: $rate, type: $type, calculationMethod: $calculationMethod, isActive: $isActive, displayOrder: $displayOrder, applyOn: $applyOn, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxRateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taxGroupId, taxGroupId) ||
                other.taxGroupId == taxGroupId) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.calculationMethod, calculationMethod) ||
                other.calculationMethod == calculationMethod) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.applyOn, applyOn) || other.applyOn == applyOn) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    taxGroupId,
    businessId,
    name,
    rate,
    type,
    calculationMethod,
    isActive,
    displayOrder,
    applyOn,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxRateImplCopyWith<_$TaxRateImpl> get copyWith =>
      __$$TaxRateImplCopyWithImpl<_$TaxRateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxRateImplToJson(this);
  }
}

abstract class _TaxRate extends TaxRate {
  const factory _TaxRate({
    required final String id,
    required final String taxGroupId,
    required final String businessId,
    required final String name,
    required final double rate,
    final TaxType type,
    final TaxCalculationMethod calculationMethod,
    final bool isActive,
    final int displayOrder,
    final String? applyOn,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TaxRateImpl;
  const _TaxRate._() : super._();

  factory _TaxRate.fromJson(Map<String, dynamic> json) = _$TaxRateImpl.fromJson;

  @override
  String get id;
  @override
  String get taxGroupId;
  @override
  String get businessId;
  @override
  String get name;
  @override
  double get rate; // Percentage or fixed amount
  @override
  TaxType get type;
  @override
  TaxCalculationMethod get calculationMethod;
  @override
  bool get isActive;
  @override
  int get displayOrder;
  @override
  String? get applyOn; // 'base_price', 'after_discount', etc.
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TaxRate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxRateImplCopyWith<_$TaxRateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaxConfig _$TaxConfigFromJson(Map<String, dynamic> json) {
  return _TaxConfig.fromJson(json);
}

/// @nodoc
mixin _$TaxConfig {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get rate =>
      throw _privateConstructorUsedError; // Percentage or fixed amount
  TaxType get type => throw _privateConstructorUsedError;
  TaxCalculationMethod get calculationMethod =>
      throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaxConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxConfigCopyWith<TaxConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxConfigCopyWith<$Res> {
  factory $TaxConfigCopyWith(TaxConfig value, $Res Function(TaxConfig) then) =
      _$TaxConfigCopyWithImpl<$Res, TaxConfig>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    double rate,
    TaxType type,
    TaxCalculationMethod calculationMethod,
    bool isActive,
    bool isDefault,
    String? description,
    int displayOrder,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TaxConfigCopyWithImpl<$Res, $Val extends TaxConfig>
    implements $TaxConfigCopyWith<$Res> {
  _$TaxConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? rate = null,
    Object? type = null,
    Object? calculationMethod = null,
    Object? isActive = null,
    Object? isDefault = null,
    Object? description = freezed,
    Object? displayOrder = null,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            rate:
                null == rate
                    ? _value.rate
                    : rate // ignore: cast_nullable_to_non_nullable
                        as double,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as TaxType,
            calculationMethod:
                null == calculationMethod
                    ? _value.calculationMethod
                    : calculationMethod // ignore: cast_nullable_to_non_nullable
                        as TaxCalculationMethod,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
                        as bool,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
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
abstract class _$$TaxConfigImplCopyWith<$Res>
    implements $TaxConfigCopyWith<$Res> {
  factory _$$TaxConfigImplCopyWith(
    _$TaxConfigImpl value,
    $Res Function(_$TaxConfigImpl) then,
  ) = __$$TaxConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    double rate,
    TaxType type,
    TaxCalculationMethod calculationMethod,
    bool isActive,
    bool isDefault,
    String? description,
    int displayOrder,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TaxConfigImplCopyWithImpl<$Res>
    extends _$TaxConfigCopyWithImpl<$Res, _$TaxConfigImpl>
    implements _$$TaxConfigImplCopyWith<$Res> {
  __$$TaxConfigImplCopyWithImpl(
    _$TaxConfigImpl _value,
    $Res Function(_$TaxConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? rate = null,
    Object? type = null,
    Object? calculationMethod = null,
    Object? isActive = null,
    Object? isDefault = null,
    Object? description = freezed,
    Object? displayOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TaxConfigImpl(
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
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        rate:
            null == rate
                ? _value.rate
                : rate // ignore: cast_nullable_to_non_nullable
                    as double,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as TaxType,
        calculationMethod:
            null == calculationMethod
                ? _value.calculationMethod
                : calculationMethod // ignore: cast_nullable_to_non_nullable
                    as TaxCalculationMethod,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                    as bool,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
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
class _$TaxConfigImpl extends _TaxConfig {
  const _$TaxConfigImpl({
    required this.id,
    required this.businessId,
    required this.name,
    required this.rate,
    this.type = TaxType.percentage,
    this.calculationMethod = TaxCalculationMethod.exclusive,
    this.isActive = true,
    this.isDefault = false,
    this.description,
    this.displayOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$TaxConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final double rate;
  // Percentage or fixed amount
  @override
  @JsonKey()
  final TaxType type;
  @override
  @JsonKey()
  final TaxCalculationMethod calculationMethod;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final String? description;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaxConfig(id: $id, businessId: $businessId, name: $name, rate: $rate, type: $type, calculationMethod: $calculationMethod, isActive: $isActive, isDefault: $isDefault, description: $description, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.calculationMethod, calculationMethod) ||
                other.calculationMethod == calculationMethod) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    name,
    rate,
    type,
    calculationMethod,
    isActive,
    isDefault,
    description,
    displayOrder,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxConfigImplCopyWith<_$TaxConfigImpl> get copyWith =>
      __$$TaxConfigImplCopyWithImpl<_$TaxConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxConfigImplToJson(this);
  }
}

abstract class _TaxConfig extends TaxConfig {
  const factory _TaxConfig({
    required final String id,
    required final String businessId,
    required final String name,
    required final double rate,
    final TaxType type,
    final TaxCalculationMethod calculationMethod,
    final bool isActive,
    final bool isDefault,
    final String? description,
    final int displayOrder,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TaxConfigImpl;
  const _TaxConfig._() : super._();

  factory _TaxConfig.fromJson(Map<String, dynamic> json) =
      _$TaxConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  double get rate; // Percentage or fixed amount
  @override
  TaxType get type;
  @override
  TaxCalculationMethod get calculationMethod;
  @override
  bool get isActive;
  @override
  bool get isDefault;
  @override
  String? get description;
  @override
  int get displayOrder;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxConfigImplCopyWith<_$TaxConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MultipleTaxConfig _$MultipleTaxConfigFromJson(Map<String, dynamic> json) {
  return _MultipleTaxConfig.fromJson(json);
}

/// @nodoc
mixin _$MultipleTaxConfig {
  List<TaxConfig> get taxes => throw _privateConstructorUsedError;
  bool get compoundTax => throw _privateConstructorUsedError;

  /// Serializes this MultipleTaxConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultipleTaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultipleTaxConfigCopyWith<MultipleTaxConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultipleTaxConfigCopyWith<$Res> {
  factory $MultipleTaxConfigCopyWith(
    MultipleTaxConfig value,
    $Res Function(MultipleTaxConfig) then,
  ) = _$MultipleTaxConfigCopyWithImpl<$Res, MultipleTaxConfig>;
  @useResult
  $Res call({List<TaxConfig> taxes, bool compoundTax});
}

/// @nodoc
class _$MultipleTaxConfigCopyWithImpl<$Res, $Val extends MultipleTaxConfig>
    implements $MultipleTaxConfigCopyWith<$Res> {
  _$MultipleTaxConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultipleTaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? taxes = null, Object? compoundTax = null}) {
    return _then(
      _value.copyWith(
            taxes:
                null == taxes
                    ? _value.taxes
                    : taxes // ignore: cast_nullable_to_non_nullable
                        as List<TaxConfig>,
            compoundTax:
                null == compoundTax
                    ? _value.compoundTax
                    : compoundTax // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MultipleTaxConfigImplCopyWith<$Res>
    implements $MultipleTaxConfigCopyWith<$Res> {
  factory _$$MultipleTaxConfigImplCopyWith(
    _$MultipleTaxConfigImpl value,
    $Res Function(_$MultipleTaxConfigImpl) then,
  ) = __$$MultipleTaxConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TaxConfig> taxes, bool compoundTax});
}

/// @nodoc
class __$$MultipleTaxConfigImplCopyWithImpl<$Res>
    extends _$MultipleTaxConfigCopyWithImpl<$Res, _$MultipleTaxConfigImpl>
    implements _$$MultipleTaxConfigImplCopyWith<$Res> {
  __$$MultipleTaxConfigImplCopyWithImpl(
    _$MultipleTaxConfigImpl _value,
    $Res Function(_$MultipleTaxConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MultipleTaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? taxes = null, Object? compoundTax = null}) {
    return _then(
      _$MultipleTaxConfigImpl(
        taxes:
            null == taxes
                ? _value._taxes
                : taxes // ignore: cast_nullable_to_non_nullable
                    as List<TaxConfig>,
        compoundTax:
            null == compoundTax
                ? _value.compoundTax
                : compoundTax // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MultipleTaxConfigImpl extends _MultipleTaxConfig {
  const _$MultipleTaxConfigImpl({
    required final List<TaxConfig> taxes,
    this.compoundTax = false,
  }) : _taxes = taxes,
       super._();

  factory _$MultipleTaxConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$MultipleTaxConfigImplFromJson(json);

  final List<TaxConfig> _taxes;
  @override
  List<TaxConfig> get taxes {
    if (_taxes is EqualUnmodifiableListView) return _taxes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taxes);
  }

  @override
  @JsonKey()
  final bool compoundTax;

  @override
  String toString() {
    return 'MultipleTaxConfig(taxes: $taxes, compoundTax: $compoundTax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultipleTaxConfigImpl &&
            const DeepCollectionEquality().equals(other._taxes, _taxes) &&
            (identical(other.compoundTax, compoundTax) ||
                other.compoundTax == compoundTax));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_taxes),
    compoundTax,
  );

  /// Create a copy of MultipleTaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultipleTaxConfigImplCopyWith<_$MultipleTaxConfigImpl> get copyWith =>
      __$$MultipleTaxConfigImplCopyWithImpl<_$MultipleTaxConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MultipleTaxConfigImplToJson(this);
  }
}

abstract class _MultipleTaxConfig extends MultipleTaxConfig {
  const factory _MultipleTaxConfig({
    required final List<TaxConfig> taxes,
    final bool compoundTax,
  }) = _$MultipleTaxConfigImpl;
  const _MultipleTaxConfig._() : super._();

  factory _MultipleTaxConfig.fromJson(Map<String, dynamic> json) =
      _$MultipleTaxConfigImpl.fromJson;

  @override
  List<TaxConfig> get taxes;
  @override
  bool get compoundTax;

  /// Create a copy of MultipleTaxConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultipleTaxConfigImplCopyWith<_$MultipleTaxConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
