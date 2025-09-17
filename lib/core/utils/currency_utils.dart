import 'package:intl/intl.dart';

class CurrencyUtils {
  // Default to INR; fallback gracefully if Intl fails
  static String format(double amount, {String symbol = '₹', int decimalDigits = 2}) {
    try {
      final fmt = NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits);
      return fmt.format(amount);
    } catch (_) {
      // Fallback simple formatting
      return '$symbol${amount.toStringAsFixed(decimalDigits)}';
    }
  }
}

