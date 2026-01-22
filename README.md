# Development Tools Installation Scripts

Automated installation scripts for common development tools on Windows with Git Bash.

## Tools Installed

- **Chocolatey** - Windows package manager
- **zip** - Compression utility (required for SDKMAN)
- **SDKMAN** - Software Development Kit Manager (for Java, Maven, Gradle, etc.)
- **NVM** - Node Version Manager

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
.\add-sdkman-to-path.ps1
```

#### Option B: Using Batch Script

Right-click on Command Prompt and select "Run as Administrator", then run:

```batch
add-sdkman-to-path.bat
```

### 3. Restart Your Terminal

After adding to PATH, restart your terminal (Git Bash, Command Prompt, or PowerShell) for changes to take effect.

## Usage

### Git Bash

SDKMAN and NVM are automatically available in Git Bash after installation.

```bash
# SDKMAN commands
sdk list java           # List available Java versions
sdk install java        # Install latest Java
sdk use java 17.0.9     # Switch Java version

# NVM commands
nvm list               # List installed Node versions
nvm install --lts      # Install latest LTS Node.js
nvm use 20             # Switch Node version
```

### Command Prompt / PowerShell

After running the PATH setup script, SDKMAN-installed tools will be available:

```cmd
java -version
mvn -version
gradle -version
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

## License

MIT
