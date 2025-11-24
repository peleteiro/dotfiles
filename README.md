# Dotfiles

Personal dotfiles configuration with support for **Bash** and **Zsh** on **macOS** and **Linux**.

## Requirements

### System Requirements
- **macOS**: 10.15 (Catalina) or later
- **Linux**: Ubuntu 20.04+ or Debian 10+
- Internet connection for package installation
- Administrator/sudo access for package installation

### Accounts & Services
- **1Password account** - Required for SSH/GPG key management
- **Google account** - Optional, for Gemini CLI

### Prerequisites
- **mise** - Runtime version manager (formerly rtx) - [Installation guide](https://mise.jdx.dev/getting-started.html)
- **Git** - Should be pre-installed on most systems
- **curl** - Usually pre-installed, required for downloads
- **bash** - Version 4.1+ recommended (will be installed via Homebrew on macOS)

## Quick Start

```bash
mise run apply
```

This installs everything: system configuration, packages, and dotfiles.

**Note:** If `mise` is not installed, install it first:
- **macOS**: `brew install mise` or `curl https://mise.run | sh`
- **Linux**: `curl https://mise.run | sh`

## Commands

All commands are run using `mise run <task>`:

| Command | Description |
|---------|-------------|
| `mise run apply` | Run apply:config, apply:install, and apply:files (in order) |
| `mise run apply:config` | Configure operating system (macOS or Linux) |
| `mise run apply:install` | Install packages and applications |
| `mise run apply:files` | Copy dotfiles to home directory |
| `mise run lint` | Lint and syntax-check all bash scripts |
| `mise run test` | Run all tests (executes test:linux) |
| `mise run test:linux` | Test scripts on Linux |

Tasks are defined in `.config/mise/tasks/` using directory structure:
- `apply` → `.config/mise/tasks/apply/_default` (has subtasks)
- `apply:config` → `.config/mise/tasks/apply/config`
- `apply:install` → `.config/mise/tasks/apply/install`
- `apply:files` → `.config/mise/tasks/apply/files`
- `lint` → `.config/mise/tasks/lint` (simple task, no subtasks)
- `test` → `.config/mise/tasks/test/_default` (has subtasks)
- `test:linux` → `.config/mise/tasks/test/linux`

List all available tasks with `mise tasks`.

## Project Structure

```
dotfiles/
├── .config/
│   └── mise/
│       └── tasks/           # mise task definitions
│           ├── apply/       # apply:* tasks (has subtasks)
│           │   ├── _default # apply task
│           │   ├── config   # apply:config task
│           │   ├── files    # apply:files task
│           │   └── install  # apply:install task
│           ├── test/        # test:* tasks (has subtasks)
│           │   ├── _default # test task
│           │   └── linux    # test:linux task
│           └── lint         # lint task (simple, no subtasks)
├── bin/              # Installation and management scripts
├── home/             # Configuration files (copied to ~/)
│   ├── .git_hooks/   # Git hooks (prepare-commit-msg, commit-msg)
│   └── .bin/         # Custom scripts
├── macos/            # macOS-specific configurations
├── mise.toml         # mise configuration
└── dotfiles          # Apply script (apply, apply:config, apply:install, apply:files)
```

## Features

- **Shells**: Full support for Bash and Zsh with shared configurations
- **OS Support**: macOS and Linux (Ubuntu/Debian)
- **Git**: Configured with SSH authentication, GPG signing, and delta pager
- **1Password**: Integrated SSH agent and GPG key management
- **Editors**: Sublime Text (GUI) or Neovim (CLI)
- **Tools**: tmux, delta, bat, ripgrep, and more

## Installed Utilities

### Core Development Tools
- **bash** - Updated Bash shell (via Homebrew on macOS)
- **bash-completion** - Programmable completion for Bash
- **neovim** - Hyperextensible Vim-based text editor
- **tmux** - Terminal multiplexer
- **git** - Distributed version control system
- **hub** - GitHub CLI tool (adds GitHub support to git)
- **gpg** - GNU Privacy Guard for encryption and signing
- **openssl** - Cryptography and SSL/TLS toolkit

### Text Processing & Search
- **bat** - Modern `cat` with syntax highlighting
- **ripgrep** (rg) - Fast text search tool
- **fzf** - Fuzzy finder for command-line
- **sd** - Modern `sed` replacement
- **gnu-sed** - Stream editor (GNU version)
- **delta** - Better `git diff` viewer with syntax highlighting

### Rust Utilities
- **dust** - More intuitive `du` alternative with visual disk usage
- **procs** - Modern `ps` replacement with better process visualization
- **bottom** (btm) - System monitor (alternative to `htop`)
- **ouch** - Universal archive extractor (zip, tar, rar, etc.)
- **tealdeer** (tldr) - Simplified man pages with practical examples
- **hyperfine** - Command-line benchmarking tool
- **gitui** - Terminal UI for Git operations
- **atuin** - Enhanced shell history with search and sync
- **navi** - Interactive cheatsheet tool for command-line

### System & Process Management
- **htop** (Linux) - Interactive process viewer
- **tree** - Directory tree viewer
- **zoxide** - Smart directory jumper (faster alternative to z)
- **exa** - Modern `ls` replacement with colors and Git integration
- **fd** - Fast and user-friendly alternative to `find`
- **moreutils** (macOS) - Collection of Unix utilities

### Network & Download
- **aria2** - Multi-protocol download utility
- **wget** - Non-interactive network downloader
- **curl** - Command-line tool for transferring data
- **ssh-copy-id** - Install SSH public keys on remote servers

### Data Processing
- **jq** - JSON processor
- **sqlite** / **sqlite3** - SQL database engine

### Image Processing
- **imagemagick** - Image manipulation suite
- **jpegoptim** - JPEG optimizer
- **pngcrush** - PNG optimizer

### Archive & Compression
- **ouch** - Universal archive extractor (Rust-based)

### Build Tools
- **autoconf** - Automatic configure script builder
- **automake** - Automatic Makefile generator
- **coreutils** (macOS) - GNU core utilities
- **build-essential** (Linux) - Essential build tools

### Cloud & DevOps
- **awscli** / **AWS CLI** - Amazon Web Services CLI
- **docker** / **Docker CE** - Container platform
  - **macOS**: Docker Desktop (via Homebrew Cask)
  - **Linux**: Docker CE (via official repository)
- **docker-compose** - Multi-container Docker application tool
  - **macOS**: via Homebrew
  - **Linux**: docker-compose-plugin (via Docker repository)
- **docker-completion** - Docker command completion (Bash and Zsh)
  - **macOS**: via Homebrew (docker-completion package)
  - **Linux**: Installed automatically with Docker
- **docker-buildx-plugin** (Linux) - Extended build capabilities

### Metadata & File Analysis
- **exiftool** - Read and write metadata in files
- **hashdeep** - Compute and verify hash sets

### Shell Utilities
- **pip-completion** (macOS) - Python pip completion
- **docker-completion** (macOS) - Docker command completion
- **entr** (Linux) - Run arbitrary commands when files change
- **parallel** (Linux) - Shell tool for executing jobs in parallel
- **rnr** (macOS) - File renamer utility

### Language Runtimes & Development Tools
- **rustup** - Rust toolchain installer
- **node** - Node.js JavaScript runtime
- **gemini** - Google Gemini CLI tool
- **mise** (macOS) - Runtime version manager (formerly rtx)
- **OpenJDK** - Open Java Development Kit
  - **macOS**: via Homebrew
  - **Linux**: OpenJDK 8 JDK via apt
- **Android SDK** - Android development tools
  - Installed to `~/.local/share/android`
  - Includes command-line tools and SDK manager
- **Flatpak** (Linux) - Application sandboxing and distribution framework

## Installed Applications

### macOS Applications

#### Homebrew Cask Applications
- **1Password** - Password manager
- **1Password CLI** - Command-line interface for 1Password
- **Antigravity** - Google AI-powered IDE
- **Cursor** - AI-powered code editor
- **Docker** - Container platform
- **Droplr** - File sharing and screenshot tool
- **Firefox** - Web browser
- **Google Chrome** - Web browser
- **Google Drive** - Cloud storage and file sync
- **Hammerspoon** - macOS automation tool
- **IconJar** - Icon management tool
- **IntelliJ IDEA** - Java IDE
- **iTerm2** - Terminal emulator
- **Sublime Merge** - Git client
- **Sublime Text** - Text editor
- **TablePlus** - Database management tool
- **The Unarchiver** - Archive extractor
- **Transmit** - FTP/SFTP client
- **Visual Studio Code** - Code editor
- **VLC** - Media player

#### Mac App Store Applications
- **Amphetamine** - Keep Mac awake utility
- **Audio Lock** - Audio device management
- **Brother P Touch Editor** - Label printer software
- **Capto** - Screen recording and capture
- **DaisyDisk** - Disk space analyzer
- **Dato** - Menu bar calendar and timezone tool
- **HTTPBot** - HTTP client and API testing
- **KeepSolid VPN** - VPN client
- **Microsoft Remote Desktop** - Remote desktop client
- **Monodraw** - ASCII art editor
- **Pastel** - Color picker and palette tool
- **Pixelmator Pro** - Image editor
- **Slack** - Team communication
- **Spark Mail** - Email client
- **TextSniper OCR** - OCR tool
- **Typeface 3** - Font manager
- **WhatsApp Desktop** - WhatsApp client
- **Xcode** - Apple development IDE
- **xScope 4** - Design and measurement tools
- **Yubico Authenticator** - Two-factor authentication

### Linux Applications (GUI Environment Only)

#### Desktop Applications
- **1Password** - Password manager (GUI)
- **Chrome** - Google Chrome web browser
- **Sublime Text** - Text editor
- **Sublime Merge** - Git client

#### Applications via Official Repositories
- **Antigravity** - Google AI-powered IDE (official apt repository)
- **AWS CLI** - Amazon Web Services command-line tool (installed via official installer)
- **Visual Studio Code** - Code editor (Microsoft official repository)
- **Insomnia** - API client and testing tool (official repository)
- **IntelliJ IDEA Ultimate** - Java IDE (JetBrains official repository)
- **Slack** - Team communication (via Flatpak)
- **VLC** - Media player (via apt)
- **Caffeine Indicator** - Keep system awake utility (via apt)

#### Development Tools
- **PlatformIO** - Embedded development platform
- **QEMU/KVM** - Virtualization platform with GUI tools
  - **virt-manager** - Virtual machine manager
  - **virt-viewer** - Virtual machine viewer

#### GNOME Extensions & Tools (Ubuntu/GNOME only)
- **Chrome GNOME Shell** - Browser extension for GNOME Shell
- **GNOME Tweaks** - GNOME customization tool
- **GNOME Shell Extensions** - Extension management
- **GNOME Online Accounts** - Online account integration (Google Drive, etc.)

#### Media & Graphics Tools
- **FFmpeg** - Multimedia framework
- **ImageMagick** - Image manipulation suite
- **Inkscape** - Vector graphics editor

## Configuration Files

### Shell Configuration
- **Shared**: `home/.shared_shell_config` (loaded by both shells)
- **Bash**: `home/.bash_profile`, `home/.bash_functions`
- **Zsh**: `home/.zshrc`, `home/.zsh_functions`
- **OS-specific**: `-macos` and `-linux` variants

### Git Configuration
- **Base**: `home/.gitconfig-base` (common settings)
- **GUI**: `home/.gitconfig-gui` (Sublime Merge, Sublime Text editor)
- **CLI**: `home/.gitconfig-nogui` (Neovim editor, delta pager)

The final `~/.gitconfig` is assembled automatically based on GUI detection.

#### Git Commit Messages with Gemini AI
This setup includes automatic commit message generation using Google Gemini AI. The commit hooks automatically generate commit messages based on your staged changes and verify that the message file was saved before committing.

**Hooks:**
- `prepare-commit-msg`: Generates commit message suggestions using Gemini AI
- `commit-msg`: Verifies that the commit message file was saved (prevents commits when editor is closed without saving)

The hooks are located in `home/.git_hooks/` and are automatically installed to `~/.git_hooks/` when running `mise run apply:files`.

**Language Configuration:**
Set the `GIT_COMMIT_LANG` environment variable to control the language of generated commit messages:

```bash
# Portuguese (Brazilian) - default for pt
export GIT_COMMIT_LANG=pt-BR

# English (American) - default for en (also the fallback)
export GIT_COMMIT_LANG=en

# Spanish
export GIT_COMMIT_LANG=es

# Any other language supported by Gemini
export GIT_COMMIT_LANG=fr  # French
export GIT_COMMIT_LANG=de  # German
export GIT_COMMIT_LANG=ja  # Japanese
# etc...
```

**Note:** 
- English (American) is the default if `GIT_COMMIT_LANG` is not set
- Portuguese codes (`pt`, `pt-BR`, etc.) default to Brazilian Portuguese
- All other language codes are passed directly to Gemini
- The commit will be aborted if you exit the editor without saving the message file

Add `export GIT_COMMIT_LANG=pt-BR` (or your preferred language) to your `~/.bash_profile` or `~/.zshrc` to set it permanently.

### Git Hooks
- `home/.git_hooks/prepare-commit-msg` - Generates commit messages using Gemini AI
- `home/.git_hooks/commit-msg` - Verifies commit message file was saved

Hooks are automatically installed to `~/.git_hooks/` and configured as global Git hooks.

### Other Configurations
- `home/.tmux.conf` - Tmux configuration
- `home/.ssh/config-*` - SSH configuration (OS-specific)
- `home/.gnupg/` - GPG configuration with 1Password integration

## Adding Configurations

1. Edit files in `home/` directory
2. Run `mise run apply:files` to apply changes
3. Reload shell: `source ~/.bash_profile` or `source ~/.zshrc`

## Updating Dotfiles

To update your dotfiles from the repository:

```bash
git pull origin master  # or 'main' depending on your default branch
mise run apply
```

This will:
1. Pull the latest changes from the repository
2. Reapply all configurations, packages, and dotfiles
3. Show instructions to reload your shell if needed

**Note**: After updating, you may need to reload your shell configuration:
```bash
source ~/.bash_profile  # for Bash
source ~/.zshrc         # for Zsh
```

## Private Files

Private files (not versioned) are automatically loaded if they exist:
- `~/.bash_private`
- `~/.zshrc_private`
- `~/.shared_shell_config_private`

## Troubleshooting

**Files not loading?**
- Ensure packages are installed: `mise run apply:install`
- Check if files were copied: `mise run apply:files`

**Commands not found?**
- Ensure packages are installed: `mise run apply:install`
- Check if `~/.shared_shell_config` is loaded

**Git/SSH/GPG issues?**
- GPG key is automatically imported from 1Password when copying dotfiles (if authenticated)
- Verify 1Password CLI is installed and authenticated: `op signin`
- If key wasn't imported, ensure you're signed in and run `mise run apply:files` again

## License

This project is licensed under the **WTFPL (Do What The Fuck You Want To Public License)**.

See [LICENSE](LICENSE) file for details.

Personal project. Feel free to use as reference.
