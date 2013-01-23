(add-to-list 'el-get-sources
  '(:name ace-jump-mode
      :post-init (progn 
                       (require 'ace-jump-mode)
                       (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
                       )))
