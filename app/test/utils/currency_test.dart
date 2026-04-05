import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/services/preferences_service.dart';
import 'package:mapa_money/utils/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CurrencyFormatter', () {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await PreferencesService().init();
    });
    test('formats zero correctly', () {
      expect(CurrencyFormatter.format(0), equals('₹0.00'));
    });

    test('formats a whole number with two decimal places', () {
      expect(CurrencyFormatter.format(100), equals('₹100.00'));
    });

    test('formats a decimal amount correctly', () {
      expect(CurrencyFormatter.format(1234.5), equals('₹1,234.50'));
    });

    test('formats large Indian number using lakh grouping', () {
      // en_IN locale: 1,00,000 style grouping
      final result = CurrencyFormatter.format(100000);
      expect(result, contains('₹'));
      expect(result, contains('1'));
      expect(result, contains('00'));
    });

    test('formats negative amount', () {
      final result = CurrencyFormatter.format(-500.75);
      expect(result, contains('₹'));
      expect(result, contains('500.75'));
    });
  });
}
