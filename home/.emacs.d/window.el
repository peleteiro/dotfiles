(setq pop-up-windows nil)
(setq same-window-regexps '("^\*"))

(global-set-key (kbd "C-M-S-<down>") (lambda () (interactive) (swap-window-with 'down)))
(global-set-key (kbd "C-M-S-<up>") (lambda () (interactive) (swap-window-with 'up)))
(global-set-key (kbd "C-M-S-<left>") (lambda () (interactive) (swap-window-with 'left)))
(global-set-key (kbd "C-M-S-<right>") (lambda () (interactive) (swap-window-with 'right)))

(global-set-key (kbd "M-S-<up>") (lambda () (interactive) (enlarge-window 1)))
(global-set-key (kbd "M-S-<down>") (lambda () (interactive) (enlarge-window -1)))
(global-set-key (kbd "M-S-<right>") (lambda () (interactive) (enlarge-window -1 t)))
(global-set-key (kbd "M-S-<left>") (lambda () (interactive) (enlarge-window 1 t)))

(defun swap-window-with (dir)
  (interactive)
  (let ((other-window (windmove-find-other-window dir)))
    (when other-window
      (let* ((this-window  (selected-window))
             (this-buffer  (window-buffer this-window))
             (other-buffer (window-buffer other-window))
             (this-start   (window-start this-window))
             (other-start  (window-start other-window)))
        (set-window-buffer this-window  other-buffer)
        (set-window-buffer other-window this-buffer)
        (set-window-start  this-window  other-start)
        (set-window-start  other-window this-start)))))

