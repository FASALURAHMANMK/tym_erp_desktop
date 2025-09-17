import 'package:freezed_annotation/freezed_annotation.dart';

part 'charge.freezed.dart';
part 'charge.g.dart';

enum ChargeType {
  @JsonValue('service')
  service,
  @JsonValue('delivery')
  delivery,
  @JsonValue('packaging')
  packaging,
  @JsonValue('convenience')
  convenience,
  @JsonValue('custom')
  custom,
}

enum CalculationType {
  @JsonValue('fixed')
  fixed,
  @JsonValue('percentage')
  percentage,
  @JsonValue('tiered')
  tiered,
  @JsonValue('formula')
  formula,
}

enum ChargeScope {
  @JsonValue('order')
  order, // Applied to entire order
  @JsonValue('item')
  item, // Applied to specific items
  @JsonValue('category')
  category, // Applied to items in specific category
  @JsonValue('customer')
  customer, // Applied based on customer type
}

@freezed
class Charge with _$Charge {
  const factory Charge({
    required String id,
    required String businessId,
    String? locationId,

    // Basic Information
    required String code,
    required String name,
    String? description,

    // Charge Configuration
    required ChargeType chargeType,
    required CalculationType calculationType,
    double? value, // Base value for fixed/percentage
    // Application Rules
    @Default(ChargeScope.order) ChargeScope scope,
    @Default(false) bool autoApply,
    @Default(false) bool isMandatory, // Cannot be removed by user
    @Default(true) bool isTaxable, // Whether tax applies on this charge
    @Default(false) bool applyBeforeDiscount, // Apply before or after discounts
    // Conditions
    double? minimumOrderValue,
    double? maximumOrderValue,
    DateTime? validFrom,
    DateTime? validUntil,

    // Time-based rules
    @Default([]) List<String> applicableDays, // ['monday', 'tuesday', ...]
    Map<String, dynamic>? applicableTimeSlots, // [{from: "18:00", to: "22:00"}]
    // Category/Product specific
    @Default([]) List<String> applicableCategories,
    @Default([]) List<String> applicableProducts,
    @Default([]) List<String> excludedCategories,
    @Default([]) List<String> excludedProducts,

    // Customer specific
    @Default([]) List<String> applicableCustomerGroups,
    @Default([]) List<String> excludedCustomerGroups,

    // Display Configuration
    @Default(0) int displayOrder,
    @Default(true) bool showInPos,
    @Default(true) bool showInInvoice,
    @Default(true) bool showInOnline,
    String? iconName, // Material icon name
    String? colorHex, // Hex color for display
    // Tier configuration (for tiered charges)
    @Default([]) List<ChargeTier> tiers,

    // Formula configuration (for formula-based charges)
    ChargeFormula? formula,

    // Status
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
  }) = _Charge;

  factory Charge.fromJson(Map<String, dynamic> json) => _$ChargeFromJson(json);

  const Charge._();

  // Check if charge is currently valid
  bool get isValid {
    if (!isActive) return false;

    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validUntil != null && now.isAfter(validUntil!)) return false;

    // Check day of week
    if (applicableDays.isNotEmpty) {
      final currentDay = _getDayName(now.weekday);
      if (!applicableDays.contains(currentDay)) return false;
    }

    // Check time slots
    if (applicableTimeSlots != null && applicableTimeSlots!.isNotEmpty) {
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      bool inTimeSlot = false;

      for (final slot in (applicableTimeSlots!['slots'] as List? ?? [])) {
        final from = slot['from'] as String;
        final to = slot['to'] as String;
        if (_isTimeInRange(currentTime, from, to)) {
          inTimeSlot = true;
          break;
        }
      }

      if (!inTimeSlot) return false;
    }

