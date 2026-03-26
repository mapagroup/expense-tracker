@echo off
echo Building MapaMoney APK...
echo.

cd /d "C:\MapaGroup\expense-tracker\app"

echo Checking Flutter doctor...
C:\flutter\bin\flutter.bat doctor

echo.
echo Building APK (this may take several minutes)...
C:\flutter\bin\flutter.bat build apk --release

echo.
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ APK built successfully!
    echo Location: %CD%\build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo You can now install this APK on Android devices!
) else (
    echo ❌ APK build failed. Check the errors above.
)

echo.
pause