;; emacs configuration
(push "/usr/local/bin" exec-path)
(add-to-list 'load-path "~/.emacs.d")

(load "core.el")
(load "window.el")

(load "editor.el")

(load "coding.el")

(load "packages.el")

(load "keybindings.el")
(load "ui.el")

(server-start)