    return true;
  }

  // Calculate charge amount based on base amount
  double calculateCharge(
    double baseAmount, {
    double? distance,
    double? weight,
    int? quantity,
    Map<String, dynamic>? customVariables,
  }) {
    if (!isValid) return 0;

    // Check minimum/maximum order value
    if (minimumOrderValue != null && baseAmount < minimumOrderValue!) {
      return 0;
    }
    if (maximumOrderValue != null && baseAmount > maximumOrderValue!) {
      return 0;
    }

    double chargeAmount = 0;

    switch (calculationType) {
      case CalculationType.fixed:
        chargeAmount = value ?? 0;
        break;

      case CalculationType.percentage:
        chargeAmount = baseAmount * ((value ?? 0) / 100);
        break;

      case CalculationType.tiered:
        chargeAmount = _calculateTieredCharge(baseAmount);
        break;

      case CalculationType.formula:
        chargeAmount = _calculateFormulaCharge(
          baseAmount,
          distance: distance,
          weight: weight,
          quantity: quantity,
          customVariables: customVariables,
        );
        break;
    }

    // Apply min/max constraints from formula if applicable
    if (formula != null) {
      if (formula!.minCharge != null && chargeAmount < formula!.minCharge!) {
        chargeAmount = formula!.minCharge!;
      }
      if (formula!.maxCharge != null && chargeAmount > formula!.maxCharge!) {
        chargeAmount = formula!.maxCharge!;
      }
    }

    return chargeAmount;
  }

  // Calculate tiered charge
  double _calculateTieredCharge(double baseAmount) {
    if (tiers.isEmpty) return 0;

    // Find applicable tier
    ChargeTier? applicableTier;
    for (final tier in tiers) {
      if (baseAmount >= tier.minValue &&
          (tier.maxValue == null || baseAmount <= tier.maxValue!)) {
        applicableTier = tier;
        break;
      }
    }

    return applicableTier?.chargeValue ?? 0;
  }

  // Calculate formula-based charge
  double _calculateFormulaCharge(
    double baseAmount, {
    double? distance,
    double? weight,
    int? quantity,
    Map<String, dynamic>? customVariables,
  }) {
    if (formula == null) return 0;

    double chargeAmount = formula!.baseAmount ?? 0;

    // Apply variable rate based on type
    if (formula!.variableRate != null && formula!.variableRate! > 0) {
      switch (formula!.variableType) {
        case 'distance':
          if (distance != null) {
            chargeAmount += distance * formula!.variableRate!;
          }
          break;
        case 'weight':
          if (weight != null) {
            chargeAmount += weight * formula!.variableRate!;
          }
          break;
        case 'quantity':
          if (quantity != null) {
            chargeAmount += quantity * formula!.variableRate!;
          }
          break;
        case 'percentage':
          chargeAmount += baseAmount * (formula!.variableRate! / 100);
          break;
        default:
          // Custom formula evaluation would go here
          break;
      }
    }

    return chargeAmount;
  }

  // Check if charge is applicable to specific conditions
  bool isApplicable({
    String? categoryId,
    String? productId,
    String? customerGroupId,
    double? orderValue,
  }) {
    if (!isValid) return false;

    // Check order value constraints
    if (orderValue != null) {
      if (minimumOrderValue != null && orderValue < minimumOrderValue!) {
        return false;
      }
      if (maximumOrderValue != null && orderValue > maximumOrderValue!) {
        return false;
      }
    }

    // Check category applicability
    if (categoryId != null) {
      if (excludedCategories.contains(categoryId)) return false;
      if (applicableCategories.isNotEmpty &&
          !applicableCategories.contains(categoryId))
        return false;
    }

    // Check product applicability
    if (productId != null) {
      if (excludedProducts.contains(productId)) return false;
      if (applicableProducts.isNotEmpty &&
          !applicableProducts.contains(productId))
        return false;
    }

    // Check customer group applicability
    if (customerGroupId != null) {
      if (excludedCustomerGroups.contains(customerGroupId)) return false;
      if (applicableCustomerGroups.isNotEmpty &&
          !applicableCustomerGroups.contains(customerGroupId))
        return false;
    }

    return true;
  }

  // Helper function to get day name
  String _getDayName(int weekday) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[weekday - 1];
  }

  // Helper function to check if time is in range
  bool _isTimeInRange(String current, String from, String to) {
    final currentMinutes = _timeToMinutes(current);
    final fromMinutes = _timeToMinutes(from);
    final toMinutes = _timeToMinutes(to);

    if (toMinutes < fromMinutes) {
      // Range spans midnight
      return currentMinutes >= fromMinutes || currentMinutes <= toMinutes;
    } else {
      return currentMinutes >= fromMinutes && currentMinutes <= toMinutes;
    }
  }

  // Convert time string to minutes
  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

