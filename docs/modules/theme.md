# Module: Theme (`lib/theme/app_theme.dart`)

## Purpose

Centralises every visual design decision in one place. No colours, fonts, or spacing values are hardcoded anywhere else in the codebase — widgets import from this file.

---

## Brand Colours (`AppColors`)

```dart
// Core brand
primary       = #0F3D3E   // Deep teal — app bar, buttons, accents
primaryDark   = #0A2B2C   // Darker teal — pressed states
accent        = #C47A2C   // Copper — secondary highlights

// Backgrounds
background    = #F8FAFA   // Off-white scaffold background
surface       = #FFFFFF   // White for cards

// Financial indicators
expense       = #E76F51   // Red-orange — used for amounts and error states
savings       = #2A9D8F   // Teal-green — positive/savings indicator
neutral       = #6B7280   // Cool grey — secondary text

// Category colours (shown in the pie/summary breakdown)
categoryFood          = #F4A261   // Warm orange
categoryTransport     = #2A9D8F   // Teal
categoryEntertainment = #C47A2C   // Copper
categoryBills         = #E76F51   // Red-orange
categoryOther         = #6B7280   // Grey
```

### `AppColors.categoryColor(String category)`
A static helper method that returns the correct colour for a given category string. Used by both the category summary and the expense list tiles.

---

## Typography

The app uses **Inter** from the `google_fonts` package. Inter is a highly legible, neutral sans-serif — well-suited for numbers and financial data.

Font fetching is **disabled at runtime** (`GoogleFonts.config.allowRuntimeFetching = false` in `main.dart`). The font files are bundled inside the `google_fonts` package, so no internet connection is needed.

Fallback: `'Noto Sans Tamil'` is specified as the font family fallback to support Tamil script in the app bar title. Noto Sans Tamil is available as a system font on most Indian Android devices.

---

## `AppTheme.light()`

Returns a fully configured `ThemeData` using Material 3. Key properties set:

| Theme property | Value |
|---|---|
| `useMaterial3` | `true` |
| `scaffoldBackgroundColor` | `AppColors.background` |
| `colorScheme.primary` | `AppColors.primary` |
| `colorScheme.secondary` | `AppColors.accent` |
| `colorScheme.error` | `AppColors.expense` |
| `appBarTheme.backgroundColor` | `AppColors.primary` |
| `cardTheme.shape` | 16 dp rounded rectangle |
| `elevatedButtonTheme` | Primary teal, white text, 12 dp radius |

---

## Why a single theme file?

Keeping all values in one place means:
- A brand colour change only requires editing `AppColors` — not hunting through 10 files
- Dark mode can be added later by adding `AppTheme.dark()` alongside `light()`
- Designers and developers share a single source of truth

---

## Adding a Dark Theme

1. Add a `dark()` static method to `AppTheme` mirroring `light()` but with dark equivalents:
   ```dart
   static ThemeData dark() { ... }
   ```
2. In `main.dart`, set both themes:
   ```dart
   theme: AppTheme.light(),
   darkTheme: AppTheme.dark(),
   themeMode: ThemeMode.system,
   ```
