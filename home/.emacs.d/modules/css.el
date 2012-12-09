(require 'css-mode)

(autoload 'css-mode "css-mode" nil t)
(add-hook 'css-mode-hook '(lambda ()
                              (coding-hook)
                              (setq css-indent-level 2)
                              (setq css-indent-offset 2)))
