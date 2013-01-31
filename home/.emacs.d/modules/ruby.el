(add-to-list 'el-get-sources '(:name inf-ruby))

(add-to-list 'el-get-sources '(:name ruby-compilation))

(add-to-list 'el-get-sources '(:name auto-complete-ruby))

(add-to-list 'el-get-sources '(:name flymake-ruby))

;;(add-to-list 'el-get-sources '(:name ruby-electric))

(add-to-list 'el-get-sources
  '(:name ruby-mode
    :post-init (progn
      (autoload 'ruby-mode "ruby-mode" nil t)
      (add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
      (add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
      (add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
      (add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
      (add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
      (add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
      (add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
      (add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))
      (add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))

      ;; We never want to edit Rubinius bytecode
      (add-to-list 'completion-ignored-extensions ".rbc")

      (autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")

      (setq ruby-block-highlight-toggle 'overlay)

      (add-hook 'ruby-mode-hook '(lambda ()
                                   (coding-hook)
                                   (setq ruby-deep-arglist t)
                                   (setq ruby-deep-indent-paren nil)
                                   (setq c-tab-always-indent nil)
                                   (require 'ruby-compilation))))))

(if (executable-find "rvm")
    (add-to-list 'el-get-sources
                 '(:name rvm
                   :type git
                   :url "http://github.com/djwhitt/rvm.el.git"
                   :load "rvm.el"
                   :post-init (progn
                                (rvm-use-default)))))
