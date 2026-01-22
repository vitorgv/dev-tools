@echo off
REM Development Tools Uninstallation Script (Windows Batch)
REM This script must be run as Administrator

echo ========================================
echo Development Tools Uninstallation Script
echo ========================================
echo.
echo WARNING: This will remove all installed development tools!
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

REM Confirmation prompt
set /p confirm="Are you sure you want to uninstall all development tools? (yes/no): "
if /i not "%confirm%"=="yes" (
    echo Uninstallation cancelled.
    pause
    exit /b 0
)

echo.
echo Starting uninstallation...
echo.

REM ========================================
REM Uninstall Chocolatey packages
REM ========================================

where choco >nul 2>&1
if %errorLevel% equ 0 (
    echo Uninstalling Chocolatey packages...
    echo.
    
    REM Uninstall Go
    choco list --local-only | findstr /C:"golang" >nul
    if %errorLevel% equ 0 (
        echo Uninstalling Go...
        choco uninstall golang -y
    )
    
    REM Uninstall Python3
    choco list --local-only | findstr /C:"python3" >nul
    if %errorLevel% equ 0 (
        echo Uninstalling Python3...
        choco uninstall python3 -y
    )
    
    REM Uninstall zip
    choco list --local-only | findstr /C:"zip" >nul
    if %errorLevel% equ 0 (
        echo Uninstalling zip...
        choco uninstall zip -y
    )
    
    echo.
    echo [OK] Chocolatey packages uninstalled
) else (
    echo Chocolatey is not installed
)

echo.

REM ========================================
REM Remove SDKMAN directory
REM ========================================

echo Removing SDKMAN...
if exist "%USERPROFILE%\.sdkman" (
    rmdir /s /q "%USERPROFILE%\.sdkman"
    echo [OK] SDKMAN directory removed
) else (
    echo SDKMAN is not installed
)

echo.

REM ========================================
REM Remove NVM directory
REM ========================================

echo Removing NVM...
if exist "%USERPROFILE%\.nvm" (
    rmdir /s /q "%USERPROFILE%\.nvm"
    echo [OK] NVM directory removed
) else (
    echo NVM is not installed
)

echo.
echo ========================================
echo Uninstallation Summary
echo ========================================
echo.

REM Check what's still installed
where go >nul 2>&1
if %errorLevel% equ 0 (
    echo [WARN] Go: Still installed
) else (
    echo [OK] Go: Removed
)

where python >nul 2>&1
if %errorLevel% equ 0 (
    echo [WARN] Python3: Still installed
) else (
    echo [OK] Python3: Removed
)

where java >nul 2>&1
if %errorLevel% equ 0 (
    echo [WARN] Java: Still in PATH
) else (
    echo [OK] Java: Removed from PATH
)

if exist "%USERPROFILE%\.sdkman" (
    echo [WARN] SDKMAN: Still present
) else (
    echo [OK] SDKMAN: Removed
)

if exist "%USERPROFILE%\.nvm" (
    echo [WARN] NVM: Still present
) else (
    echo [OK] NVM: Removed
)

echo.
echo ========================================
echo Post-Uninstallation Instructions
echo ========================================
echo.
echo Please restart your terminal for changes to take effect.
echo.
echo To remove SDKMAN tools from Windows PATH:
echo 1. Open System Properties ^> Environment Variables
echo 2. Edit System PATH variable
echo 3. Remove entries containing: .sdkman\candidates
echo.
echo To completely remove Chocolatey (optional):
echo Run: Remove-Item C:\ProgramData\chocolatey -Recurse -Force
echo.
echo Uninstallation completed!
echo.
pause
