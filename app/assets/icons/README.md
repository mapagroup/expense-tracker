# Mapa Money App Icons

## Brand Colors
- Primary: Deep Teal (#0F3D3E)
- Accent: Copper (#C47A2C)

## How to add your icon

1. Place your icon file here as **`app_icon.png`**
   - Minimum recommended size: **1024 × 1024 px**
   - Format: PNG with transparency supported
   - The icon will be used for both Android and iOS

2. Run the generator from the `app/` directory:
   ```
   flutter pub run flutter_launcher_icons
   ```

3. Rebuild the app — the new icon will appear on the device.

## Android adaptive icon
The adaptive icon background is pre-set to the brand teal `#0F3D3E`.
Your foreground PNG will be centred on it. Keep the main artwork inside
the central **66%** of the canvas (safe zone) so it isn't clipped on
circular/squircle launchers.

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