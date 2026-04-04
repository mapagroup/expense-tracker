# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# SQLite / sqflite
-keep class com.tekartik.sqflite.** { *; }

# Keep the app entry point
-keep class com.mapauniverse.mapa_money.MainActivity { *; }

# Suppress notes/warnings for unused platform code
-dontnote io.flutter.**
-dontnote com.google.android.gms.**

# Flutter uses Play Core for deferred components — we don't use that feature
# but the classes are still referenced in Flutter's embedding code.
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
