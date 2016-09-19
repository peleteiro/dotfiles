hs.hotkey.bind({"ctrl", "alt", "cmd"}, "M", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  win:setFrame(max)
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  max.w = max.w * 0.6
  win:setFrame(max)
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  max.x = max.w - (max.w * 0.4)
  max.w = max.w * 0.4
  win:setFrame(max)
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  max.x = max.w - (max.w * 0.4)
  max.w = max.w * 0.4
  max.h = max.h * 0.7
  win:setFrame(max)
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  max.x = max.w - (max.w * 0.4)
  max.w = max.w * 0.4
  max.y = max.y + (max.h - (max.h * 0.3))
  max.h = max.h * 0.3
  win:setFrame(max)
end)

hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
  hs.alert.show("Prev Monitor")
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():previous()
  win:moveToScreen(nextScreen)
end)

hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
  hs.alert.show("Next Monitor")
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():next()
  win:moveToScreen(nextScreen)
end)