@freezed
class ChargeTier with _$ChargeTier {
  const factory ChargeTier({
    required String id,
    required String chargeId,
    String? tierName,
    required double minValue,
    double? maxValue, // null means no upper limit
    required double chargeValue, // Amount or percentage for this tier
    @Default(0) int displayOrder,
    required DateTime createdAt,
  }) = _ChargeTier;

  factory ChargeTier.fromJson(Map<String, dynamic> json) =>
      _$ChargeTierFromJson(json);
}

@freezed
class ChargeFormula with _$ChargeFormula {
  const factory ChargeFormula({
    required String id,
    required String chargeId,
    @Default(0) double baseAmount, // Fixed base amount
    @Default(0) double variableRate, // Per unit rate
    String? variableType, // 'distance', 'weight', 'quantity', 'percentage'
    double? minCharge, // Minimum charge amount
    double? maxCharge, // Maximum charge amount
    String? formulaExpression, // For complex calculations
    Map<String, dynamic>? customVariables, // Additional variables
    required DateTime createdAt,
  }) = _ChargeFormula;

  factory ChargeFormula.fromJson(Map<String, dynamic> json) =>
      _$ChargeFormulaFromJson(json);
}

@freezed
class AppliedCharge with _$AppliedCharge {
  const factory AppliedCharge({
    required String id,
    required String orderId,
    String? chargeId,

    // Charge details snapshot
    required String chargeCode,
    required String chargeName,
    required String chargeType,
    required String calculationType,

    // Calculation details
    double? baseAmount, // Amount on which charge is calculated
    double? chargeRate, // Percentage or per-unit rate used
    required double chargeAmount, // Final charge amount
    // Tax calculation
    @Default(true) bool isTaxable,
    @Default(0) double taxAmount,

    // Manual override
    @Default(false) bool isManual,
    double? originalAmount, // Original amount before manual adjustment
    String? adjustmentReason,

    // Metadata
    String? addedBy,
    String? removedBy,
    @Default(false) bool isRemoved,
    DateTime? removedAt,
    String? notes,

    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AppliedCharge;

  factory AppliedCharge.fromJson(Map<String, dynamic> json) =>
      _$AppliedChargeFromJson(json);

  const AppliedCharge._();

  // Total amount including tax
  double get totalAmount => chargeAmount + taxAmount;

  // Check if charge was adjusted
  bool get wasAdjusted =>
      originalAmount != null && originalAmount != chargeAmount;
}

@freezed
class CustomerChargeExemption with _$CustomerChargeExemption {
  const factory CustomerChargeExemption({
    required String id,
    required String customerId,
    required String chargeId,
    required String businessId,

    required String exemptionType, // 'full', 'partial', 'percentage'
    double? exemptionValue, // Amount or percentage

    String? reason,
    DateTime? validFrom,
    DateTime? validUntil,

    @Default(true) bool isActive,
    String? approvedBy,
    DateTime? approvedAt,

    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CustomerChargeExemption;

  factory CustomerChargeExemption.fromJson(Map<String, dynamic> json) =>
      _$CustomerChargeExemptionFromJson(json);

  const CustomerChargeExemption._();

  // Check if exemption is currently valid
  bool get isValid {
    if (!isActive) return false;

    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validUntil != null && now.isAfter(validUntil!)) return false;

    return true;
  }

  // Calculate exempted amount
  double calculateExemption(double chargeAmount) {
    if (!isValid) return 0;

    switch (exemptionType) {
      case 'full':
        return chargeAmount;
      case 'partial':
        return exemptionValue ?? 0;
      case 'percentage':
        return chargeAmount * ((exemptionValue ?? 0) / 100);
      default:
        return 0;
    }
  }
}
