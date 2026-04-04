# Mapa Money — Architecture Overview

## What is this app?

Mapa Money is a **personal expense tracker** for Android (with desktop and web support). It is fully offline — all data is stored locally on the device in a SQLite database. No data is ever sent to a server.

---

## High-level Architecture

```
┌─────────────────────────────────────────┐
│               Flutter UI                │
│  ┌──────────────┐   ┌─────────────────┐ │
│  │  HomeScreen  │   │ AddExpenseScreen │ │
│  │ (main.dart)  │   │  (screens/)     │ │
│  └──────┬───────┘   └────────┬────────┘ │
│         │                    │           │
│         └────────┬───────────┘           │
│                  │                       │
│         ┌────────▼────────┐              │
│         │ DatabaseService │              │
│         │  (services/)    │              │
│         └────────┬────────┘              │
│                  │                       │
│         ┌────────▼────────┐              │
│         │  SQLite (.db)   │  ← device    │
│         └─────────────────┘    storage  │
└─────────────────────────────────────────┘
```

The architecture is intentionally simple: **no state management library, no networking, no external services**. Data flows from the SQLite database through `DatabaseService` to the UI widgets.

---

## Data Flow

### Loading expenses (Home screen)
1. `HomeScreen.initState()` calls `DatabaseService().getAllExpenses()`
2. The `Future<List<Expense>>` is assigned to `_expensesFuture`
3. `FutureBuilder` in `build()` shows a loading spinner, then renders the list
4. `_filterExpensesByMonth()` filters in-memory (no second DB query needed)
5. `_calculateCategoryTotals()` aggregates totals in-memory

### Adding / editing an expense
1. User taps FAB (add) or long-presses a row (edit)
2. `AddExpenseScreen` opens with an optional `Expense` object pre-filled
3. On submit, `DatabaseService().insertExpense()` or `updateExpense()` is called
4. On success, `Navigator.pop(context, true)` returns to Home
5. Home receives `result == true` and calls `setState(() { _loadExpenses(); })`

### Deleting an expense
1. User swipes a list tile (or taps delete)
2. A confirmation `AlertDialog` is shown
3. On confirm, `DatabaseService().deleteExpense(id)` is called
4. Home refreshes via `setState`

---

## Directory Structure

```
app/
├── lib/
│   ├── main.dart              Entry point, app root widget, HomeScreen
│   ├── models/
│   │   └── expense.dart       Expense data model + DB serialisation
│   ├── screens/
│   │   └── add_expense_screen.dart   Add/Edit expense form
│   ├── services/
│   │   └── database_service.dart     SQLite CRUD operations (singleton)
│   ├── theme/
│   │   └── app_theme.dart     Colours, typography, Material 3 theme
│   ├── utils/
│   │   ├── currency.dart      INR formatter (₹1,234.50)
│   │   ├── db_init_desktop.dart   SQLite FFI init for Windows/Linux/macOS
│   │   └── db_init_stub.dart      No-op stub for Android/iOS/Web
│   └── widgets/
│       └── month_year_picker.dart  Custom month+year picker dialog
├── test/                      Unit and widget tests (mirrors lib/ structure)
├── android/                   Android platform shell (Gradle, Manifest)
├── ios/                       iOS platform shell (Xcode project)
└── assets/icons/              App icon source (app_icon.png)
```

---

## Key Design Decisions

| Decision | Reason |
|---|---|
| No state management library | App state is simple (one list, one filter). `setState` + `FutureBuilder` is sufficient and reduces dependencies. |
| Singleton `DatabaseService` | Prevents multiple database connections being opened simultaneously. |
| Conditional import for DB init | Android/iOS have SQLite built in; desktop needs the FFI bridge. The conditional import pattern keeps the code clean and cross-platform without `if (Platform…)` scattered everywhere. |
| All data stays on device | Privacy-first: no user accounts, no cloud sync, no analytics. |
| `GoogleFonts.config.allowRuntimeFetching = false` | Enforces offline font loading. Fonts are bundled inside the `google_fonts` package — no INTERNET permission required. |
| ABI split APKs | Reduces download size from ~60 MB to ~15 MB by shipping only the native code for the target CPU architecture. |
| R8 minification enabled | Further reduces APK size and obfuscates the bytecode. |

---

## Platform Support

| Platform | Status | Notes |
|---|---|---|
| Android | ✅ Primary target | Tested on API 36 (Android 16) emulator |
| iOS | ✅ Supported | Not actively tested — no signing cert configured |
| Windows | ✅ Supported | Uses `sqflite_common_ffi` for SQLite |
| Linux | ✅ Supported | Uses `sqflite_common_ffi` for SQLite |
| macOS | ✅ Supported | Uses `sqflite_common_ffi` for SQLite |
| Web | ⚠️ Partial | SQLite not supported on Web; requires separate implementation |

---

## Adding a New Feature

See [adding-features.md](adding-features.md) for a step-by-step guide.
