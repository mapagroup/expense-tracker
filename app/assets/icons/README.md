# MapaMoney App Icons

## Logo Design
**MapaMoney** - Your Personal Expense Tracker

### Color Scheme:
- Primary: Blue (#1976D2)
- Accent: Green (#4CAF50) for positive money actions
- Warning: Orange (#FF9800) for expenses
- Background: White (#FFFFFF)

### Icon Concept:
- Wallet/Money bag with Indian Rupee symbol (₹)
- Modern, clean design
- Financial/banking theme

## Required Files:
- `app_icon.png` - Main app icon (512x512 recommended)
- `app_icon_foreground.png` - Foreground icon for Android adaptive icons (432x432 recommended)

## Icon Generation:
Run the following command to generate icons from the main icon:
```
flutter pub run flutter_launcher_icons
```

## Current Placeholder:
The `logo.txt` file contains an ASCII art version of the logo. Replace with actual PNG files for production.

## Icon Creation Steps:
1. Design a 512x512 PNG icon with MapaMoney branding
2. Create a foreground version (remove background for adaptive icons)
3. Place files in this directory
4. Run `flutter pub run flutter_launcher_icons`
5. Build APK to see the result