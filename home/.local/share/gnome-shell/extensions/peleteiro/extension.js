const Meta = imports.gi.Meta
const Main = imports.ui.main
const Mainloop = imports.mainloop;
const Gio = imports.gi.Gio;

let _close = 50;
var debug = false;

var _log = function(){}
if (debug)
	_log = log.bind(window.console);

const Config = imports.misc.config;
window.gsconnect = {
	    extdatadir: imports.misc.extensionUtils.getCurrentExtension().path,
	    shell_version: parseInt(Config.PACKAGE_VERSION.split('.')[1], 10)
};
imports.searchPath.unshift(gsconnect.extdatadir);

const KeyBindings = imports.keybindings
let keyManager = null;
var oldbindings = {
	unmaximize: [],
	maximize: [],
	toggle_tiled_left: [],
	toggle_tiled_right: []
}

function isClose(a, b) {
	if (a <= b && a > b - _close)
		return true;
	else if (a >= b && a < b + _close)
		return true;
	else
		return false;
}

function getPosition(app, space) {
	let window = app.get_frame_rect()
	_log("window.x: "+window.x+" window.y: "+window.y+" window.width: "+window.width+" window.height: "+window.height)
	_log("space.x: "+space.x+" space.y: "+space.y+" space.width: "+space.width+" space.height: "+space.height+" space.width/2: "+Math.floor(space.width/2)+" space.height/2: "+Math.floor(space.height/2))
	if (isClose(window.x, space.x) && isClose(window.y, space.y)) {
		// X,Y in upper left
		if (isClose(window.height, space.height) && isClose(window.width, space.width)) {
			// Maximized
			return "maximized"
		} else if (isClose(window.height, space.height) && isClose(window.width, space.width/2)) {
			// Left
			return "left"
		} else if (isClose(window.height, space.height/2) && isClose(window.width, space.width)) {
			// Top
			return "top"
		} else if (isClose(window.height, space.height/2) && isClose(window.width, space.width/2)) {
			// Top-left
			return "topleft"
		}
	} else if (isClose(window.x, space.width/2+space.x) && isClose(window.y, space.y)) {
		// X, Y in middle upper
		if (isClose(window.height, space.height) && isClose(window.width, space.width/2)) {
			// Right
			return "right"
		} else if (isClose(window.height, space.height/2) && isClose(window.width, space.width/2)) {
			// Top-right
			return "topright"
		}
	} else if (isClose(window.x, space.x) && isClose(window.y, space.height/2+space.y)) {
		// X, Y in middle left
		if (isClose(window.height, space.height/2) && isClose(window.width, space.width)) {
			// Bottom
			return "bottom"
		} else if (isClose(window.height, space.height/2) && isClose(window.width, space.width/2)) {
			// Bottom-left
			return "bottomleft"
		}
	} else if (isClose(window.x, space.width/2+space.x) && isClose(window.y, space.height/2+space.y)) {
		// X, Y in middle
		if (isClose(window.height, space.height/2) && isClose(window.width, space.width/2)) {
			// Bottom-right
			return "bottomright"
		}
	}
	// Floating
	return "floating"
}

