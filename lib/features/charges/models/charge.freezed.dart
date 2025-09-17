// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Charge _$ChargeFromJson(Map<String, dynamic> json) {
  return _Charge.fromJson(json);
}

/// @nodoc
mixin _$Charge {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String? get locationId =>
      throw _privateConstructorUsedError; // Basic Information
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Charge Configuration
  ChargeType get chargeType => throw _privateConstructorUsedError;
  CalculationType get calculationType => throw _privateConstructorUsedError;
  double? get value =>
      throw _privateConstructorUsedError; // Base value for fixed/percentage
  // Application Rules
  ChargeScope get scope => throw _privateConstructorUsedError;
  bool get autoApply => throw _privateConstructorUsedError;
  bool get isMandatory =>
      throw _privateConstructorUsedError; // Cannot be removed by user
  bool get isTaxable =>
      throw _privateConstructorUsedError; // Whether tax applies on this charge
  bool get applyBeforeDiscount =>
      throw _privateConstructorUsedError; // Apply before or after discounts
  // Conditions
  double? get minimumOrderValue => throw _privateConstructorUsedError;
  double? get maximumOrderValue => throw _privateConstructorUsedError;
  DateTime? get validFrom => throw _privateConstructorUsedError;
  DateTime? get validUntil =>
      throw _privateConstructorUsedError; // Time-based rules
  List<String> get applicableDays =>
      throw _privateConstructorUsedError; // ['monday', 'tuesday', ...]
  Map<String, dynamic>? get applicableTimeSlots =>
      throw _privateConstructorUsedError; // [{from: "18:00", to: "22:00"}]
  // Category/Product specific
  List<String> get applicableCategories => throw _privateConstructorUsedError;
  List<String> get applicableProducts => throw _privateConstructorUsedError;
  List<String> get excludedCategories => throw _privateConstructorUsedError;
  List<String> get excludedProducts =>
      throw _privateConstructorUsedError; // Customer specific
  List<String> get applicableCustomerGroups =>
      throw _privateConstructorUsedError;
  List<String> get excludedCustomerGroups =>
      throw _privateConstructorUsedError; // Display Configuration
  int get displayOrder => throw _privateConstructorUsedError;
  bool get showInPos => throw _privateConstructorUsedError;
  bool get showInInvoice => throw _privateConstructorUsedError;
  bool get showInOnline => throw _privateConstructorUsedError;
  String? get iconName =>
      throw _privateConstructorUsedError; // Material icon name
  String? get colorHex =>
      throw _privateConstructorUsedError; // Hex color for display
  // Tier configuration (for tiered charges)
  List<ChargeTier> get tiers =>
      throw _privateConstructorUsedError; // Formula configuration (for formula-based charges)
  ChargeFormula? get formula => throw _privateConstructorUsedError; // Status
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Serializes this Charge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Charge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargeCopyWith<Charge> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargeCopyWith<$Res> {
  factory $ChargeCopyWith(Charge value, $Res Function(Charge) then) =
      _$ChargeCopyWithImpl<$Res, Charge>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String? locationId,
    String code,
    String name,
    String? description,
    ChargeType chargeType,
    CalculationType calculationType,
    double? value,
    ChargeScope scope,
    bool autoApply,
    bool isMandatory,
    bool isTaxable,
    bool applyBeforeDiscount,
    double? minimumOrderValue,
    double? maximumOrderValue,
    DateTime? validFrom,
    DateTime? validUntil,
    List<String> applicableDays,
    Map<String, dynamic>? applicableTimeSlots,
    List<String> applicableCategories,
    List<String> applicableProducts,
    List<String> excludedCategories,
    List<String> excludedProducts,
    List<String> applicableCustomerGroups,
    List<String> excludedCustomerGroups,
    int displayOrder,
    bool showInPos,
    bool showInInvoice,
    bool showInOnline,
    String? iconName,
    String? colorHex,
    List<ChargeTier> tiers,
    ChargeFormula? formula,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
  });

  $ChargeFormulaCopyWith<$Res>? get formula;
}

