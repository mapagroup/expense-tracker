import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Currency model ─────────────────────────────────────────────────────────

/// Represents a selectable currency in the app.
class CurrencyOption {
  final String code;
  final String symbol;
  final String name;

  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.name,
  });

  /// Human-readable label shown in the currency picker, e.g. "₹ — Indian Rupee".
  String get label => '$symbol — $name';

  // ignore: prefer_expression_function_bodies
  static const List<CurrencyOption> kAll = [
    CurrencyOption(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    CurrencyOption(code: 'USD', symbol: r'$', name: 'US Dollar'),
    CurrencyOption(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyOption(code: 'GBP', symbol: '£', name: 'British Pound Sterling'),
    CurrencyOption(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    CurrencyOption(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    CurrencyOption(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
    CurrencyOption(code: 'AUD', symbol: r'A$', name: 'Australian Dollar'),
    CurrencyOption(code: 'CAD', symbol: r'C$', name: 'Canadian Dollar'),
    CurrencyOption(code: 'CHF', symbol: 'Fr.', name: 'Swiss Franc'),
    CurrencyOption(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
    CurrencyOption(code: 'SAR', symbol: 'ر.س', name: 'Saudi Riyal'),
    CurrencyOption(code: 'SGD', symbol: r'S$', name: 'Singapore Dollar'),
    CurrencyOption(code: 'HKD', symbol: r'HK$', name: 'Hong Kong Dollar'),
    CurrencyOption(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit'),
    CurrencyOption(code: 'PHP', symbol: '₱', name: 'Philippine Peso'),
    CurrencyOption(code: 'THB', symbol: '฿', name: 'Thai Baht'),
    CurrencyOption(code: 'VND', symbol: '₫', name: 'Vietnamese Dong'),
    CurrencyOption(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
    CurrencyOption(code: 'BDT', symbol: '৳', name: 'Bangladeshi Taka'),
    CurrencyOption(code: 'PKR', symbol: '₨', name: 'Pakistani Rupee'),
    CurrencyOption(code: 'LKR', symbol: 'Rs', name: 'Sri Lankan Rupee'),
    CurrencyOption(code: 'NPR', symbol: 'रू', name: 'Nepalese Rupee'),
    CurrencyOption(code: 'BRL', symbol: r'R$', name: 'Brazilian Real'),
    CurrencyOption(code: 'MXN', symbol: r'Mex$', name: 'Mexican Peso'),
    CurrencyOption(code: 'ZAR', symbol: 'R', name: 'South African Rand'),
    CurrencyOption(code: 'TRY', symbol: '₺', name: 'Turkish Lira'),
    CurrencyOption(code: 'RUB', symbol: '₽', name: 'Russian Ruble'),
    CurrencyOption(code: 'PLN', symbol: 'zł', name: 'Polish Zloty'),
    CurrencyOption(code: 'NGN', symbol: '₦', name: 'Nigerian Naira'),
    CurrencyOption(code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling'),
    CurrencyOption(code: 'NOK', symbol: 'kr', name: 'Norwegian Krone'),
    CurrencyOption(code: 'SEK', symbol: 'kr', name: 'Swedish Krona'),
    CurrencyOption(code: 'DKK', symbol: 'kr', name: 'Danish Krone'),
    CurrencyOption(code: 'GHS', symbol: 'GH₵', name: 'Ghanaian Cedi'),
  ];

  /// Returns the [CurrencyOption] matching [code], falling back to INR.
  static CurrencyOption find(String code) =>
      kAll.firstWhere((c) => c.code == code, orElse: () => kAll.first);
}

// ── PreferencesService ─────────────────────────────────────────────────────

/// Singleton service that persists user preferences via [SharedPreferences].
///
/// Extends [ChangeNotifier] so [MainApp] and [PreferencesScreen] can rebuild
/// immediately when any preference changes.
///
/// Call [init] once in `main()` before `runApp`, then use the factory
/// constructor `PreferencesService()` everywhere else.
class PreferencesService extends ChangeNotifier {
  PreferencesService._();

  static final PreferencesService _instance = PreferencesService._();

  /// Returns the process-wide singleton.
  factory PreferencesService() => _instance;

  // ── Preference keys ────────────────────────────────────────────────────────
  static const _kThemeMode = 'pref_theme_mode';
  static const _kDecimalPlaces = 'pref_decimal_places';
  static const _kCurrencyCode = 'pref_currency_code';
  static const _kLanguageCode = 'pref_language_code';

  // ── Cached state ───────────────────────────────────────────────────────────
  late SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.light;
  int _decimalPlaces = 2;
  String _currencyCode = 'INR';
  String _languageCode = 'en';

  // ── Getters ────────────────────────────────────────────────────────────────
  ThemeMode get themeMode => _themeMode;
  int get decimalPlaces => _decimalPlaces;
  String get currencyCode => _currencyCode;
  String get languageCode => _languageCode;

  /// Convenience getter for the full [CurrencyOption] matching [currencyCode].
  CurrencyOption get currentCurrency => CurrencyOption.find(_currencyCode);

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Must be `await`-ed once in `main()` before `runApp`.
  ///
  /// Re-reading [SharedPreferences] also serves as a reset mechanism in tests:
  /// call `SharedPreferences.setMockInitialValues({})` then `init()`.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode = _decodeThemeMode(_prefs.getString(_kThemeMode));
    _decimalPlaces = _prefs.getInt(_kDecimalPlaces) ?? 2;
    _currencyCode = _prefs.getString(_kCurrencyCode) ?? 'INR';
    _languageCode = _prefs.getString(_kLanguageCode) ?? 'en';
  }

  // ── Setters ────────────────────────────────────────────────────────────────

  /// Persists [mode] and notifies listeners so the [MaterialApp] theme updates
  /// immediately.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setString(_kThemeMode, _encodeThemeMode(mode));
    notifyListeners();
  }

  /// Persists [places] (0–2) and notifies listeners.
  Future<void> setDecimalPlaces(int places) async {
    assert(places >= 0 && places <= 2);
    if (_decimalPlaces == places) return;
    _decimalPlaces = places;
    await _prefs.setInt(_kDecimalPlaces, places);
    notifyListeners();
  }

  /// Persists [code] (e.g. `'USD'`) and notifies listeners.
  Future<void> setCurrencyCode(String code) async {
    if (_currencyCode == code) return;
    _currencyCode = code;
    await _prefs.setString(_kCurrencyCode, code);
    notifyListeners();
  }

  /// Persists [code] (e.g. `'hi'`) and notifies listeners so [MainApp]
  /// updates the locale immediately.
  Future<void> setLanguageCode(String code) async {
    if (_languageCode == code) return;
    _languageCode = code;
    await _prefs.setString(_kLanguageCode, code);
    notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static ThemeMode _decodeThemeMode(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }

  static String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system: // coverage:ignore-line
        return 'system'; // coverage:ignore-line
    }
  }
}
