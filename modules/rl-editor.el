;;; rl-editor.el --- Editing behaviour, encoding, text helpers -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-editor.el and emacs-core.el.
;;
;; Not ported on purpose:
;; - (setq-default indent-line-function 2)   ; invalid: the value must be a function
;; - (set 'ad-redefinition-action 'accept)   ; the variable no longer exists
;; - highlight-tabs                            ; not a variable in Emacs 31
;; - the isearch advice that pre-filled the search with the region.  The
;;   built-in command `isearch-forward-thing' does the same job: with a region
;;   it searches the region, otherwise the URL, symbol or sexp at point.
;;   It is bound in rl-keys.el.

;;; Code:

;;; Encoding
;; One rule: files are UTF-8 with Unix line endings, everywhere.
(prefer-coding-system 'utf-8)
(set-language-environment 'UTF-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq default-input-method nil
      buffer-file-coding-system 'utf-8-unix
      default-file-name-coding-system 'utf-8-unix
      locale-coding-system 'utf-8)

;; Portuguese input with the compose key style (accented chars from ASCII).
;; Loaded on demand, so typing an accent does not cost startup time.
(eval-after-load 'iso-transl
  '(setq default-input-method "portuguese-prefix"))

;;; Indentation and whitespace behaviour
;; Nothing sets `indent-line-function' globally: each major mode chooses its
;; own.  The old config assigned the number 2 to it, which is invalid.
;; `indent-tabs-mode', `tab-always-indent', `word-wrap' and `fill-column' are
;; already set by init.el -- `word-wrap' included, which reads like it turns
;; wrapping on and does not (see `truncate-lines' in init.el).
(setq-default
 indent-tabs-mode nil
 tab-width 2
 tab-always-indent 'complete)
(setq sentence-end-double-space nil
      fill-column 80)

;;; Text editing
(use-package editorconfig
  :init (editorconfig-mode 1))

(use-package goto-line-preview
  :commands goto-line-preview
  :bind (([remap goto-line] . goto-line-preview)))

(use-package string-inflection
  :commands (string-inflection-ruby-style-cycle
             string-inflection-python-style-cycle
             string-inflection-java-style-cycle
             string-inflection-all-cycle)
  :preface
  (defun rl-string-inflection-cycle ()
    "Cycle case style of the symbol at point, by major mode."
    (interactive)
    (cond ((eq major-mode 'emacs-lisp-mode) (string-inflection-all-cycle))
          ((derived-mode-p 'python-mode)    (string-inflection-python-style-cycle))
          ((derived-mode-p 'java-mode)      (string-inflection-java-style-cycle))
          (t                                (string-inflection-ruby-style-cycle))))
  :bind ("C-c M-u" . rl-string-inflection-cycle))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C->"     . mc/mark-all-like-this)
         ("C-."         . mc/mark-next-lines)
         ("C-,"         . mc/mark-previous-lines)))

(use-package drag-stuff
  :bind (("M-<up>" . drag-stuff-up)
         ("M-<down>" . drag-stuff-down))
  :init (drag-stuff-global-mode 1))

(use-package buffer-move
  :bind (("C-c C-c <up>"    . buf-move-up)
         ("C-c C-c <down>"  . buf-move-down)
         ("C-c C-c <left>"  . buf-move-left)
         ("C-c C-c <right>" . buf-move-right)))

(use-package symbol-overlay
  :bind (("M-i" . symbol-overlay-put)
         ("M-n" . symbol-overlay-jump-next)
         ("M-p" . symbol-overlay-jump-prev))
  :hook ((prog-mode . symbol-overlay-mode)))

;;; Commands
(defun rl-next-code-buffer ()
  "Select the next buffer whose name does not start with an asterisk."
  (interactive)
  (let ((bread-crumb (buffer-name)))
    (next-buffer)
    (while (and (string-match-p "\\`\\*" (buffer-name))
                (not (equal bread-crumb (buffer-name))))
      (next-buffer))))

(defun rl-previous-code-buffer ()
  "Select the previous buffer whose name does not start with an asterisk."
  (interactive)
  (let ((bread-crumb (buffer-name)))
    (previous-buffer)
    (while (and (string-match-p "\\`\\*" (buffer-name))
                (not (equal bread-crumb (buffer-name))))
      (previous-buffer))))

;; Copy a region to the clipboard as syntax-highlighted RTF.
;; Needs: brew install pygments
(when (executable-find "pygmentize")
  (defun rl-formatted-copy (lang &optional bnd end)
    "Copy region to the system clipboard, highlighted for LANG."
    (interactive (cons (read-string "Language: ")
                       (if (use-region-p)
                           (list (region-beginning) (region-end))
                         (list (point-min) (point-max)))))
    (shell-command-on-region
     bnd end
     (format "pygmentize -l %s -f rtf -O style=solarized-light | pbcopy" lang)
     nil t)))

;;; Typing behaviour
(use-package emacs
  :ensure nil
  :config
  ;; Typing with an active region replaces it (the old config had this).
  (delete-selection-mode 1))

;;; Efficient jumps: xref first, grep as the fallback
(use-package dumb-jump
  :custom (dumb-jump-force-searcher 'rg)
  :init (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; Parens: the built-in pair insertion replaces smartparens, which the old
;; config enabled but never used beyond the minor mode itself.
(use-package elec-pair
  :ensure nil
  :custom
  (electric-pair-preserve-balance t)
  (electric-pair-delete-adjacent-pairs t)
  (electric-pair-skip-whitespace 'chomp)
  (electric-pair-open-newline-between-pairs nil)
  ;; `electric-pair-pairs' keeps its defaults: ( ) { } [ ] " " ' '.
  :init (electric-pair-mode 1))

(provide 'rl-editor)
;;; rl-editor.el ends here
