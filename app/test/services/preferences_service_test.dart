import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  group('PreferencesService defaults', () {
    test('themeMode defaults to light', () {
      expect(PreferencesService().themeMode, equals(ThemeMode.light));
    });

    test('decimalPlaces defaults to 2', () {
      expect(PreferencesService().decimalPlaces, equals(2));
    });

    test('currencyCode defaults to INR', () {
      expect(PreferencesService().currencyCode, equals('INR'));
    });

    test('languageCode defaults to en', () {
      expect(PreferencesService().languageCode, equals('en'));
    });

    test('currentCurrency resolves to INR option', () {
      final c = PreferencesService().currentCurrency;
      expect(c.code, equals('INR'));
      expect(c.symbol, equals('₹'));
    });
  });

  group('PreferencesService setThemeMode', () {
    test('persists light theme mode', () async {
      await PreferencesService().setThemeMode(ThemeMode.light);
      expect(PreferencesService().themeMode, equals(ThemeMode.light));

      // Reload to verify persistence.
      await PreferencesService().init();
      expect(PreferencesService().themeMode, equals(ThemeMode.light));
    });

    test('persists dark theme mode', () async {
      await PreferencesService().setThemeMode(ThemeMode.dark);
      expect(PreferencesService().themeMode, equals(ThemeMode.dark));
    });

    test('no-ops when setting the same value', () async {
      int notifyCount = 0;
      PreferencesService().addListener(() => notifyCount++);
      // Default is light; setting light again should be a no-op.
      await PreferencesService().setThemeMode(ThemeMode.light);
      expect(notifyCount, equals(0));
      PreferencesService().removeListener(() {});
    });

    test('notifies listeners on change', () async {
      bool notified = false;
      void listener() => notified = true;
      PreferencesService().addListener(listener);
      await PreferencesService().setThemeMode(ThemeMode.dark);
      expect(notified, isTrue);
      PreferencesService().removeListener(listener);
    });
  });

  group('PreferencesService setDecimalPlaces', () {
    test('persists 0 decimal places', () async {
      await PreferencesService().setDecimalPlaces(0);
      expect(PreferencesService().decimalPlaces, equals(0));
    });

    test('persists 1 decimal place', () async {
      await PreferencesService().setDecimalPlaces(1);
      expect(PreferencesService().decimalPlaces, equals(1));
    });

    test('persists 2 decimal places', () async {
      await PreferencesService().setDecimalPlaces(2);
      expect(PreferencesService().decimalPlaces, equals(2));
    });

    test('notifies listeners on change', () async {
      bool notified = false;
      void listener() => notified = true;
      PreferencesService().addListener(listener);
      await PreferencesService().setDecimalPlaces(0);
      expect(notified, isTrue);
      PreferencesService().removeListener(listener);
    });
  });

  group('PreferencesService setCurrencyCode', () {
    test('persists USD code', () async {
      await PreferencesService().setCurrencyCode('USD');
      expect(PreferencesService().currencyCode, equals('USD'));
      expect(PreferencesService().currentCurrency.symbol, equals(r'$'));
    });

    test('persists EUR code', () async {
      await PreferencesService().setCurrencyCode('EUR');
      expect(PreferencesService().currencyCode, equals('EUR'));
    });

    test('falls back to INR for unknown code', () async {
      await PreferencesService().setCurrencyCode('XYZ');
      expect(PreferencesService().currentCurrency.code, equals('INR'));
    });

    test('notifies listeners on change', () async {
      bool notified = false;
      void listener() => notified = true;
      PreferencesService().addListener(listener);
      await PreferencesService().setCurrencyCode('GBP');
      expect(notified, isTrue);
      PreferencesService().removeListener(listener);
    });
  });

  group('PreferencesService setLanguageCode', () {
    test('persists language code', () async {
      await PreferencesService().setLanguageCode('hi');
      expect(PreferencesService().languageCode, equals('hi'));
    });

    test('notifies listeners on change', () async {
      bool notified = false;
      void listener() => notified = true;
      PreferencesService().addListener(listener);
      await PreferencesService().setLanguageCode('fr');
      expect(notified, isTrue);
      PreferencesService().removeListener(listener);
    });
  });

  group('CurrencyOption', () {
    test('kAll has at least 20 entries', () {
      expect(CurrencyOption.kAll.length, greaterThanOrEqualTo(20));
    });

    test('find returns INR by default for unknown code', () {
      final c = CurrencyOption.find('UNKNOWN');
      expect(c.code, equals('INR'));
    });

    test('find returns matching currency', () {
      final c = CurrencyOption.find('EUR');
      expect(c.symbol, equals('€'));
      expect(c.name, equals('Euro'));
    });

    test('label concatenates symbol and name', () {
      final c = CurrencyOption.find('INR');
      expect(c.label, equals('₹ — Indian Rupee'));
    });
  });
}
