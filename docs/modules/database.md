# Module: Database Service (`lib/services/database_service.dart`)

## Purpose

`DatabaseService` is the single point of contact between the Flutter UI and the local SQLite database. All reads and writes go through this class.

---

## Singleton pattern

```dart
static final DatabaseService _instance = DatabaseService._internal();
factory DatabaseService() => _instance;
```

The class uses the Dart factory constructor + static field pattern to ensure only **one instance** is ever created. This is important because opening multiple `Database` objects to the same file can cause write conflicts and lock errors on some Android versions.

---

## Lazy database initialisation

```dart
static Database? _database;

Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _initDatabase();
  return _database!;
}
```

The database is not opened at app startup — it is opened on the **first access**. `WidgetsFlutterBinding.ensureInitialized()` in `main()` guarantees Flutter's platform channels are ready before any DB call is made.

---

## Database location

```dart
final documentsDirectory = await getApplicationDocumentsDirectory();
final path = join(documentsDirectory.path, 'expense_tracker.db');
```

The `.db` file is stored in the app's private documents directory:
- **Android**: `/data/data/com.mapauniverse.mapa_money/app_flutter/`
- **iOS**: `~/Documents/`
- **Windows**: `C:\Users\<user>\Documents\`

This directory is **private to the app** and not accessible by other apps (unless the device is rooted).

---

## `expenses` table schema

```sql
CREATE TABLE expenses (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  title       TEXT    NOT NULL,
  amount      REAL    NOT NULL,
  date        TEXT    NOT NULL,    -- ISO-8601 string
  category    TEXT    NOT NULL,
  description TEXT                 -- nullable
)
```

`AUTOINCREMENT` ensures IDs are never reused after a delete, which prevents accidental data confusion.

---

## CRUD operations

| Method | SQL | Notes |
|---|---|---|
| `insertExpense(expense)` | `INSERT` | Uses `ConflictAlgorithm.abort` — raises an error instead of silently overwriting |
| `getAllExpenses()` | `SELECT * ORDER BY date DESC` | Returns newest first |
| `getExpensesByCategory(category)` | `SELECT WHERE category = ?` | Uses parameterised query (prevents SQL injection) |
| `updateExpense(expense)` | `UPDATE WHERE id = ?` | ID must be non-null |
| `deleteExpense(id)` | `DELETE WHERE id = ?` | ID is the SQLite AUTOINCREMENT primary key |

### Why parameterised queries?
All `where` clauses use `whereArgs: [value]` instead of string interpolation. This prevents **SQL injection** — even though all data comes from the local UI, it is best practice and required for security audits.

**Safe (used here):**
```dart
db.query('expenses', where: 'category = ?', whereArgs: [category])
```

**Unsafe (never do this):**
```dart
db.rawQuery("SELECT * FROM expenses WHERE category = '$category'")
```

---

## Desktop platform SQLite

On Android and iOS, SQLite is built into the OS. On Windows, Linux, and macOS it is not. `sqflite_common_ffi` provides a native SQLite library via FFI (Foreign Function Interface). The `db_init_desktop.dart` / `db_init_stub.dart` conditional import pattern in `main.dart` handles this transparently.

---

## Future migration strategy

Currently the database is at version 1 with no migration logic. When a schema change is needed:

```dart
return await openDatabase(
  path,
  version: 2,          // bump version
  onCreate: _createDatabase,
  onUpgrade: (db, oldVersion, newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE expenses ADD COLUMN currency TEXT DEFAULT "INR"');
    }
  },
);
```
