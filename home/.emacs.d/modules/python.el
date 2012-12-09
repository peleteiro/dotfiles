
(add-to-list 'el-get-sources
  '(:name python-mode
    :type git
    :url "https://github.com/emacsmirror/python-mode.git"
    :description "Major mode for editing Python programs"
    :features (python-mode doctest-mode)
    :load "test/doctest-mode.el"
    :prepare (progn
               (autoload 'python-mode "python-mode" "Python editing mode." t)
               (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
               (add-to-list 'interpreter-mode-alist '("python" . python-mode)))))

(add-to-list 'el-get-sources
  '(:name python-pep8
    :type emacsmirror
    :description "Minor mode for running `pep8'"
    :features python-pep8
    :post-init (require 'tramp)))


