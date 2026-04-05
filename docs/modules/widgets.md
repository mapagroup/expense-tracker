# Module: Widgets (`lib/widgets/`)

Reusable UI components that are not tied to any specific screen.

---

## `app_drawer.dart` — Application Navigation Drawer

### Purpose
A reusable `NavigationDrawer`-backed side drawer that provides access to app-level destinations (e.g. Preferences). It is injected into `HomeScreen`'s `Scaffold.drawer`; Flutter's `Scaffold` automatically adds the hamburger `DrawerButton` to the `AppBar` when a drawer is present.

### Public API

```dart
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
}
```

### Structure

The drawer contains two sections:

**1. Header (`DrawerHeader`)**
Displays the app icon (`assets/icons/app_icon.png`, decoded at `(48 × devicePixelRatio)` physical pixels via `cacheWidth`/`cacheHeight` to avoid blurriness on high-DPI screens while keeping the displayed size at 48 logical pixels) and the app name/tagline. The background uses `AppColors.primary`; text colours derive from `Theme.of(context).colorScheme.onPrimary`.

**2. Navigation entries**
| Entry | Icon | Destination |
|---|---|---|
| Preferences | `Icons.settings_outlined` | `PreferencesScreen` |

Navigation is handled by capturing the `NavigatorState` before popping the drawer, then pushing the destination via `Future.microtask` to avoid using a deactivated context.

### Tests
`test/widgets/home_screen_drawer_test.dart` (group `AppDrawer`) tests:
- Hamburger button opens the drawer
- Drawer title and subtitle text are displayed
- Preferences tile is visible inside the drawer
- Tapping Preferences navigates to `PreferencesScreen`
- Tapping outside the drawer closes it

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
