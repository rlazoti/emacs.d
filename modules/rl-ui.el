;;; rl-ui.el --- Mode line, line numbers, fringe, minor-mode feedback -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-modeline.el, emacs-which-key.el,
;; emacs-todo.el, emacs-whitespace.el and emacs-indent-guide.el.
;;
;; Changed on purpose:
;; - all-the-icons  -> nerd-icons  (smaller, and already installed in the old config)
;; - nyan-mode      -> dropped
;; - dimmer         -> dropped (unmaintained)
;; - highlight-indent-guides -> indent-bars
;; - flycheck hydra -> transient menu in rl-check.el

;;; Code:

;;; Icons
(use-package nerd-icons
  ;; Fonts must be downloaded once: M-x nerd-icons-install-fonts
  :commands (nerd-icons-install-fonts nerd-icons-coding-icon-nerd))

;;; Mode line
(use-package minions
  :custom (minions-mode-line-lighter "+%d")
  :init (minions-mode 1))

(use-package doom-modeline
  :after nerd-icons
  :custom
  (doom-modeline-height 14)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-icon t)
  :init (doom-modeline-mode 1))

;;; Minor mode help
(use-package which-key
  :ensure nil                    ; built into Emacs 31 (which-key 3.6.1)
  :custom
  (which-key-side-window-slot -10)
  (which-key-side-window-max-height 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-display-columns nil)
  (which-key-sort-order 'which-key-prefix-then-key-order)
  :init (which-key-mode))

;;; Line numbers, current line, counters
(use-package emacs
  :ensure nil
  :custom
  (display-line-numbers-type t)
  (display-line-numbers-width 3)
  (display-line-numbers-widen t)
  :config
  (global-display-line-numbers-mode 1)
  (global-hl-line-mode 1)
  (column-number-mode 1)
  (size-indication-mode 1)
  ;; The base configuration turns blinking off.  The old config had it on, so
  ;; turn it back on; delete these two lines to keep the base default.
  (blink-cursor-mode 1)
  :custom
  (blink-cursor-delay 0.0)
  (blink-cursor-interval 0.8))

;; Line numbers are noise in these modes.
(dolist (mode '(org-mode term-mode shell-mode eshell-mode treemacs-mode
                magit-mode Buffer-menu-mode))
  (add-hook (intern (format "%s-hook" mode))
            (lambda () (display-line-numbers-mode 0))))

;;; Indent guides
;; Only two options are set here.  List the others with `C-h v' and the
;; completion at `M-x customize-group RET indent-bars'.
(use-package indent-bars
  :custom (indent-bars-treesit-support t) ; ignored until a grammar is installed
  :hook ((prog-mode text-mode) . indent-bars-mode))

;;; TODO keywords
(use-package hl-todo
  :custom
  (hl-todo-highlight-punctuation ":")
  (hl-todo-keyword-faces
   '(("TODO"       . warning)
     ("FIXME"      . error)
     ("BUG"        . error)
     ("HACK"       . font-lock-constant-face)
     ("REVIEW"     . font-lock-keyword-face)
     ("NOTE"       . font-lock-doc-face)
     ("DEPRECATED" . font-lock-doc-face)
     ("XXX"        . font-lock-constant-face)))
  :hook (prog-mode . hl-todo-mode))

;;; Visible whitespace
(require 'whitespace)
(setq whitespace-line-column 120
      whitespace-style '(face spaces tabs tab-mark lines-tail trailing))

(define-global-minor-mode rl-global-whitespace-mode whitespace-mode
  (lambda ()
    (unless (derived-mode-p 'org-mode 'term-mode 'magit-mode 'treemacs-mode
                            'ibuffer-mode 'dired-mode 'comint-mode
                            'markdown-mode 'vterm-mode)
      (whitespace-mode)))
  :group 'rl)

(rl-global-whitespace-mode 1)

;; Auto-remove trailing whitespace and trailing blank lines on save.
(use-package stripspace
  :commands stripspace-local-mode
  :custom
  (stripspace-only-if-initially-clean nil)
  (stripspace-restore-column t)
  :hook ((prog-mode text-mode conf-mode) . stripspace-local-mode))

(provide 'rl-ui)
;;; rl-ui.el ends here
