(add-to-list 'el-get-sources
  '(:name js3-mode
     :post-init (progn
                  (autoload 'js3-mode "js3-mode" nil t)
                  (add-to-list 'auto-mode-alist '("\\.js$" . js3-mode))
                  (setq js-indent-level 2)
                  (setq js3-basic-offset 2)
                  (setq js3-cleanup-whitespace t)
                  (add-hook 'js3-mode-hook '(lambda ()
                                              (coding-hook)
                                              (auto-complete-mode))))))


(add-to-list 'el-get-sources
  '(:name coffee-mode
    :post-init (progn 
                  (autoload 'coffee-mode "coffee-mode")
                  (add-hook 'coffee-mode-hook (lambda ()
                                              (coding-hook)
                                              (auto-complete-mode))))))