/// @nodoc
class _$ChargeCopyWithImpl<$Res, $Val extends Charge>
    implements $ChargeCopyWith<$Res> {
  _$ChargeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Charge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = freezed,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? chargeType = null,
    Object? calculationType = null,
    Object? value = freezed,
    Object? scope = null,
    Object? autoApply = null,
    Object? isMandatory = null,
    Object? isTaxable = null,
    Object? applyBeforeDiscount = null,
    Object? minimumOrderValue = freezed,
    Object? maximumOrderValue = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? applicableDays = null,
    Object? applicableTimeSlots = freezed,
    Object? applicableCategories = null,
    Object? applicableProducts = null,
    Object? excludedCategories = null,
    Object? excludedProducts = null,
    Object? applicableCustomerGroups = null,
    Object? excludedCustomerGroups = null,
    Object? displayOrder = null,
    Object? showInPos = null,
    Object? showInInvoice = null,
    Object? showInOnline = null,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? tiers = null,
    Object? formula = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
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
            code:
                null == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
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
            chargeType:
                null == chargeType
                    ? _value.chargeType
                    : chargeType // ignore: cast_nullable_to_non_nullable
                        as ChargeType,
            calculationType:
                null == calculationType
                    ? _value.calculationType
                    : calculationType // ignore: cast_nullable_to_non_nullable
                        as CalculationType,
            value:
                freezed == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double?,
            scope:
                null == scope
                    ? _value.scope
                    : scope // ignore: cast_nullable_to_non_nullable
                        as ChargeScope,
            autoApply:
                null == autoApply
                    ? _value.autoApply
                    : autoApply // ignore: cast_nullable_to_non_nullable
                        as bool,
            isMandatory:
                null == isMandatory
                    ? _value.isMandatory
                    : isMandatory // ignore: cast_nullable_to_non_nullable
                        as bool,
            isTaxable:
                null == isTaxable
                    ? _value.isTaxable
                    : isTaxable // ignore: cast_nullable_to_non_nullable
                        as bool,
            applyBeforeDiscount:
                null == applyBeforeDiscount
                    ? _value.applyBeforeDiscount
                    : applyBeforeDiscount // ignore: cast_nullable_to_non_nullable
                        as bool,
            minimumOrderValue:
                freezed == minimumOrderValue
                    ? _value.minimumOrderValue
                    : minimumOrderValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            maximumOrderValue:
                freezed == maximumOrderValue
                    ? _value.maximumOrderValue
                    : maximumOrderValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            validFrom:
                freezed == validFrom
                    ? _value.validFrom
                    : validFrom // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            validUntil:
                freezed == validUntil
                    ? _value.validUntil
                    : validUntil // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            applicableDays:
                null == applicableDays
                    ? _value.applicableDays
                    : applicableDays // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            applicableTimeSlots:
                freezed == applicableTimeSlots
                    ? _value.applicableTimeSlots
                    : applicableTimeSlots // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            applicableCategories:
                null == applicableCategories
                    ? _value.applicableCategories
                    : applicableCategories // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            applicableProducts:
                null == applicableProducts
                    ? _value.applicableProducts
                    : applicableProducts // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            excludedCategories:
                null == excludedCategories
                    ? _value.excludedCategories
                    : excludedCategories // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            excludedProducts:
                null == excludedProducts
                    ? _value.excludedProducts
                    : excludedProducts // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            applicableCustomerGroups:
                null == applicableCustomerGroups
                    ? _value.applicableCustomerGroups
                    : applicableCustomerGroups // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            excludedCustomerGroups:
                null == excludedCustomerGroups
                    ? _value.excludedCustomerGroups
                    : excludedCustomerGroups // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            showInPos:
                null == showInPos
                    ? _value.showInPos
                    : showInPos // ignore: cast_nullable_to_non_nullable
                        as bool,
            showInInvoice:
                null == showInInvoice
                    ? _value.showInInvoice
                    : showInInvoice // ignore: cast_nullable_to_non_nullable
                        as bool,
            showInOnline:
                null == showInOnline
                    ? _value.showInOnline
                    : showInOnline // ignore: cast_nullable_to_non_nullable
                        as bool,
            iconName:
                freezed == iconName
                    ? _value.iconName
                    : iconName // ignore: cast_nullable_to_non_nullable
                        as String?,
            colorHex:
                freezed == colorHex
                    ? _value.colorHex
                    : colorHex // ignore: cast_nullable_to_non_nullable
                        as String?,
            tiers:
                null == tiers
                    ? _value.tiers
                    : tiers // ignore: cast_nullable_to_non_nullable
                        as List<ChargeTier>,
            formula:
                freezed == formula
                    ? _value.formula
                    : formula // ignore: cast_nullable_to_non_nullable
                        as ChargeFormula?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
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
          )
          as $Val,
    );
  }

  /// Create a copy of Charge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChargeFormulaCopyWith<$Res>? get formula {
    if (_value.formula == null) {
      return null;
    }

    return $ChargeFormulaCopyWith<$Res>(_value.formula!, (value) {
      return _then(_value.copyWith(formula: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChargeImplCopyWith<$Res> implements $ChargeCopyWith<$Res> {
  factory _$$ChargeImplCopyWith(
    _$ChargeImpl value,
    $Res Function(_$ChargeImpl) then,
  ) = __$$ChargeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String? locationId,
    String code,
    String name,
    String? description,
    ChargeType chargeType,
    CalculationType calculationType,
    double? value,
    ChargeScope scope,
    bool autoApply,
    bool isMandatory,
    bool isTaxable,
    bool applyBeforeDiscount,
    double? minimumOrderValue,
    double? maximumOrderValue,
    DateTime? validFrom,
    DateTime? validUntil,
    List<String> applicableDays,
    Map<String, dynamic>? applicableTimeSlots,
    List<String> applicableCategories,
    List<String> applicableProducts,
    List<String> excludedCategories,
    List<String> excludedProducts,
    List<String> applicableCustomerGroups,
    List<String> excludedCustomerGroups,
    int displayOrder,
    bool showInPos,
    bool showInInvoice,
    bool showInOnline,
    String? iconName,
    String? colorHex,
    List<ChargeTier> tiers,
    ChargeFormula? formula,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
  });

  @override
  $ChargeFormulaCopyWith<$Res>? get formula;
}

/// @nodoc
class __$$ChargeImplCopyWithImpl<$Res>
    extends _$ChargeCopyWithImpl<$Res, _$ChargeImpl>
    implements _$$ChargeImplCopyWith<$Res> {
  __$$ChargeImplCopyWithImpl(
    _$ChargeImpl _value,
    $Res Function(_$ChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Charge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = freezed,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? chargeType = null,
    Object? calculationType = null,
    Object? value = freezed,
    Object? scope = null,
    Object? autoApply = null,
    Object? isMandatory = null,
    Object? isTaxable = null,
    Object? applyBeforeDiscount = null,
    Object? minimumOrderValue = freezed,
    Object? maximumOrderValue = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? applicableDays = null,
    Object? applicableTimeSlots = freezed,
    Object? applicableCategories = null,
    Object? applicableProducts = null,
    Object? excludedCategories = null,
    Object? excludedProducts = null,
    Object? applicableCustomerGroups = null,
    Object? excludedCustomerGroups = null,
    Object? displayOrder = null,
    Object? showInPos = null,
    Object? showInInvoice = null,
    Object? showInOnline = null,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? tiers = null,
    Object? formula = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
  }) {
    return _then(
      _$ChargeImpl(
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
        code:
            null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
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
        chargeType:
            null == chargeType
                ? _value.chargeType
                : chargeType // ignore: cast_nullable_to_non_nullable
                    as ChargeType,
        calculationType:
            null == calculationType
                ? _value.calculationType
                : calculationType // ignore: cast_nullable_to_non_nullable
                    as CalculationType,
        value:
            freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double?,
        scope:
            null == scope
                ? _value.scope
                : scope // ignore: cast_nullable_to_non_nullable
                    as ChargeScope,
        autoApply:
            null == autoApply
                ? _value.autoApply
                : autoApply // ignore: cast_nullable_to_non_nullable
                    as bool,
        isMandatory:
            null == isMandatory
                ? _value.isMandatory
                : isMandatory // ignore: cast_nullable_to_non_nullable
                    as bool,
        isTaxable:
            null == isTaxable
                ? _value.isTaxable
                : isTaxable // ignore: cast_nullable_to_non_nullable
                    as bool,
        applyBeforeDiscount:
            null == applyBeforeDiscount
                ? _value.applyBeforeDiscount
                : applyBeforeDiscount // ignore: cast_nullable_to_non_nullable
                    as bool,
        minimumOrderValue:
            freezed == minimumOrderValue
                ? _value.minimumOrderValue
                : minimumOrderValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        maximumOrderValue:
            freezed == maximumOrderValue
                ? _value.maximumOrderValue
                : maximumOrderValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        validFrom:
            freezed == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        validUntil:
            freezed == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        applicableDays:
            null == applicableDays
                ? _value._applicableDays
                : applicableDays // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        applicableTimeSlots:
            freezed == applicableTimeSlots
                ? _value._applicableTimeSlots
                : applicableTimeSlots // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        applicableCategories:
            null == applicableCategories
                ? _value._applicableCategories
                : applicableCategories // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        applicableProducts:
            null == applicableProducts
                ? _value._applicableProducts
                : applicableProducts // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        excludedCategories:
            null == excludedCategories
                ? _value._excludedCategories
                : excludedCategories // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        excludedProducts:
            null == excludedProducts
                ? _value._excludedProducts
                : excludedProducts // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        applicableCustomerGroups:
            null == applicableCustomerGroups
                ? _value._applicableCustomerGroups
                : applicableCustomerGroups // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        excludedCustomerGroups:
            null == excludedCustomerGroups
                ? _value._excludedCustomerGroups
                : excludedCustomerGroups // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        showInPos:
            null == showInPos
                ? _value.showInPos
                : showInPos // ignore: cast_nullable_to_non_nullable
                    as bool,
        showInInvoice:
            null == showInInvoice
                ? _value.showInInvoice
                : showInInvoice // ignore: cast_nullable_to_non_nullable
                    as bool,
        showInOnline:
            null == showInOnline
                ? _value.showInOnline
                : showInOnline // ignore: cast_nullable_to_non_nullable
                    as bool,
        iconName:
            freezed == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                    as String?,
        colorHex:
            freezed == colorHex
                ? _value.colorHex
                : colorHex // ignore: cast_nullable_to_non_nullable
                    as String?,
        tiers:
            null == tiers
                ? _value._tiers
                : tiers // ignore: cast_nullable_to_non_nullable
                    as List<ChargeTier>,
        formula:
            freezed == formula
                ? _value.formula
                : formula // ignore: cast_nullable_to_non_nullable
                    as ChargeFormula?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChargeImpl extends _Charge {
  const _$ChargeImpl({
    required this.id,
    required this.businessId,
    this.locationId,
    required this.code,
    required this.name,
    this.description,
    required this.chargeType,
    required this.calculationType,
    this.value,
    this.scope = ChargeScope.order,
    this.autoApply = false,
    this.isMandatory = false,
    this.isTaxable = true,
    this.applyBeforeDiscount = false,
    this.minimumOrderValue,
    this.maximumOrderValue,
    this.validFrom,
    this.validUntil,
    final List<String> applicableDays = const [],
    final Map<String, dynamic>? applicableTimeSlots,
    final List<String> applicableCategories = const [],
    final List<String> applicableProducts = const [],
    final List<String> excludedCategories = const [],
    final List<String> excludedProducts = const [],
    final List<String> applicableCustomerGroups = const [],
    final List<String> excludedCustomerGroups = const [],
    this.displayOrder = 0,
    this.showInPos = true,
    this.showInInvoice = true,
    this.showInOnline = true,
    this.iconName,
    this.colorHex,
    final List<ChargeTier> tiers = const [],
    this.formula,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
  }) : _applicableDays = applicableDays,
       _applicableTimeSlots = applicableTimeSlots,
       _applicableCategories = applicableCategories,
       _applicableProducts = applicableProducts,
       _excludedCategories = excludedCategories,
       _excludedProducts = excludedProducts,
       _applicableCustomerGroups = applicableCustomerGroups,
       _excludedCustomerGroups = excludedCustomerGroups,
       _tiers = tiers,
       super._();

  factory _$ChargeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargeImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String? locationId;
  // Basic Information
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  // Charge Configuration
  @override
  final ChargeType chargeType;
  @override
  final CalculationType calculationType;
  @override
  final double? value;
  // Base value for fixed/percentage
  // Application Rules
  @override
  @JsonKey()
  final ChargeScope scope;
  @override
  @JsonKey()
  final bool autoApply;
  @override
  @JsonKey()
  final bool isMandatory;
  // Cannot be removed by user
  @override
  @JsonKey()
  final bool isTaxable;
  // Whether tax applies on this charge
  @override
  @JsonKey()
  final bool applyBeforeDiscount;
  // Apply before or after discounts
  // Conditions
  @override
  final double? minimumOrderValue;
  @override
  final double? maximumOrderValue;
  @override
  final DateTime? validFrom;
  @override
  final DateTime? validUntil;
  // Time-based rules
  final List<String> _applicableDays;
  // Time-based rules
  @override
  @JsonKey()
  List<String> get applicableDays {
    if (_applicableDays is EqualUnmodifiableListView) return _applicableDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableDays);
  }

  // ['monday', 'tuesday', ...]
  final Map<String, dynamic>? _applicableTimeSlots;
  // ['monday', 'tuesday', ...]
  @override
  Map<String, dynamic>? get applicableTimeSlots {
    final value = _applicableTimeSlots;
    if (value == null) return null;
    if (_applicableTimeSlots is EqualUnmodifiableMapView)
      return _applicableTimeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // [{from: "18:00", to: "22:00"}]
  // Category/Product specific
  final List<String> _applicableCategories;
  // [{from: "18:00", to: "22:00"}]
  // Category/Product specific
  @override
  @JsonKey()
  List<String> get applicableCategories {
    if (_applicableCategories is EqualUnmodifiableListView)
      return _applicableCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableCategories);
  }

  final List<String> _applicableProducts;
  @override
  @JsonKey()
  List<String> get applicableProducts {
    if (_applicableProducts is EqualUnmodifiableListView)
      return _applicableProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableProducts);
  }

  final List<String> _excludedCategories;
  @override
  @JsonKey()
  List<String> get excludedCategories {
    if (_excludedCategories is EqualUnmodifiableListView)
      return _excludedCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_excludedCategories);
  }

  final List<String> _excludedProducts;
  @override
  @JsonKey()
  List<String> get excludedProducts {
    if (_excludedProducts is EqualUnmodifiableListView)
      return _excludedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_excludedProducts);
  }

  // Customer specific
  final List<String> _applicableCustomerGroups;
  // Customer specific
  @override
  @JsonKey()
  List<String> get applicableCustomerGroups {
    if (_applicableCustomerGroups is EqualUnmodifiableListView)
      return _applicableCustomerGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableCustomerGroups);
  }

  final List<String> _excludedCustomerGroups;
  @override
  @JsonKey()
  List<String> get excludedCustomerGroups {
    if (_excludedCustomerGroups is EqualUnmodifiableListView)
      return _excludedCustomerGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_excludedCustomerGroups);
  }

  // Display Configuration
  @override
  @JsonKey()
  final int displayOrder;
  @override
  @JsonKey()
  final bool showInPos;
  @override
  @JsonKey()
  final bool showInInvoice;
  @override
  @JsonKey()
  final bool showInOnline;
  @override
  final String? iconName;
  // Material icon name
  @override
  final String? colorHex;
  // Hex color for display
  // Tier configuration (for tiered charges)
  final List<ChargeTier> _tiers;
  // Hex color for display
  // Tier configuration (for tiered charges)
  @override
  @JsonKey()
  List<ChargeTier> get tiers {
    if (_tiers is EqualUnmodifiableListView) return _tiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tiers);
  }

  // Formula configuration (for formula-based charges)
  @override
  final ChargeFormula? formula;
  // Status
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'Charge(id: $id, businessId: $businessId, locationId: $locationId, code: $code, name: $name, description: $description, chargeType: $chargeType, calculationType: $calculationType, value: $value, scope: $scope, autoApply: $autoApply, isMandatory: $isMandatory, isTaxable: $isTaxable, applyBeforeDiscount: $applyBeforeDiscount, minimumOrderValue: $minimumOrderValue, maximumOrderValue: $maximumOrderValue, validFrom: $validFrom, validUntil: $validUntil, applicableDays: $applicableDays, applicableTimeSlots: $applicableTimeSlots, applicableCategories: $applicableCategories, applicableProducts: $applicableProducts, excludedCategories: $excludedCategories, excludedProducts: $excludedProducts, applicableCustomerGroups: $applicableCustomerGroups, excludedCustomerGroups: $excludedCustomerGroups, displayOrder: $displayOrder, showInPos: $showInPos, showInInvoice: $showInInvoice, showInOnline: $showInOnline, iconName: $iconName, colorHex: $colorHex, tiers: $tiers, formula: $formula, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.chargeType, chargeType) ||
                other.chargeType == chargeType) &&
            (identical(other.calculationType, calculationType) ||
                other.calculationType == calculationType) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.autoApply, autoApply) ||
                other.autoApply == autoApply) &&
            (identical(other.isMandatory, isMandatory) ||
                other.isMandatory == isMandatory) &&
            (identical(other.isTaxable, isTaxable) ||
                other.isTaxable == isTaxable) &&
            (identical(other.applyBeforeDiscount, applyBeforeDiscount) ||
                other.applyBeforeDiscount == applyBeforeDiscount) &&
            (identical(other.minimumOrderValue, minimumOrderValue) ||
                other.minimumOrderValue == minimumOrderValue) &&
            (identical(other.maximumOrderValue, maximumOrderValue) ||
                other.maximumOrderValue == maximumOrderValue) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            const DeepCollectionEquality().equals(
              other._applicableDays,
              _applicableDays,
            ) &&
            const DeepCollectionEquality().equals(
              other._applicableTimeSlots,
              _applicableTimeSlots,
            ) &&
            const DeepCollectionEquality().equals(
              other._applicableCategories,
              _applicableCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._applicableProducts,
              _applicableProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._excludedCategories,
              _excludedCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._excludedProducts,
              _excludedProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._applicableCustomerGroups,
              _applicableCustomerGroups,
            ) &&
            const DeepCollectionEquality().equals(
              other._excludedCustomerGroups,
              _excludedCustomerGroups,
            ) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.showInPos, showInPos) ||
                other.showInPos == showInPos) &&
            (identical(other.showInInvoice, showInInvoice) ||
                other.showInInvoice == showInInvoice) &&
            (identical(other.showInOnline, showInOnline) ||
                other.showInOnline == showInOnline) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            const DeepCollectionEquality().equals(other._tiers, _tiers) &&
            (identical(other.formula, formula) || other.formula == formula) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessId,
    locationId,
    code,
    name,
    description,
    chargeType,
    calculationType,
    value,
    scope,
    autoApply,
    isMandatory,
    isTaxable,
    applyBeforeDiscount,
    minimumOrderValue,
    maximumOrderValue,
    validFrom,
    validUntil,
    const DeepCollectionEquality().hash(_applicableDays),
    const DeepCollectionEquality().hash(_applicableTimeSlots),
    const DeepCollectionEquality().hash(_applicableCategories),
    const DeepCollectionEquality().hash(_applicableProducts),
    const DeepCollectionEquality().hash(_excludedCategories),
    const DeepCollectionEquality().hash(_excludedProducts),
    const DeepCollectionEquality().hash(_applicableCustomerGroups),
    const DeepCollectionEquality().hash(_excludedCustomerGroups),
    displayOrder,
    showInPos,
    showInInvoice,
    showInOnline,
    iconName,
    colorHex,
    const DeepCollectionEquality().hash(_tiers),
    formula,
    isActive,
    createdAt,
    updatedAt,
    createdBy,
  ]);

  /// Create a copy of Charge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargeImplCopyWith<_$ChargeImpl> get copyWith =>
      __$$ChargeImplCopyWithImpl<_$ChargeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargeImplToJson(this);
  }
}

