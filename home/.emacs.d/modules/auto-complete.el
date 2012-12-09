(add-to-list 'el-get-sources
  '(:name popup
    :url "https://github.com/auto-complete/popup-el.git"
    :type git))

(add-to-list 'el-get-sources
  '(:name fuzzy
    :url "https://github.com/auto-complete/fuzzy-el.git"
    :type git))

(add-to-list 'el-get-sources
  '(:name auto-complete
    :url "https://github.com/auto-complete/auto-complete.git"
    :type git
    :depends (popup fuzzy)
    :post-init (progn
                 (require 'auto-complete)
                 (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
                 (require 'auto-complete-config)
                 (setq ac-auto-start nil)
                 (ac-set-trigger-key "TAB")
                 (ac-config-default))))
