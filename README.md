# Dotfiles

> Personal dotfiles configuration with support for **Bash** and **Zsh** on **macOS** and **Linux**.  
> Automate your development environment setup with a single command.

## 🚀 Quick Start

### Installation

Clone the repository and run the setup:

```bash
git clone <repository-url> dotfiles
cd dotfiles
./dotfiles apply
```

That's it! This will:
- ✅ Configure your operating system (macOS or Linux)
- ✅ Install all packages and applications
- ✅ Copy and configure all dotfiles

**Available commands:**
- `./dotfiles apply` - Run everything (recommended for first-time setup)
- `./dotfiles apply:config` - Configure OS settings only
- `./dotfiles apply:install` - Install packages only
- `./dotfiles apply:files` - Copy dotfiles only

### Development Tools (Optional)

For development tasks (linting, testing, debugging), install `mise`:

```bash
# Install mise
# macOS: brew install mise
# Linux: curl https://mise.run | sh

# Development commands
mise run lint              # Lint and syntax-check scripts
mise run test              # Run tests on Linux
mise run debug:linux:gui   # Debug environment with GUI (VNC)
mise run debug:linux:nogui # Debug environment without GUI
```

---

## 📋 Requirements

### System Requirements
- **macOS**: 10.15 (Catalina) or later
- **Linux**: Ubuntu 20.04+ or Debian 10+
- Internet connection for package installation
- Administrator/sudo access for package installation

