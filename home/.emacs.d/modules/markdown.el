(add-to-list 'el-get-sources
  '(:name markdown
    :type git
    :url "https://github.com/defunkt/markdown-mode.git"
    :load "markdown-mode.el"
    :post-init (progn
             (autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
             (setq markdown-command "/usr/local/bin/markdown")
             (setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))
             (setq auto-mode-alist (cons '("\\.text" . markdown-mode) auto-mode-alist)))))
