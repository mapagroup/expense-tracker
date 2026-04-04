# Module: Utilities (`lib/utils/`)

Three small utility files that handle cross-cutting concerns: currency formatting and platform-specific database setup.

---

## `currency.dart` — INR Formatter

### Purpose
A single, consistent way to format a `double` as an Indian Rupee string throughout the entire app.

### Usage
```dart
CurrencyFormatter.format(1234.5)   // → "₹1,234.50"
CurrencyFormatter.format(100000)   // → "₹1,00,000.00"  (Indian lakh grouping)
CurrencyFormatter.format(0)        // → "₹0.00"
```

### Implementation detail
Uses Dart's `intl` package with `locale: 'en_IN'`. The `en_IN` locale applies **Indian number grouping** (lakh/crore system):
- First separator at 3 digits from the right: `1,000`
- Subsequent separators every 2 digits: `1,00,000` (one lakh), `1,00,00,000` (one crore)

### Why a class instead of a plain function?
The `NumberFormat` object is expensive to create. Making it a `static final` field means it is created **once** and reused for every call, which is important when rendering a long list of expenses.

### Tests
`test/utils/currency_test.dart` verifies zero, whole numbers, decimals, lakh grouping, and negative amounts.

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
