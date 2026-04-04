# GitHub Copilot Instructions — Mapa Money

This is a **Flutter offline expense tracker** app by **MaPa Universe**.  
All financial data stays on-device. Privacy is a first-class design requirement.

---

## Project Identity

- **App name**: Mapa Money
- **Package name**: `mapa_money`
- **Application ID**: `com.mapauniverse.mapa_money`
- **Entry point**: `app/lib/main.dart`
- **Platform**: Android (primary), iOS, desktop (secondary)

---

## Architecture

```
lib/
  main.dart          ← App entry, MainApp, HomeScreen (StatefulWidget)
  models/
    expense.dart     ← Expense data class (id, title, amount, category, date)
  services/
    database_service.dart ← Singleton SQLite CRUD service
  screens/
    add_expense_screen.dart ← Add / Edit form (dual-mode)
  theme/
    app_theme.dart   ← AppColors constants + AppTheme.light() Material 3 theme
  utils/
    currency.dart    ← CurrencyFormatter.format(double) → "₹1,234.50"
    db_init_desktop.dart / db_init_stub.dart ← conditional import for FFI SQLite
  widgets/
    month_year_picker.dart ← Custom month+year dialog
```

There is **no state management library** (no Provider, Riverpod, Bloc). All state is held in `StatefulWidget` using `setState`.

---

## Coding Rules

### Theming
- **Never hardcode hex colours**. Use `AppColors.*` from `lib/theme/app_theme.dart` or `Theme.of(context).colorScheme.*`.
- **Always use `CurrencyFormatter.format(amount)`** for displaying monetary values — never format amounts manually.
- Fonts: use `GoogleFonts.inter()` or `GoogleFonts.interTextTheme()`. Never set `GoogleFonts.config.allowRuntimeFetching = true`.

### Database
- Always use **parameterized queries** with `whereArgs`. Never use string interpolation in SQL.
  ```dart
  // ✅ Correct
  db.query('expenses', where: 'id = ?', whereArgs: [id]);
  // ❌ Wrong — SQL injection risk
  db.rawQuery('SELECT * FROM expenses WHERE id = $id');
  ```
- When adding columns: bump `_dbVersion` and add an `onUpgrade` migration using `ALTER TABLE ... ADD COLUMN`. Never drop or recreate the table in an upgrade.
- Use `ConflictAlgorithm.abort` (not `replace`) on inserts to avoid silent data overwrites.

### Error Handling
- **Never show raw exception text to users**. Use generic messages like `'Failed to save. Please try again.'`.
- For debug logging, use `assert()` blocks (stripped in release builds):
  ```dart
  assert(() {
    debugPrint('Error: $e');
    return true;
  }());
  ```

### Network & Privacy
- The app has **no INTERNET permission** and must stay that way.
- Do not add any network calls, analytics, crash reporting, or telemetry.
- Do not add packages that require the INTERNET permission.
- Font fetching is disabled: `GoogleFonts.config.allowRuntimeFetching = false` (set at startup).

### Categories
Categories are a hardcoded `List<String>` in `add_expense_screen.dart`. To add a category, append to that list. No database migration needed.

### Navigation
When a screen modifies data, return `true` via `Navigator.pop(context, true)` and reload in the caller with `if (changed == true) _loadExpenses()`.

### Controllers
All `TextEditingController` instances must be disposed in `dispose()`.

---

## Testing

- Mirror `lib/` structure in `test/`:  
  `lib/models/expense.dart` → `test/models/expense_test.dart`
- Every new feature must include unit tests (models, utils) and widget tests (screens, widgets).
- Run tests: `make test` or `cd app && flutter test`
- Run analysis: `make lint` or `cd app && flutter analyze --fatal-infos`
- Run format check: `make format` or `cd app && dart format --set-exit-if-changed .`

---

## Build & Release

- **APK (split by ABI)**: `make apk-split` → outputs per-architecture APKs (~15–20 MB each)
- **APK (universal)**: `make apk`
- **App Bundle**: `make aab`
- Release is automated via `.github/workflows/release-please.yml` — it builds split APKs + AAB and attaches them to the GitHub Release.

---

## Documentation

When adding or changing features, update the relevant doc in `docs/`:

| Change | Doc to update |
|--------|--------------|
| Model field | `docs/modules/data-model.md` |
| DB schema | `docs/modules/database.md` |
| New screen | `docs/modules/screens.md` |
| New widget | `docs/modules/widgets.md` |
| Security | `docs/security.md` |
| New feature guide | `docs/adding-features.md` |

---

## What NOT to do

- Do not add `INTERNET` or any other dangerous Android permission.
- Do not introduce a state management library without discussion.
- Do not store expenses in shared preferences or plain files — use `DatabaseService`.
- Do not catch exceptions silently — either handle them or rethrow.
- Do not use `dynamic` types for database maps; cast explicitly with `as`.
- Do not add cloud sync, export-to-cloud, or any remote storage.
