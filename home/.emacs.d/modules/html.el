(add-to-list 'el-get-sources
  '(:name hl-tags-mode
    :type git
    :url "https://github.com/deactivated/hl-tags-mode.git"
    :load "hl-tags-mode.el"
    :post-init (progn
      (require 'hl-tags-mode)
      (add-hook 'rhtml-mode-hook (lambda () (hl-tags-mode 1)))
      (add-hook 'sgml-mode-hook (lambda () (hl-tags-mode 1)))
      (add-hook 'nxml-mode-hook (lambda () (hl-tags-mode 1))))))

(add-to-list 'el-get-sources
  '(:name multi-web-mode
    :type git
    :url "https://github.com/fgallina/multi-web-mode.git"
    :load "multi-web-mode.el"
    :post-init (progn
      (require 'multi-web-mode)
      (setq mweb-default-major-mode 'html-mode)
      (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                        (js-mode "<script\\( type=\"text/javascript\"\\| language=\"javascript\"\\)?>" "</script>")
                        (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
      (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
      (multi-web-global-mode 1))))


