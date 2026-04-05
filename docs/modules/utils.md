# Module: Utilities (`lib/utils/`)

Three small utility files that handle cross-cutting concerns: currency formatting and platform-specific database setup.

---

## `currency.dart` — Dynamic Currency Formatter

### Purpose
A single, consistent way to format a `double` as a currency string throughout the entire app. The symbol, decimal precision, and grouping are all read from `PreferencesService` at call time, so they reflect whatever the user has chosen.

### Usage
```dart
CurrencyFormatter.format(1234.5)   // → "₹1,234.50"  (default: INR, 2 dp)
CurrencyFormatter.format(100)      // → "₹100.00"
CurrencyFormatter.format(0)        // → "₹0.00"
```

The output symbol and decimal places change automatically when the user updates those preferences — no restart needed.

### Implementation detail
Creates a `NumberFormat.currency` instance on every call using:
- `locale: 'en_US'` — Western grouping (thousands separator at every 3 digits)
- `symbol` — from `PreferencesService().currentCurrency.symbol`
- `decimalDigits` — from `PreferencesService().decimalPlaces`

The `en_US` locale is used (rather than `en_IN`) so the grouping works correctly for all currencies, not just INR with lakh/crore grouping.

### Tests
`test/utils/currency_test.dart` verifies zero, whole numbers, decimals, large numbers, and negative amounts. The test `setUp` calls `SharedPreferences.setMockInitialValues({})` + `PreferencesService().init()` to ensure default settings (INR, 2 dp) are active for every test.

---

## `db_init_desktop.dart` — Desktop SQLite Init

### Purpose
On **Windows, Linux, and macOS**, SQLite is not built into the OS. The `sqflite_common_ffi` package provides a native SQLite binary via FFI (Foreign Function Interface). This file initialises it.

```dart
void initDatabaseFactory() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

This must be called before any `openDatabase()` call. `main.dart` calls it in `main()` before `runApp()`.

### Why is this in a separate file?
If this code were compiled on Android/iOS, the app would fail at runtime because `sqflite_common_ffi` is not available on those platforms. The **conditional import** in `main.dart` ensures only the correct file is compiled for each target:

```dart
import 'utils/db_init_stub.dart'
    if (dart.library.io) 'utils/db_init_desktop.dart';
```

`dart.library.io` is only available on dart:io platforms (desktop and to some extent Android/iOS), but the full desktop check is done inside `main()`:
```dart
if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
  initDatabaseFactory();
}
```

---

## `db_init_stub.dart` — Mobile/Web No-op

### Purpose
On **Android, iOS, and Web**, `initDatabaseFactory()` does nothing. Mobile OSes ship with SQLite built in; the regular `sqflite` package handles it without any setup.

```dart
void initDatabaseFactory() {}
```

This stub file exists so the conditional import in `main.dart` always has a valid target regardless of platform. Without it, a compilation error would occur on Android.

---

## Summary: Which file runs where?

| Platform | File compiled | What it does |
|---|---|---|
| Android, iOS | `db_init_stub.dart` | Nothing — SQLite is built in |
| Windows, Linux, macOS | `db_init_desktop.dart` | Activates FFI SQLite bridge |
| Web | `db_init_stub.dart` | Nothing — SQLite not available on Web |