abstract class _Charge extends Charge {
  const factory _Charge({
    required final String id,
    required final String businessId,
    final String? locationId,
    required final String code,
    required final String name,
    final String? description,
    required final ChargeType chargeType,
    required final CalculationType calculationType,
    final double? value,
    final ChargeScope scope,
    final bool autoApply,
    final bool isMandatory,
    final bool isTaxable,
    final bool applyBeforeDiscount,
    final double? minimumOrderValue,
    final double? maximumOrderValue,
    final DateTime? validFrom,
    final DateTime? validUntil,
    final List<String> applicableDays,
    final Map<String, dynamic>? applicableTimeSlots,
    final List<String> applicableCategories,
    final List<String> applicableProducts,
    final List<String> excludedCategories,
    final List<String> excludedProducts,
    final List<String> applicableCustomerGroups,
    final List<String> excludedCustomerGroups,
    final int displayOrder,
    final bool showInPos,
    final bool showInInvoice,
    final bool showInOnline,
    final String? iconName,
    final String? colorHex,
    final List<ChargeTier> tiers,
    final ChargeFormula? formula,
    final bool isActive,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? createdBy,
  }) = _$ChargeImpl;
  const _Charge._() : super._();

  factory _Charge.fromJson(Map<String, dynamic> json) = _$ChargeImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String? get locationId; // Basic Information
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description; // Charge Configuration
  @override
  ChargeType get chargeType;
  @override
  CalculationType get calculationType;
  @override
  double? get value; // Base value for fixed/percentage
  // Application Rules
  @override
  ChargeScope get scope;
  @override
  bool get autoApply;
  @override
  bool get isMandatory; // Cannot be removed by user
  @override
  bool get isTaxable; // Whether tax applies on this charge
  @override
  bool get applyBeforeDiscount; // Apply before or after discounts
  // Conditions
  @override
  double? get minimumOrderValue;
  @override
  double? get maximumOrderValue;
  @override
  DateTime? get validFrom;
  @override
  DateTime? get validUntil; // Time-based rules
  @override
  List<String> get applicableDays; // ['monday', 'tuesday', ...]
  @override
  Map<String, dynamic>? get applicableTimeSlots; // [{from: "18:00", to: "22:00"}]
  // Category/Product specific
  @override
  List<String> get applicableCategories;
  @override
  List<String> get applicableProducts;
  @override
  List<String> get excludedCategories;
  @override
  List<String> get excludedProducts; // Customer specific
  @override
  List<String> get applicableCustomerGroups;
  @override
  List<String> get excludedCustomerGroups; // Display Configuration
  @override
  int get displayOrder;
  @override
  bool get showInPos;
  @override
  bool get showInInvoice;
  @override
  bool get showInOnline;
  @override
  String? get iconName; // Material icon name
  @override
  String? get colorHex; // Hex color for display
  // Tier configuration (for tiered charges)
  @override
  List<ChargeTier> get tiers; // Formula configuration (for formula-based charges)
  @override
  ChargeFormula? get formula; // Status
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;

