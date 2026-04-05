# Module: Screens

This app has three screens: **HomeScreen** (in `lib/main.dart`), **AddExpenseScreen** (`lib/screens/add_expense_screen.dart`), and **PreferencesScreen** (`lib/screens/preferences_screen.dart`).

---

## HomeScreen (`lib/main.dart`)

### What it does
The main screen the user sees on launch. Shows:
- A header with the selected month and total spending
- A per-category spending breakdown with percentages
- A scrollable list of expense tiles for that month
- A FAB (floating action button) to add a new expense
- A hamburger icon (☰) in the AppBar that opens a side drawer

### Navigation
The screen exposes app-level navigation through the side drawer (`AppDrawer`). From here, the user can open `PreferencesScreen`. See [`docs/modules/widgets.md`](widgets.md) for the `AppDrawer` widget documentation.

### State management
Uses plain `StatefulWidget` + `setState`. The state consists of:
- `_allExpenses` — `List<Expense>` loaded from the database
- `_isLoading` — `bool` flag shown while the DB query is in-flight
- `_hasError` — `bool` flag set when the DB query fails; triggers an error UI instead of the expense list
- `_selectedMonth` — the month currently being filtered

There is no global state or state management library. When data changes (add/edit/delete), `_loadExpenses()` is called, which sets `_isLoading = true` and `_hasError = false`, awaits `DatabaseService().getAllExpenses()`, then calls `setState` with the fresh list (or sets `_hasError = true` on failure).

### Month filtering
Filtering is done **in-memory** after loading all expenses:

```dart
expenses.where((e) =>
  e.date.year == _selectedMonth.year &&
  e.date.month == _selectedMonth.month
).toList()
```

This avoids an extra DB query and is fast enough for typical volumes (hundreds of records). If the app ever accumulates thousands of records, this should be moved to a `WHERE` clause in the DB query.

### Category totals
`_calculateCategoryTotals()` builds a `Map<String, double>` by iterating the filtered list once. Percentages are calculated as `(categoryTotal / grandTotal * 100)`.

---

## AddExpenseScreen (`lib/screens/add_expense_screen.dart`)

### What it does
A full-screen form used for **both adding a new expense and editing an existing one**. The same screen serves both purposes to avoid duplicating form logic.

### Add vs Edit mode
The screen accepts an optional `Expense? expense` parameter:
- **`null`** → Add mode: blank form, calls `insertExpense()` on save
- **non-null** → Edit mode: form pre-filled from the expense, calls `updateExpense()` on save

```dart
class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;   // null = add, non-null = edit
  ...
}
```

### Form fields and validation

| Field | Type | Validation |
|---|---|---|
| Title | `TextFormField` | Non-empty, 2–50 characters |
| Amount | `TextFormField` (numeric) | Valid number, > 0, ≤ 9,99,999 |
| Category | `DropdownButtonFormField` | Required selection |
| Date | Date picker button | Between 2020 and today |
| Description | `TextFormField` | Optional, can be empty |

Validation runs on the `GlobalKey<FormState>` when the user taps Save. The button shows a `CircularProgressIndicator` while the DB write is in progress (`_isLoading` flag).

### Security note
Error messages shown to the user are generic — the raw exception from the DB layer is logged only in debug builds via `assert()`. This prevents internal file paths and stack traces from being visible to end users.

### Controllers
Three `TextEditingController` objects are created for the text fields and disposed in `dispose()` to prevent memory leaks:

```dart
@override
void dispose() {
  _titleController.dispose();
  _amountController.dispose();
  _descriptionController.dispose();
  super.dispose();
}
```

---

## PreferencesScreen (`lib/screens/preferences_screen.dart`)

### What it does
A full settings screen reached via the navigation drawer. Organised into three sections rendered as a `ListView`:

| Section | Tiles |
|---|---|
| **Display** | Theme, Decimal Places |
| **Regional** | Currency, Language |
| **Data Entry** | *(placeholder — no preferences yet)* |

Each tile opens a dialog to change the setting. Changes are persisted immediately via `PreferencesService` (backed by `SharedPreferences`).

### State management
`_PreferencesScreenState` holds a reference to the `PreferencesService` singleton and registers `_rebuild` as a `ChangeNotifier` listener. When any preference changes, the screen rebuilds so that tile subtitles (showing the current value) stay up to date. The listener is removed in `dispose()`.

### Theme dialog
Shows `System Default`, `Light`, and `Dark` options in a `RadioGroup<ThemeMode>`. Selecting and confirming calls `PreferencesService().setThemeMode(selected)`. Effect is immediate app-wide because `MainApp` also listens to `PreferencesService`.

### Decimal Places dialog
Shows options `0`, `1`, `2` using `RadioGroup<int>`. Each option includes an example formatted value (e.g. `1234` for 0 dp). Calls `PreferencesService().setDecimalPlaces(selected)`.

### Currency picker
`_CurrencyPickerDialog` — a private `StatefulWidget` with a search `TextField` that filters `CurrencyOption.kAll` (35 currencies) by name, symbol, or code. Confirmed selection calls `PreferencesService().setCurrencyCode(selected.code)`.

### Language dialog
Shows 9 languages (each with its native name and English name) using `RadioGroup<String>`. On confirm, calls `PreferencesService().setLanguageCode(selected)` then shows a **Restart Required** alert. Language changes take effect on the next app launch.

### Tests
`test/screens/preferences_screen_test.dart` verifies:
- AppBar shows "Preferences"
- All three section headers are rendered (uppercased)
- All four tiles are present
- Tapping Theme, Decimal Places, Currency, and Language opens the correct dialog

