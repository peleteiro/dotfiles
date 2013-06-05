(add-to-list 'el-get-sources
  '(:name rhtml-mode
    :post-init (progn
      (add-hook 'rhtml-mode '(lambda ()
                               (coding-hook)
                               (define-key rhtml-mode-map (kbd "M-s") 'save-buffer))))))