### Prerequisites
- **Git** - Should be pre-installed on most systems
- **curl** - Usually pre-installed, required for downloads
- **bash** - Version 4.1+ recommended (installed automatically on macOS via Homebrew)
- **mise** (optional) - Required only for development tasks (`lint`, `test`, `debug`)
  - Installation: [mise.jdx.dev/getting-started.html](https://mise.jdx.dev/getting-started.html)

### Accounts & Services
- **1Password account** - Required for SSH/GPG key management
- **Google account** - Optional, for Gemini CLI (AI-powered commit messages)

---

## 📖 Commands Reference

### Installation Commands

All installation commands use the `./dotfiles` script directly (no `mise` required):

| Command | Description |
|---------|-------------|
| `./dotfiles apply` | Complete setup: config + install + files |
| `./dotfiles apply:config` | Configure OS settings (macOS/Linux) |
| `./dotfiles apply:install` | Install packages and applications |
| `./dotfiles apply:files` | Copy dotfiles to home directory |

### Development Commands

These commands require `mise` to be installed:

| Command | Description |
|---------|-------------|
| `mise run lint` | Lint and syntax-check all bash scripts |
| `mise run test` | Run all tests (executes test:linux) |
| `mise run test:linux` | Test scripts on Linux (Docker) |
| `mise run debug:linux:gui` | Interactive debug: Ubuntu with GUI (VNC) |
| `mise run debug:linux:nogui` | Interactive debug: Debian slim without GUI |

---

## ✨ Features

### 🐚 Shell Support
- **Bash** and **Zsh** with shared configurations
- OS-specific configurations (`-macos` and `-linux` variants)
- Private configuration files support

### 🖥️ Operating Systems
- **macOS** - Full support with Homebrew integration
- **Linux** - Ubuntu and Debian support
- Automatic OS detection and configuration

### 🔧 Development Tools
- **Git** - Configured with SSH, GPG signing, and delta pager
- **1Password** - Integrated SSH agent and GPG key management
- **Editors** - Sublime Text (GUI) or Neovim (CLI), auto-detected
- **AI Commit Messages** - Gemini AI-powered commit message generation

### 🛠️ Modern CLI Tools
- **Rust utilities**: dust, procs, bottom, ouch, tealdeer, hyperfine, gitui, atuin, navi
- **Text processing**: bat, ripgrep, fzf, delta, sd
- **System tools**: zoxide, exa, fd, tree, htop

---

## 📦 Installed Packages

### Core Development Tools
- **bash** (updated via Homebrew on macOS)
- **bash-completion** - Programmable completion
- **neovim** - Hyperextensible Vim-based editor
- **tmux** - Terminal multiplexer
- **git** + **hub** - Version control with GitHub integration
- **gpg** + **openssl** - Encryption and signing

### Text Processing & Search
- **bat** - Modern `cat` with syntax highlighting
- **ripgrep** (rg) - Fast text search
- **fzf** - Fuzzy finder
- **delta** - Beautiful `git diff` viewer
- **sd** - Modern `sed` replacement

### Rust Utilities
- **dust** - Intuitive disk usage analyzer
- **procs** - Modern process viewer
- **bottom** (btm) - System monitor
- **ouch** - Universal archive extractor
- **tealdeer** (tldr) - Simplified man pages
- **hyperfine** - Command benchmarking
- **gitui** - Terminal UI for Git
- **atuin** - Enhanced shell history
- **navi** - Interactive cheatsheets

### System & Process Management
- **htop** (Linux) - Interactive process viewer
- **tree** - Directory tree viewer
- **zoxide** - Smart directory jumper
- **exa** - Modern `ls` replacement
- **fd** - Fast `find` alternative

### Cloud & DevOps
- **docker** / **Docker CE** - Container platform
- **docker-compose** - Multi-container orchestration
- **awscli** - AWS command-line interface

### Language Runtimes
- **rustup** - Rust toolchain
- **node** - Node.js runtime
- **OpenJDK** - Java Development Kit
- **Android SDK** - Android development tools
- **gemini** - Google Gemini CLI

---

## 💻 Installed Applications

### macOS Applications

#### Homebrew Cask
- **1Password** + CLI - Password manager
- **Antigravity** - Google AI-powered IDE
- **Cursor** - AI-powered code editor
- **Docker Desktop** - Container platform
- **IntelliJ IDEA** - Java IDE
- **iTerm2** - Terminal emulator
- **Sublime Text** + **Sublime Merge** - Editor and Git client
- **Visual Studio Code** - Code editor
- **Firefox**, **Google Chrome** - Web browsers
- And many more...

#### Mac App Store
- **Xcode** - Apple development IDE
- **Slack** - Team communication
- **Pixelmator Pro** - Image editor
- **DaisyDisk** - Disk space analyzer
- And 20+ more applications...

### Linux Applications (GUI Environment Only)

#### Desktop Applications
- **1Password** (GUI)
- **Chrome** - Web browser
- **Sublime Text** + **Sublime Merge**
- **Visual Studio Code**
- **IntelliJ IDEA Ultimate**
- **Slack** (via Flatpak)
- **VLC** - Media player

#### Development Tools
- **PlatformIO** - Embedded development
- **QEMU/KVM** - Virtualization with GUI tools
- **GNOME Extensions** (Ubuntu/GNOME only)

---

## ⚙️ Configuration Files

### Shell Configuration
- **Shared**: `home/.shared_shell_config` (loaded by both shells)
- **Bash**: `home/.bash_profile`, `home/.bash_functions`
- **Zsh**: `home/.zshrc`, `home/.zsh_functions`
- **OS-specific**: Automatically selected based on OS (`-macos` or `-linux`)

### Git Configuration
The `.gitconfig` is automatically assembled based on your environment:

- **Base**: Common settings (SSH, GPG signing, aliases)
- **GUI mode** (macOS or Linux with GUI):
  - Sublime Merge for merge conflicts
  - Sublime Text as editor
  - Delta pager for diffs
- **CLI mode** (Linux without GUI):
  - Neovim as editor
  - Delta pager for diffs

### Git Hooks with AI

Automatic commit message generation using **Google Gemini AI**:

**Features:**
- Generates commit messages based on staged changes
- Verifies message file was saved before committing
- Supports multiple languages (set `GIT_COMMIT_LANG` environment variable)

**Language Configuration:**
```bash
# Set in ~/.bash_profile or ~/.zshrc
export GIT_COMMIT_LANG=pt-BR  # Portuguese (Brazilian)
export GIT_COMMIT_LANG=en      # English (default)
export GIT_COMMIT_LANG=es      # Spanish
# ... any language supported by Gemini
```

**Hooks:**
- `prepare-commit-msg` - Generates AI commit message suggestions
- `commit-msg` - Verifies message file was saved

### Other Configurations
- **tmux** - Terminal multiplexer configuration
- **SSH** - OS-specific SSH config
- **GPG** - 1Password integration for key management

---

## 📁 Project Structure

```
dotfiles/
├── .config/
│   └── mise/
│       └── tasks/           # Development tasks (lint, test, debug)
│           ├── test/        # Test tasks
│           ├── debug/       # Debug environments
│           └── lint         # Linting task
├── bin/                     # Installation scripts
│   ├── apply-config-macos   # macOS system configuration
│   ├── apply-config-linux   # Linux system configuration
│   ├── apply-install-macos  # macOS package installation
│   ├── apply-install-linux  # Linux package installation
│   ├── apply-files          # Copy dotfiles to home
│   └── validate-url         # URL validation utility
├── home/                    # Configuration files (→ ~/)
│   ├── .git_hooks/          # Git hooks
│   ├── .bin/                # Custom scripts
│   └── .*                    # Dotfiles (bash, zsh, git, tmux, etc.)
├── macos/                   # macOS-specific configs
│   └── DefaultKeyBinding.dict
├── mise.toml                # mise configuration
└── dotfiles                 # Main script (apply commands)
```

---

## 🔄 Updating Dotfiles

To update your dotfiles from the repository:

```bash
git pull origin master  # or 'main'
./dotfiles apply
```

This will:
1. Pull the latest changes
2. Reapply all configurations, packages, and dotfiles
3. Show instructions to reload your shell if needed

**After updating**, reload your shell:
```bash
source ~/.bash_profile  # for Bash
source ~/.zshrc         # for Zsh
```

---

## ➕ Adding Custom Configurations

1. Edit files in the `home/` directory
2. Run `./dotfiles apply:files` to apply changes
3. Reload your shell: `source ~/.bash_profile` or `source ~/.zshrc`

### Private Files

Private files (not versioned) are automatically loaded if they exist:
- `~/.bash_private`
- `~/.zshrc_private`
- `~/.shared_shell_config_private`

Add your personal configurations here without committing them to the repository.

---

## 🐛 Troubleshooting

### Files Not Loading?

**Symptoms:** Changes to dotfiles aren't taking effect, or files aren't found.

**Solution:**
```bash
./dotfiles apply:install  # Ensure packages are installed
./dotfiles apply:files     # Re-copy dotfiles
source ~/.bash_profile    # Reload shell (Bash)
# or
source ~/.zshrc           # Reload shell (Zsh)
```

### Commands Not Found?

**Symptoms:** Commands like `bat`, `rg`, `fzf`, etc. are not recognized.

**Solutions:**
1. Verify packages are installed: `./dotfiles apply:install`
2. Check if `~/.shared_shell_config` is loaded in your shell
3. Verify PATH includes `~/.local/bin` (Linux) or Homebrew paths (macOS)
4. Reload shell: `source ~/.bash_profile` or `source ~/.zshrc`
5. Check if the package manager (Homebrew/apt) is working correctly

### GPG/1Password Setup Issues?

**Symptoms:** GPG key not imported, Git commits not signed, or 1Password integration not working.

**Common Causes:**
- 1Password CLI not installed or not signed in
- GPG key import failed during initial setup
- GPG agent not configured correctly

**Solution - Use the GPG Setup Script:**

We provide a dedicated script to fix GPG setup issues:

```bash
# From the dotfiles directory
./bin/setup-gpg-with-1password
```

This script will:
- ✅ Verify 1Password CLI is installed and authenticated
- ✅ Retrieve the PGP key from 1Password
- ✅ Import or reimport the GPG key
- ✅ Configure Git signing automatically
- ✅ Verify GPG agent configuration

**Force Reimport:**
If you need to reimport the key even if it already exists:

```bash
./bin/setup-gpg-with-1password --force
```

**Manual Troubleshooting Steps:**

1. **Verify 1Password CLI:**
   ```bash
   op --version           # Check if installed
   op account list        # Check if signed in
   op signin              # Sign in if needed
   ```

2. **Verify GPG Key in 1Password:**
   ```bash
   op document get b2lpibkkqfqtp5lvvp25ugx3kq | head -20
   ```

3. **Check Current GPG Keys:**
   ```bash
   gpg --list-secret-keys
   ```

4. **Verify Git Configuration:**
   ```bash
   git config --global user.signingkey
   git config --global commit.gpgsign
   ```

5. **Re-run Setup:**
   ```bash
   ./bin/setup-gpg-with-1password  # Use the setup script
   # or
   ./bin/apply-config-gpg          # Original config script
   ```

### SSH Issues?

**Symptoms:** SSH connections failing, keys not found, or 1Password SSH agent not working.

**Solutions:**
1. Verify 1Password SSH agent is running:
   ```bash
   ls -la ~/.1password/agent.sock
   ```

2. Check SSH config:
   ```bash
   cat ~/.ssh/config
   ```

3. Verify SSH keys in 1Password:
   ```bash
   op item list --categories "Secure Note" | grep -i ssh
   ```

4. Re-apply SSH configuration:
   ```bash
   ./dotfiles apply:files
   ```

### Git Configuration Issues?

**Symptoms:** Wrong editor, merge tool, or signing not working.

**Solutions:**
1. Check current Git configuration:
   ```bash
   git config --global --list
   ```

2. Verify GUI detection (should match your environment):
   ```bash
   echo $DISPLAY        # Linux GUI
   echo $WAYLAND_DISPLAY  # Linux Wayland
   ```

3. Re-apply Git configuration:
   ```bash
   ./dotfiles apply:files
   ```

### Package Installation Issues?

**Symptoms:** Packages fail to install, or installation is incomplete.

**Solutions:**

**macOS:**
```bash
# Update Homebrew
brew update

# Fix Homebrew issues
brew doctor

# Re-run installation
./dotfiles apply:install
```

**Linux:**
```bash
# Update package lists
sudo apt update

# Fix broken packages
sudo apt --fix-broken install

# Re-run installation
./dotfiles apply:install
```

### Debug Environment

Use the debug environments to troubleshoot issues in isolated containers:

```bash
# Ubuntu with GUI (VNC access)
mise run debug:linux:gui

# Debian slim without GUI
mise run debug:linux:nogui
```

The debug environments provide:
- Interactive bash shell with pre-configured environment
- VNC access (GUI mode) for visual debugging
- Automatic cleanup on exit
- Full access to test installation scripts

**VNC Connection (GUI mode):**
After starting `debug:linux:gui`, the script will display connection instructions.
Typically: `vncviewer localhost:<port>` with password `password`.

---

## 🧪 Testing

Run tests to verify everything works:

```bash
mise run test              # Run all tests
mise run test:linux        # Test on Linux (Docker)
```

Tests verify:
- Script syntax and execution
- Dotfiles are copied correctly
- Git configuration (GUI/nogui detection)
- Shell configuration validity

---

## 📝 License

This project is licensed under the **WTFPL (Do What The Fuck You Want To Public License)**.

See [LICENSE](LICENSE) file for details.

**Personal project. Feel free to use as reference.**

---

## 🤝 Contributing

This is a personal dotfiles repository. Feel free to:
- Fork and adapt for your own use
- Use as reference for your own setup
- Report issues or suggest improvements

---

## 📚 Additional Resources

- [mise documentation](https://mise.jdx.dev/)
- [1Password CLI documentation](https://developer.1password.com/docs/cli)
- [Gemini AI documentation](https://ai.google.dev/)
