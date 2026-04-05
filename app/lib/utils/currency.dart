import 'package:intl/intl.dart';
import '../services/preferences_service.dart';

/// Centralised currency formatter for the entire app.
///
/// Reads the active [CurrencyOption] and decimal-places preference from
/// [PreferencesService] on every call so the output reflects the user's
/// current settings without requiring an app restart.
///
/// Usage:
///   CurrencyFormatter.format(1234.5) → '₹1,234.50'  (default INR, 2 dp)
///   CurrencyFormatter.format(1234.5) → '$1,235'      (USD, 0 dp)
class CurrencyFormatter {
  CurrencyFormatter._(); // coverage:ignore-line

  /// Formats [amount] using the currency symbol and decimal places currently
  /// selected in [PreferencesService].
  static String format(double amount) {
    final prefs = PreferencesService();
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: prefs.currentCurrency.symbol,
      decimalDigits: prefs.decimalPlaces,
    ).format(amount);
  }
}
