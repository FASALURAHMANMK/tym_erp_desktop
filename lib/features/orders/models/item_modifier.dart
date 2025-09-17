import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_modifier.freezed.dart';
part 'item_modifier.g.dart';

@freezed
class ItemModifier with _$ItemModifier {
  const factory ItemModifier({
    required String id,
    required String name,
    @Default(0) double price,
    @Default(1) int quantity,
    String? groupName, // e.g., "Size", "Add-ons", "Toppings"
    @Default(false) bool isRequired,
  }) = _ItemModifier;

  factory ItemModifier.fromJson(Map<String, dynamic> json) => 
      _$ItemModifierFromJson(json);
  
  const ItemModifier._();
  
  // Get total price for this modifier
  double get totalPrice => price * quantity;
  
  // Get display text
  String get displayText {
    if (quantity > 1) {
      return '$name x$quantity';
    }
    return name;
  }
  
  // Get display text with price
  String get displayTextWithPrice {
    if (price > 0) {
      return '$displayText (+₹${price.toStringAsFixed(2)})';
    }
    return displayText;
  }
}