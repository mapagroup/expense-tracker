@echo off
echo Setting up Android development environment for MapaMoney APK build...
echo.

echo Step 1: Installing Android Studio...
echo Please run the installer: %TEMP%\android-studio-installer.exe
echo Follow the installation wizard and install Android SDK when prompted.
echo.
pause

echo Step 2: Setting up environment variables...
setx ANDROID_HOME "C:\Users\%USERNAME%\AppData\Local\Android\Sdk" /M
setx PATH "%PATH%;C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools;C:\Users\%USERNAME%\AppData\Local\Android\Sdk\tools\bin" /M

echo Environment variables set!
echo Please restart your command prompt and run the next script.
echo.
pause