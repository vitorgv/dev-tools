# Development Tools Uninstallation Script (PowerShell)
# This script must be run as Administrator

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Development Tools Uninstallation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This will remove all installed development tools!" -ForegroundColor Red
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

# Confirmation prompt
$confirm = Read-Host "Are you sure you want to uninstall all development tools? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Uninstallation cancelled." -ForegroundColor Yellow
    pause
    exit 0
}

Write-Host ""
Write-Host "Starting uninstallation..." -ForegroundColor Green
Write-Host ""

# ========================================
# Uninstall Chocolatey packages
# ========================================

Write-Host "Uninstalling Chocolatey packages..." -ForegroundColor Yellow
Write-Host ""

if (Get-Command choco -ErrorAction SilentlyContinue) {
    # Uninstall Go
    $goInstalled = choco list --local-only | Select-String "golang"
    if ($goInstalled) {
        Write-Host "Uninstalling Go..." -ForegroundColor Yellow
        choco uninstall golang -y
        Write-Host "[OK] Go uninstalled" -ForegroundColor Green
    }
    
    # Uninstall Python3
    $pythonInstalled = choco list --local-only | Select-String "python3"
    if ($pythonInstalled) {
        Write-Host "Uninstalling Python3..." -ForegroundColor Yellow
        choco uninstall python3 -y
        Write-Host "[OK] Python3 uninstalled" -ForegroundColor Green
    }
    
    # Uninstall zip
    $zipInstalled = choco list --local-only | Select-String "^zip "
    if ($zipInstalled) {
        Write-Host "Uninstalling zip..." -ForegroundColor Yellow
        choco uninstall zip -y
        Write-Host "[OK] zip uninstalled" -ForegroundColor Green
    }
} else {
    Write-Host "Chocolatey is not installed" -ForegroundColor Gray
}

Write-Host ""

# ========================================
# Remove SDKMAN directory
# ========================================

Write-Host "Removing SDKMAN..." -ForegroundColor Yellow
$sdkmanPath = "$env:USERPROFILE\.sdkman"

if (Test-Path $sdkmanPath) {
    Remove-Item $sdkmanPath -Recurse -Force
    Write-Host "[OK] SDKMAN directory removed" -ForegroundColor Green
} else {
    Write-Host "SDKMAN is not installed" -ForegroundColor Gray
}

Write-Host ""

# ========================================
# Remove NVM directory
# ========================================

Write-Host "Removing NVM..." -ForegroundColor Yellow
$nvmPath = "$env:USERPROFILE\.nvm"

if (Test-Path $nvmPath) {
    Remove-Item $nvmPath -Recurse -Force
    Write-Host "[OK] NVM directory removed" -ForegroundColor Green
} else {
    Write-Host "NVM is not installed" -ForegroundColor Gray
}

Write-Host ""

# ========================================
# Clean up PATH environment variable
# ========================================

Write-Host "Cleaning up system PATH..." -ForegroundColor Yellow
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

# Remove SDKMAN paths
$pathsToRemove = @(
    "*\.sdkman\candidates\*"
)

$newPath = $currentPath
$pathChanged = $false

foreach ($pattern in $pathsToRemove) {
    $paths = $currentPath -split ";" | Where-Object { $_ -like $pattern }
    foreach ($path in $paths) {
        $newPath = $newPath -replace [regex]::Escape($path), ""
        $pathChanged = $true
    }
}

# Clean up extra semicolons
$newPath = $newPath -replace ";;+", ";"
$newPath = $newPath.Trim(";")

if ($pathChanged) {
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "[OK] System PATH cleaned" -ForegroundColor Green
} else {
    Write-Host "No PATH cleanup needed" -ForegroundColor Gray
}

Write-Host ""

# ========================================
# Summary
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Uninstallation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check what's still installed
if (Get-Command go -ErrorAction SilentlyContinue) {
    Write-Host "[WARN] Go: Still installed" -ForegroundColor Yellow
} else {
    Write-Host "[OK] Go: Removed" -ForegroundColor Green
}

if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "[WARN] Python3: Still installed" -ForegroundColor Yellow
} else {
    Write-Host "[OK] Python3: Removed" -ForegroundColor Green
}

if (Get-Command java -ErrorAction SilentlyContinue) {
    Write-Host "[WARN] Java: Still in PATH" -ForegroundColor Yellow
} else {
    Write-Host "[OK] Java: Removed from PATH" -ForegroundColor Green
}

if (Test-Path "$env:USERPROFILE\.sdkman") {
    Write-Host "[WARN] SDKMAN: Still present" -ForegroundColor Yellow
} else {
    Write-Host "[OK] SDKMAN: Removed" -ForegroundColor Green
}

if (Test-Path "$env:USERPROFILE\.nvm") {
    Write-Host "[WARN] NVM: Still present" -ForegroundColor Yellow
} else {
    Write-Host "[OK] NVM: Removed" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Post-Uninstallation Instructions" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please restart your terminal for changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "To completely remove Chocolatey (optional):" -ForegroundColor Yellow
Write-Host "  Remove-Item C:\ProgramData\chocolatey -Recurse -Force" -ForegroundColor Gray
Write-Host ""
Write-Host "Uninstallation completed!" -ForegroundColor Green
Write-Host ""
pause
