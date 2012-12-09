(add-to-list 'el-get-sources
  '(:name less-css-mode
    :type git
    :url "https://github.com/purcell/less-css-mode.git"
    :post-init (progn
      (autoload 'less-css-mode "less-css-mode" nil t)
      (add-hook 'less-css-mode-hook '(lambda ()
                                       (coding-hook)
                                       (setq css-indent-level 2)
                                       (setq css-indent-offset 2))))))
