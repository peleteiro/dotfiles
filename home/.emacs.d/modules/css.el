(add-to-list 'el-get-sources '(:name css-mode))
(add-to-list 'el-get-sources '(:name auto-complete-css))

(autoload 'css-mode "css-mode" nil t)
(add-hook 'css-mode-hook '(lambda ()
                              (coding-hook)
                              (setq css-indent-level 2)
                              (setq css-indent-offset 2)))
