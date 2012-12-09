;;; railscasts-theme.el --- Custom face theme for Emacs

;; Copyright (C) 2011 Matt Woodward.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(deftheme railscasts
  "Similar to the railscasts theme by Oleg Shaldybin")

(custom-theme-set-faces
 'railscasts
 '(default ((t (:background "#000" :foreground "#e6e1de"))))
 '(cursor ((t (:background "#999" :foreground "#5a647e" :inverse-video t))))
 '(region ((t (:background "#555577" :foreground "#e6e1de" :weight bold))))
 '(mode-line ((t (:background "#333333" :foreground "#a5baf1"))))
 '(mode-line-inactive ((t (:background "#333" :foreground "#111" :box nil))))
 '(fringe ((t (:background "#000000"))))
 '(minibuffer-prompt ((t (:foreground "#ff6600" :weight bold))))
 '(font-lock-builtin-face ((t (:foreground "#d0d0ff"))))
 '(font-lock-comment-face ((t (:slant italic :foreground "#bc9458"))))
 '(font-lock-constant-face ((t (:foreground "#6d9cbe"))))
 '(font-lock-function-name-face ((t (:foreground "#ffc66d"))))
 '(font-lock-keyword-face ((t (:foreground "#cc7833"))))
 '(font-lock-string-face ((t (:foreground "#a5c261"))))
 '(font-lock-type-face ((t (:foreground "#ffffff"))))
 '(font-lock-variable-name-face ((t (:foreground "#b0c4de"))))
 '(font-lock-warning-face ((t (:foreground "#cd6889" :weight bold))))
 '(isearch ((t (:background "#555555" :foreground "#b0e2ff"))))
 '(lazy-highlight ((t (:background "#222"))))
 '(highlight ((t (:background "#222"))))
 '(link ((t (:foreground "#0000ff" :underline t))))
 '(link-visited ((t (:foreground "#8b008b" :underline t))))
 '(button ((t (:underline t))))
 '(show-paren-match-face ((t (:background "#333"))))
 '(header-line ((t (:background "#5a647e" :foreground "#e6e1de")))))

(provide-theme 'railscasts)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; railscasts-theme.el  ends here
