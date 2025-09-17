// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoleTemplate _$RoleTemplateFromJson(Map<String, dynamic> json) {
  return _RoleTemplate.fromJson(json);
}

/// @nodoc
mixin _$RoleTemplate {
  String get id => throw _privateConstructorUsedError;
  String get roleCode => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  Map<String, dynamic> get permissions => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isSystemRole => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RoleTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoleTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleTemplateCopyWith<RoleTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleTemplateCopyWith<$Res> {
  factory $RoleTemplateCopyWith(
    RoleTemplate value,
    $Res Function(RoleTemplate) then,
  ) = _$RoleTemplateCopyWithImpl<$Res, RoleTemplate>;
  @useResult
  $Res call({
    String id,
    String roleCode,
    String roleName,
    Map<String, dynamic> permissions,
    String? description,
    bool isSystemRole,
    DateTime createdAt,
  });
}

/// @nodoc
class _$RoleTemplateCopyWithImpl<$Res, $Val extends RoleTemplate>
    implements $RoleTemplateCopyWith<$Res> {
  _$RoleTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roleCode = null,
    Object? roleName = null,
    Object? permissions = null,
    Object? description = freezed,
    Object? isSystemRole = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            roleCode:
                null == roleCode
                    ? _value.roleCode
                    : roleCode // ignore: cast_nullable_to_non_nullable
                        as String,
            roleName:
                null == roleName
                    ? _value.roleName
                    : roleName // ignore: cast_nullable_to_non_nullable
                        as String,
            permissions:
                null == permissions
                    ? _value.permissions
                    : permissions // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            isSystemRole:
                null == isSystemRole
                    ? _value.isSystemRole
                    : isSystemRole // ignore: cast_nullable_to_non_nullable
                        as bool,
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
abstract class _$$RoleTemplateImplCopyWith<$Res>
    implements $RoleTemplateCopyWith<$Res> {
  factory _$$RoleTemplateImplCopyWith(
    _$RoleTemplateImpl value,
    $Res Function(_$RoleTemplateImpl) then,
  ) = __$$RoleTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String roleCode,
    String roleName,
    Map<String, dynamic> permissions,
    String? description,
    bool isSystemRole,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$RoleTemplateImplCopyWithImpl<$Res>
    extends _$RoleTemplateCopyWithImpl<$Res, _$RoleTemplateImpl>
    implements _$$RoleTemplateImplCopyWith<$Res> {
  __$$RoleTemplateImplCopyWithImpl(
    _$RoleTemplateImpl _value,
    $Res Function(_$RoleTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoleTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roleCode = null,
    Object? roleName = null,
    Object? permissions = null,
    Object? description = freezed,
    Object? isSystemRole = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$RoleTemplateImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        roleCode:
            null == roleCode
                ? _value.roleCode
                : roleCode // ignore: cast_nullable_to_non_nullable
                    as String,
        roleName:
            null == roleName
                ? _value.roleName
                : roleName // ignore: cast_nullable_to_non_nullable
                    as String,
        permissions:
            null == permissions
                ? _value._permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        isSystemRole:
            null == isSystemRole
                ? _value.isSystemRole
                : isSystemRole // ignore: cast_nullable_to_non_nullable
                    as bool,
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
class _$RoleTemplateImpl extends _RoleTemplate {
  const _$RoleTemplateImpl({
    required this.id,
    required this.roleCode,
    required this.roleName,
    required final Map<String, dynamic> permissions,
    this.description,
    this.isSystemRole = true,
    required this.createdAt,
  }) : _permissions = permissions,
       super._();

  factory _$RoleTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String roleCode;
  @override
  final String roleName;
  final Map<String, dynamic> _permissions;
  @override
  Map<String, dynamic> get permissions {
    if (_permissions is EqualUnmodifiableMapView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_permissions);
  }

  @override
  final String? description;
  @override
  @JsonKey()
  final bool isSystemRole;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RoleTemplate(id: $id, roleCode: $roleCode, roleName: $roleName, permissions: $permissions, description: $description, isSystemRole: $isSystemRole, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.roleCode, roleCode) ||
                other.roleCode == roleCode) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isSystemRole, isSystemRole) ||
                other.isSystemRole == isSystemRole) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    roleCode,
    roleName,
    const DeepCollectionEquality().hash(_permissions),
    description,
    isSystemRole,
    createdAt,
  );

  /// Create a copy of RoleTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleTemplateImplCopyWith<_$RoleTemplateImpl> get copyWith =>
      __$$RoleTemplateImplCopyWithImpl<_$RoleTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleTemplateImplToJson(this);
  }
}

abstract class _RoleTemplate extends RoleTemplate {
  const factory _RoleTemplate({
    required final String id,
    required final String roleCode,
    required final String roleName,
    required final Map<String, dynamic> permissions,
    final String? description,
    final bool isSystemRole,
    required final DateTime createdAt,
  }) = _$RoleTemplateImpl;
  const _RoleTemplate._() : super._();

  factory _RoleTemplate.fromJson(Map<String, dynamic> json) =
      _$RoleTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get roleCode;
  @override
  String get roleName;
  @override
  Map<String, dynamic> get permissions;
  @override
  String? get description;
  @override
  bool get isSystemRole;
  @override
  DateTime get createdAt;

  /// Create a copy of RoleTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleTemplateImplCopyWith<_$RoleTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
