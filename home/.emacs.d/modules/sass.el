(add-to-list 'el-get-sources
  '(:name scss-mode
    :type elpa
    :post-init (progn
            (require 'scss-mode)
            (add-hook 'scss-mode-hook '(lambda ()
                                         (coding-hook)
                                         (setq css-indent-offset 2)
                                         ;; turn off annoying auto-compile on save
                                         (setq scss-compile-at-save nil))))))




