(add-to-list 'el-get-sources
  '(:name mustache-mode
    :post-init (progn
                  (autoload 'mustache-mode "mustache-mode")
                  (add-hook 'mustache-mode-hook (lambda ()
                                              (coding-hook))))))




