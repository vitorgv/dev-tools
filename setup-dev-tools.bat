@echo off
REM Development Tools Setup Script for Windows (Batch)
REM This script must be run as Administrator

echo =========================================
echo Development Tools Setup Script (Windows)
echo =========================================
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

echo Starting installation...
echo.

REM ========================================
REM 1. Install Chocolatey
REM ========================================
echo Checking Chocolatey installation...

where choco >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Chocolatey is already installed
    choco --version
) else (
    echo Installing Chocolatey...
    echo This requires PowerShell to install...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    
    if %errorLevel% equ 0 (
        echo [OK] Chocolatey installed successfully
        REM Refresh environment
        call refreshenv
    ) else (
        echo [ERROR] Failed to install Chocolatey
    )
)

echo.

REM ========================================
REM 2. Install zip
REM ========================================
echo Checking zip installation...

where zip >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] zip is already installed
) else (
    echo Installing zip...
    choco install zip -y
    if %errorLevel% equ 0 (
        echo [OK] zip installed successfully
    ) else (
        echo [ERROR] Failed to install zip
    )
)

echo.

REM ========================================
REM 3. Install Python3
REM ========================================
echo Checking Python3 installation...

where python >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Python3 is already installed
    python --version
) else (
    echo Installing Python3...
    choco install python3 -y
    if %errorLevel% equ 0 (
        echo [OK] Python3 installed successfully
        call refreshenv
        python --version
    ) else (
        echo [ERROR] Failed to install Python3
    )
)

echo.

REM ========================================
REM 4. Install Go
REM ========================================
echo Checking Go installation...

where go >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Go is already installed
    go version
) else (
    echo Installing Go...
    choco install golang -y
    if %errorLevel% equ 0 (
        echo [OK] Go installed successfully
        call refreshenv
        go version
    ) else (
        echo [ERROR] Failed to install Go
    )
)

echo.

REM ========================================
REM 5. Install NVM for Windows
REM ========================================
echo Checking NVM for Windows installation...

where nvm >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] NVM for Windows is already installed
    nvm version
) else (
    echo Installing NVM for Windows...
    choco install nvm -y
    if %errorLevel% equ 0 (
        echo [OK] NVM for Windows installed successfully
        call refreshenv
        nvm version
    ) else (
        echo [ERROR] Failed to install NVM for Windows
    )
)

echo.

REM ========================================
REM 6. Install Node.js via NVM
REM ========================================
echo Installing Node.js LTS via NVM...

where nvm >nul 2>&1
if %errorLevel% equ 0 (
    nvm install lts
    nvm use lts
    echo [OK] Node.js LTS installed
    node --version
    npm --version
) else (
    echo [SKIP] NVM not available, skipping Node.js installation
)

echo.

REM ========================================
REM Note about SDKMAN
REM ========================================
echo =========================================
echo Note: SDKMAN (Java, Maven, Gradle)
echo =========================================
echo.
echo SDKMAN works best in Git Bash or WSL on Windows.
echo For native Windows, install Java tools via Chocolatey:
echo.
echo   choco install openjdk -y
echo   choco install maven -y
echo   choco install gradle -y
echo.
echo Or run this script in Git Bash to use SDKMAN:
echo   ./setup-dev-tools.sh
echo.

REM ========================================
REM Summary
REM ========================================
echo =========================================
echo Installation Summary
echo =========================================
echo.

where choco >nul 2>&1 && echo [OK] Chocolatey: Installed || echo [ERROR] Chocolatey: Not installed
where zip >nul 2>&1 && echo [OK] zip: Installed || echo [ERROR] zip: Not installed
where python >nul 2>&1 && echo [OK] Python3: Installed || echo [ERROR] Python3: Not installed
where go >nul 2>&1 && echo [OK] Go: Installed || echo [ERROR] Go: Not installed
where nvm >nul 2>&1 && echo [OK] NVM: Installed || echo [ERROR] NVM: Not installed
where node >nul 2>&1 && echo [OK] Node.js: Installed || echo [WARN] Node.js: Not installed

echo.
echo =========================================
echo Post-Installation Instructions
echo =========================================
echo.
echo Please restart your Command Prompt or PowerShell for changes to take effect.
echo.
echo Quick start commands:
echo   python --version          # Check Python
echo   go version                # Check Go
echo   node --version            # Check Node.js
echo   nvm list                  # List Node versions
echo.
echo Setup script completed!
echo.
pause
