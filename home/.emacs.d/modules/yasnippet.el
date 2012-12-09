
(push '(:name yasnippet
              :website "https://github.com/capitaomorte/yasnippet.git"
              :description "YASnippet is a template system for Emacs."
              :type github
              :pkgname "capitaomorte/yasnippet"
              :features "yasnippet"
              :compile "yasnippet.el"
              :post-init (progn
                (yas/load-directory "~/.emacs.d/snippets")))
      el-get-sources)

