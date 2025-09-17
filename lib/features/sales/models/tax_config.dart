import 'package:freezed_annotation/freezed_annotation.dart';

part 'tax_config.freezed.dart';
part 'tax_config.g.dart';

enum TaxType {
  @JsonValue('percentage')
  percentage,
  @JsonValue('fixed')
  fixed,
}

enum TaxCalculationMethod {
  @JsonValue('exclusive')
  exclusive, // Tax calculated on top of price
  @JsonValue('inclusive')
  inclusive, // Tax included in price
}

// Tax Group - contains multiple tax rates
@freezed
class TaxGroup with _$TaxGroup {
  const factory TaxGroup({
    required String id,
    required String businessId,
    required String name,
    String? description,
    @Default(false) bool isDefault,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    @Default([]) List<TaxRate> taxRates,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaxGroup;

  factory TaxGroup.fromJson(Map<String, dynamic> json) =>
      _$TaxGroupFromJson(json);
}

// Individual Tax Rate within a group
@freezed
class TaxRate with _$TaxRate {
  const factory TaxRate({
    required String id,
    required String taxGroupId,
    required String businessId,
    required String name,
    required double rate, // Percentage or fixed amount
    @Default(TaxType.percentage) TaxType type,
    @Default(TaxCalculationMethod.exclusive)
    TaxCalculationMethod calculationMethod,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    String? applyOn, // 'base_price', 'after_discount', etc.
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaxRate;

  factory TaxRate.fromJson(Map<String, dynamic> json) =>
      _$TaxRateFromJson(json);

  const TaxRate._();

  // Calculate tax amount based on the base amount
  double calculateTax(double baseAmount) {
    if (type == TaxType.percentage) {
      if (calculationMethod == TaxCalculationMethod.inclusive) {
        // Tax is included in the price, extract it
        return baseAmount * (rate / (100 + rate));
      } else {
        // Tax is exclusive, calculate on top
        return baseAmount * (rate / 100);
      }
    } else {
      // Fixed amount tax
      return rate;
    }
  }
}

// Legacy TaxConfig for backward compatibility
@freezed
class TaxConfig with _$TaxConfig {
  const factory TaxConfig({
    required String id,
    required String businessId,
    required String name,
    required double rate, // Percentage or fixed amount
    @Default(TaxType.percentage) TaxType type,
    @Default(TaxCalculationMethod.exclusive)
    TaxCalculationMethod calculationMethod,
    @Default(true) bool isActive,
    @Default(false) bool isDefault,
    String? description,
    @Default(0) int displayOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaxConfig;

  factory TaxConfig.fromJson(Map<String, dynamic> json) =>
      _$TaxConfigFromJson(json);

  const TaxConfig._();

  // Calculate tax amount based on the base amount
  double calculateTax(double baseAmount) {
    if (type == TaxType.percentage) {
      if (calculationMethod == TaxCalculationMethod.inclusive) {
        // Tax is included in the price, extract it
        return baseAmount * (rate / (100 + rate));
      } else {
        // Tax is exclusive, calculate on top
        return baseAmount * (rate / 100);
      }
    } else {
      // Fixed tax amount
      return rate;
    }
  }

  // Get the price excluding tax (for inclusive tax)
  double getPriceExcludingTax(double priceWithTax) {
    if (type == TaxType.percentage &&
        calculationMethod == TaxCalculationMethod.inclusive) {
      return priceWithTax / (1 + (rate / 100));
    }
    return priceWithTax;
  }
}

// Multiple tax configuration for complex scenarios
@freezed
class MultipleTaxConfig with _$MultipleTaxConfig {
  const factory MultipleTaxConfig({
    required List<TaxConfig> taxes,
    @Default(false) bool compoundTax, // Apply tax on tax
  }) = _MultipleTaxConfig;

  factory MultipleTaxConfig.fromJson(Map<String, dynamic> json) =>
      _$MultipleTaxConfigFromJson(json);

  const MultipleTaxConfig._();

  // Calculate total tax from multiple tax configs
  double calculateTotalTax(double baseAmount) {
    if (taxes.isEmpty) return 0;

    double totalTax = 0;
    double currentBase = baseAmount;

    for (final tax in taxes) {
      final taxAmount = tax.calculateTax(currentBase);
      totalTax += taxAmount;

      // If compound tax, add tax to base for next calculation
      if (compoundTax &&
          tax.calculationMethod == TaxCalculationMethod.exclusive) {
        currentBase += taxAmount;
      }
    }

    return totalTax;
  }

  // Get breakdown of taxes
  Map<String, double> getTaxBreakdown(double baseAmount) {
    final breakdown = <String, double>{};
    double currentBase = baseAmount;

    for (final tax in taxes) {
      final taxAmount = tax.calculateTax(currentBase);
      breakdown[tax.name] = taxAmount;

      if (compoundTax &&
          tax.calculationMethod == TaxCalculationMethod.exclusive) {
        currentBase += taxAmount;
      }
    }

    return breakdown;
  }
}
