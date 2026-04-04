# Module: Data Model (`lib/models/expense.dart`)

## Purpose

Defines the `Expense` class — the single data entity in the app. Every piece of user data is represented as an `Expense` object.

---

## The `Expense` class

```dart
class Expense {
  final int? id;          // null when not yet saved to DB (auto-assigned by SQLite)
  final String title;     // short label, e.g. "Lunch at Saravana Bhavan"
  final double amount;    // in Indian Rupees (₹); always > 0
  final DateTime date;    // the date the expense occurred
  final String category;  // one of: Food, Transport, Entertainment, Bills, Other
  final String? description; // optional longer note
}
```

### Why `id` is nullable
When creating a new expense in the UI, no ID exists yet — SQLite generates one (`AUTOINCREMENT`). The `id` is only populated after `insertExpense()` returns (or when reading from the DB).

### Why `amount` is `double` and not `int`
Indian currency uses paise (½ rupee = ₹0.50). Storing as `double` handles fractional amounts. The max allowed value is ₹9,99,999 (validated in the form).

---

## Serialisation

### `toMap()` — Dart → SQLite
Converts the object to a `Map<String, dynamic>` matching the `expenses` table columns.

```dart
// date is stored as ISO-8601 string, not a Unix timestamp.
// This makes it human-readable in the raw DB file.
'date': date.toIso8601String()   // e.g. "2025-03-15T00:00:00.000"
```

### `Expense.fromMap()` — SQLite → Dart
Factory constructor that parses a row map back into an `Expense`. Called by `DatabaseService` every time rows are read from the DB.

---

## Why a separate model file?

Keeping the data model separate from UI code means:
- The model can be tested in isolation (`test/models/expense_test.dart`)
- The same model is reused across `DatabaseService`, `HomeScreen`, and `AddExpenseScreen`
- If the data schema changes (e.g. adding a `currency` field), only this file and `database_service.dart` need to change

---

## Categories

Categories are currently **hardcoded** in `add_expense_screen.dart`. The model itself has no restriction — `category` is a plain `String`. This was intentional: if custom categories are added later, the model does not need to change.

---

## Tests

`test/models/expense_test.dart` covers:
- Construction with required and optional fields
- `toMap()` serialisation correctness
- `fromMap()` round-trip (toMap → fromMap produces equal values)
- Null handling for `id` and `description`
