const Mainloop = imports.mainloop
const Config = imports.misc.config

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
        withFocus((app, space) => {
          app.move_resize_frame(true, space.x, space.y, space.width * 0.6, space.height)
        }),
      )

      keyManager.add(
        '<Control><Super><Alt>right',
        withFocus((app, space) => {
          app.move_resize_frame(true, space.x + space.width * 0.6, space.y, space.width * 0.4, space.height)
        }),
      )

      keyManager.add(
        '<Control><Super><Alt>up',
        withFocus((app, space) => {
          app.move_resize_frame(true, space.x + space.width * 0.6, space.y, space.width * 0.4, space.height * 0.7)
        }),
      )

      keyManager.add(
        '<Control><Super><Alt>down',
        withFocus((app, space) => {
          app.move_resize_frame(true, space.x + space.width * 0.6, space.y + space.height * 0.7, space.width * 0.4, space.height * 0.3)
        }),
      )

      keyManager.add(
        '<Control><Super><Alt>m',
        withFocus((app, space) => {
          app.move_resize_frame(true, space.x, space.y, space.width, space.height)
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
    const app = global.display.focus_window
    if (!app) return
    const space = app.get_work_area_current_monitor()
    if (app.maximized_horizontally || app.maximizedVertically) app.unmaximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL)
    cb(app, space)
  }
}
