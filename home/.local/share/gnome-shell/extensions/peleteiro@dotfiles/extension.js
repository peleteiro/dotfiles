const Mainloop = imports.mainloop
const Config = imports.misc.config
const {GLib, Meta} = imports.gi

window.gsconnect = {
  extdatadir: imports.misc.extensionUtils.getCurrentExtension().path,
  shell_version: parseInt(Config.PACKAGE_VERSION.split('.')[1], 10),
}
imports.searchPath.unshift(gsconnect.extdatadir)

const KeyBindings = imports.keybindings
let keyManager

function init() {}

function enable() {
  if (!keyManager) {
    keyManager = new KeyBindings.Manager()
    Mainloop.timeout_add(3000, function() {
      keyManager.add(
        '<Control><Super><Alt>left',
        withFocus((win, space) => {
          win.move_resize_frame(true, space.x, space.y, space.width * 0.6, space.height)
        }),
      )

      keyManager.add(
        '<Control><Super><Alt>right',
        withFocus((win, space) => {
          win.move_resize_frame(true, space.x + space.width * 0.6, space.y, space.width * 0.4, space.height)
        }),
      )

      keyManager.add(
        '<Control><Super><Alt>up',
        withFocus((win, space) => {
          win.move_resize_frame(true, space.x + space.width * 0.6, space.y, space.width * 0.4, space.height * 0.7)
        }),
      )

      keyManager.add(
        '<Control><Super><Alt>down',
        withFocus((win, space) => {
          win.move_resize_frame(true, space.x + space.width * 0.6, space.y + space.height * 0.7, space.width * 0.4, space.height * 0.3)
        }),
      )

      keyManager.add(
        '<Control><Super><Alt>m',
        withFocus((win, space) => {
          win.move_resize_frame(true, space.x, space.y, space.width, space.height)
        }),
      )
    })
  }
}

function disable() {
  if (keyManager) {
    keyManager.removeAll()
    keyManager.destroy()
    keyManager = null
  }
}

function withFocus(cb) {
  return () => {
    const win = global.display.focus_window
    if (!win) return
    const space = win.get_work_area_current_monitor()
    if (win.maximized_horizontally || win.maximizedVertically) win.unmaximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL)
    cb(win, space)
  }
}
