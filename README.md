# Mapa Money

A personal expense tracking app built with Flutter. Track, categorise, and analyse your daily spending — all stored locally on your device.

## Features

- Add, edit, and delete expense records
- Categories: Food, Transport, Entertainment, Bills, Other
- Filter expenses by month and year
- Category totals and spending percentages
- All amounts in Indian Rupees (₹)
- Works on Android, iOS, Windows, Linux, macOS, and Web

## Project Structure

```
├── app/                  # Flutter application source
│   ├── lib/              # Dart source code
│   │   ├── main.dart     # App entry point & Home screen
│   │   ├── models/       # Data models (Expense)
│   │   ├── screens/      # UI screens (Add/Edit expense)
│   │   ├── services/     # Database service (SQLite)
│   │   ├── theme/        # App colours and theme
│   │   ├── utils/        # Currency formatter, DB init helpers
│   │   └── widgets/      # Reusable widgets (MonthYearPicker)
│   ├── test/             # Unit and widget tests
│   ├── android/          # Android platform files
│   ├── ios/              # iOS platform files
│   └── assets/           # App icons
├── distribution/         # Play Store release notes
└── .github/              # CI/CD workflows (lint, test, deploy)
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, 3.x)
- Android Studio or Xcode (for mobile targets)

### Run the app

```bash
cd app
flutter pub get
flutter run
```

### Run tests

```bash
cd app
flutter test
```

### Build a release APK

```bash
cd app
flutter build apk --release
# Output: app/build/app/outputs/flutter-apk/app-release.apk
```

### App icon setup

See [app/assets/icons/README.md](app/assets/icons/README.md) for instructions on updating the app icon.

## CI/CD

| Workflow | Trigger | What it does |
|---|---|---|
| `ci.yml` | Push / PR to `main`, `develop` | Lint, format check, unit tests |
| `release-please.yml` | Push to `main` | Auto-creates GitHub releases and builds AAB |
| `play-store.yml` | GitHub Release published | Uploads signed AAB to Google Play |

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Database | SQLite via `sqflite` + `sqflite_common_ffi` |
| Fonts | Google Fonts (Inter) |
| Formatting | `intl` (INR / `en_IN` locale) |
| Release automation | release-please, GitHub Actions |