(add-to-list 'el-get-sources
  '(:name rainbow-delimiters
    :type elpa
    :post-init (progn
      (require 'rainbow-delimiters)
      (global-rainbow-delimiters-mode))))
