# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Global AI agent collection in `agents/`: meta-skills (`project`,
  `project-new`, `project-update`, `project-doctor`, `new-skill`,
  `security-check`) with 21 per-project skill templates living inside the
  `project` skill (`SKILL.template.md`, inert until copied into a project)
- `./dotfiles apply:agents` command symlinking the collection into Claude
  Code, Codex, agents.md and Antigravity global dirs, plus
  `agents/AGENTS.md` as global instructions
- `mise run skills:check` task validating the collection structure
- `docs/agents.md` documenting the collection, scopes and symlink targets
- macOS apps: Audio Manager, 1Password for Safari, Color Picker, iQR,
  Dipper (App Store); `codex` cask
- Support for macOS and Linux (Ubuntu/Debian)
- Bash and Zsh shell configurations with shared config
- Git configuration with SSH, GPG signing, and delta pager
- 1Password integration for SSH and GPG keys
- Multiple Rust utilities (dust, procs, bottom, ouch, tealdeer, hyperfine, gitui, atuin, navi)
- Docker installation for both macOS and Linux
- Android SDK installation
- Multiple IDEs: Neovim, Sublime Text, IntelliJ IDEA, Antigravity IDE, Cursor, VS Code
- Antigravity CLI (`agy`) installed in all environments (macOS + Linux)
- Comprehensive application installation for macOS and Linux
- fzf (fuzzy finder) for enhanced command-line experience
- `update` command to easily update dotfiles from repository
- Enhanced `check` command with more comprehensive verification
- LICENSE file (WTFPL)
- CHANGELOG.md for tracking changes
- .gitignore for repository management

### Changed
- Migrated from Makefile to subcommand-based script (`./dotfiles`)
- Improved OS-specific file handling with suffix removal
- Optimized PGP signing with 1Password pinentry wrapper
- Replaced git-extras with hub (GitHub CLI)
- Migrated from Snap to apt/Flatpak for Linux applications
- Install the Antigravity hub app and Antigravity IDE from Google's official tarball updater on Linux (replacing the deprecated `antigravity-debian` apt package); macOS now uses the `antigravity`, `antigravity-cli` and `antigravity-ide` Homebrew casks
- Enhanced README with Requirements section and better documentation
- Repository documentation, code comments and new commit messages converted
  to English (chat replies to the user stay in pt-BR)
- Renamed the `docker` cask to `docker-desktop` (upstream rename)

### Removed
- Audio Lock (App Store app no longer available; replaced by Audio Manager)

### Fixed
- Fixed bash-completion nosort error by installing updated bash
- Fixed PGP commit signing timeout issues
- Improved Android SDK installation to avoid reinstalling on every run

## [1.0.0] - 2025-11-23

### Added
- Initial release

