# Hammerspoon (macOS)

[Hammerspoon](https://www.hammerspoon.org/) is a macOS automation tool that
exposes the OS internals to Lua. This repo uses it only for **window
management** — tiling and moving windows between monitors with keyboard
shortcuts.

Linux users can skip this document; Hammerspoon is macOS-only.

## Install

Hammerspoon is installed by `./dotfiles apply:install` on macOS via Homebrew
Cask (`brew install --cask hammerspoon`). On first launch, grant it
Accessibility permission in **System Settings → Privacy & Security**.

## Files

| Path | Purpose |
|------|---------|
| [`home/.hammerspoon/init.lua`](../home/.hammerspoon/init.lua) | Window management bindings + auto-reload watcher |

`./dotfiles apply:files` copies the directory to `~/.hammerspoon/`.

## Keybindings

The base modifier is **`Ctrl + Alt + Cmd`** (a chord rarely captured by other
apps).

| Chord | Action |
|-------|--------|
| `Ctrl+Alt+Cmd + M` | Maximize the focused window |
| `Ctrl+Alt+Cmd + ←` | Left 60% of screen (full height) |
| `Ctrl+Alt+Cmd + →` | Right 40% of screen (full height) |
| `Ctrl+Alt+Cmd + ↑` | Right 40% wide × top 70% of height |
| `Ctrl+Alt+Cmd + ↓` | Right 40% wide × bottom 30% of height |
| `Ctrl+Alt + ←` | Move focused window to **previous** monitor |
| `Ctrl+Alt + →` | Move focused window to **next** monitor |

The asymmetric 60/40 split is intentional — Sublime Text / IDEs on the wider
left, terminal / docs on the narrower right.

## Design

### Instant snaps

```lua
hs.window.animationDuration = 0
```

Disables the default fade/slide animation. Windows jump to their new position
instantly, which feels much more responsive when chording bindings.

### Grid-based geometry

Sizing uses `hs.grid` instead of raw frame math:

```lua
hs.grid.setGrid("10x10")
hs.grid.setMargins({0, 0})

-- e.g. left-60% becomes:
hs.grid.set(win, {x = 0, y = 0, w = 6, h = 10})
```

A 10×10 grid gives exact 60/40, 70/30, 50/50, etc. splits without floating
point arithmetic. Margins are zero — set them to `{4, 4}` if you want gaps
between snapped windows.

### Auto-reload on save

```lua
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
  for _, file in ipairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end):start()
```

Any `.lua` file saved under `~/.hammerspoon/` triggers `hs.reload()`. The
**"Hammerspoon loaded"** alert at the bottom confirms it picked up changes.

This lets you iterate on bindings without quitting Hammerspoon from the menu
bar each time:

1. Edit `home/.hammerspoon/init.lua` in the repo
2. `./dotfiles apply:files` (copies to `~/.hammerspoon/init.lua`)
3. The watcher fires; alert appears; new bindings are live

## Extending

The Hammerspoon API surface is huge — see [the
docs](https://www.hammerspoon.org/docs/index.html). Common additions:

- **App launchers:** `hs.application.launchOrFocus("Sublime Text")` bound to
  a hotkey.
- **Caffeine-equivalent:** `hs.caffeinate.set("displayIdle", true, true)`
  to prevent screen sleep on demand.
- **Focus a monitor by index:** `hs.screen.allScreens()[2]:setPrimary()`.
- **Visual workspace indicators:** `hs.alert.show()` on focus changes between
  monitors (already used here for prev/next).

When adding new bindings, follow the existing pattern in `init.lua`:

```lua
local function bindGrid(chord, geom)
  hs.hotkey.bind(mash, chord, function()
    local win = hs.window.focusedWindow()
    if win then hs.grid.set(win, geom) end
  end)
end

bindGrid("H", {x = 0, y = 0, w = 5, h = 10})  -- exact left half
bindGrid("L", {x = 5, y = 0, w = 5, h = 10})  -- exact right half
```

## Why Hammerspoon vs alternatives

- **Rectangle / Magnet:** simpler, mouse-friendly, no Lua. Good if you only
  want tiling shortcuts and no automation.
- **Yabai:** tiling window manager (not just shortcuts). Requires disabling
  SIP, which is too invasive for most setups.
- **Hammerspoon:** scriptable, doesn't touch SIP, and the same Lua runtime
  can grow into menubar tools, app launchers, network event reactions, etc.
  Pays off if you'll add more automation over time.

This config sits at the lightest end of the Hammerspoon spectrum — purely
keyboard tiling — but the framework is there if you want to grow it.
