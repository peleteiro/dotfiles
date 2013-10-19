(add-to-list 'el-get-sources
  '(:name web-mode
    :post-init (progn

      (add-hook 'sgml-mode-hook 'web-mode)

      (add-hook 'web-mode-hook (lambda ()
                            (coding-hook)))

      (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.hbl\\'" . web-mode))      
      (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode)))))
      

