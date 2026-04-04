# Module: Widgets (`lib/widgets/`)

Reusable UI components that are not tied to any specific screen.

---

## `month_year_picker.dart` — Month & Year Picker Dialog

### Purpose
A custom dialog that lets the user select a **month and year** (not a specific date). Flutter's built-in `showDatePicker` returns a full date — this widget returns only `DateTime(year, month, 1)`, which is what month filtering needs.

### Public API

```dart
Future<DateTime?> showMonthYearPicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,        // defaults to DateTime(2020)
  DateTime? lastDate,         // defaults to DateTime.now()
})
```

Returns `null` if the user cancels (taps outside the dialog or presses Cancel). Returns the first day of the selected month on confirm.

### How it works

The dialog has two parts:

**1. Year navigation row**
```
[◀]  2025  [▶]
```
`◀` and `▶` buttons increment/decrement the year. Buttons are disabled when at the boundary (`firstDate.year` or `lastDate.year`).

When the year changes, if the currently selected month becomes invalid (e.g. you're in December 2024 and move to 2025 where only Jan–March is within `lastDate`), the month is automatically clamped to the nearest allowed value.

**2. Month grid**
12 abbreviated month name buttons in a 4×3 grid. Months outside the `[firstDate, lastDate]` range are shown as disabled (greyed out, not tappable) using `_isMonthAllowed(month)`.

### Why not use Flutter's built-in pickers?
Flutter's `showDatePicker` forces the user to pick a full date (day + month + year). For expense filtering, the day is irrelevant — showing a full calendar adds unnecessary cognitive load. The custom widget shows only what's needed.

### State
The dialog is its own `StatefulWidget` (`_MonthYearPickerDialog`) to keep year/month selection state local. It does not interact with the app's data layer.

### Tests
`test/widgets/month_year_picker_test.dart` tests:
- Dialog opens and shows title text
- Initial year and month are displayed correctly
- Month abbreviations are all shown
- Selecting a month and confirming returns the correct `DateTime`
- Cancel returns `null`
- Boundary months are disabled correctly
