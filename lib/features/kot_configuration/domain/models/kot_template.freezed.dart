// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kot_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KotTemplate _$KotTemplateFromJson(Map<String, dynamic> json) {
  return _KotTemplate.fromJson(json);
}

/// @nodoc
mixin _$KotTemplate {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // header, footer, item_format
  String get content =>
      throw _privateConstructorUsedError; // template content with placeholders
  bool get isActive => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings =>
      throw _privateConstructorUsedError; // font size, alignment, etc.
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this KotTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KotTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KotTemplateCopyWith<KotTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KotTemplateCopyWith<$Res> {
  factory $KotTemplateCopyWith(
    KotTemplate value,
    $Res Function(KotTemplate) then,
  ) = _$KotTemplateCopyWithImpl<$Res, KotTemplate>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    String type,
    String content,
    bool isActive,
    bool isDefault,
    String? description,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$KotTemplateCopyWithImpl<$Res, $Val extends KotTemplate>
    implements $KotTemplateCopyWith<$Res> {
  _$KotTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KotTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? type = null,
    Object? content = null,
    Object? isActive = null,
    Object? isDefault = null,
    Object? description = freezed,
    Object? settings = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String,
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
            settings:
                freezed == settings
                    ? _value.settings
                    : settings // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$KotTemplateImplCopyWith<$Res>
    implements $KotTemplateCopyWith<$Res> {
  factory _$$KotTemplateImplCopyWith(
    _$KotTemplateImpl value,
    $Res Function(_$KotTemplateImpl) then,
  ) = __$$KotTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    String type,
    String content,
    bool isActive,
    bool isDefault,
    String? description,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$KotTemplateImplCopyWithImpl<$Res>
    extends _$KotTemplateCopyWithImpl<$Res, _$KotTemplateImpl>
    implements _$$KotTemplateImplCopyWith<$Res> {
  __$$KotTemplateImplCopyWithImpl(
    _$KotTemplateImpl _value,
    $Res Function(_$KotTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KotTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? type = null,
    Object? content = null,
    Object? isActive = null,
    Object? isDefault = null,
    Object? description = freezed,
    Object? settings = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$KotTemplateImpl(
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
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
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
        settings:
            freezed == settings
                ? _value._settings
                : settings // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
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
class _$KotTemplateImpl implements _KotTemplate {
  const _$KotTemplateImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.name,
    required this.type,
    required this.content,
    required this.isActive,
    required this.isDefault,
    this.description,
    final Map<String, dynamic>? settings,
    this.createdAt,
    this.updatedAt,
    this.hasUnsyncedChanges = false,
  }) : _settings = settings;

  factory _$KotTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$KotTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String name;
  @override
  final String type;
  // header, footer, item_format
  @override
  final String content;
  // template content with placeholders
  @override
  final bool isActive;
  @override
  final bool isDefault;
  @override
  final String? description;
  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // font size, alignment, etc.
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'KotTemplate(id: $id, businessId: $businessId, locationId: $locationId, name: $name, type: $type, content: $content, isActive: $isActive, isDefault: $isDefault, description: $description, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KotTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
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
    name,
    type,
    content,
    isActive,
    isDefault,
    description,
    const DeepCollectionEquality().hash(_settings),
    createdAt,
    updatedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of KotTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KotTemplateImplCopyWith<_$KotTemplateImpl> get copyWith =>
      __$$KotTemplateImplCopyWithImpl<_$KotTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KotTemplateImplToJson(this);
  }
}

abstract class _KotTemplate implements KotTemplate {
  const factory _KotTemplate({
    required final String id,
    required final String businessId,
    required final String locationId,
    required final String name,
    required final String type,
    required final String content,
    required final bool isActive,
    required final bool isDefault,
    final String? description,
    final Map<String, dynamic>? settings,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final bool hasUnsyncedChanges,
  }) = _$KotTemplateImpl;

  factory _KotTemplate.fromJson(Map<String, dynamic> json) =
      _$KotTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get name;
  @override
  String get type; // header, footer, item_format
  @override
  String get content; // template content with placeholders
  @override
  bool get isActive;
  @override
  bool get isDefault;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get settings; // font size, alignment, etc.
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of KotTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KotTemplateImplCopyWith<_$KotTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
