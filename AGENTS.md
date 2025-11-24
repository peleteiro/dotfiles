# AGENTS.md - Development Rules

## Key Principles

1. **Installation**: Use `./dotfiles` directly (no mise required)
2. **Development**: Use `mise` for lint, test, and debug tasks
3. **No mise tasks for apply**: Removed - use `./dotfiles` directly
4. **Always respond in pt-BR** (Portuguese Brazilian)
5. **Keep README.md updated**: Always update README.md when making changes that affect usage, commands, or project structure

## Code Rules

### Shell Scripts

1. **Linting**: All scripts must pass `mise run lint`
2. **Quoting**: Always quote variables: `"$VAR"` not `$VAR`
3. **Pattern matching**: Quote expansions in `${..}`: `"${var%-"${OS}"}"`
4. **Source files**: Use `# shellcheck disable=SC1091` for optional sources
5. **Continue**: Only use `continue` in loops
6. **Grep**: Use `grep -q` instead of `[ -n "$(grep ...)" ]`
7. **Redirects**: Group multiple redirects: `{ cmd1; cmd2; } >> file`
8. **Project utilities**: Scripts in `home/.bin/` can use any utility installed by the project (e.g., `sd`, `bat`, `rg`, `fzf`, etc.) - they are installed in the environment before scripts are copied

### Git Config Files

1. **Never copy `.gitconfig-gui` or `.gitconfig-nogui`** to home
2. **Only create `.gitconfig`** - assembled from base + gui/nogui
3. **Skip in copy loops**: `if [[ "$filename" == ".gitconfig"* ]]; then continue; fi`
4. **Auto-detect GUI**: Based on `DISPLAY`/`WAYLAND_DISPLAY` or macOS

### File Naming

- Use `nogui` (not `no-gui`) for consistency
- OS suffixes: `-macos` and `-linux`
- Keep suffix files: `.bash_profile-${OS}`, `.shared_shell_config-${OS}`

## Mise Tasks

### Best Practices
- Use `$MISE_CONFIG_ROOT` directly (no fallback needed)
- Always cleanup containers on exit (trap EXIT INT TERM)
- Use process substitution: `< <(find ...)` to avoid subshell issues

### Structure
- Tasks in `.config/mise/tasks/` using directory structure
- `_default` files for main tasks with subtasks
- No default for debug tasks (must specify gui/nogui)

## Testing

### Linux Tests
- Use Docker containers (Ubuntu for GUI, Debian slim for nogui)
- Test `apply:files` only (not config/install - require sudo)
- Verify files copied and `.gitconfig` configuration

### Debug Environments
- `debug:linux:gui`: Ubuntu with VNC server (port auto-detected)
- `debug:linux:nogui`: Debian slim without GUI
- Always cleanup container on bash exit
- VNC password: `password` (default)

## Common Patterns

### OS Detection
```bash
OS=$(uname)
if [ "$OS" = "Darwin" ]; then
  CURRENT_OS="macos"
else
  CURRENT_OS="linux"
fi
```

### GUI Detection
```bash
HAS_GUI=false
if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
  HAS_GUI=true
elif [[ "$(uname)" == "Darwin" ]]; then
  HAS_GUI=true  # macOS always has GUI
fi
```

### Container Cleanup
```bash
cleanup() {
  docker rm -f "$CONTAINER_NAME" > /dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM
```

## Important Notes

1. **No macOS automated tests** - Only manual testing
2. **No GitHub Actions for macOS** - Not worth the complexity
3. **Docker for Linux only** - Can't test macOS in containers
4. **mise is optional** - Only needed for development tasks
5. **Always use `./dotfiles` for installation** - It's the recommended method

## Linting Rules

- All scripts must pass shellcheck
- Fix all errors (SC2105, SC2086, SC2143, etc.)
- Use shellcheck disable comments only when necessary
- Check mise tasks too (not just bin/ scripts)
- **SC2016 with sd/rg**: When using `sd` or `rg` with single quotes for regex patterns, use `# shellcheck disable=SC2016` - this is expected and safe
- Shellcheck configuration: `.shellcheckrc` in project root documents expected patterns