  /// Create a copy of Charge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargeImplCopyWith<_$ChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChargeTier _$ChargeTierFromJson(Map<String, dynamic> json) {
  return _ChargeTier.fromJson(json);
}

/// @nodoc
mixin _$ChargeTier {
  String get id => throw _privateConstructorUsedError;
  String get chargeId => throw _privateConstructorUsedError;
  String? get tierName => throw _privateConstructorUsedError;
  double get minValue => throw _privateConstructorUsedError;
  double? get maxValue =>
      throw _privateConstructorUsedError; // null means no upper limit
  double get chargeValue =>
      throw _privateConstructorUsedError; // Amount or percentage for this tier
  int get displayOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChargeTier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChargeTier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargeTierCopyWith<ChargeTier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargeTierCopyWith<$Res> {
  factory $ChargeTierCopyWith(
    ChargeTier value,
    $Res Function(ChargeTier) then,
  ) = _$ChargeTierCopyWithImpl<$Res, ChargeTier>;
  @useResult
  $Res call({
    String id,
    String chargeId,
    String? tierName,
    double minValue,
    double? maxValue,
    double chargeValue,
    int displayOrder,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ChargeTierCopyWithImpl<$Res, $Val extends ChargeTier>
    implements $ChargeTierCopyWith<$Res> {
  _$ChargeTierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChargeTier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chargeId = null,
    Object? tierName = freezed,
    Object? minValue = null,
    Object? maxValue = freezed,
    Object? chargeValue = null,
    Object? displayOrder = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            chargeId:
                null == chargeId
                    ? _value.chargeId
                    : chargeId // ignore: cast_nullable_to_non_nullable
                        as String,
            tierName:
                freezed == tierName
                    ? _value.tierName
                    : tierName // ignore: cast_nullable_to_non_nullable
                        as String?,
            minValue:
                null == minValue
                    ? _value.minValue
                    : minValue // ignore: cast_nullable_to_non_nullable
                        as double,
            maxValue:
                freezed == maxValue
                    ? _value.maxValue
                    : maxValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            chargeValue:
                null == chargeValue
                    ? _value.chargeValue
                    : chargeValue // ignore: cast_nullable_to_non_nullable
                        as double,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChargeTierImplCopyWith<$Res>
    implements $ChargeTierCopyWith<$Res> {
  factory _$$ChargeTierImplCopyWith(
    _$ChargeTierImpl value,
    $Res Function(_$ChargeTierImpl) then,
  ) = __$$ChargeTierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String chargeId,
    String? tierName,
    double minValue,
    double? maxValue,
    double chargeValue,
    int displayOrder,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ChargeTierImplCopyWithImpl<$Res>
    extends _$ChargeTierCopyWithImpl<$Res, _$ChargeTierImpl>
    implements _$$ChargeTierImplCopyWith<$Res> {
  __$$ChargeTierImplCopyWithImpl(
    _$ChargeTierImpl _value,
    $Res Function(_$ChargeTierImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargeTier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chargeId = null,
    Object? tierName = freezed,
    Object? minValue = null,
    Object? maxValue = freezed,
    Object? chargeValue = null,
    Object? displayOrder = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ChargeTierImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        chargeId:
            null == chargeId
                ? _value.chargeId
                : chargeId // ignore: cast_nullable_to_non_nullable
                    as String,
        tierName:
            freezed == tierName
                ? _value.tierName
                : tierName // ignore: cast_nullable_to_non_nullable
                    as String?,
        minValue:
            null == minValue
                ? _value.minValue
                : minValue // ignore: cast_nullable_to_non_nullable
                    as double,
        maxValue:
            freezed == maxValue
                ? _value.maxValue
                : maxValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        chargeValue:
            null == chargeValue
                ? _value.chargeValue
                : chargeValue // ignore: cast_nullable_to_non_nullable
                    as double,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChargeTierImpl implements _ChargeTier {
  const _$ChargeTierImpl({
    required this.id,
    required this.chargeId,
    this.tierName,
    required this.minValue,
    this.maxValue,
    required this.chargeValue,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory _$ChargeTierImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargeTierImplFromJson(json);

  @override
  final String id;
  @override
  final String chargeId;
  @override
  final String? tierName;
  @override
  final double minValue;
  @override
  final double? maxValue;
  // null means no upper limit
  @override
  final double chargeValue;
  // Amount or percentage for this tier
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChargeTier(id: $id, chargeId: $chargeId, tierName: $tierName, minValue: $minValue, maxValue: $maxValue, chargeValue: $chargeValue, displayOrder: $displayOrder, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargeTierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chargeId, chargeId) ||
                other.chargeId == chargeId) &&
            (identical(other.tierName, tierName) ||
                other.tierName == tierName) &&
            (identical(other.minValue, minValue) ||
                other.minValue == minValue) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            (identical(other.chargeValue, chargeValue) ||
                other.chargeValue == chargeValue) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    chargeId,
    tierName,
    minValue,
    maxValue,
    chargeValue,
    displayOrder,
    createdAt,
  );

  /// Create a copy of ChargeTier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargeTierImplCopyWith<_$ChargeTierImpl> get copyWith =>
      __$$ChargeTierImplCopyWithImpl<_$ChargeTierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargeTierImplToJson(this);
  }
}

abstract class _ChargeTier implements ChargeTier {
  const factory _ChargeTier({
    required final String id,
    required final String chargeId,
    final String? tierName,
    required final double minValue,
    final double? maxValue,
    required final double chargeValue,
    final int displayOrder,
    required final DateTime createdAt,
  }) = _$ChargeTierImpl;

  factory _ChargeTier.fromJson(Map<String, dynamic> json) =
      _$ChargeTierImpl.fromJson;

  @override
  String get id;
  @override
  String get chargeId;
  @override
  String? get tierName;
  @override
  double get minValue;
  @override
  double? get maxValue; // null means no upper limit
  @override
  double get chargeValue; // Amount or percentage for this tier
  @override
  int get displayOrder;
  @override
  DateTime get createdAt;

  /// Create a copy of ChargeTier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargeTierImplCopyWith<_$ChargeTierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChargeFormula _$ChargeFormulaFromJson(Map<String, dynamic> json) {
  return _ChargeFormula.fromJson(json);
}

/// @nodoc
mixin _$ChargeFormula {
  String get id => throw _privateConstructorUsedError;
  String get chargeId => throw _privateConstructorUsedError;
  double get baseAmount =>
      throw _privateConstructorUsedError; // Fixed base amount
  double get variableRate =>
      throw _privateConstructorUsedError; // Per unit rate
  String? get variableType =>
      throw _privateConstructorUsedError; // 'distance', 'weight', 'quantity', 'percentage'
  double? get minCharge =>
      throw _privateConstructorUsedError; // Minimum charge amount
  double? get maxCharge =>
      throw _privateConstructorUsedError; // Maximum charge amount
  String? get formulaExpression =>
      throw _privateConstructorUsedError; // For complex calculations
  Map<String, dynamic>? get customVariables =>
      throw _privateConstructorUsedError; // Additional variables
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChargeFormula to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChargeFormula
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargeFormulaCopyWith<ChargeFormula> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargeFormulaCopyWith<$Res> {
  factory $ChargeFormulaCopyWith(
    ChargeFormula value,
    $Res Function(ChargeFormula) then,
  ) = _$ChargeFormulaCopyWithImpl<$Res, ChargeFormula>;
  @useResult
  $Res call({
    String id,
    String chargeId,
    double baseAmount,
    double variableRate,
    String? variableType,
    double? minCharge,
    double? maxCharge,
    String? formulaExpression,
    Map<String, dynamic>? customVariables,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ChargeFormulaCopyWithImpl<$Res, $Val extends ChargeFormula>
    implements $ChargeFormulaCopyWith<$Res> {
  _$ChargeFormulaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChargeFormula
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chargeId = null,
    Object? baseAmount = null,
    Object? variableRate = null,
    Object? variableType = freezed,
    Object? minCharge = freezed,
    Object? maxCharge = freezed,
    Object? formulaExpression = freezed,
    Object? customVariables = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            chargeId:
                null == chargeId
                    ? _value.chargeId
                    : chargeId // ignore: cast_nullable_to_non_nullable
                        as String,
            baseAmount:
                null == baseAmount
                    ? _value.baseAmount
                    : baseAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            variableRate:
                null == variableRate
                    ? _value.variableRate
                    : variableRate // ignore: cast_nullable_to_non_nullable
                        as double,
            variableType:
                freezed == variableType
                    ? _value.variableType
                    : variableType // ignore: cast_nullable_to_non_nullable
                        as String?,
            minCharge:
                freezed == minCharge
                    ? _value.minCharge
                    : minCharge // ignore: cast_nullable_to_non_nullable
                        as double?,
            maxCharge:
                freezed == maxCharge
                    ? _value.maxCharge
                    : maxCharge // ignore: cast_nullable_to_non_nullable
                        as double?,
            formulaExpression:
                freezed == formulaExpression
                    ? _value.formulaExpression
                    : formulaExpression // ignore: cast_nullable_to_non_nullable
                        as String?,
            customVariables:
                freezed == customVariables
                    ? _value.customVariables
                    : customVariables // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ChargeFormulaImplCopyWith<$Res>
    implements $ChargeFormulaCopyWith<$Res> {
  factory _$$ChargeFormulaImplCopyWith(
    _$ChargeFormulaImpl value,
    $Res Function(_$ChargeFormulaImpl) then,
  ) = __$$ChargeFormulaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String chargeId,
    double baseAmount,
    double variableRate,
    String? variableType,
    double? minCharge,
    double? maxCharge,
    String? formulaExpression,
    Map<String, dynamic>? customVariables,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ChargeFormulaImplCopyWithImpl<$Res>
    extends _$ChargeFormulaCopyWithImpl<$Res, _$ChargeFormulaImpl>
    implements _$$ChargeFormulaImplCopyWith<$Res> {
  __$$ChargeFormulaImplCopyWithImpl(
    _$ChargeFormulaImpl _value,
    $Res Function(_$ChargeFormulaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargeFormula
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chargeId = null,
    Object? baseAmount = null,
    Object? variableRate = null,
    Object? variableType = freezed,
    Object? minCharge = freezed,
    Object? maxCharge = freezed,
    Object? formulaExpression = freezed,
    Object? customVariables = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$ChargeFormulaImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        chargeId:
            null == chargeId
                ? _value.chargeId
                : chargeId // ignore: cast_nullable_to_non_nullable
                    as String,
        baseAmount:
            null == baseAmount
                ? _value.baseAmount
                : baseAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        variableRate:
            null == variableRate
                ? _value.variableRate
                : variableRate // ignore: cast_nullable_to_non_nullable
                    as double,
        variableType:
            freezed == variableType
                ? _value.variableType
                : variableType // ignore: cast_nullable_to_non_nullable
                    as String?,
        minCharge:
            freezed == minCharge
                ? _value.minCharge
                : minCharge // ignore: cast_nullable_to_non_nullable
                    as double?,
        maxCharge:
            freezed == maxCharge
                ? _value.maxCharge
                : maxCharge // ignore: cast_nullable_to_non_nullable
                    as double?,
        formulaExpression:
            freezed == formulaExpression
                ? _value.formulaExpression
                : formulaExpression // ignore: cast_nullable_to_non_nullable
                    as String?,
        customVariables:
            freezed == customVariables
                ? _value._customVariables
                : customVariables // ignore: cast_nullable_to_non_nullable
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
class _$ChargeFormulaImpl implements _ChargeFormula {
  const _$ChargeFormulaImpl({
    required this.id,
    required this.chargeId,
    this.baseAmount = 0,
    this.variableRate = 0,
    this.variableType,
    this.minCharge,
    this.maxCharge,
    this.formulaExpression,
    final Map<String, dynamic>? customVariables,
    required this.createdAt,
  }) : _customVariables = customVariables;

  factory _$ChargeFormulaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargeFormulaImplFromJson(json);

  @override
  final String id;
  @override
  final String chargeId;
  @override
  @JsonKey()
  final double baseAmount;
  // Fixed base amount
  @override
  @JsonKey()
  final double variableRate;
  // Per unit rate
  @override
  final String? variableType;
  // 'distance', 'weight', 'quantity', 'percentage'
  @override
  final double? minCharge;
  // Minimum charge amount
  @override
  final double? maxCharge;
  // Maximum charge amount
  @override
  final String? formulaExpression;
  // For complex calculations
  final Map<String, dynamic>? _customVariables;
  // For complex calculations
  @override
  Map<String, dynamic>? get customVariables {
    final value = _customVariables;
    if (value == null) return null;
    if (_customVariables is EqualUnmodifiableMapView) return _customVariables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Additional variables
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChargeFormula(id: $id, chargeId: $chargeId, baseAmount: $baseAmount, variableRate: $variableRate, variableType: $variableType, minCharge: $minCharge, maxCharge: $maxCharge, formulaExpression: $formulaExpression, customVariables: $customVariables, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargeFormulaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chargeId, chargeId) ||
                other.chargeId == chargeId) &&
            (identical(other.baseAmount, baseAmount) ||
                other.baseAmount == baseAmount) &&
            (identical(other.variableRate, variableRate) ||
                other.variableRate == variableRate) &&
            (identical(other.variableType, variableType) ||
                other.variableType == variableType) &&
            (identical(other.minCharge, minCharge) ||
                other.minCharge == minCharge) &&
            (identical(other.maxCharge, maxCharge) ||
                other.maxCharge == maxCharge) &&
            (identical(other.formulaExpression, formulaExpression) ||
                other.formulaExpression == formulaExpression) &&
            const DeepCollectionEquality().equals(
              other._customVariables,
              _customVariables,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    chargeId,
    baseAmount,
    variableRate,
    variableType,
    minCharge,
    maxCharge,
    formulaExpression,
    const DeepCollectionEquality().hash(_customVariables),
    createdAt,
  );

  /// Create a copy of ChargeFormula
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargeFormulaImplCopyWith<_$ChargeFormulaImpl> get copyWith =>
      __$$ChargeFormulaImplCopyWithImpl<_$ChargeFormulaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargeFormulaImplToJson(this);
  }
}

abstract class _ChargeFormula implements ChargeFormula {
  const factory _ChargeFormula({
    required final String id,
    required final String chargeId,
    final double baseAmount,
    final double variableRate,
    final String? variableType,
    final double? minCharge,
    final double? maxCharge,
    final String? formulaExpression,
    final Map<String, dynamic>? customVariables,
    required final DateTime createdAt,
  }) = _$ChargeFormulaImpl;

  factory _ChargeFormula.fromJson(Map<String, dynamic> json) =
      _$ChargeFormulaImpl.fromJson;

  @override
  String get id;
  @override
  String get chargeId;
  @override
  double get baseAmount; // Fixed base amount
  @override
  double get variableRate; // Per unit rate
  @override
  String? get variableType; // 'distance', 'weight', 'quantity', 'percentage'
  @override
  double? get minCharge; // Minimum charge amount
  @override
  double? get maxCharge; // Maximum charge amount
  @override
  String? get formulaExpression; // For complex calculations
  @override
  Map<String, dynamic>? get customVariables; // Additional variables
  @override
  DateTime get createdAt;

  /// Create a copy of ChargeFormula
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargeFormulaImplCopyWith<_$ChargeFormulaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppliedCharge _$AppliedChargeFromJson(Map<String, dynamic> json) {
  return _AppliedCharge.fromJson(json);
}

/// @nodoc
mixin _$AppliedCharge {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String? get chargeId =>
      throw _privateConstructorUsedError; // Charge details snapshot
  String get chargeCode => throw _privateConstructorUsedError;
  String get chargeName => throw _privateConstructorUsedError;
  String get chargeType => throw _privateConstructorUsedError;
  String get calculationType =>
      throw _privateConstructorUsedError; // Calculation details
  double? get baseAmount =>
      throw _privateConstructorUsedError; // Amount on which charge is calculated
  double? get chargeRate =>
      throw _privateConstructorUsedError; // Percentage or per-unit rate used
  double get chargeAmount =>
      throw _privateConstructorUsedError; // Final charge amount
  // Tax calculation
  bool get isTaxable => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError; // Manual override
  bool get isManual => throw _privateConstructorUsedError;
  double? get originalAmount =>
      throw _privateConstructorUsedError; // Original amount before manual adjustment
  String? get adjustmentReason =>
      throw _privateConstructorUsedError; // Metadata
  String? get addedBy => throw _privateConstructorUsedError;
  String? get removedBy => throw _privateConstructorUsedError;
  bool get isRemoved => throw _privateConstructorUsedError;
  DateTime? get removedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AppliedCharge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppliedCharge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppliedChargeCopyWith<AppliedCharge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppliedChargeCopyWith<$Res> {
  factory $AppliedChargeCopyWith(
    AppliedCharge value,
    $Res Function(AppliedCharge) then,
  ) = _$AppliedChargeCopyWithImpl<$Res, AppliedCharge>;
  @useResult
  $Res call({
    String id,
    String orderId,
    String? chargeId,
    String chargeCode,
    String chargeName,
    String chargeType,
    String calculationType,
    double? baseAmount,
    double? chargeRate,
    double chargeAmount,
    bool isTaxable,
    double taxAmount,
    bool isManual,
    double? originalAmount,
    String? adjustmentReason,
    String? addedBy,
    String? removedBy,
    bool isRemoved,
    DateTime? removedAt,
    String? notes,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$AppliedChargeCopyWithImpl<$Res, $Val extends AppliedCharge>
    implements $AppliedChargeCopyWith<$Res> {
  _$AppliedChargeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppliedCharge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? chargeId = freezed,
    Object? chargeCode = null,
    Object? chargeName = null,
    Object? chargeType = null,
    Object? calculationType = null,
    Object? baseAmount = freezed,
    Object? chargeRate = freezed,
    Object? chargeAmount = null,
    Object? isTaxable = null,
    Object? taxAmount = null,
    Object? isManual = null,
    Object? originalAmount = freezed,
    Object? adjustmentReason = freezed,
    Object? addedBy = freezed,
    Object? removedBy = freezed,
    Object? isRemoved = null,
    Object? removedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            orderId:
                null == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String,
            chargeId:
                freezed == chargeId
                    ? _value.chargeId
                    : chargeId // ignore: cast_nullable_to_non_nullable
                        as String?,
            chargeCode:
                null == chargeCode
                    ? _value.chargeCode
                    : chargeCode // ignore: cast_nullable_to_non_nullable
                        as String,
            chargeName:
                null == chargeName
                    ? _value.chargeName
                    : chargeName // ignore: cast_nullable_to_non_nullable
                        as String,
            chargeType:
                null == chargeType
                    ? _value.chargeType
                    : chargeType // ignore: cast_nullable_to_non_nullable
                        as String,
            calculationType:
                null == calculationType
                    ? _value.calculationType
                    : calculationType // ignore: cast_nullable_to_non_nullable
                        as String,
            baseAmount:
                freezed == baseAmount
                    ? _value.baseAmount
                    : baseAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
            chargeRate:
                freezed == chargeRate
                    ? _value.chargeRate
                    : chargeRate // ignore: cast_nullable_to_non_nullable
                        as double?,
            chargeAmount:
                null == chargeAmount
                    ? _value.chargeAmount
                    : chargeAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            isTaxable:
                null == isTaxable
                    ? _value.isTaxable
                    : isTaxable // ignore: cast_nullable_to_non_nullable
                        as bool,
            taxAmount:
                null == taxAmount
                    ? _value.taxAmount
                    : taxAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            isManual:
                null == isManual
                    ? _value.isManual
                    : isManual // ignore: cast_nullable_to_non_nullable
                        as bool,
            originalAmount:
                freezed == originalAmount
                    ? _value.originalAmount
                    : originalAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
            adjustmentReason:
                freezed == adjustmentReason
                    ? _value.adjustmentReason
                    : adjustmentReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            addedBy:
                freezed == addedBy
                    ? _value.addedBy
                    : addedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            removedBy:
                freezed == removedBy
                    ? _value.removedBy
                    : removedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            isRemoved:
                null == isRemoved
                    ? _value.isRemoved
                    : isRemoved // ignore: cast_nullable_to_non_nullable
                        as bool,
            removedAt:
                freezed == removedAt
                    ? _value.removedAt
                    : removedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppliedChargeImplCopyWith<$Res>
    implements $AppliedChargeCopyWith<$Res> {
  factory _$$AppliedChargeImplCopyWith(
    _$AppliedChargeImpl value,
    $Res Function(_$AppliedChargeImpl) then,
  ) = __$$AppliedChargeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    String? chargeId,
    String chargeCode,
    String chargeName,
    String chargeType,
    String calculationType,
    double? baseAmount,
    double? chargeRate,
    double chargeAmount,
    bool isTaxable,
    double taxAmount,
    bool isManual,
    double? originalAmount,
    String? adjustmentReason,
    String? addedBy,
    String? removedBy,
    bool isRemoved,
    DateTime? removedAt,
    String? notes,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$AppliedChargeImplCopyWithImpl<$Res>
    extends _$AppliedChargeCopyWithImpl<$Res, _$AppliedChargeImpl>
    implements _$$AppliedChargeImplCopyWith<$Res> {
  __$$AppliedChargeImplCopyWithImpl(
    _$AppliedChargeImpl _value,
    $Res Function(_$AppliedChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppliedCharge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? chargeId = freezed,
    Object? chargeCode = null,
    Object? chargeName = null,
    Object? chargeType = null,
    Object? calculationType = null,
    Object? baseAmount = freezed,
    Object? chargeRate = freezed,
    Object? chargeAmount = null,
    Object? isTaxable = null,
    Object? taxAmount = null,
    Object? isManual = null,
    Object? originalAmount = freezed,
    Object? adjustmentReason = freezed,
    Object? addedBy = freezed,
    Object? removedBy = freezed,
    Object? isRemoved = null,
    Object? removedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$AppliedChargeImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        orderId:
            null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String,
        chargeId:
            freezed == chargeId
                ? _value.chargeId
                : chargeId // ignore: cast_nullable_to_non_nullable
                    as String?,
        chargeCode:
            null == chargeCode
                ? _value.chargeCode
                : chargeCode // ignore: cast_nullable_to_non_nullable
                    as String,
        chargeName:
            null == chargeName
                ? _value.chargeName
                : chargeName // ignore: cast_nullable_to_non_nullable
                    as String,
        chargeType:
            null == chargeType
                ? _value.chargeType
                : chargeType // ignore: cast_nullable_to_non_nullable
                    as String,
        calculationType:
            null == calculationType
                ? _value.calculationType
                : calculationType // ignore: cast_nullable_to_non_nullable
                    as String,
        baseAmount:
            freezed == baseAmount
                ? _value.baseAmount
                : baseAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
        chargeRate:
            freezed == chargeRate
                ? _value.chargeRate
                : chargeRate // ignore: cast_nullable_to_non_nullable
                    as double?,
        chargeAmount:
            null == chargeAmount
                ? _value.chargeAmount
                : chargeAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        isTaxable:
            null == isTaxable
                ? _value.isTaxable
                : isTaxable // ignore: cast_nullable_to_non_nullable
                    as bool,
        taxAmount:
            null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        isManual:
            null == isManual
                ? _value.isManual
                : isManual // ignore: cast_nullable_to_non_nullable
                    as bool,
        originalAmount:
            freezed == originalAmount
                ? _value.originalAmount
                : originalAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
        adjustmentReason:
            freezed == adjustmentReason
                ? _value.adjustmentReason
                : adjustmentReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        addedBy:
            freezed == addedBy
                ? _value.addedBy
                : addedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        removedBy:
            freezed == removedBy
                ? _value.removedBy
                : removedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        isRemoved:
            null == isRemoved
                ? _value.isRemoved
                : isRemoved // ignore: cast_nullable_to_non_nullable
                    as bool,
        removedAt:
            freezed == removedAt
                ? _value.removedAt
                : removedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppliedChargeImpl extends _AppliedCharge {
  const _$AppliedChargeImpl({
    required this.id,
    required this.orderId,
    this.chargeId,
    required this.chargeCode,
    required this.chargeName,
    required this.chargeType,
    required this.calculationType,
    this.baseAmount,
    this.chargeRate,
    required this.chargeAmount,
    this.isTaxable = true,
    this.taxAmount = 0,
    this.isManual = false,
    this.originalAmount,
    this.adjustmentReason,
    this.addedBy,
    this.removedBy,
    this.isRemoved = false,
    this.removedAt,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$AppliedChargeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppliedChargeImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final String? chargeId;
  // Charge details snapshot
  @override
  final String chargeCode;
  @override
  final String chargeName;
  @override
  final String chargeType;
  @override
  final String calculationType;
  // Calculation details
  @override
  final double? baseAmount;
  // Amount on which charge is calculated
  @override
  final double? chargeRate;
  // Percentage or per-unit rate used
  @override
  final double chargeAmount;
  // Final charge amount
  // Tax calculation
  @override
  @JsonKey()
  final bool isTaxable;
  @override
  @JsonKey()
  final double taxAmount;
  // Manual override
  @override
  @JsonKey()
  final bool isManual;
  @override
  final double? originalAmount;
  // Original amount before manual adjustment
  @override
  final String? adjustmentReason;
  // Metadata
  @override
  final String? addedBy;
  @override
  final String? removedBy;
  @override
  @JsonKey()
  final bool isRemoved;
  @override
  final DateTime? removedAt;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AppliedCharge(id: $id, orderId: $orderId, chargeId: $chargeId, chargeCode: $chargeCode, chargeName: $chargeName, chargeType: $chargeType, calculationType: $calculationType, baseAmount: $baseAmount, chargeRate: $chargeRate, chargeAmount: $chargeAmount, isTaxable: $isTaxable, taxAmount: $taxAmount, isManual: $isManual, originalAmount: $originalAmount, adjustmentReason: $adjustmentReason, addedBy: $addedBy, removedBy: $removedBy, isRemoved: $isRemoved, removedAt: $removedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppliedChargeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.chargeId, chargeId) ||
                other.chargeId == chargeId) &&
            (identical(other.chargeCode, chargeCode) ||
                other.chargeCode == chargeCode) &&
            (identical(other.chargeName, chargeName) ||
                other.chargeName == chargeName) &&
            (identical(other.chargeType, chargeType) ||
                other.chargeType == chargeType) &&
            (identical(other.calculationType, calculationType) ||
                other.calculationType == calculationType) &&
            (identical(other.baseAmount, baseAmount) ||
                other.baseAmount == baseAmount) &&
            (identical(other.chargeRate, chargeRate) ||
                other.chargeRate == chargeRate) &&
            (identical(other.chargeAmount, chargeAmount) ||
                other.chargeAmount == chargeAmount) &&
            (identical(other.isTaxable, isTaxable) ||
                other.isTaxable == isTaxable) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.isManual, isManual) ||
                other.isManual == isManual) &&
            (identical(other.originalAmount, originalAmount) ||
                other.originalAmount == originalAmount) &&
            (identical(other.adjustmentReason, adjustmentReason) ||
                other.adjustmentReason == adjustmentReason) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy) &&
            (identical(other.removedBy, removedBy) ||
                other.removedBy == removedBy) &&
            (identical(other.isRemoved, isRemoved) ||
                other.isRemoved == isRemoved) &&
            (identical(other.removedAt, removedAt) ||
                other.removedAt == removedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
    orderId,
    chargeId,
    chargeCode,
    chargeName,
    chargeType,
    calculationType,
    baseAmount,
    chargeRate,
    chargeAmount,
    isTaxable,
    taxAmount,
    isManual,
    originalAmount,
    adjustmentReason,
    addedBy,
    removedBy,
    isRemoved,
    removedAt,
    notes,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of AppliedCharge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppliedChargeImplCopyWith<_$AppliedChargeImpl> get copyWith =>
      __$$AppliedChargeImplCopyWithImpl<_$AppliedChargeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppliedChargeImplToJson(this);
  }
}

abstract class _AppliedCharge extends AppliedCharge {
  const factory _AppliedCharge({
    required final String id,
    required final String orderId,
    final String? chargeId,
    required final String chargeCode,
    required final String chargeName,
    required final String chargeType,
    required final String calculationType,
    final double? baseAmount,
    final double? chargeRate,
    required final double chargeAmount,
    final bool isTaxable,
    final double taxAmount,
    final bool isManual,
    final double? originalAmount,
    final String? adjustmentReason,
    final String? addedBy,
    final String? removedBy,
    final bool isRemoved,
    final DateTime? removedAt,
    final String? notes,
    required final DateTime createdAt,
    final DateTime? updatedAt,
  }) = _$AppliedChargeImpl;
  const _AppliedCharge._() : super._();

  factory _AppliedCharge.fromJson(Map<String, dynamic> json) =
      _$AppliedChargeImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  String? get chargeId; // Charge details snapshot
  @override
  String get chargeCode;
  @override
  String get chargeName;
  @override
  String get chargeType;
  @override
  String get calculationType; // Calculation details
  @override
  double? get baseAmount; // Amount on which charge is calculated
  @override
  double? get chargeRate; // Percentage or per-unit rate used
  @override
  double get chargeAmount; // Final charge amount
  // Tax calculation
  @override
  bool get isTaxable;
  @override
  double get taxAmount; // Manual override
  @override
  bool get isManual;
  @override
  double? get originalAmount; // Original amount before manual adjustment
  @override
  String? get adjustmentReason; // Metadata
  @override
  String? get addedBy;
  @override
  String? get removedBy;
  @override
  bool get isRemoved;
  @override
  DateTime? get removedAt;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of AppliedCharge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppliedChargeImplCopyWith<_$AppliedChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerChargeExemption _$CustomerChargeExemptionFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerChargeExemption.fromJson(json);
}

/// @nodoc
mixin _$CustomerChargeExemption {
  String get id => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get chargeId => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get exemptionType =>
      throw _privateConstructorUsedError; // 'full', 'partial', 'percentage'
  double? get exemptionValue =>
      throw _privateConstructorUsedError; // Amount or percentage
  String? get reason => throw _privateConstructorUsedError;
  DateTime? get validFrom => throw _privateConstructorUsedError;
  DateTime? get validUntil => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CustomerChargeExemption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerChargeExemption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerChargeExemptionCopyWith<CustomerChargeExemption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerChargeExemptionCopyWith<$Res> {
  factory $CustomerChargeExemptionCopyWith(
    CustomerChargeExemption value,
    $Res Function(CustomerChargeExemption) then,
  ) = _$CustomerChargeExemptionCopyWithImpl<$Res, CustomerChargeExemption>;
  @useResult
  $Res call({
    String id,
    String customerId,
    String chargeId,
    String businessId,
    String exemptionType,
    double? exemptionValue,
    String? reason,
    DateTime? validFrom,
    DateTime? validUntil,
    bool isActive,
    String? approvedBy,
    DateTime? approvedAt,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CustomerChargeExemptionCopyWithImpl<
  $Res,
  $Val extends CustomerChargeExemption
>
    implements $CustomerChargeExemptionCopyWith<$Res> {
  _$CustomerChargeExemptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerChargeExemption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? chargeId = null,
    Object? businessId = null,
    Object? exemptionType = null,
    Object? exemptionValue = freezed,
    Object? reason = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? isActive = null,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            customerId:
                null == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String,
            chargeId:
                null == chargeId
                    ? _value.chargeId
                    : chargeId // ignore: cast_nullable_to_non_nullable
                        as String,
            businessId:
                null == businessId
                    ? _value.businessId
                    : businessId // ignore: cast_nullable_to_non_nullable
                        as String,
            exemptionType:
                null == exemptionType
                    ? _value.exemptionType
                    : exemptionType // ignore: cast_nullable_to_non_nullable
                        as String,
            exemptionValue:
                freezed == exemptionValue
                    ? _value.exemptionValue
                    : exemptionValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            reason:
                freezed == reason
                    ? _value.reason
                    : reason // ignore: cast_nullable_to_non_nullable
                        as String?,
            validFrom:
                freezed == validFrom
                    ? _value.validFrom
                    : validFrom // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            validUntil:
                freezed == validUntil
                    ? _value.validUntil
                    : validUntil // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            approvedBy:
                freezed == approvedBy
                    ? _value.approvedBy
                    : approvedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            approvedAt:
                freezed == approvedAt
                    ? _value.approvedAt
                    : approvedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerChargeExemptionImplCopyWith<$Res>
    implements $CustomerChargeExemptionCopyWith<$Res> {
  factory _$$CustomerChargeExemptionImplCopyWith(
    _$CustomerChargeExemptionImpl value,
    $Res Function(_$CustomerChargeExemptionImpl) then,
  ) = __$$CustomerChargeExemptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String customerId,
    String chargeId,
    String businessId,
    String exemptionType,
    double? exemptionValue,
    String? reason,
    DateTime? validFrom,
    DateTime? validUntil,
    bool isActive,
    String? approvedBy,
    DateTime? approvedAt,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CustomerChargeExemptionImplCopyWithImpl<$Res>
    extends
        _$CustomerChargeExemptionCopyWithImpl<
          $Res,
          _$CustomerChargeExemptionImpl
        >
    implements _$$CustomerChargeExemptionImplCopyWith<$Res> {
  __$$CustomerChargeExemptionImplCopyWithImpl(
    _$CustomerChargeExemptionImpl _value,
    $Res Function(_$CustomerChargeExemptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerChargeExemption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? chargeId = null,
    Object? businessId = null,
    Object? exemptionType = null,
    Object? exemptionValue = freezed,
    Object? reason = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? isActive = null,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CustomerChargeExemptionImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        customerId:
            null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String,
        chargeId:
            null == chargeId
                ? _value.chargeId
                : chargeId // ignore: cast_nullable_to_non_nullable
                    as String,
        businessId:
            null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                    as String,
        exemptionType:
            null == exemptionType
                ? _value.exemptionType
                : exemptionType // ignore: cast_nullable_to_non_nullable
                    as String,
        exemptionValue:
            freezed == exemptionValue
                ? _value.exemptionValue
                : exemptionValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        reason:
            freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                    as String?,
        validFrom:
            freezed == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        validUntil:
            freezed == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        approvedBy:
            freezed == approvedBy
                ? _value.approvedBy
                : approvedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        approvedAt:
            freezed == approvedAt
                ? _value.approvedAt
                : approvedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerChargeExemptionImpl extends _CustomerChargeExemption {
  const _$CustomerChargeExemptionImpl({
    required this.id,
    required this.customerId,
    required this.chargeId,
    required this.businessId,
    required this.exemptionType,
    this.exemptionValue,
    this.reason,
    this.validFrom,
    this.validUntil,
    this.isActive = true,
    this.approvedBy,
    this.approvedAt,
    required this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$CustomerChargeExemptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerChargeExemptionImplFromJson(json);

  @override
  final String id;
  @override
  final String customerId;
  @override
  final String chargeId;
  @override
  final String businessId;
  @override
  final String exemptionType;
  // 'full', 'partial', 'percentage'
  @override
  final double? exemptionValue;
  // Amount or percentage
  @override
  final String? reason;
  @override
  final DateTime? validFrom;
  @override
  final DateTime? validUntil;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? approvedBy;
  @override
  final DateTime? approvedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CustomerChargeExemption(id: $id, customerId: $customerId, chargeId: $chargeId, businessId: $businessId, exemptionType: $exemptionType, exemptionValue: $exemptionValue, reason: $reason, validFrom: $validFrom, validUntil: $validUntil, isActive: $isActive, approvedBy: $approvedBy, approvedAt: $approvedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerChargeExemptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.chargeId, chargeId) ||
                other.chargeId == chargeId) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.exemptionType, exemptionType) ||
                other.exemptionType == exemptionType) &&
            (identical(other.exemptionValue, exemptionValue) ||
                other.exemptionValue == exemptionValue) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
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
    customerId,
    chargeId,
    businessId,
    exemptionType,
    exemptionValue,
    reason,
    validFrom,
    validUntil,
    isActive,
    approvedBy,
    approvedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CustomerChargeExemption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerChargeExemptionImplCopyWith<_$CustomerChargeExemptionImpl>
  get copyWith => __$$CustomerChargeExemptionImplCopyWithImpl<
    _$CustomerChargeExemptionImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerChargeExemptionImplToJson(this);
  }
}

abstract class _CustomerChargeExemption extends CustomerChargeExemption {
  const factory _CustomerChargeExemption({
    required final String id,
    required final String customerId,
    required final String chargeId,
    required final String businessId,
    required final String exemptionType,
    final double? exemptionValue,
    final String? reason,
    final DateTime? validFrom,
    final DateTime? validUntil,
    final bool isActive,
    final String? approvedBy,
    final DateTime? approvedAt,
    required final DateTime createdAt,
    final DateTime? updatedAt,
  }) = _$CustomerChargeExemptionImpl;
  const _CustomerChargeExemption._() : super._();

  factory _CustomerChargeExemption.fromJson(Map<String, dynamic> json) =
      _$CustomerChargeExemptionImpl.fromJson;

  @override
  String get id;
  @override
  String get customerId;
  @override
  String get chargeId;
  @override
  String get businessId;
  @override
  String get exemptionType; // 'full', 'partial', 'percentage'
  @override
  double? get exemptionValue; // Amount or percentage
  @override
  String? get reason;
  @override
  DateTime? get validFrom;
  @override
  DateTime? get validUntil;
  @override
  bool get isActive;
  @override
  String? get approvedBy;
  @override
  DateTime? get approvedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CustomerChargeExemption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerChargeExemptionImplCopyWith<_$CustomerChargeExemptionImpl>
  get copyWith => throw _privateConstructorUsedError;
}