function placeWindow(loc, app) {
	_log("placeWindow: " + loc);
	let x, y, w, h = 0
	var space = app.get_work_area_current_monitor()
	switch (loc) {
		case "left":
			x = space.x;
			y = space.y;
			w = Math.floor(space.width/2);
			h = space.height;
			if (!app.maximizedVertically)
				app.maximize(Meta.MaximizeFlags.VERTICAL)
			if (app.maximized_horizontally)
				app.unmaximize(Meta.MaximizeFlags.HORIZONTAL);
			app.move_resize_frame(true, x, y, w, h)
			break;
		case "topleft":
			x = space.x;
			y = space.y;
			w = Math.floor(space.width/2);
			h = Math.floor(space.height/2);
			if (app.maximized_horizontally || app.maximizedVertically)
				app.unmaximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL);
			app.move_resize_frame(true, x, y, w, h)
			break;
		case "bottomleft":
			x = space.x;
			y = Math.floor(space.height/2)+space.y;
			w = Math.floor(space.width/2);
			h = Math.floor(space.height/2);
			if (app.maximized_horizontally || app.maximizedVertically)
				app.unmaximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL);
			app.move_resize_frame(true, x, y, w, h)
			break;
		case "right":
			x = Math.floor(space.width/2+space.x);
			y = space.y;
			w = Math.floor(space.width/2);
			h = space.height;
			if (!app.maximizedVertically)
				app.maximize(Meta.MaximizeFlags.VERTICAL)
			if (app.maximized_horizontally)
				app.unmaximize(Meta.MaximizeFlags.HORIZONTAL);
			app.move_resize_frame(true, x, y, w, h)
			break;
		case "topright":
			x = Math.floor(space.width/2+space.x);
			y = space.y;
			w = Math.floor(space.width/2);
			h = Math.floor(space.height/2);
			if (app.maximized_horizontally || app.maximizedVertically)
				app.unmaximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL);
			app.move_resize_frame(true, x, y, w, h)
			break;
		case "bottomright":
			x = Math.floor(space.width/2+space.x);
			y = Math.floor(space.height/2)+space.y;
			w = Math.floor(space.width/2);
			h = Math.floor(space.height/2);
			if (app.maximized_horizontally || app.maximizedVertically)
				app.unmaximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL);
			app.move_resize_frame(true, x, y, w, h)
			break;
		case "maximize":
			if (!app.maximized_horizontally || !app.maximizedVertically)
				app.maximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL);
			break;
		case "floating":
			if (app.maximized_horizontally || app.maximizedVertically)
				app.unmaximize(Meta.MaximizeFlags.HORIZONTAL | Meta.MaximizeFlags.VERTICAL);
			break;
	}
	let window = app.get_frame_rect()
	_log("window.x: "+window.x+" window.y: "+window.y+" window.width: "+window.width+" window.height: "+window.height)
}

function getMonitorArray() {
	var monitors = [];
	for (var i = 0; i < Main.layoutManager.monitors.length; i++) {
		monitors.push({ "index": i, "x": Main.layoutManager.monitors[i].x });
	}
	monitors.sort(function(a, b) {
		    return a.x - b.x;
	});
	for (var i = 0; i < monitors.length; i++) {
		_log(JSON.stringify(monitors[i]));
	}
	//var monitors = Main.layoutManager.monitors;
	//monitors.sort(function(a, b) {
	//});
	//let monWidth = Main.layoutManager.monitors[mon].width;
	//let monHeight = Main.layoutManager.monitors[mon].height;
	//_log("mon: " + mon);
}

function moveWindow(direction) {
	_log("moveWindow: " + direction);
	var app = global.display.focus_window;
	var space = app.get_work_area_current_monitor()
	let pos = getPosition(app, space);
	_log("pos: " + pos);
	//var monitors = getMonitorArray();
	var curMonitor = app.get_monitor();
	let monitorToLeft = -1;
	let monitorToRight = -1;
	for (var i = 0; i < Main.layoutManager.monitors.length; i++) {
		if (Main.layoutManager.monitors[i].x < Main.layoutManager.monitors[curMonitor].x && (monitorToLeft == -1 || (monitorToLeft >= 0 && Main.layoutManager.monitors[i].x > Main.layoutManager.monitors[monitorToLeft].x)))
			monitorToLeft = i;
		if (Main.layoutManager.monitors[i].x > Main.layoutManager.monitors[curMonitor].x && (monitorToRight == -1 || (monitorToRight >= 0 && Main.layoutManager.monitors[i].x < Main.layoutManager.monitors[monitorToRight].x)))
			monitorToRight = i;
	}
	_log("monitorToLeft: " + monitorToLeft);
	_log("monitorToRight " + monitorToRight);

	switch (direction) {
		case "left":
			if (pos == "left" && monitorToLeft != -1) {
				app.move_to_monitor(monitorToLeft);
				placeWindow("right", app);
			} else if (pos == "topleft" && monitorToLeft != -1) {
				app.move_to_monitor(monitorToLeft);
				placeWindow("topright", app);
			} else if (pos == "bottomleft" && monitorToLeft != -1) {
				app.move_to_monitor(monitorToLeft);
				placeWindow("bottomright", app);
			} else if (pos == "topright") {
				placeWindow("topleft", app);
			} else if (pos == "bottomright") {
				placeWindow("bottomleft", app);
			} else {
				placeWindow("left", app);
			}
			break;
		case "right":
			if (pos == "right" && monitorToRight != -1) {
				app.move_to_monitor(monitorToRight);
				placeWindow("left", app);
			} else if (pos == "topright" && monitorToRight != -1) {
				app.move_to_monitor(monitorToRight);
				placeWindow("topleft", app);
			} else if (pos == "bottomright" && monitorToRight != -1) {
				app.move_to_monitor(monitorToRight);
				placeWindow("bottomleft", app);
			} else if (pos == "topleft") {
				placeWindow("topright", app);
			} else if (pos == "bottomleft") {
				placeWindow("bottomright", app);
			} else {
				placeWindow("right", app);
			}
			break;
		case "up":
			if (pos == "left")
				placeWindow("topleft", app);
			else if (pos == "bottomleft")
				placeWindow("left", app);
			else if (pos == "right")
				placeWindow("topright", app);
			else if (pos == "bottomright")
				placeWindow("right", app);
			else
				placeWindow("maximize", app);
			break;
		case "down":
			if (pos == "left")
				placeWindow("bottomleft", app);
			else if (pos == "topleft")
				placeWindow("left", app);
			else if (pos == "right")
				placeWindow("bottomright", app);
			else if (pos == "topright")
				placeWindow("right", app);
			else if (pos == "maximized")
				placeWindow("floating", app);
			break;
	}
}

