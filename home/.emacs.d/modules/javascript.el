(add-to-list 'el-get-sources
  '(:name js2-mode
    :type git
    :url "https://github.com/mooz/js2-mode.git"
    :prepare (autoload 'js2-mode "js2-mode" nil t)
    :post-init (progn
      (autoload 'js2-mode "js2-mode" nil t)
      (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

      (setq js-indent-level 2)
      (setq js2-basic-offset 2)
      (setq js2-cleanup-whitespace t)

    )))


(add-to-list 'el-get-sources
  '(:name coffee-mode))

