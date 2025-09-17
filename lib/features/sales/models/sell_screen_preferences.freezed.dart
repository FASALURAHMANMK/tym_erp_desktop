// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sell_screen_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SellScreenPreferences _$SellScreenPreferencesFromJson(
  Map<String, dynamic> json,
) {
  return _SellScreenPreferences.fromJson(json);
}

/// @nodoc
mixin _$SellScreenPreferences {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  bool get showOnHoldTab => throw _privateConstructorUsedError;
  bool get showSettlementTab => throw _privateConstructorUsedError;
  String? get defaultPriceCategoryId => throw _privateConstructorUsedError;
  ProductViewMode get productViewMode => throw _privateConstructorUsedError;
  int get gridColumns => throw _privateConstructorUsedError;
  bool get showQuickSale => throw _privateConstructorUsedError;
  bool get showAddExpense => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this SellScreenPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellScreenPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellScreenPreferencesCopyWith<SellScreenPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellScreenPreferencesCopyWith<$Res> {
  factory $SellScreenPreferencesCopyWith(
    SellScreenPreferences value,
    $Res Function(SellScreenPreferences) then,
  ) = _$SellScreenPreferencesCopyWithImpl<$Res, SellScreenPreferences>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    bool showOnHoldTab,
    bool showSettlementTab,
    String? defaultPriceCategoryId,
    ProductViewMode productViewMode,
    int gridColumns,
    bool showQuickSale,
    bool showAddExpense,
    Map<String, dynamic> settings,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$SellScreenPreferencesCopyWithImpl<
  $Res,
  $Val extends SellScreenPreferences
>
    implements $SellScreenPreferencesCopyWith<$Res> {
  _$SellScreenPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellScreenPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? showOnHoldTab = null,
    Object? showSettlementTab = null,
    Object? defaultPriceCategoryId = freezed,
    Object? productViewMode = null,
    Object? gridColumns = null,
    Object? showQuickSale = null,
    Object? showAddExpense = null,
    Object? settings = null,
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
            businessId:
                null == businessId
                    ? _value.businessId
                    : businessId // ignore: cast_nullable_to_non_nullable
                        as String,
            locationId:
                null == locationId
                    ? _value.locationId
                    : locationId // ignore: cast_nullable_to_non_nullable
                        as String,
            showOnHoldTab:
                null == showOnHoldTab
                    ? _value.showOnHoldTab
                    : showOnHoldTab // ignore: cast_nullable_to_non_nullable
                        as bool,
            showSettlementTab:
                null == showSettlementTab
                    ? _value.showSettlementTab
                    : showSettlementTab // ignore: cast_nullable_to_non_nullable
                        as bool,
            defaultPriceCategoryId:
                freezed == defaultPriceCategoryId
                    ? _value.defaultPriceCategoryId
                    : defaultPriceCategoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            productViewMode:
                null == productViewMode
                    ? _value.productViewMode
                    : productViewMode // ignore: cast_nullable_to_non_nullable
                        as ProductViewMode,
            gridColumns:
                null == gridColumns
                    ? _value.gridColumns
                    : gridColumns // ignore: cast_nullable_to_non_nullable
                        as int,
            showQuickSale:
                null == showQuickSale
                    ? _value.showQuickSale
                    : showQuickSale // ignore: cast_nullable_to_non_nullable
                        as bool,
            showAddExpense:
                null == showAddExpense
                    ? _value.showAddExpense
                    : showAddExpense // ignore: cast_nullable_to_non_nullable
                        as bool,
            settings:
                null == settings
                    ? _value.settings
                    : settings // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
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
abstract class _$$SellScreenPreferencesImplCopyWith<$Res>
    implements $SellScreenPreferencesCopyWith<$Res> {
  factory _$$SellScreenPreferencesImplCopyWith(
    _$SellScreenPreferencesImpl value,
    $Res Function(_$SellScreenPreferencesImpl) then,
  ) = __$$SellScreenPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    bool showOnHoldTab,
    bool showSettlementTab,
    String? defaultPriceCategoryId,
    ProductViewMode productViewMode,
    int gridColumns,
    bool showQuickSale,
    bool showAddExpense,
    Map<String, dynamic> settings,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$SellScreenPreferencesImplCopyWithImpl<$Res>
    extends
        _$SellScreenPreferencesCopyWithImpl<$Res, _$SellScreenPreferencesImpl>
    implements _$$SellScreenPreferencesImplCopyWith<$Res> {
  __$$SellScreenPreferencesImplCopyWithImpl(
    _$SellScreenPreferencesImpl _value,
    $Res Function(_$SellScreenPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SellScreenPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? showOnHoldTab = null,
    Object? showSettlementTab = null,
    Object? defaultPriceCategoryId = freezed,
    Object? productViewMode = null,
    Object? gridColumns = null,
    Object? showQuickSale = null,
    Object? showAddExpense = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$SellScreenPreferencesImpl(
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
            null == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                    as String,
        showOnHoldTab:
            null == showOnHoldTab
                ? _value.showOnHoldTab
                : showOnHoldTab // ignore: cast_nullable_to_non_nullable
                    as bool,
        showSettlementTab:
            null == showSettlementTab
                ? _value.showSettlementTab
                : showSettlementTab // ignore: cast_nullable_to_non_nullable
                    as bool,
        defaultPriceCategoryId:
            freezed == defaultPriceCategoryId
                ? _value.defaultPriceCategoryId
                : defaultPriceCategoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        productViewMode:
            null == productViewMode
                ? _value.productViewMode
                : productViewMode // ignore: cast_nullable_to_non_nullable
                    as ProductViewMode,
        gridColumns:
            null == gridColumns
                ? _value.gridColumns
                : gridColumns // ignore: cast_nullable_to_non_nullable
                    as int,
        showQuickSale:
            null == showQuickSale
                ? _value.showQuickSale
                : showQuickSale // ignore: cast_nullable_to_non_nullable
                    as bool,
        showAddExpense:
            null == showAddExpense
                ? _value.showAddExpense
                : showAddExpense // ignore: cast_nullable_to_non_nullable
                    as bool,
        settings:
            null == settings
                ? _value._settings
                : settings // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
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
class _$SellScreenPreferencesImpl extends _SellScreenPreferences {
  const _$SellScreenPreferencesImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    this.showOnHoldTab = true,
    this.showSettlementTab = true,
    this.defaultPriceCategoryId,
    this.productViewMode = ProductViewMode.grid,
    this.gridColumns = 4,
    this.showQuickSale = true,
    this.showAddExpense = false,
    final Map<String, dynamic> settings = const {},
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : _settings = settings,
       super._();

  factory _$SellScreenPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellScreenPreferencesImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  @JsonKey()
  final bool showOnHoldTab;
  @override
  @JsonKey()
  final bool showSettlementTab;
  @override
  final String? defaultPriceCategoryId;
  @override
  @JsonKey()
  final ProductViewMode productViewMode;
  @override
  @JsonKey()
  final int gridColumns;
  @override
  @JsonKey()
  final bool showQuickSale;
  @override
  @JsonKey()
  final bool showAddExpense;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

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
    return 'SellScreenPreferences(id: $id, businessId: $businessId, locationId: $locationId, showOnHoldTab: $showOnHoldTab, showSettlementTab: $showSettlementTab, defaultPriceCategoryId: $defaultPriceCategoryId, productViewMode: $productViewMode, gridColumns: $gridColumns, showQuickSale: $showQuickSale, showAddExpense: $showAddExpense, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellScreenPreferencesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.showOnHoldTab, showOnHoldTab) ||
                other.showOnHoldTab == showOnHoldTab) &&
            (identical(other.showSettlementTab, showSettlementTab) ||
                other.showSettlementTab == showSettlementTab) &&
            (identical(other.defaultPriceCategoryId, defaultPriceCategoryId) ||
                other.defaultPriceCategoryId == defaultPriceCategoryId) &&
            (identical(other.productViewMode, productViewMode) ||
                other.productViewMode == productViewMode) &&
            (identical(other.gridColumns, gridColumns) ||
                other.gridColumns == gridColumns) &&
            (identical(other.showQuickSale, showQuickSale) ||
                other.showQuickSale == showQuickSale) &&
            (identical(other.showAddExpense, showAddExpense) ||
                other.showAddExpense == showAddExpense) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
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
    businessId,
    locationId,
    showOnHoldTab,
    showSettlementTab,
    defaultPriceCategoryId,
    productViewMode,
    gridColumns,
    showQuickSale,
    showAddExpense,
    const DeepCollectionEquality().hash(_settings),
    createdAt,
    updatedAt,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of SellScreenPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellScreenPreferencesImplCopyWith<_$SellScreenPreferencesImpl>
  get copyWith =>
      __$$SellScreenPreferencesImplCopyWithImpl<_$SellScreenPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SellScreenPreferencesImplToJson(this);
  }
}

abstract class _SellScreenPreferences extends SellScreenPreferences {
  const factory _SellScreenPreferences({
    required final String id,
    required final String businessId,
    required final String locationId,
    final bool showOnHoldTab,
    final bool showSettlementTab,
    final String? defaultPriceCategoryId,
    final ProductViewMode productViewMode,
    final int gridColumns,
    final bool showQuickSale,
    final bool showAddExpense,
    final Map<String, dynamic> settings,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$SellScreenPreferencesImpl;
  const _SellScreenPreferences._() : super._();

  factory _SellScreenPreferences.fromJson(Map<String, dynamic> json) =
      _$SellScreenPreferencesImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  bool get showOnHoldTab;
  @override
  bool get showSettlementTab;
  @override
  String? get defaultPriceCategoryId;
  @override
  ProductViewMode get productViewMode;
  @override
  int get gridColumns;
  @override
  bool get showQuickSale;
  @override
  bool get showAddExpense;
  @override
  Map<String, dynamic> get settings;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of SellScreenPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellScreenPreferencesImplCopyWith<_$SellScreenPreferencesImpl>
  get copyWith => throw _privateConstructorUsedError;
}
