(require 'cl)
(require 'thingatpt)
(require 'imenu)

;; show-paren-mode: subtle highlighting of matching parens
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;; use shift + arrow keys to switch between visible buffers
(require 'windmove)
(windmove-default-keybindings 'super)

;; fuzzy selection
(require 'ido)
(ido-mode t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-max-prospects 10
      ido-default-file-method 'selected-window)

(setq ido-ignore-buffers '("*scratch*" "\\` " "^\\*ESS\\*" "^\\*Messages\\*" "^\\*Help\\*" "^\\*Buffer" 
                           "^\*.*\*$"
                           "^\\*.*Completions\\*$" "^\\*Ediff" "^\\*tramp" "^\\*cvs-" "_region_" " output\\*$" 
                           "^TAGS$" "^\*Ido"))

(icomplete-mode +1)
(set-default 'imenu-auto-rescan t)

;; use shift + arrow keys to switch between visible buffers
(require 'windmove)
(windmove-default-keybindings 'super)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq c-basic-offset 1)
(setq inhibit-startup-message t)

(setq-default word-wrap nil)
(setq-default truncate-lines t)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq-default fill-column 140)

(fset 'yes-or-no-p 'y-or-n-p)

(delete-selection-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode t)
(show-paren-mode t)
(column-number-mode t)
(set-fringe-style -1)
(tooltip-mode -1)

;; smart indenting and pairing for all
;;(electric-pair-mode t)
;;(electric-indent-mode t)
;;(electric-layout-mode t)

;; meaningful names for buffers with the same name
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; clean up obsolete buffers automatically
(require 'midnight)

;; keep the whitespace decent all the time
(add-hook 'before-save-hook 'whitespace-cleanup)

;; flyspell-mode does spell-checking on the fly as you type
(setq ispell-program-name "aspell" ; use aspell instead of ispell
      ispell-extra-args '("--sug-mode=ultra"))
      (autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)

(defun insert-empty-line ()
  "Insert an empty line after the current line and positon the curson at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (open-line 1)
  (next-line 1)
  (indent-according-to-mode))

;; mimic popular IDEs binding, note that it doesn't work in a terminal session
(global-set-key [(shift return)] 'insert-empty-line)

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

(global-set-key [(meta shift up)] 'move-line-up)

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

(global-set-key [(meta shift down)] 'move-line-down)

(define-key global-map (kbd "RET") 'newline-and-indent)










