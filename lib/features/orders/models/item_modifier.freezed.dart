// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_modifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ItemModifier _$ItemModifierFromJson(Map<String, dynamic> json) {
  return _ItemModifier.fromJson(json);
}

/// @nodoc
mixin _$ItemModifier {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get groupName =>
      throw _privateConstructorUsedError; // e.g., "Size", "Add-ons", "Toppings"
  bool get isRequired => throw _privateConstructorUsedError;

  /// Serializes this ItemModifier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemModifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemModifierCopyWith<ItemModifier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemModifierCopyWith<$Res> {
  factory $ItemModifierCopyWith(
    ItemModifier value,
    $Res Function(ItemModifier) then,
  ) = _$ItemModifierCopyWithImpl<$Res, ItemModifier>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    int quantity,
    String? groupName,
    bool isRequired,
  });
}

/// @nodoc
class _$ItemModifierCopyWithImpl<$Res, $Val extends ItemModifier>
    implements $ItemModifierCopyWith<$Res> {
  _$ItemModifierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemModifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? groupName = freezed,
    Object? isRequired = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            quantity:
                null == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int,
            groupName:
                freezed == groupName
                    ? _value.groupName
                    : groupName // ignore: cast_nullable_to_non_nullable
                        as String?,
            isRequired:
                null == isRequired
                    ? _value.isRequired
                    : isRequired // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemModifierImplCopyWith<$Res>
    implements $ItemModifierCopyWith<$Res> {
  factory _$$ItemModifierImplCopyWith(
    _$ItemModifierImpl value,
    $Res Function(_$ItemModifierImpl) then,
  ) = __$$ItemModifierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    int quantity,
    String? groupName,
    bool isRequired,
  });
}

/// @nodoc
class __$$ItemModifierImplCopyWithImpl<$Res>
    extends _$ItemModifierCopyWithImpl<$Res, _$ItemModifierImpl>
    implements _$$ItemModifierImplCopyWith<$Res> {
  __$$ItemModifierImplCopyWithImpl(
    _$ItemModifierImpl _value,
    $Res Function(_$ItemModifierImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemModifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? groupName = freezed,
    Object? isRequired = null,
  }) {
    return _then(
      _$ItemModifierImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        quantity:
            null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int,
        groupName:
            freezed == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                    as String?,
        isRequired:
            null == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemModifierImpl extends _ItemModifier {
  const _$ItemModifierImpl({
    required this.id,
    required this.name,
    this.price = 0,
    this.quantity = 1,
    this.groupName,
    this.isRequired = false,
  }) : super._();

  factory _$ItemModifierImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemModifierImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final int quantity;
  @override
  final String? groupName;
  // e.g., "Size", "Add-ons", "Toppings"
  @override
  @JsonKey()
  final bool isRequired;

  @override
  String toString() {
    return 'ItemModifier(id: $id, name: $name, price: $price, quantity: $quantity, groupName: $groupName, isRequired: $isRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemModifierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    quantity,
    groupName,
    isRequired,
  );

  /// Create a copy of ItemModifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemModifierImplCopyWith<_$ItemModifierImpl> get copyWith =>
      __$$ItemModifierImplCopyWithImpl<_$ItemModifierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemModifierImplToJson(this);
  }
}

abstract class _ItemModifier extends ItemModifier {
  const factory _ItemModifier({
    required final String id,
    required final String name,
    final double price,
    final int quantity,
    final String? groupName,
    final bool isRequired,
  }) = _$ItemModifierImpl;
  const _ItemModifier._() : super._();

  factory _ItemModifier.fromJson(Map<String, dynamic> json) =
      _$ItemModifierImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  int get quantity;
  @override
  String? get groupName; // e.g., "Size", "Add-ons", "Toppings"
  @override
  bool get isRequired;

  /// Create a copy of ItemModifier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemModifierImplCopyWith<_$ItemModifierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
