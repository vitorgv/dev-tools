#!/bin/bash

# Development Tools Installation Script
# Installs: Chocolatey, zip, SDKMAN, and NVM

set -e  # Exit on error

echo "========================================="
echo "Development Tools Installation Script"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

# ========================================
# 1. Install Chocolatey
# ========================================
echo ""
print_info "Checking Chocolatey installation..."

if command -v choco &> /dev/null; then
    print_success "Chocolatey is already installed ($(choco --version))"
else
    print_info "Installing Chocolatey..."
    print_error "Chocolatey requires Administrator privileges to install."
    print_info "Please run this script in an elevated PowerShell/Command Prompt, or install manually:"
    echo "   Run in PowerShell (as Admin):"
    echo "   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    echo ""
    print_info "Skipping Chocolatey installation for now..."
fi

# ========================================
# 2. Install zip using Chocolatey
# ========================================
echo ""
print_info "Checking zip installation..."

if command -v zip &> /dev/null; then
    print_success "zip is already installed"
else
    print_info "Attempting to install zip using Chocolatey..."
    if command -v choco &> /dev/null; then
        print_info "This requires Administrator privileges..."
        if choco install zip -y 2>/dev/null; then
            print_success "zip installed successfully"
            # Refresh environment variables
            export PATH="$PATH:/c/ProgramData/chocolatey/bin"
        else
            print_error "Failed to install zip. Please run as Administrator:"
            echo "   choco install zip -y"
            echo ""
        fi
    else
        print_error "Chocolatey not available. Please install Chocolatey first."
    fi
fi

# ========================================
# 3. Install Python3 using Chocolatey
# ========================================
echo ""
print_info "Checking Python3 installation..."

if command -v python3 &> /dev/null || command -v python &> /dev/null; then
    print_success "Python3 is already installed"
    if command -v python3 &> /dev/null; then
        print_info "Python version: $(python3 --version)"
    else
        print_info "Python version: $(python --version)"
    fi
else
    print_info "Attempting to install Python3 using Chocolatey..."
    if command -v choco &> /dev/null; then
        print_info "This requires Administrator privileges..."
        if choco install python3 -y 2>/dev/null; then
            print_success "Python3 installed successfully"
            # Refresh environment variables
            export PATH="$PATH:/c/Python312:/c/Python312/Scripts"
            print_info "Python version: $(python --version 2>&1 || echo 'Restart terminal to use Python')"
        else
            print_error "Failed to install Python3. Please run as Administrator:"
            echo "   choco install python3 -y"
            echo ""
        fi
    else
        print_error "Chocolatey not available. Please install Chocolatey first."
    fi
fi

# ========================================
# 4. Install SDKMAN
# ========================================
echo ""
print_info "Checking SDKMAN installation..."

if [ -d "$HOME/.sdkman" ]; then
    print_success "SDKMAN is already installed"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    print_info "SDKMAN version: $(sdk version | head -n 2)"
    
    # Ensure SDKMAN is in .bashrc
    if ! grep -q "sdkman-init.sh" "$HOME/.bashrc" 2>/dev/null; then
        echo "" >> "$HOME/.bashrc"
        echo "# SDKMAN initialization" >> "$HOME/.bashrc"
        echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> "$HOME/.bashrc"
        echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> "$HOME/.bashrc"
        print_success "Added SDKMAN to .bashrc"
    fi
else
    print_info "Installing SDKMAN..."
    
    # Check if zip is available (required for SDKMAN)
    if ! command -v zip &> /dev/null; then
        print_error "zip is required for SDKMAN installation but not found."
        print_info "Please install zip first: choco install zip -y (as Admin)"
        echo ""
    else
        # Install SDKMAN
        curl -s "https://get.sdkman.io" | bash
        
        if [ -d "$HOME/.sdkman" ]; then
            print_success "SDKMAN installed successfully"
            source "$HOME/.sdkman/bin/sdkman-init.sh"
            print_info "SDKMAN version: $(sdk version | head -n 2)"
            
            # Add SDKMAN to .bashrc if not already present
            if ! grep -q "sdkman-init.sh" "$HOME/.bashrc" 2>/dev/null; then
                echo "" >> "$HOME/.bashrc"
                echo "# SDKMAN initialization" >> "$HOME/.bashrc"
                echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> "$HOME/.bashrc"
                echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> "$HOME/.bashrc"
                print_success "Added SDKMAN to .bashrc"
            fi
            
            # Suggest installing Java, Maven, and Gradle
            echo ""
            print_info "Installing recommended tools via SDKMAN..."
            echo ""
            
            # Install Java
            print_info "Installing Java..."
            if sdk install java 2>/dev/null; then
                print_success "Java installed successfully"
            else
                print_info "Java installation skipped (may already be installed)"
            fi
            
            # Install Maven
            print_info "Installing Maven..."
            if sdk install maven 2>/dev/null; then
                print_success "Maven installed successfully"
            else
                print_info "Maven installation skipped (may already be installed)"
            fi
            
            # Install Gradle
            print_info "Installing Gradle..."
            if sdk install gradle 2>/dev/null; then
                print_success "Gradle installed successfully"
            else
                print_info "Gradle installation skipped (may already be installed)"
            fi
            
            echo ""
            print_info "To add SDKMAN tools to Windows PATH, run as Administrator:"
            echo "   .\\add-sdkman-to-path.ps1  (PowerShell)"
            echo "   add-sdkman-to-path.bat     (Command Prompt)"
            echo ""
        else
            print_error "SDKMAN installation failed"
        fi
    fi
