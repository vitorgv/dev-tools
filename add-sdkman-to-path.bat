@echo off
REM Add SDKMAN Java to Windows PATH
REM This script must be run as Administrator

echo ========================================
echo Adding SDKMAN to Windows PATH
echo ========================================
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Error: This script requires Administrator privileges
    echo Please right-click and select "Run as Administrator"
    echo.
    pause
    exit /b 1
)

REM Add SDKMAN candidates to PATH
set SDKMAN_CANDIDATES=%USERPROFILE%\.sdkman\candidates

REM Check if SDKMAN is installed
if not exist "%SDKMAN_CANDIDATES%" (
    echo Error: SDKMAN directory not found at %SDKMAN_CANDIDATES%
    echo Please install SDKMAN first by running install-dev-tools.sh
    echo.
    pause
    exit /b 1
)

echo Adding SDKMAN directories to system PATH...
echo.

REM Get current PATH
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set CURRENT_PATH=%%b

REM Add Java if installed
if exist "%SDKMAN_CANDIDATES%\java\current\bin" (
    echo Adding Java to PATH...
    setx /M PATH "%CURRENT_PATH%;%SDKMAN_CANDIDATES%\java\current\bin" >nul
    echo [OK] Java added to PATH
)

REM Add Maven if installed
if exist "%SDKMAN_CANDIDATES%\maven\current\bin" (
    echo Adding Maven to PATH...
    for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set CURRENT_PATH=%%b
    setx /M PATH "%CURRENT_PATH%;%SDKMAN_CANDIDATES%\maven\current\bin" >nul
    echo [OK] Maven added to PATH
)

REM Add Gradle if installed
if exist "%SDKMAN_CANDIDATES%\gradle\current\bin" (
    echo Adding Gradle to PATH...
    for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set CURRENT_PATH=%%b
    setx /M PATH "%CURRENT_PATH%;%SDKMAN_CANDIDATES%\gradle\current\bin" >nul
    echo [OK] Gradle added to PATH
)

echo.
echo ========================================
echo SDKMAN tools added to Windows PATH
echo ========================================
echo.
echo Installed tools are now available in CMD/PowerShell:
where python >nul 2>&1 && echo   - python --version
where go >nul 2>&1 && echo   - go version
if exist "%SDKMAN_CANDIDATES%\java\current\bin" echo   - java -version
if exist "%SDKMAN_CANDIDATES%\maven\current\bin" echo   - mvn --version
if exist "%SDKMAN_CANDIDATES%\gradle\current\bin" echo   - gradle --version
echo.
echo Please restart your terminal or Command Prompt for changes to take effect.
echo.
pause
