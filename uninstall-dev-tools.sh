#!/bin/bash

# Development Tools Uninstallation Script
# Uninstalls: SDKMAN, NVM, and Chocolatey packages

set -e  # Exit on error

echo "========================================="
echo "Development Tools Uninstallation Script"
echo "========================================="
echo ""
echo "WARNING: This will remove all installed development tools!"
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

# Confirmation prompt
read -p "Are you sure you want to uninstall all development tools? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Uninstallation cancelled."
    exit 0
fi

echo ""
echo "Starting uninstallation..."
echo ""

# ========================================
# 1. Uninstall NVM
# ========================================
echo ""
print_info "Uninstalling NVM..."

if [ -d "$HOME/.nvm" ]; then
    print_info "Removing NVM directory..."
    rm -rf "$HOME/.nvm"
    
    # Remove from .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        sed -i '/NVM_DIR/d' "$HOME/.bashrc" 2>/dev/null || true
        sed -i '/nvm.sh/d' "$HOME/.bashrc" 2>/dev/null || true
        print_success "Removed NVM from .bashrc"
    fi
    
    # Remove from .bash_profile
    if [ -f "$HOME/.bash_profile" ]; then
        sed -i '/NVM_DIR/d' "$HOME/.bash_profile" 2>/dev/null || true
        sed -i '/nvm.sh/d' "$HOME/.bash_profile" 2>/dev/null || true
    fi
    
    # Remove from .profile
    if [ -f "$HOME/.profile" ]; then
        sed -i '/NVM_DIR/d' "$HOME/.profile" 2>/dev/null || true
        sed -i '/nvm.sh/d' "$HOME/.profile" 2>/dev/null || true
    fi
    
    print_success "NVM uninstalled successfully"
else
    print_info "NVM is not installed"
fi

# ========================================
# 2. Uninstall SDKMAN
# ========================================
echo ""
print_info "Uninstalling SDKMAN..."

if [ -d "$HOME/.sdkman" ]; then
    print_info "Removing SDKMAN directory..."
    rm -rf "$HOME/.sdkman"
    
    # Remove from .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        sed -i '/SDKMAN/d' "$HOME/.bashrc" 2>/dev/null || true
        sed -i '/sdkman-init.sh/d' "$HOME/.bashrc" 2>/dev/null || true
        print_success "Removed SDKMAN from .bashrc"
    fi
    
    # Remove from .bash_profile
    if [ -f "$HOME/.bash_profile" ]; then
        sed -i '/SDKMAN/d' "$HOME/.bash_profile" 2>/dev/null || true
        sed -i '/sdkman-init.sh/d' "$HOME/.bash_profile" 2>/dev/null || true
    fi
    
    # Remove from .profile
    if [ -f "$HOME/.profile" ]; then
        sed -i '/SDKMAN/d' "$HOME/.profile" 2>/dev/null || true
        sed -i '/sdkman-init.sh/d' "$HOME/.profile" 2>/dev/null || true
    fi
    
    print_success "SDKMAN uninstalled successfully"
else
    print_info "SDKMAN is not installed"
fi

# ========================================
# 3. Uninstall Chocolatey packages
# ========================================
echo ""
print_info "Uninstalling Chocolatey packages..."

if command -v choco &> /dev/null; then
    print_info "This requires Administrator privileges..."
    
    # Uninstall Go
    if choco list --local-only | grep -q golang; then
        print_info "Uninstalling Go..."
        choco uninstall golang -y 2>/dev/null && print_success "Go uninstalled" || print_error "Failed to uninstall Go"
    fi
    
    # Uninstall Python3
    if choco list --local-only | grep -q python3; then
        print_info "Uninstalling Python3..."
        choco uninstall python3 -y 2>/dev/null && print_success "Python3 uninstalled" || print_error "Failed to uninstall Python3"
    fi
    
    # Uninstall zip
    if choco list --local-only | grep -q "^zip "; then
        print_info "Uninstalling zip..."
        choco uninstall zip -y 2>/dev/null && print_success "zip uninstalled" || print_error "Failed to uninstall zip"
    fi
    
    echo ""
    print_info "To uninstall Chocolatey itself, run as Administrator:"
    echo "   Remove-Item C:\\ProgramData\\chocolatey -Recurse -Force"
else
    print_info "Chocolatey is not installed"
fi

# ========================================
# Summary
# ========================================
echo ""
echo "========================================="
echo "Uninstallation Summary"
echo "========================================="
echo ""

[ ! -d "$HOME/.nvm" ] && print_success "NVM: Removed" || print_error "NVM: Still present"
[ ! -d "$HOME/.sdkman" ] && print_success "SDKMAN: Removed" || print_error "SDKMAN: Still present"
command -v go &> /dev/null && print_error "Go: Still installed" || print_success "Go: Removed"
command -v python &> /dev/null && print_error "Python3: Still installed" || print_success "Python3: Removed"
command -v zip &> /dev/null && print_error "zip: Still installed" || print_success "zip: Removed"

echo ""
echo "========================================="
echo "Post-Uninstallation Instructions"
echo "========================================="
echo ""
print_info "Please restart your terminal for changes to take effect."
echo ""
print_info "To clean up Windows PATH for SDKMAN tools, run as Administrator:"
echo "   Remove paths containing: .sdkman\\candidates"
echo ""
print_success "Uninstallation script completed!"
