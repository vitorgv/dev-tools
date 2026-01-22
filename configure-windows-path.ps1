# Configure Windows PATH for Development Tools
# This script must be run as Administrator

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configure Windows PATH for Development Tools" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: This script requires Administrator privileges" -ForegroundColor Red
    Write-Host "Please right-click and select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

# Define SDKMAN candidates directory
$sdkmanCandidates = "$env:USERPROFILE\.sdkman\candidates"

# Check if SDKMAN is installed
if (-not (Test-Path $sdkmanCandidates)) {
    Write-Host "Error: SDKMAN directory not found at $sdkmanCandidates" -ForegroundColor Red
    Write-Host "Please install SDKMAN first by running install-dev-tools.sh" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host "Adding SDKMAN directories to system PATH..." -ForegroundColor Green
Write-Host ""

# Get current system PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

# Function to add path if not already present
function Add-ToPath {
    param (
        [string]$newPath,
        [string]$toolName
    )
    
    if (Test-Path $newPath) {
        if ($currentPath -notlike "*$newPath*") {
            Write-Host "Adding $toolName to PATH..." -ForegroundColor Yellow
            $script:currentPath = "$currentPath;$newPath"
            [Environment]::SetEnvironmentVariable("Path", $currentPath, "Machine")
            Write-Host "[OK] $toolName added to PATH" -ForegroundColor Green
        } else {
            Write-Host "[SKIP] $toolName already in PATH" -ForegroundColor Cyan
        }
    } else {
        Write-Host "[SKIP] $toolName not installed" -ForegroundColor Gray
    }
}

# Add Java
Add-ToPath "$sdkmanCandidates\java\current\bin" "Java"

# Add Maven
Add-ToPath "$sdkmanCandidates\maven\current\bin" "Maven"

# Add Gradle
Add-ToPath "$sdkmanCandidates\gradle\current\bin" "Gradle"

# Add Kotlin
Add-ToPath "$sdkmanCandidates\kotlin\current\bin" "Kotlin"

# Add Groovy
Add-ToPath "$sdkmanCandidates\groovy\current\bin" "Groovy"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SDKMAN tools added to Windows PATH" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed tools are now available in CMD/PowerShell:" -ForegroundColor Yellow

if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "  - python --version" -ForegroundColor Green
}
if (Get-Command go -ErrorAction SilentlyContinue) {
    Write-Host "  - go version" -ForegroundColor Green
}
if (Test-Path "$sdkmanCandidates\java\current\bin") {
    Write-Host "  - java -version" -ForegroundColor Green
}
if (Test-Path "$sdkmanCandidates\maven\current\bin") {
    Write-Host "  - mvn --version" -ForegroundColor Green
}
if (Test-Path "$sdkmanCandidates\gradle\current\bin") {
    Write-Host "  - gradle --version" -ForegroundColor Green
}

Write-Host ""
Write-Host "Please restart your terminal or Command Prompt for changes to take effect." -ForegroundColor Yellow
Write-Host ""
pause
