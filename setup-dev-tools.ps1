# Development Tools Setup Script for Windows (PowerShell)
# This script must be run as Administrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Development Tools Setup Script (Windows)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
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

Write-Host "Starting installation..." -ForegroundColor Green
Write-Host ""

# ========================================
# 1. Install Chocolatey
# ========================================
Write-Host "Checking Chocolatey installation..." -ForegroundColor Yellow

if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Chocolatey is already installed" -ForegroundColor Green
    choco --version
} else {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "[OK] Chocolatey installed successfully" -ForegroundColor Green
        # Refresh environment
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } else {
        Write-Host "[ERROR] Failed to install Chocolatey" -ForegroundColor Red
    }
}

Write-Host ""

# ========================================
# 2. Install zip
# ========================================
Write-Host "Checking zip installation..." -ForegroundColor Yellow

if (Get-Command zip -ErrorAction SilentlyContinue) {
    Write-Host "[OK] zip is already installed" -ForegroundColor Green
} else {
    Write-Host "Installing zip..." -ForegroundColor Yellow
    choco install zip -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] zip installed successfully" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Failed to install zip" -ForegroundColor Red
    }
}

Write-Host ""

# ========================================
# 3. Install Python3
# ========================================
Write-Host "Checking Python3 installation..." -ForegroundColor Yellow

if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Python3 is already installed" -ForegroundColor Green
    python --version
} else {
    Write-Host "Installing Python3..." -ForegroundColor Yellow
    choco install python3 -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Python3 installed successfully" -ForegroundColor Green
        # Refresh environment
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        python --version
    } else {
        Write-Host "[ERROR] Failed to install Python3" -ForegroundColor Red
    }
}

Write-Host ""

# ========================================
# 4. Install Go
# ========================================
Write-Host "Checking Go installation..." -ForegroundColor Yellow

if (Get-Command go -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Go is already installed" -ForegroundColor Green
    go version
} else {
    Write-Host "Installing Go..." -ForegroundColor Yellow
    choco install golang -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Go installed successfully" -ForegroundColor Green
        # Refresh environment
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        go version
    } else {
        Write-Host "[ERROR] Failed to install Go" -ForegroundColor Red
    }
}

Write-Host ""

# ========================================
# 5. Install NVM for Windows
# ========================================
Write-Host "Checking NVM for Windows installation..." -ForegroundColor Yellow

if (Get-Command nvm -ErrorAction SilentlyContinue) {
    Write-Host "[OK] NVM for Windows is already installed" -ForegroundColor Green
    nvm version
} else {
    Write-Host "Installing NVM for Windows..." -ForegroundColor Yellow
    choco install nvm -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] NVM for Windows installed successfully" -ForegroundColor Green
        # Refresh environment
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        nvm version
    } else {
        Write-Host "[ERROR] Failed to install NVM for Windows" -ForegroundColor Red
    }
}

Write-Host ""

# ========================================
# 6. Install Node.js via NVM
# ========================================
Write-Host "Installing Node.js LTS via NVM..." -ForegroundColor Yellow

if (Get-Command nvm -ErrorAction SilentlyContinue) {
    nvm install lts
    nvm use lts
    Write-Host "[OK] Node.js LTS installed" -ForegroundColor Green
    if (Get-Command node -ErrorAction SilentlyContinue) {
        node --version
        npm --version
    }
} else {
    Write-Host "[SKIP] NVM not available, skipping Node.js installation" -ForegroundColor Gray
}

Write-Host ""

# ========================================
# Note about SDKMAN
# ========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Note: SDKMAN (Java, Maven, Gradle)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "SDKMAN works best in Git Bash or WSL on Windows." -ForegroundColor Yellow
Write-Host "For native Windows, install Java tools via Chocolatey:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  choco install openjdk -y" -ForegroundColor Gray
Write-Host "  choco install maven -y" -ForegroundColor Gray
Write-Host "  choco install gradle -y" -ForegroundColor Gray
Write-Host ""
Write-Host "Or run setup-dev-tools.sh in Git Bash to use SDKMAN." -ForegroundColor Yellow
Write-Host "Then run this script again to add SDKMAN tools to Windows PATH." -ForegroundColor Yellow
Write-Host ""

# ========================================
# Configure Windows PATH for SDKMAN tools
# ========================================
$sdkmanCandidates = "$env:USERPROFILE\.sdkman\candidates"

if (Test-Path $sdkmanCandidates) {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "Configuring Windows PATH for SDKMAN tools" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
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
            if ($script:currentPath -notlike "*$newPath*") {
                Write-Host "Adding $toolName to PATH..." -ForegroundColor Yellow
                $script:currentPath = "$script:currentPath;$newPath"
                [Environment]::SetEnvironmentVariable("Path", $script:currentPath, "Machine")
                Write-Host "[OK] $toolName added to PATH" -ForegroundColor Green
            } else {
                Write-Host "[SKIP] $toolName already in PATH" -ForegroundColor Cyan
            }
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
}

# ========================================
# Summary
# ========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Installation Summary" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Chocolatey: Installed" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Chocolatey: Not installed" -ForegroundColor Red
}

if (Get-Command zip -ErrorAction SilentlyContinue) {
    Write-Host "[OK] zip: Installed" -ForegroundColor Green
} else {
    Write-Host "[ERROR] zip: Not installed" -ForegroundColor Red
}

if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Python3: Installed" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Python3: Not installed" -ForegroundColor Red
}

if (Get-Command go -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Go: Installed" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Go: Not installed" -ForegroundColor Red
}

if (Get-Command nvm -ErrorAction SilentlyContinue) {
    Write-Host "[OK] NVM: Installed" -ForegroundColor Green
} else {
    Write-Host "[ERROR] NVM: Not installed" -ForegroundColor Red
}

if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Node.js: Installed" -ForegroundColor Green
} else {
    Write-Host "[WARN] Node.js: Not installed" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Post-Installation Instructions" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please restart your PowerShell or Command Prompt for changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "Quick start commands:" -ForegroundColor Yellow
Write-Host "  python --version          # Check Python" -ForegroundColor Gray
Write-Host "  go version                # Check Go" -ForegroundColor Gray
Write-Host "  node --version            # Check Node.js" -ForegroundColor Gray
Write-Host "  nvm list                  # List Node versions" -ForegroundColor Gray
Write-Host ""
Write-Host "Setup script completed!" -ForegroundColor Green
Write-Host ""
pause
