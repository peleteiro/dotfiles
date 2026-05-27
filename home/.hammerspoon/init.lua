-- Hammerspoon configuration (macOS only)
-- Window management + monitor focus, using hs.grid for clean geometry.

-- Snap instantly instead of animating
hs.window.animationDuration = 0

-- 10×10 grid: exact 60/40 splits, no margins
hs.grid.setGrid("10x10")
hs.grid.setMargins({0, 0})

local mash = {"ctrl", "alt", "cmd"}

-- Helper: bind `chord` to placing the focused window at a grid `geom`
local function bindGrid(chord, geom)
  hs.hotkey.bind(mash, chord, function()
    local win = hs.window.focusedWindow()
    if win then hs.grid.set(win, geom) end
  end)
end

-- Maximize
hs.hotkey.bind(mash, "M", function()
  local win = hs.window.focusedWindow()
  if win then hs.grid.maximizeWindow(win) end
end)

-- 60% left / 40% right (asymmetric — matches original config)
bindGrid("Left",  {x = 0, y = 0, w = 6, h = 10})
bindGrid("Right", {x = 6, y = 0, w = 4, h = 10})

-- 40% wide × 70% tall at top-right
bindGrid("Up",    {x = 6, y = 0, w = 4, h = 7})

-- 40% wide × 30% tall at bottom-right
bindGrid("Down",  {x = 6, y = 7, w = 4, h = 3})

-- Move focused window to adjacent monitor
hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
  local win = hs.window.focusedWindow()
  if win then
    hs.alert.show("← Prev Monitor", 0.5)
    win:moveToScreen(win:screen():previous())
  end
end)
hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
  local win = hs.window.focusedWindow()
  if win then
    hs.alert.show("Next Monitor →", 0.5)
    win:moveToScreen(win:screen():next())
  end
end)

-- Auto-reload config when any .lua under ~/.hammerspoon/ is saved
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
  for _, file in ipairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end):start()

hs.alert.show("Hammerspoon loaded", 1)