fi

# ========================================
# 5. Install NVM (Node Version Manager)
# ========================================
echo ""
print_info "Checking NVM installation..."

# Check if NVM is already installed
if [ -d "$HOME/.nvm" ] || [ -n "$NVM_DIR" ]; then
    print_success "NVM is already installed"
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    if command -v nvm &> /dev/null; then
        print_info "NVM version: $(nvm --version)"
    fi
else
    print_info "Installing NVM..."
    
    # Install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if command -v nvm &> /dev/null; then
        print_success "NVM installed successfully"
        print_info "NVM version: $(nvm --version)"
        
        # Install Node.js LTS
        echo ""
        print_info "Installing Node.js LTS..."
        if nvm install --lts 2>/dev/null; then
            print_success "Node.js LTS installed successfully"
            nvm use --lts 2>/dev/null
            print_info "Node version: $(node --version)"
            print_info "NPM version: $(npm --version)"
        else
            print_info "Node.js installation skipped"
        fi
    else
        print_error "NVM installation failed"
    fi
fi

# ========================================
# Summary
# ========================================
echo ""
echo "========================================="
echo "Installation Summary"
echo "========================================="
echo ""

# Check installations
command -v choco &> /dev/null && print_success "Chocolatey: Installed" || print_error "Chocolatey: Not installed"
command -v zip &> /dev/null && print_success "zip: Installed" || print_error "zip: Not installed"

if command -v python3 &> /dev/null || command -v python &> /dev/null; then
    print_success "Python3: Installed"
    if command -v python3 &> /dev/null; then
        print_info "  └─ Version: $(python3 --version 2>&1 | cut -d' ' -f2)"
    else
        print_info "  └─ Version: $(python --version 2>&1 | cut -d' ' -f2)"
    fi
else
    print_error "Python3: Not installed"
fi

[ -d "$HOME/.sdkman" ] && print_success "SDKMAN: Installed" || print_error "SDKMAN: Not installed"

# Check SDKMAN-managed tools
if [ -d "$HOME/.sdkman" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh" 2>/dev/null
    command -v java &> /dev/null && print_success "  ├─ Java: $(java -version 2>&1 | head -n 1)" || print_info "  ├─ Java: Not installed"
    command -v mvn &> /dev/null && print_success "  ├─ Maven: $(mvn --version 2>&1 | head -n 1 | cut -d' ' -f3)" || print_info "  ├─ Maven: Not installed"
    command -v gradle &> /dev/null && print_success "  └─ Gradle: $(gradle --version 2>&1 | grep Gradle | cut -d' ' -f2)" || print_info "  └─ Gradle: Not installed"
fi

[ -d "$HOME/.nvm" ] && print_success "NVM: Installed" || print_error "NVM: Not installed"

# Check NVM-managed Node.js
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 2>/dev/null
    command -v node &> /dev/null && print_success "  └─ Node.js: $(node --version)" || print_info "  └─ Node.js: Not installed"
fi

echo ""
echo "========================================="
echo "Post-Installation Instructions"
echo "========================================="
echo ""
print_info "To use SDKMAN in your current session:"
echo "   source \"\$HOME/.sdkman/bin/sdkman-init.sh\""
echo ""
print_info "To use NVM in your current session:"
echo "   source \"\$HOME/.nvm/nvm.sh\""
echo ""
print_info "For new terminals, these tools will be available automatically."
echo ""
print_info "Quick start commands:"
echo "   # Python"
echo "   python --version             # Check Python version"
echo "   pip --version                # Check pip version"
echo "   pip install <package>        # Install Python package"
echo ""
echo "   # Java, Maven, Gradle (via SDKMAN)"
echo "   sdk list java                # List available Java versions"
echo "   sdk use java <version>       # Switch Java version"
echo "   mvn --version                # Check Maven version"
echo "   gradle --version             # Check Gradle version"
echo ""
echo "   # Node.js (via NVM)"
echo "   nvm list                     # List installed Node versions"
echo "   nvm use <version>            # Switch Node version"
echo "   node --version               # Check Node version"
echo ""
print_info "To add SDKMAN tools to Windows CMD/PowerShell:"
echo "   Run as Administrator: .\\add-sdkman-to-path.ps1"
echo ""
print_success "Installation script completed!"
