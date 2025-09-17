import 'package:freezed_annotation/freezed_annotation.dart';

part 'kot_routing_rule.freezed.dart';
part 'kot_routing_rule.g.dart';

@freezed
class KotRoutingRule with _$KotRoutingRule {
  const factory KotRoutingRule({
    required String id,
    required String productId,
    required String printerId,
    String? instruction,
    @Default(1) int copies,
    @Default(1) int priority,
    @Default(true) bool isActive,
    
    // Optional conditions
    String? orderType, // dine_in, takeaway, delivery
    String? timeRange, // breakfast, lunch, dinner
    
    // Sync fields
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _KotRoutingRule;

  factory KotRoutingRule.fromJson(Map<String, dynamic> json) => 
      _$KotRoutingRuleFromJson(json);
      
  const KotRoutingRule._();
}