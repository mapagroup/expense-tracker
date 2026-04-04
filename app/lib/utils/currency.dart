import 'package:intl/intl.dart';

/// Centralised INR currency formatter for the entire app.
///
/// Usage:
///   CurrencyFormatter.format(1234.5) → '₹1,234.50'
class CurrencyFormatter {
  CurrencyFormatter._(); // coverage:ignore-line

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Formats [amount] as an INR currency string, e.g. ₹1,234.50.
  static String format(double amount) => _formatter.format(amount);
}
