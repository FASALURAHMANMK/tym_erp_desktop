import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_group.freezed.dart';
part 'customer_group.g.dart';

@freezed
class CustomerGroup with _$CustomerGroup {
  const factory CustomerGroup({
    required String id,
    required String businessId,
    required String name,
    required String code,
    String? description,
    String? color,
    @Default(0) double discountPercent,
    @Default(0) double creditLimit,
    @Default(0) int paymentTerms,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    @Default(false) bool hasUnsyncedChanges,
  }) = _CustomerGroup;

  factory CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);
}