(add-to-list 'el-get-sources
  '(:name tomorrow-theme
       :type git
       :url "https://github.com/chriskempson/tomorrow-theme.git"
       :description "Colour Schemes for Hackers"
       :website "https://github.com/chriskempson/tomorrow-theme"
       :load-path "GNU Emacs"
       :minimum-emacs-version 24
       :post-init (progn
               (add-to-list 'custom-theme-load-path default-directory))))


(add-to-list 'el-get-sources
  '(:name tomorrow-night-paradise-theme
       :type git
       :url "https://github.com/jimeh/tomorrow-night-paradise-theme.el.git"
       :description "A light-on-dark Emacs theme which is essentially a tweaked version of Chris Kempson's Tomorrow Night Bright theme."
       :website "https://github.com/jimeh/tomorrow-night-paradise-theme.el"
       :minimum-emacs-version 24
       :post-init (progn
               (add-to-list 'custom-theme-load-path default-directory))))


