(add-to-list 'el-get-sources
  '(:name find-file-in-project
    :post-init (progn
      (require 'find-file-in-project)
      (setq ffip-patterns
            '("*.json" "*.html" "*.org" "*.txt" "*.md" "*.el" "*.clj" "*.py" "*.rb" "*.js" "*.less" "Procfile"
              "*.hbs" "*.handlebars" "*.coffee" "*.json"
              "*.pl" "*.sh" "*.erl" "*.hs" "*.ml" "*.css" "*.scss" "*.sass" "*.haml" "*.slim" "Gemfile" "*.erb"))

      (setq ffip-find-options "-not -regex \".*/\.tmp/.*\" -not -regex \".*/bower_components/.*\" -not -regex \".*/node_modules/.*\" -not -regex \".*/vendor/.*\" -not -regex \".*/public/system/.*\"")

      (global-set-key (kbd "C-x f") 'find-file-in-project)
    )))
