# Adding New Features

This guide walks through the common patterns for extending Mapa Money. Follow these steps to keep the codebase consistent.

---

## Table of Contents
1. [Adding a new expense category](#1-adding-a-new-expense-category)
2. [Adding a new screen](#2-adding-a-new-screen)
3. [Adding a new field to Expense](#3-adding-a-new-field-to-expense)
4. [Adding a widget](#4-adding-a-widget)
5. [Writing tests](#5-writing-tests)
6. [Updating documentation](#6-updating-documentation)

---

## 1. Adding a new expense category

Categories are a hardcoded list in `lib/screens/add_expense_screen.dart`:

```dart
static const List<String> _categories = [
  'Food', 'Transport', 'Entertainment', 'Shopping',
  'Bills', 'Health', 'Education', 'Other',
];
```

To add a new category:
1. Add the string to `_categories` in alphabetical order (or end of list).
2. The category dropdown and pie chart will automatically include it — no other changes needed.
3. Update `docs/modules/screens.md` to document the new category.

> **Note**: Category data is stored as a plain string in the database — no migration is needed when adding new categories. Existing records keep their existing category string.

---

## 2. Adding a new screen

### Step 1: Create the screen file
```
lib/screens/my_new_screen.dart
```

Follow the existing pattern:

```dart
import 'package:flutter/material.dart';

class MyNewScreen extends StatefulWidget {
  const MyNewScreen({super.key});

  @override
  State<MyNewScreen> createState() => _MyNewScreenState();
}

class _MyNewScreenState extends State<MyNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: ...,
    );
  }
}
```

### Step 2: Navigate to it
From `HomeScreen` (in `main.dart`) or any other screen:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const MyNewScreen()),
);
```

If the new screen can modify data (add/edit/delete), return `true` on success and refresh in the caller:

```dart
// In the caller:
final changed = await Navigator.push<bool>(...);
if (changed == true) _loadExpenses();

// In the new screen on success:
if (context.mounted) Navigator.pop(context, true);
```

### Step 3: Apply theming
- Use `Theme.of(context).colorScheme.*` for colours — never hardcode hex values.
- For predefined colours, use `AppColors` from `lib/theme/app_theme.dart`.
- Use `CurrencyFormatter.format(amount)` for any monetary display.

---

## 3. Adding a new field to Expense

This requires changes to the model, the database, and the UI.

### Step 1: Update the model (`lib/models/expense.dart`)

```dart
class Expense {
  final int? id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? notes;   // ← new optional field

  const Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,          // ← new
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'notes': notes,      // ← new
  };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'] as int?,
    title: map['title'] as String,
    amount: (map['amount'] as num).toDouble(),
    category: map['category'] as String,
    date: DateTime.parse(map['date'] as String),
    notes: map['notes'] as String?,  // ← new
  );
}
```

### Step 2: Write a database migration (`lib/services/database_service.dart`)

**Bump the version number** and add an `onUpgrade` handler:

```dart
static const int _dbVersion = 2;   // ← was 1

// Inside _initDatabase():
database: await openDatabase(
  path,
  version: _dbVersion,
  onCreate: _createTables,
  onUpgrade: _onUpgrade,   // ← add this
),

// New method:
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE expenses ADD COLUMN notes TEXT');
  }
}
```

> The `ALTER TABLE ... ADD COLUMN` approach preserves existing data. Never `DROP TABLE` in an upgrade.

### Step 3: Update the form (`lib/screens/add_expense_screen.dart`)

Add a `TextEditingController`, a form field, and include the new value when calling `insertExpense`/`updateExpense`.

Remember to **dispose** the controller:
```dart
@override
void dispose() {
  _notesController.dispose();
  super.dispose();
}
```

### Step 4: Update tests

- `test/models/expense_test.dart` — add test for `toMap`/`fromMap` round-trip with the new field
- `test/widgets/...` — if you added a form field, test its validation

---

## 4. Adding a widget

Create the file under `lib/widgets/`:

```dart
// lib/widgets/my_widget.dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final String label;
  const MyWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}
```

Write a corresponding test in `test/widgets/my_widget_test.dart`.

---

## 5. Writing tests

Tests live in `test/` and mirror the `lib/` structure:

```
lib/models/expense.dart          → test/models/expense_test.dart
lib/utils/currency.dart          → test/utils/currency_test.dart
lib/widgets/month_year_picker.dart → test/widgets/month_year_picker_test.dart
```

Run all tests:
```bash
make test
# or: cd app && flutter test
```

### Model tests
Test `toMap()` / `fromMap()` round-trips and edge cases (null id, boundary amounts):

```dart
test('toMap does not include id when null', () {
  final e = Expense(title: 'T', amount: 1.0, category: 'Food', date: DateTime(2025));
  expect(e.toMap().containsKey('id'), isFalse);
});
```

### Widget tests
Use `pumpWidget` with `MaterialApp` as wrapper:

```dart
testWidgets('shows label', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: MyWidget(label: 'Hello'))),
  );
  expect(find.text('Hello'), findsOneWidget);
});
```

---

## 6. Updating documentation

After implementing a feature, update the relevant docs:

| Change | Update |
|--------|--------|
| New model field | `docs/modules/data-model.md` |
| DB schema change | `docs/modules/database.md` (schema table + migration section) |
| New screen | `docs/modules/screens.md` |
| New widget | `docs/modules/widgets.md` |
| New category | `docs/modules/screens.md` (category list) |
| Security-relevant change | `docs/security.md` |
| Architecture change | `docs/architecture.md` |

Keep the docs close to the code — a stale doc is worse than no doc.
