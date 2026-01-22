# Development Tools Installation Scripts

Automated installation scripts for common development tools on Windows with Git Bash.

## Tools Installed

### Core Package Managers
- **Chocolatey** - Windows package manager
- **zip** - Compression utility (required for SDKMAN)
- **SDKMAN** - Software Development Kit Manager
- **NVM** - Node Version Manager

### Development Tools (Auto-installed)
- **Python3** - Latest version via Chocolatey
- **Go** - Latest version via Chocolatey
- **Java** - Latest LTS version via SDKMAN
- **Maven** - Latest version via SDKMAN
- **Gradle** - Latest version via SDKMAN
- **Node.js** - Latest LTS version via NVM

## Installation

### 1. Run the Installation Script

Open Git Bash and run:

```bash
./install-dev-tools.sh
```

This will install all the tools automatically.

### 2. Add SDKMAN to Windows PATH

To use SDKMAN tools (Java, Maven, Gradle, etc.) in Command Prompt and PowerShell, you need to add them to the Windows PATH.

#### Option A: Using PowerShell (Recommended)

Right-click on PowerShell and select "Run as Administrator", then run:

```powershell
.\setup-windows-path.ps1
```

#### Option B: Using Batch Script

Right-click on Command Prompt and select "Run as Administrator", then run:

```batch
setup-windows-path.bat
```

### 3. Restart Your Terminal

After adding to PATH, restart your terminal (Git Bash, Command Prompt, or PowerShell) for changes to take effect.

## Usage

### Git Bash

SDKMAN and NVM are automatically available in Git Bash after installation.

```bash
# Python commands
python --version        # Check Python version
pip --version          # Check pip version
pip install requests   # Install package
pip list              # List installed packages

# Go commands
go version             # Check Go version
go mod init myapp      # Initialize Go module
go build              # Build Go project
go run main.go        # Run Go program
go get <package>      # Install Go package

# SDKMAN commands
sdk list java           # List available Java versions
sdk install java 21     # Install specific Java version
sdk use java 21         # Switch to Java 21
sdk current java        # Show current Java version

# Maven
mvn --version          # Check Maven installation
mvn clean install      # Build project

# Gradle
gradle --version       # Check Gradle installation
gradle build          # Build project

# NVM commands
nvm list               # List installed Node versions
nvm install 20         # Install Node.js 20
nvm use 20             # Switch to Node.js 20
nvm current            # Show current Node version

# Node.js
node --version         # Check Node version
npm --version          # Check NPM version
```

### Command Prompt / PowerShell

After running the PATH setup script, all development tools will be available:

```cmd
python --version
pip --version
go version
java -version
mvn -version
gradle -version
node -v
npm -v
```

## Manual PATH Setup

If you prefer to add SDKMAN to PATH manually:

1. Open System Properties → Environment Variables
2. Edit the System `PATH` variable
3. Add these directories (if they exist):
   - `%USERPROFILE%\.sdkman\candidates\java\current\bin`
   - `%USERPROFILE%\.sdkman\candidates\maven\current\bin`
   - `%USERPROFILE%\.sdkman\candidates\gradle\current\bin`

## Troubleshooting

### SDKMAN not found in Git Bash

Reload your bash profile:

```bash
source ~/.bashrc
```

### Tools not found in CMD/PowerShell

1. Verify the PATH was added:
   ```cmd
   echo %PATH%
   ```

2. Restart your terminal completely

3. Re-run the PATH setup script as Administrator

### Permission Issues

- Chocolatey installation requires Administrator privileges
- Adding system PATH variables requires Administrator privileges
- Run scripts as Administrator when prompted

## Uninstallation

To remove all installed development tools, run the appropriate uninstall script:

### Git Bash

```bash
./uninstall-dev-tools.sh
```

### Command Prompt (as Administrator)

```batch
uninstall-dev-tools.bat
```

### PowerShell (as Administrator)

```powershell
.\uninstall-dev-tools.ps1
```

**Note:** The uninstall scripts will:
- Remove SDKMAN and all Java tools (Java, Maven, Gradle)
- Remove NVM and Node.js
- Uninstall Chocolatey packages (Python3, Go, zip)
- Clean up PATH environment variables
- Remove configuration from shell profiles

To completely remove Chocolatey itself (optional), run as Administrator:
```powershell
Remove-Item C:\ProgramData\chocolatey -Recurse -Force
```

## License

MIT
