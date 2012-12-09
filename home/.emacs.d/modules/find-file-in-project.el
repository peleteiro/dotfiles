(add-to-list 'el-get-sources
  '(:name find-file-in-project
    :type elpa
    :post-init (progn
      (require 'find-file-in-project)
      (setq ffip-patterns
            '("*.json" "*.html" "*.org" "*.txt" "*.md" "*.el" "*.clj" "*.py" "*.rb" "*.js" "*.less" "Procfile"
              "*.pl" "*.sh" "*.erl" "*.hs" "*.ml" "*.css" "*.scss" "*.sass" "*.haml" "*.slim" "Gemfile" "*.erb"))

      (setq ffip-find-options "-not -regex \".*/node_modules/.*\" -not -regex \".*/vendor/.*\" -not -regex \".*/public/system/.*\"")

      (global-set-key (kbd "C-x f") 'find-file-in-project)
    )))
