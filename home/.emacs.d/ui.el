(set-frame-font "Menlo-14")

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)
;;(setq-default cursor-type '(bar . 2))

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; make the fringe (gutter) smaller
;; the argument is a width in pixels (the default is 8)
(if (fboundp 'fringe-mode)
    (fringe-mode 4))

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '("" invocation-name " - " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))

;; custom Emacs 24 color themes support
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; (load-theme 'railscasts t)
(load-theme 'peleteiro t)

