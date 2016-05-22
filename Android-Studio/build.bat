@echo OFF
java -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Java is required to download necessary Android SDK components
    echo Make sure Java is in your path: https://java.com/en/download/help/path.xml
    exit /b
)
powershell -executionpolicy bypass -File ../buildtools/build-android-studio.ps1

