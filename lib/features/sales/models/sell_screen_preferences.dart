import 'package:freezed_annotation/freezed_annotation.dart';

part 'sell_screen_preferences.freezed.dart';
part 'sell_screen_preferences.g.dart';

enum ProductViewMode {
  @JsonValue('grid')
  grid,
  @JsonValue('list')
  list,
}

@freezed
class SellScreenPreferences with _$SellScreenPreferences {
  const factory SellScreenPreferences({
    required String id,
    required String businessId,
    required String locationId,
    @Default(true) bool showOnHoldTab,
    @Default(true) bool showSettlementTab,
    String? defaultPriceCategoryId,
    @Default(ProductViewMode.grid) ProductViewMode productViewMode,
    @Default(4) int gridColumns,
    @Default(true) bool showQuickSale,
    @Default(false) bool showAddExpense,
    @Default({}) Map<String, dynamic> settings,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _SellScreenPreferences;

  factory SellScreenPreferences.fromJson(Map<String, dynamic> json) =>
      _$SellScreenPreferencesFromJson(json);

  const SellScreenPreferences._();

  // Helper methods
  bool get isGridView => productViewMode == ProductViewMode.grid;
  bool get isListView => productViewMode == ProductViewMode.list;
  
  // Validate grid columns
  int get validatedGridColumns {
    if (gridColumns < 2) return 2;
    if (gridColumns > 8) return 8;
    return gridColumns;
  }
  
  // Check if any special tabs are enabled
  bool get hasSpecialTabs => showOnHoldTab || showSettlementTab;
  
  // Get setting value with type safety
  T? getSetting<T>(String key) {
    if (!settings.containsKey(key)) return null;
    final value = settings[key];
    if (value is T) return value;
    return null;
  }
  
  // Common settings getters
  bool get showProductImages => getSetting<bool>('showProductImages') ?? true;
  bool get showProductPrices => getSetting<bool>('showProductPrices') ?? true;
  bool get showProductStock => getSetting<bool>('showProductStock') ?? false;
  bool get showCategoryFilter => getSetting<bool>('showCategoryFilter') ?? true;
  bool get enableQuickQuantityButtons => getSetting<bool>('enableQuickQuantityButtons') ?? true;
  bool get enableBarcodeScan => getSetting<bool>('enableBarcodeScan') ?? true;
  bool get autoOpenNumpad => getSetting<bool>('autoOpenNumpad') ?? false;
  String get defaultPaymentMethod => getSetting<String>('defaultPaymentMethod') ?? 'cash';
}