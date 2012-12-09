;;; peleteiro-theme.el --- A soothing Emacs 24 light-on-dark theme
;;; Inspired on https://github.com/jimeh/twilight-anti-bright-theme

(deftheme peleteiro
  "A soothing light-on-dark theme.")

(let ((background "#000000")
      (foreground "#dcdddd")
      (selection "#313c4d")
      (hl-line "#11151a")
      (cursor "#b4b4b4")
      (comment "#716d73")

      (gray-1 "#878289")   (gray-1bg "#181d23")
      (gray-2 "#2a3441")
      (gray-3 "#b3adb4")   (gray-3bg "#0e1116")
      (gray-4 "#1f2730")
      (gray-5 "#242d38")
      (gray-6 "#192028")
      (red-1 "#d15120")    (red-1bg "#2a1f1f")
      (red-2 "#b23f1e")    (red-2bg "#251c1e")
      (brown-1 "#9f621d")  (brown-1bg "#2a1f1f")
      (orange-1 "#d97a35") (orange-1bg "#272122")
      (yellow-1 "#deae3e") (yellow-1bg "#2a2921")
      (green-1 "#81af34")  (green-1bg "#1a2321")
      (green-2 "#4e9f75")  (green-2bg "#1a2321")
      (blue-1 "#7e9fc9")   (blue-1bg "#1e252f")
      (blue-2 "#417598")   (blue-2bg "#1b333e")
      (blue-3 "#00959e")   (blue-3bg "#132228")
      (blue-4 "#365e7a")   (blue-4bg "#172028")
      (purple-1 "#a878b5") (purple-1bg "#25222f")
      )

  (custom-theme-set-faces
   'peleteiro

   ;; Basics
   `(default ((t (:background ,background :foreground ,foreground))))
   `(cursor ((t (:background ,cursor))))
   `(region ((t (:background ,selection))))
   `(highlight ((t (:foreground ,blue-3 :background ,blue-3bg))))
   `(hl-line ((t (:background ,hl-line))))
   `(minibuffer-prompt ((t (:foreground ,orange-1 :background ,orange-1bg))))
   `(escape-glyph ((t (:foreground ,purple-1 :background , purple-1bg))))

   ;; Font-lock stuff
   `(font-lock-builtin-face ((t (:foreground ,yellow-1))))
   `(font-lock-constant-face ((t (:foreground ,purple-1))))
   `(font-lock-comment-face ((t (:foreground ,comment :italic t))))
   `(font-lock-doc-face ((t (:foreground ,gray-1))))
   `(font-lock-doc-string-face ((t (:foreground ,gray-1))))
   `(font-lock-function-name-face ((t (:foreground ,red-1))))
   `(font-lock-keyword-face ((t (:foreground ,orange-1))))
   `(font-lock-negation-char-face ((t (:foreground ,yellow-1))))
   `(font-lock-preprocessor-face ((t (:foreground ,orange-1))))
   `(font-lock-string-face ((t (:foreground ,green-1))))
   `(font-lock-type-face ((t (:foreground ,red-2 :bold nil))))
   `(font-lock-variable-name-face ((t (:foreground ,blue-1))))
   `(font-lock-warning-face ((t (:foreground ,red-2))))

   ;; UI related
   `(link ((t (:foreground ,blue-1 :background ,blue-1bg))))
   `(fringe ((t (:background ,gray-1bg))))
   `(mode-line ((t (:foreground ,blue-1 :background ,blue-2bg))))
   `(mode-line-inactive ((t (:foreground ,blue-4 :background ,gray-4))))
   `(vertical-border ((t (:background ,background :foreground ,gray-5))))

   ;; Linum
   `(linum ((t (:foreground ,gray-2 :background ,gray-1bg))))

   ;; show-paren-mode
   `(show-paren-match ((t (:foreground ,orange-1 :background ,orange-1bg))))
   `(show-paren-mismatch ((t (:foreground ,red-2bg :background ,red-2))))

   ;; ido
   `(ido-only-match ((t (:foreground ,green-1 :background ,green-1bg))))
   `(ido-subdir ((t (:foreground ,purple-1 :background ,purple-1bg))))

   ;; whitespace-mode
   `(whitespace-empty ((t (:foreground ,yellow-1bg :background ,yellow-1))))
   `(whitespace-hspace ((t (:foreground ,gray-2))))
   `(whitespace-indentation ((t (:foreground ,gray-2))))
   `(whitespace-line ((t (:background ,gray-2))))
   `(whitespace-newline ((t (:foreground ,gray-2))))
   `(whitespace-space ((t (:foreground ,gray-2))))
   `(whitespace-space-after-tab ((t (:foreground ,gray-2))))
   `(whitespace-tab ((t (:foreground ,gray-2))))
   `(whitespace-trailing ((t (:foreground ,red-1bg :background ,red-1))))

   ;; flyspell-mode
   `(flyspell-incorrect ((t (:underline ,red-2))))
   `(flyspell-duplicate ((t (:underline ,red-2))))

   ;; magit
   `(magit-diff-add ((t (:foreground ,green-1))))
   `(magit-diff-del ((t (:foreground ,red-2))))
   `(magit-item-highlight ((t (:background ,gray-1bg))))

   ;; highlight-indentation-mode
   `(highlight-indentation-face ((t (:background ,gray-1bg))))
   `(highlight-indentation-current-column-face ((t (:background ,gray-4))))

   ;; ECB
   `(ecb-default-general-face ((t (:foreground ,gray-3 :background ,gray-1bg))))
   `(ecb-default-highlight-face ((t (:foreground ,red-1 :background ,red-1bg))))
   `(ecb-method-face ((t (:foreground ,red-1 :background ,red-1bg))))
   `(ecb-tag-header-face ((t (:background ,blue-2bg))))

   ;; org-mode
   `(org-date ((t (:foreground ,purple-1 :background ,purple-1bg))))
   `(org-done ((t (:foreground ,green-1 :background ,green-1bg))))
   `(org-hide ((t (:foreground ,gray-2 :background ,gray-1bg))))
   `(org-link ((t (:foreground ,blue-1 :background ,blue-1bg))))
   `(org-todo ((t (:foreground ,red-1 :background ,red-1bg))))
   )

  (custom-theme-set-variables
   'peleteiro

   ;; ;; Fill Column Indicator mode
   `(fci-rule-color ,gray-6)
   `(fci-rule-character-color ,gray-6)

   `(ansi-color-names-vector
     ;; black, red, green, yellow, blue, magenta, cyan, white
     [,background ,red-1 ,green-1 ,yellow-1 ,blue-1 ,purple-1 ,blue-1 ,foreground])
   `(ansi-term-color-vector
     ;; black, red, green, yellow, blue, magenta, cyan, white
     [unspecified ,background ,red-1 ,green-1 ,yellow-1 ,blue-1 ,purple-1 ,blue-1 ,foreground])
   )
  )

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'peleteiro)

;;; twilight-anti-bright-theme.el ends here
