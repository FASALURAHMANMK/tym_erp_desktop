// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameInAlternateLanguage => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get descriptionInAlternateLanguage =>
      throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String? get brandId => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get additionalImageUrls => throw _privateConstructorUsedError;
  UnitOfMeasure get unitOfMeasure => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get hsn => throw _privateConstructorUsedError;
  double get taxRate =>
      throw _privateConstructorUsedError; // Deprecated - use taxRateId instead
  String? get taxGroupId =>
      throw _privateConstructorUsedError; // Deprecated - use taxRateId instead
  String? get taxRateId =>
      throw _privateConstructorUsedError; // Reference to specific tax_rates table entry
  String? get shortCode => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  ProductType get productType => throw _privateConstructorUsedError;
  bool get trackInventory => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Availability flags
  bool get availableInPos => throw _privateConstructorUsedError;
  bool get availableInOnlineStore => throw _privateConstructorUsedError;
  bool get availableInCatalog =>
      throw _privateConstructorUsedError; // KOT settings
  bool get skipKot =>
      throw _privateConstructorUsedError; // Always has at least one variation
  List<ProductVariation> get variations =>
      throw _privateConstructorUsedError; // Sync fields
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? nameInAlternateLanguage,
    String? description,
    String? descriptionInAlternateLanguage,
    String categoryId,
    String? brandId,
    String? imageUrl,
    List<String> additionalImageUrls,
    UnitOfMeasure unitOfMeasure,
    String? barcode,
    String? hsn,
    double taxRate,
    String? taxGroupId,
    String? taxRateId,
    String? shortCode,
    List<String> tags,
    ProductType productType,
    bool trackInventory,
    bool isActive,
    int displayOrder,
    DateTime createdAt,
    DateTime updatedAt,
    bool availableInPos,
    bool availableInOnlineStore,
    bool availableInCatalog,
    bool skipKot,
    List<ProductVariation> variations,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? nameInAlternateLanguage = freezed,
    Object? description = freezed,
    Object? descriptionInAlternateLanguage = freezed,
    Object? categoryId = null,
    Object? brandId = freezed,
    Object? imageUrl = freezed,
    Object? additionalImageUrls = null,
    Object? unitOfMeasure = null,
    Object? barcode = freezed,
    Object? hsn = freezed,
    Object? taxRate = null,
    Object? taxGroupId = freezed,
    Object? taxRateId = freezed,
    Object? shortCode = freezed,
    Object? tags = null,
    Object? productType = null,
    Object? trackInventory = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? availableInPos = null,
    Object? availableInOnlineStore = null,
    Object? availableInCatalog = null,
    Object? skipKot = null,
    Object? variations = null,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            nameInAlternateLanguage:
                freezed == nameInAlternateLanguage
                    ? _value.nameInAlternateLanguage
                    : nameInAlternateLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            descriptionInAlternateLanguage:
                freezed == descriptionInAlternateLanguage
                    ? _value.descriptionInAlternateLanguage
                    : descriptionInAlternateLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
            categoryId:
                null == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as String,
            brandId:
                freezed == brandId
                    ? _value.brandId
                    : brandId // ignore: cast_nullable_to_non_nullable
                        as String?,
            imageUrl:
                freezed == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            additionalImageUrls:
                null == additionalImageUrls
                    ? _value.additionalImageUrls
                    : additionalImageUrls // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            unitOfMeasure:
                null == unitOfMeasure
                    ? _value.unitOfMeasure
                    : unitOfMeasure // ignore: cast_nullable_to_non_nullable
                        as UnitOfMeasure,
            barcode:
                freezed == barcode
                    ? _value.barcode
                    : barcode // ignore: cast_nullable_to_non_nullable
                        as String?,
            hsn:
                freezed == hsn
                    ? _value.hsn
                    : hsn // ignore: cast_nullable_to_non_nullable
                        as String?,
            taxRate:
                null == taxRate
                    ? _value.taxRate
                    : taxRate // ignore: cast_nullable_to_non_nullable
                        as double,
            taxGroupId:
                freezed == taxGroupId
                    ? _value.taxGroupId
                    : taxGroupId // ignore: cast_nullable_to_non_nullable
                        as String?,
            taxRateId:
                freezed == taxRateId
                    ? _value.taxRateId
                    : taxRateId // ignore: cast_nullable_to_non_nullable
                        as String?,
            shortCode:
                freezed == shortCode
                    ? _value.shortCode
                    : shortCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            tags:
                null == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            productType:
                null == productType
                    ? _value.productType
                    : productType // ignore: cast_nullable_to_non_nullable
                        as ProductType,
            trackInventory:
                null == trackInventory
                    ? _value.trackInventory
                    : trackInventory // ignore: cast_nullable_to_non_nullable
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
            availableInPos:
                null == availableInPos
                    ? _value.availableInPos
                    : availableInPos // ignore: cast_nullable_to_non_nullable
                        as bool,
            availableInOnlineStore:
                null == availableInOnlineStore
                    ? _value.availableInOnlineStore
                    : availableInOnlineStore // ignore: cast_nullable_to_non_nullable
                        as bool,
            availableInCatalog:
                null == availableInCatalog
                    ? _value.availableInCatalog
                    : availableInCatalog // ignore: cast_nullable_to_non_nullable
                        as bool,
            skipKot:
                null == skipKot
                    ? _value.skipKot
                    : skipKot // ignore: cast_nullable_to_non_nullable
                        as bool,
            variations:
                null == variations
                    ? _value.variations
                    : variations // ignore: cast_nullable_to_non_nullable
                        as List<ProductVariation>,
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
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? nameInAlternateLanguage,
    String? description,
    String? descriptionInAlternateLanguage,
    String categoryId,
    String? brandId,
    String? imageUrl,
    List<String> additionalImageUrls,
    UnitOfMeasure unitOfMeasure,
    String? barcode,
    String? hsn,
    double taxRate,
    String? taxGroupId,
    String? taxRateId,
    String? shortCode,
    List<String> tags,
    ProductType productType,
    bool trackInventory,
    bool isActive,
    int displayOrder,
    DateTime createdAt,
    DateTime updatedAt,
    bool availableInPos,
    bool availableInOnlineStore,
    bool availableInCatalog,
    bool skipKot,
    List<ProductVariation> variations,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? nameInAlternateLanguage = freezed,
    Object? description = freezed,
    Object? descriptionInAlternateLanguage = freezed,
    Object? categoryId = null,
    Object? brandId = freezed,
    Object? imageUrl = freezed,
    Object? additionalImageUrls = null,
    Object? unitOfMeasure = null,
    Object? barcode = freezed,
    Object? hsn = freezed,
    Object? taxRate = null,
    Object? taxGroupId = freezed,
    Object? taxRateId = freezed,
    Object? shortCode = freezed,
    Object? tags = null,
    Object? productType = null,
    Object? trackInventory = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? availableInPos = null,
    Object? availableInOnlineStore = null,
    Object? availableInCatalog = null,
    Object? skipKot = null,
    Object? variations = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$ProductImpl(
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
        nameInAlternateLanguage:
            freezed == nameInAlternateLanguage
                ? _value.nameInAlternateLanguage
                : nameInAlternateLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        descriptionInAlternateLanguage:
            freezed == descriptionInAlternateLanguage
                ? _value.descriptionInAlternateLanguage
                : descriptionInAlternateLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
        categoryId:
            null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as String,
        brandId:
            freezed == brandId
                ? _value.brandId
                : brandId // ignore: cast_nullable_to_non_nullable
                    as String?,
        imageUrl:
            freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        additionalImageUrls:
            null == additionalImageUrls
                ? _value._additionalImageUrls
                : additionalImageUrls // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        unitOfMeasure:
            null == unitOfMeasure
                ? _value.unitOfMeasure
                : unitOfMeasure // ignore: cast_nullable_to_non_nullable
                    as UnitOfMeasure,
        barcode:
            freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                    as String?,
        hsn:
            freezed == hsn
                ? _value.hsn
                : hsn // ignore: cast_nullable_to_non_nullable
                    as String?,
        taxRate:
            null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                    as double,
        taxGroupId:
            freezed == taxGroupId
                ? _value.taxGroupId
                : taxGroupId // ignore: cast_nullable_to_non_nullable
                    as String?,
        taxRateId:
            freezed == taxRateId
                ? _value.taxRateId
                : taxRateId // ignore: cast_nullable_to_non_nullable
                    as String?,
        shortCode:
            freezed == shortCode
                ? _value.shortCode
                : shortCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        tags:
            null == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        productType:
            null == productType
                ? _value.productType
                : productType // ignore: cast_nullable_to_non_nullable
                    as ProductType,
        trackInventory:
            null == trackInventory
                ? _value.trackInventory
                : trackInventory // ignore: cast_nullable_to_non_nullable
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
        availableInPos:
            null == availableInPos
                ? _value.availableInPos
                : availableInPos // ignore: cast_nullable_to_non_nullable
                    as bool,
        availableInOnlineStore:
            null == availableInOnlineStore
                ? _value.availableInOnlineStore
                : availableInOnlineStore // ignore: cast_nullable_to_non_nullable
                    as bool,
        availableInCatalog:
            null == availableInCatalog
                ? _value.availableInCatalog
                : availableInCatalog // ignore: cast_nullable_to_non_nullable
                    as bool,
        skipKot:
            null == skipKot
                ? _value.skipKot
                : skipKot // ignore: cast_nullable_to_non_nullable
                    as bool,
        variations:
            null == variations
                ? _value._variations
                : variations // ignore: cast_nullable_to_non_nullable
                    as List<ProductVariation>,
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
class _$ProductImpl extends _Product {
  const _$ProductImpl({
    required this.id,
    required this.businessId,
    required this.name,
    this.nameInAlternateLanguage,
    this.description,
    this.descriptionInAlternateLanguage,
    required this.categoryId,
    this.brandId,
    this.imageUrl,
    final List<String> additionalImageUrls = const [],
    this.unitOfMeasure = UnitOfMeasure.count,
    this.barcode,
    this.hsn,
    this.taxRate = 0.0,
    this.taxGroupId,
    this.taxRateId,
    this.shortCode,
    final List<String> tags = const [],
    this.productType = ProductType.physical,
    this.trackInventory = true,
    this.isActive = true,
    this.displayOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    this.availableInPos = true,
    this.availableInOnlineStore = false,
    this.availableInCatalog = true,
    this.skipKot = false,
    required final List<ProductVariation> variations,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : _additionalImageUrls = additionalImageUrls,
       _tags = tags,
       _variations = variations,
       super._();

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final String? nameInAlternateLanguage;
  @override
  final String? description;
  @override
  final String? descriptionInAlternateLanguage;
  @override
  final String categoryId;
  @override
  final String? brandId;
  @override
  final String? imageUrl;
  final List<String> _additionalImageUrls;
  @override
  @JsonKey()
  List<String> get additionalImageUrls {
    if (_additionalImageUrls is EqualUnmodifiableListView)
      return _additionalImageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_additionalImageUrls);
  }

  @override
  @JsonKey()
  final UnitOfMeasure unitOfMeasure;
  @override
  final String? barcode;
  @override
  final String? hsn;
  @override
  @JsonKey()
  final double taxRate;
  // Deprecated - use taxRateId instead
  @override
  final String? taxGroupId;
  // Deprecated - use taxRateId instead
  @override
  final String? taxRateId;
  // Reference to specific tax_rates table entry
  @override
  final String? shortCode;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final ProductType productType;
  @override
  @JsonKey()
  final bool trackInventory;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  // Availability flags
  @override
  @JsonKey()
  final bool availableInPos;
  @override
  @JsonKey()
  final bool availableInOnlineStore;
  @override
  @JsonKey()
  final bool availableInCatalog;
  // KOT settings
  @override
  @JsonKey()
  final bool skipKot;
  // Always has at least one variation
  final List<ProductVariation> _variations;
  // Always has at least one variation
  @override
  List<ProductVariation> get variations {
    if (_variations is EqualUnmodifiableListView) return _variations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variations);
  }

  // Sync fields
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'Product(id: $id, businessId: $businessId, name: $name, nameInAlternateLanguage: $nameInAlternateLanguage, description: $description, descriptionInAlternateLanguage: $descriptionInAlternateLanguage, categoryId: $categoryId, brandId: $brandId, imageUrl: $imageUrl, additionalImageUrls: $additionalImageUrls, unitOfMeasure: $unitOfMeasure, barcode: $barcode, hsn: $hsn, taxRate: $taxRate, taxGroupId: $taxGroupId, taxRateId: $taxRateId, shortCode: $shortCode, tags: $tags, productType: $productType, trackInventory: $trackInventory, isActive: $isActive, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt, availableInPos: $availableInPos, availableInOnlineStore: $availableInOnlineStore, availableInCatalog: $availableInCatalog, skipKot: $skipKot, variations: $variations, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(
                  other.nameInAlternateLanguage,
                  nameInAlternateLanguage,
                ) ||
                other.nameInAlternateLanguage == nameInAlternateLanguage) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(
                  other.descriptionInAlternateLanguage,
                  descriptionInAlternateLanguage,
                ) ||
                other.descriptionInAlternateLanguage ==
                    descriptionInAlternateLanguage) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(
              other._additionalImageUrls,
              _additionalImageUrls,
            ) &&
            (identical(other.unitOfMeasure, unitOfMeasure) ||
                other.unitOfMeasure == unitOfMeasure) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.hsn, hsn) || other.hsn == hsn) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxGroupId, taxGroupId) ||
                other.taxGroupId == taxGroupId) &&
            (identical(other.taxRateId, taxRateId) ||
                other.taxRateId == taxRateId) &&
            (identical(other.shortCode, shortCode) ||
                other.shortCode == shortCode) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.trackInventory, trackInventory) ||
                other.trackInventory == trackInventory) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.availableInPos, availableInPos) ||
                other.availableInPos == availableInPos) &&
            (identical(other.availableInOnlineStore, availableInOnlineStore) ||
                other.availableInOnlineStore == availableInOnlineStore) &&
            (identical(other.availableInCatalog, availableInCatalog) ||
                other.availableInCatalog == availableInCatalog) &&
            (identical(other.skipKot, skipKot) || other.skipKot == skipKot) &&
            const DeepCollectionEquality().equals(
              other._variations,
              _variations,
            ) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessId,
    name,
    nameInAlternateLanguage,
    description,
    descriptionInAlternateLanguage,
    categoryId,
    brandId,
    imageUrl,
    const DeepCollectionEquality().hash(_additionalImageUrls),
    unitOfMeasure,
    barcode,
    hsn,
    taxRate,
    taxGroupId,
    taxRateId,
    shortCode,
    const DeepCollectionEquality().hash(_tags),
    productType,
    trackInventory,
    isActive,
    displayOrder,
    createdAt,
    updatedAt,
    availableInPos,
    availableInOnlineStore,
    availableInCatalog,
    skipKot,
    const DeepCollectionEquality().hash(_variations),
    lastSyncedAt,
    hasUnsyncedChanges,
  ]);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product extends Product {
  const factory _Product({
    required final String id,
    required final String businessId,
    required final String name,
    final String? nameInAlternateLanguage,
    final String? description,
    final String? descriptionInAlternateLanguage,
    required final String categoryId,
    final String? brandId,
    final String? imageUrl,
    final List<String> additionalImageUrls,
    final UnitOfMeasure unitOfMeasure,
    final String? barcode,
    final String? hsn,
    final double taxRate,
    final String? taxGroupId,
    final String? taxRateId,
    final String? shortCode,
    final List<String> tags,
    final ProductType productType,
    final bool trackInventory,
    final bool isActive,
    final int displayOrder,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final bool availableInPos,
    final bool availableInOnlineStore,
    final bool availableInCatalog,
    final bool skipKot,
    required final List<ProductVariation> variations,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$ProductImpl;
  const _Product._() : super._();

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  String? get nameInAlternateLanguage;
  @override
  String? get description;
  @override
  String? get descriptionInAlternateLanguage;
  @override
  String get categoryId;
  @override
  String? get brandId;
  @override
  String? get imageUrl;
  @override
  List<String> get additionalImageUrls;
  @override
  UnitOfMeasure get unitOfMeasure;
  @override
  String? get barcode;
  @override
  String? get hsn;
  @override
  double get taxRate; // Deprecated - use taxRateId instead
  @override
  String? get taxGroupId; // Deprecated - use taxRateId instead
  @override
  String? get taxRateId; // Reference to specific tax_rates table entry
  @override
  String? get shortCode;
  @override
  List<String> get tags;
  @override
  ProductType get productType;
  @override
  bool get trackInventory;
  @override
  bool get isActive;
  @override
  int get displayOrder;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // Availability flags
  @override
  bool get availableInPos;
  @override
  bool get availableInOnlineStore;
  @override
  bool get availableInCatalog; // KOT settings
  @override
  bool get skipKot; // Always has at least one variation
  @override
  List<ProductVariation> get variations; // Sync fields
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductVariation _$ProductVariationFromJson(Map<String, dynamic> json) {
  return _ProductVariation.fromJson(json);
}

/// @nodoc
mixin _$ProductVariation {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  double get mrp => throw _privateConstructorUsedError;
  double get sellingPrice => throw _privateConstructorUsedError;
  double? get purchasePrice => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError; // Inventory flags
  bool get isForSale => throw _privateConstructorUsedError;
  bool get isForPurchase =>
      throw _privateConstructorUsedError; // Price category overrides
  // Map of priceCategoryId to price
  Map<String, double> get categoryPrices =>
      throw _privateConstructorUsedError; // Table-specific price overrides (optional)
  // Map of tableId to price
  Map<String, double> get tablePrices => throw _privateConstructorUsedError;

  /// Serializes this ProductVariation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductVariation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductVariationCopyWith<ProductVariation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductVariationCopyWith<$Res> {
  factory $ProductVariationCopyWith(
    ProductVariation value,
    $Res Function(ProductVariation) then,
  ) = _$ProductVariationCopyWithImpl<$Res, ProductVariation>;
  @useResult
  $Res call({
    String id,
    String productId,
    String name,
    String? sku,
    double mrp,
    double sellingPrice,
    double? purchasePrice,
    String? barcode,
    bool isDefault,
    bool isActive,
    int displayOrder,
    bool isForSale,
    bool isForPurchase,
    Map<String, double> categoryPrices,
    Map<String, double> tablePrices,
  });
}

/// @nodoc
class _$ProductVariationCopyWithImpl<$Res, $Val extends ProductVariation>
    implements $ProductVariationCopyWith<$Res> {
  _$ProductVariationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductVariation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? name = null,
    Object? sku = freezed,
    Object? mrp = null,
    Object? sellingPrice = null,
    Object? purchasePrice = freezed,
    Object? barcode = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? isForSale = null,
    Object? isForPurchase = null,
    Object? categoryPrices = null,
    Object? tablePrices = null,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            sku:
                freezed == sku
                    ? _value.sku
                    : sku // ignore: cast_nullable_to_non_nullable
                        as String?,
            mrp:
                null == mrp
                    ? _value.mrp
                    : mrp // ignore: cast_nullable_to_non_nullable
                        as double,
            sellingPrice:
                null == sellingPrice
                    ? _value.sellingPrice
                    : sellingPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            purchasePrice:
                freezed == purchasePrice
                    ? _value.purchasePrice
                    : purchasePrice // ignore: cast_nullable_to_non_nullable
                        as double?,
            barcode:
                freezed == barcode
                    ? _value.barcode
                    : barcode // ignore: cast_nullable_to_non_nullable
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
            isForSale:
                null == isForSale
                    ? _value.isForSale
                    : isForSale // ignore: cast_nullable_to_non_nullable
                        as bool,
            isForPurchase:
                null == isForPurchase
                    ? _value.isForPurchase
                    : isForPurchase // ignore: cast_nullable_to_non_nullable
                        as bool,
            categoryPrices:
                null == categoryPrices
                    ? _value.categoryPrices
                    : categoryPrices // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
            tablePrices:
                null == tablePrices
                    ? _value.tablePrices
                    : tablePrices // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductVariationImplCopyWith<$Res>
    implements $ProductVariationCopyWith<$Res> {
  factory _$$ProductVariationImplCopyWith(
    _$ProductVariationImpl value,
    $Res Function(_$ProductVariationImpl) then,
  ) = __$$ProductVariationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productId,
    String name,
    String? sku,
    double mrp,
    double sellingPrice,
    double? purchasePrice,
    String? barcode,
    bool isDefault,
    bool isActive,
    int displayOrder,
    bool isForSale,
    bool isForPurchase,
    Map<String, double> categoryPrices,
    Map<String, double> tablePrices,
  });
}

/// @nodoc
class __$$ProductVariationImplCopyWithImpl<$Res>
    extends _$ProductVariationCopyWithImpl<$Res, _$ProductVariationImpl>
    implements _$$ProductVariationImplCopyWith<$Res> {
  __$$ProductVariationImplCopyWithImpl(
    _$ProductVariationImpl _value,
    $Res Function(_$ProductVariationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductVariation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? name = null,
    Object? sku = freezed,
    Object? mrp = null,
    Object? sellingPrice = null,
    Object? purchasePrice = freezed,
    Object? barcode = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? isForSale = null,
    Object? isForPurchase = null,
    Object? categoryPrices = null,
    Object? tablePrices = null,
  }) {
    return _then(
      _$ProductVariationImpl(
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
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        sku:
            freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                    as String?,
        mrp:
            null == mrp
                ? _value.mrp
                : mrp // ignore: cast_nullable_to_non_nullable
                    as double,
        sellingPrice:
            null == sellingPrice
                ? _value.sellingPrice
                : sellingPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        purchasePrice:
            freezed == purchasePrice
                ? _value.purchasePrice
                : purchasePrice // ignore: cast_nullable_to_non_nullable
                    as double?,
        barcode:
            freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
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
        isForSale:
            null == isForSale
                ? _value.isForSale
                : isForSale // ignore: cast_nullable_to_non_nullable
                    as bool,
        isForPurchase:
            null == isForPurchase
                ? _value.isForPurchase
                : isForPurchase // ignore: cast_nullable_to_non_nullable
                    as bool,
        categoryPrices:
            null == categoryPrices
                ? _value._categoryPrices
                : categoryPrices // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
        tablePrices:
            null == tablePrices
                ? _value._tablePrices
                : tablePrices // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductVariationImpl extends _ProductVariation {
  const _$ProductVariationImpl({
    required this.id,
    required this.productId,
    required this.name,
    this.sku,
    required this.mrp,
    required this.sellingPrice,
    this.purchasePrice,
    this.barcode,
    this.isDefault = false,
    this.isActive = true,
    this.displayOrder = 0,
    this.isForSale = true,
    this.isForPurchase = false,
    final Map<String, double> categoryPrices = const {},
    final Map<String, double> tablePrices = const {},
  }) : _categoryPrices = categoryPrices,
       _tablePrices = tablePrices,
       super._();

  factory _$ProductVariationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductVariationImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String name;
  @override
  final String? sku;
  @override
  final double mrp;
  @override
  final double sellingPrice;
  @override
  final double? purchasePrice;
  @override
  final String? barcode;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int displayOrder;
  // Inventory flags
  @override
  @JsonKey()
  final bool isForSale;
  @override
  @JsonKey()
  final bool isForPurchase;
  // Price category overrides
  // Map of priceCategoryId to price
  final Map<String, double> _categoryPrices;
  // Price category overrides
  // Map of priceCategoryId to price
  @override
  @JsonKey()
  Map<String, double> get categoryPrices {
    if (_categoryPrices is EqualUnmodifiableMapView) return _categoryPrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryPrices);
  }

  // Table-specific price overrides (optional)
  // Map of tableId to price
  final Map<String, double> _tablePrices;
  // Table-specific price overrides (optional)
  // Map of tableId to price
  @override
  @JsonKey()
  Map<String, double> get tablePrices {
    if (_tablePrices is EqualUnmodifiableMapView) return _tablePrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tablePrices);
  }

  @override
  String toString() {
    return 'ProductVariation(id: $id, productId: $productId, name: $name, sku: $sku, mrp: $mrp, sellingPrice: $sellingPrice, purchasePrice: $purchasePrice, barcode: $barcode, isDefault: $isDefault, isActive: $isActive, displayOrder: $displayOrder, isForSale: $isForSale, isForPurchase: $isForPurchase, categoryPrices: $categoryPrices, tablePrices: $tablePrices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductVariationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.mrp, mrp) || other.mrp == mrp) &&
            (identical(other.sellingPrice, sellingPrice) ||
                other.sellingPrice == sellingPrice) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isForSale, isForSale) ||
                other.isForSale == isForSale) &&
            (identical(other.isForPurchase, isForPurchase) ||
                other.isForPurchase == isForPurchase) &&
            const DeepCollectionEquality().equals(
              other._categoryPrices,
              _categoryPrices,
            ) &&
            const DeepCollectionEquality().equals(
              other._tablePrices,
              _tablePrices,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    name,
    sku,
    mrp,
    sellingPrice,
    purchasePrice,
    barcode,
    isDefault,
    isActive,
    displayOrder,
    isForSale,
    isForPurchase,
    const DeepCollectionEquality().hash(_categoryPrices),
    const DeepCollectionEquality().hash(_tablePrices),
  );

  /// Create a copy of ProductVariation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductVariationImplCopyWith<_$ProductVariationImpl> get copyWith =>
      __$$ProductVariationImplCopyWithImpl<_$ProductVariationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductVariationImplToJson(this);
  }
}

abstract class _ProductVariation extends ProductVariation {
  const factory _ProductVariation({
    required final String id,
    required final String productId,
    required final String name,
    final String? sku,
    required final double mrp,
    required final double sellingPrice,
    final double? purchasePrice,
    final String? barcode,
    final bool isDefault,
    final bool isActive,
    final int displayOrder,
    final bool isForSale,
    final bool isForPurchase,
    final Map<String, double> categoryPrices,
    final Map<String, double> tablePrices,
  }) = _$ProductVariationImpl;
  const _ProductVariation._() : super._();

  factory _ProductVariation.fromJson(Map<String, dynamic> json) =
      _$ProductVariationImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get name;
  @override
  String? get sku;
  @override
  double get mrp;
  @override
  double get sellingPrice;
  @override
  double? get purchasePrice;
  @override
  String? get barcode;
  @override
  bool get isDefault;
  @override
  bool get isActive;
  @override
  int get displayOrder; // Inventory flags
  @override
  bool get isForSale;
  @override
  bool get isForPurchase; // Price category overrides
  // Map of priceCategoryId to price
  @override
  Map<String, double> get categoryPrices; // Table-specific price overrides (optional)
  // Map of tableId to price
  @override
  Map<String, double> get tablePrices;

  /// Create a copy of ProductVariation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductVariationImplCopyWith<_$ProductVariationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
