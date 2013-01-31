(add-to-list 'el-get-sources
  '(:name flymake
          :after (progn
                              (setq flymake-run-in-place nil)
                                          (setq temporary-file-directory (expand-file-name "~/.emacs.d/tmp")))
          ))

(add-to-list 'el-get-sources
             '(:name flymake-easy
               :pkgname flymake-easy
               :type elpa
               ))
