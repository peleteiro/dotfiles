hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  win:setFrame(max)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  max.w = max.w * 0.6
  win:setFrame(max)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  max.x = max.w - (max.w * 0.4)
  max.w = max.w * 0.4
  win:setFrame(max)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  max.x = max.w - (max.w * 0.4)
  max.w = max.w * 0.4
  max.h = max.h * 0.7
  win:setFrame(max)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  max.x = max.w - (max.w * 0.4)
  max.w = max.w * 0.4
  max.y = max.y + (max.h - (max.h * 0.3))
  max.h = max.h * 0.3
  win:setFrame(max)
end)