function requestMove(direction) {
	Mainloop.timeout_add(10, function () {
		moveWindow(direction);
	});
}

function changeBinding(settings, key, oldBinding, newBinding) {
	var binding = oldbindings[key.replace(/-/g, '_')];
	var _newbindings = [];
	for (var i = 0; i < binding.length; i++) {
		let currentbinding = binding[i];
		if (currentbinding == oldBinding)
			currentbinding = newBinding;
		_newbindings.push(currentbinding)
	}
	settings.set_strv(key, _newbindings);
}

function resetBinding(settings, key) {
	var binding = oldbindings[key.replace(/-/g, '_')];
	settings.set_strv(key, binding);
}

var enable = function() {
	if (!keyManager) {
		keyManager = new KeyBindings.Manager();
		let desktopSettings = new Gio.Settings({ schema_id: 'org.gnome.desktop.wm.keybindings' });
		let mutterSettings = new Gio.Settings({ schema_id: 'org.gnome.mutter.keybindings' });
		oldbindings['unmaximize'] = desktopSettings.get_strv('unmaximize');
		oldbindings['maximize'] = desktopSettings.get_strv('maximize');
		oldbindings['toggle_tiled_left'] = mutterSettings.get_strv('toggle-tiled-left');
		oldbindings['toggle_tiled_right'] = mutterSettings.get_strv('toggle-tiled-right');
		changeBinding(desktopSettings, 'unmaximize', '<Super>Down', '<Control><Shift><Super>Down');
		changeBinding(desktopSettings, 'maximize', '<Super>Up', '<Control><Shift><Super>Up');
		changeBinding(mutterSettings, 'toggle-tiled-left', '<Super>Left', '<Control><Shift><Super>Left');
		changeBinding(mutterSettings, 'toggle-tiled-right', '<Super>Right', '<Control><Shift><Super>Right');
		Mainloop.timeout_add(3000, function() {
			keyManager.add("<Super>left", function() { requestMove("left") })
			keyManager.add("<Super>right", function() { requestMove("right") })
			keyManager.add("<Super>up", function() { requestMove("up") })
			keyManager.add("<Super>down", function() { requestMove("down") })
		});
	}
}

var disable = function() {
	if (keyManager) {
		keyManager.removeAll();
		keyManager.destroy();
		keyManager = null;
		let desktopSettings = new Gio.Settings({ schema_id: 'org.gnome.desktop.wm.keybindings' });
		let mutterSettings = new Gio.Settings({ schema_id: 'org.gnome.mutter.keybindings' });
		resetBinding(desktopSettings, 'unmaximize');
		resetBinding(desktopSettings, 'maximize');
		resetBinding(mutterSettings, 'toggle-tiled-left');
		resetBinding(mutterSettings, 'toggle-tiled-right');
	}
}
