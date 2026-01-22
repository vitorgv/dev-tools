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
# 3. Install SDKMAN
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
            
            # Add SDKMAN to PATH for Windows (cmd/PowerShell)
            SDKMAN_PATH=$(cygpath -w "$HOME/.sdkman/candidates/java/current/bin" 2>/dev/null || echo "$HOME/.sdkman/candidates/java/current/bin")
            print_info "To add SDKMAN Java to Windows PATH, run as Administrator:"
            echo "   setx /M PATH \"%PATH%;%USERPROFILE%\\.sdkman\\candidates\\java\\current\\bin\""
            echo ""
        else
            print_error "SDKMAN installation failed"
        fi
    fi
fi

# ========================================
# 4. Install NVM (Node Version Manager)
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
[ -d "$HOME/.sdkman" ] && print_success "SDKMAN: Installed" || print_error "SDKMAN: Not installed"
[ -d "$HOME/.nvm" ] && print_success "NVM: Installed" || print_error "NVM: Not installed"

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
echo "   sdk list java          # List available Java versions"
echo "   sdk install java       # Install latest Java"
echo "   nvm list               # List installed Node versions"
echo "   nvm install --lts      # Install latest LTS Node.js"
echo ""
print_success "Installation script completed!"
