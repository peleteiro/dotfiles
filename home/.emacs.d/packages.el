(package-initialize)
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
     "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
      (lambda (s)
           (let (el-get-master-branch)
                (goto-char (point-max))
                (eval-print-last-sexp)))))

(add-to-list 'el-get-recipe-path "~/.emacs.d/recipes")

(add-to-list 'load-path "~/.emacs.d/modules/")
(mapc 'load (directory-files "~/.emacs.d/modules/" nil "^[^#].*el$"))

(el-get 'sync 'el-get (mapcar 'el-get-source-name el-get-sources))
