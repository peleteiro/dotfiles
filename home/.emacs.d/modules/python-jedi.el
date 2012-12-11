
(add-to-list 'el-get-sources '(:name jedi
                               :post-init (progn
                                            (setq jedi:setup-keys t)
                                            (add-hook 'python-mode-hook 'jedi:setup)
                              )))

