# Security Practices

Mapa Money is designed with **privacy first**. All financial data stays on-device. This document explains every security decision in the codebase.

---

## Network Permissions

### No INTERNET permission
`AndroidManifest.xml` does **not** declare the `INTERNET` permission. This means the OS will block all network connections at the socket level — no data can be sent or received, even if a dependency attempts it.

```xml
<!-- No INTERNET permission declared -->
```

### Why no INTERNET?
The app is fully offline by design:
- The SQLite database is stored in the app's private directory
- The Inter font is bundled inside the `google_fonts` package assets
- There are no analytics, crash reporting, or telemetry SDKs

### `GoogleFonts.config.allowRuntimeFetching = false`
Even with no INTERNET permission, the `google_fonts` package is explicitly told not to attempt network access. This is set in `main()` before `runApp()`:

```dart
GoogleFonts.config.allowRuntimeFetching = false;
```

This means font loading will never throw a network error — it will always use the bundled assets.

---

## Android App Security

### `android:allowBackup="false"`
Set in `AndroidManifest.xml`. This prevents ADB backup (`adb backup`) from extracting the app's private data. Without this, anyone with USB access to an unlocked phone could extract all expense records.

### `android:usesCleartextTraffic="false"`
Set in `AndroidManifest.xml`. Blocks all plain HTTP connections (only HTTPS allowed). In combination with no INTERNET permission, this is defence-in-depth.

### R8 Minification + Code Shrinking
Enabled in `build.gradle.kts` for release builds:

```kotlin
isMinifyEnabled = true
isShrinkResources = true
```

Effects:
- Unused code and resources are stripped from the APK (smaller attack surface)
- Class/method names are obfuscated, making reverse engineering harder
- ProGuard rules in `proguard-rules.pro` preserve necessary Flutter entry points

---

## Database Security

### Private storage location
The SQLite database (`expense_tracker.db`) is stored in the app's private documents directory, returned by `getApplicationDocumentsDirectory()`. Other apps cannot access this path without root.

### Parameterized queries
All SQL operations use parameterized queries — **never** string concatenation. This prevents SQL injection regardless of what characters the user types.

```dart
// Safe — parameterized
await db.query('expenses', where: 'id = ?', whereArgs: [id]);

// Never done — string interpolation
// await db.rawQuery('SELECT * FROM expenses WHERE id = $id'); // ← WRONG
```

### `ConflictAlgorithm.abort`
`insertExpense` uses `ConflictAlgorithm.abort`, which throws an exception if a constraint is violated. This is safer than `ConflictAlgorithm.replace`, which would silently overwrite existing data.

---

## Input Validation

All user input in `AddExpenseScreen` is validated before it reaches the database:

| Field | Validation |
|-------|------------|
| Title | Non-empty, trimmed |
| Amount | Non-empty, valid number, > 0, ≤ 999,999 |
| Category | Selected from fixed list (no free-text) |
| Date | Picked via Flutter date picker (no manual parsing) |

The `_formKey.currentState!.validate()` call ensures all validators pass before `DatabaseService.insertExpense` or `updateExpense` is ever called.

---

## Error Messages

Internal error details (stack traces, file paths, Dart class names) are **never shown to the user**. Errors are shown as generic messages:

```dart
// ✅ Safe — generic message to UI
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Failed to save. Please try again.')),
);

// Debug details only in assert (stripped in release builds)
assert(() {
  debugPrint('Save error: $e');
  return true;
}());
```

`assert` blocks are entirely removed by the Dart compiler in release mode, so no sensitive information can appear in production builds.

---

## Dependency Security

Run `make security` to check for outdated dependencies with known vulnerabilities:

```bash
make security   # runs: flutter pub outdated --dependency-overrides --dev-dependencies
```

Keep all dependencies up to date. Prefer packages with:
- Active maintenance
- Limited permission requirements
- No analytics/telemetry

---

## Future Recommendations

These are not yet implemented but are worth considering:

| Recommendation | Priority | Notes |
|---------------|----------|-------|
| Screenshot prevention | Medium | `FLAG_SECURE` on Android to block app from appearing in recent apps/screenshots |
| Biometric lock | Low | Require fingerprint/PIN to open app |
| Root/jailbreak detection | Low | Warn user if device is rooted |
| Database encryption | Low | `sqflite_sqlcipher` for encrypted SQLite |
| Export file security | Medium | If a CSV/export feature is added, ensure it writes to a user-chosen location, not public storage |
