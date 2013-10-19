(add-to-list 'el-get-sources
  '(:name yasnippet
    :post-init (progn
      (yas/load-directory "~/.emacs.d/snippets"))))

