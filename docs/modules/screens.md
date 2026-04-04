# Module: Screens

This app has two screens: **HomeScreen** (in `lib/main.dart`) and **AddExpenseScreen** (in `lib/screens/add_expense_screen.dart`).

---

## HomeScreen (`lib/main.dart`)

### What it does
The main screen the user sees on launch. Shows:
- A header with the selected month and total spending
- A per-category spending breakdown with percentages
- A scrollable list of expense tiles for that month
- A FAB (floating action button) to add a new expense

### Why it lives in `main.dart`
It is the only screen that exists at app startup. Keeping the entry point and home screen together reduces the number of files for a simple app. If the app grows (e.g. adds a settings screen), `HomeScreen` should be moved to `screens/home_screen.dart`.

### State management
Uses plain `StatefulWidget` + `setState`. The state consists of:
- `_expensesFuture` — the `Future` returned by `DatabaseService().getAllExpenses()`
- `_selectedMonth` — the month currently being filtered

There is no global state or state management library. When data changes (add/edit/delete), the future is simply replaced with a fresh DB query and `setState` triggers a rebuild.

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
