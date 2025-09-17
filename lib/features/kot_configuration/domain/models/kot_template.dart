import 'package:freezed_annotation/freezed_annotation.dart';

part 'kot_template.freezed.dart';
part 'kot_template.g.dart';

@freezed
class KotTemplate with _$KotTemplate {
  const factory KotTemplate({
    required String id,
    required String businessId,
    required String locationId,
    required String name,
    required String type, // header, footer, item_format
    required String content, // template content with placeholders
    required bool isActive,
    required bool isDefault,
    String? description,
    Map<String, dynamic>? settings, // font size, alignment, etc.
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _KotTemplate;

  factory KotTemplate.fromJson(Map<String, dynamic> json) =>
      _$KotTemplateFromJson(json);
}