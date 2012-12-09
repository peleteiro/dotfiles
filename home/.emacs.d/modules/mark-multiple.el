(add-to-list 'el-get-sources
  '(:name mark-multiple
    :type git
    :url "https://github.com/magnars/mark-multiple.el.git"
    :post-init (progn
      (require 'inline-string-rectangle)
      (global-set-key (kbd "C-x r t") 'inline-string-rectangle)

      (require 'mark-more-like-this)
      (global-set-key (kbd "C-<") 'mark-previous-like-this)
      (global-set-key (kbd "C->") 'mark-next-like-this)
      (global-set-key (kbd "C-M-m") 'mark-more-like-this) ; like the other two, but takes an argument (negative is previous)

      ;(require 'rename-sgml-tag)
      ;(define-key sgml-mode-map (kbd "C-c C-r") 'rename-sgml-tag)

      ;(require 'js2-rename-var)
      ;(define-key js2-mode-map (kbd "C-c C-r") 'js2-rename-var)
    )))





