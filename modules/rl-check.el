;;; rl-check.el --- Syntax checking and spell checking -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-flycheck.el and emacs-flyspell.el.
;;
;; Changed:
;; - flycheck-pos-tip and pos-tip are gone.  Errors are shown with
;;   `flycheck-list-errors' and `consult-flycheck' (M-g f).
;; - flyspell-correct-ivy is gone.  Plain `flyspell-correct' uses
;;   `completing-read', which is Vertico + Orderless, so it needs no interface
;;   package.
;; - the hand drawn fringe bitmaps are gone: Flycheck ships good ones.
;; - hydra-flycheck (C-c f) is replaced by the transient menu below.

;;; Code:

(use-package flycheck
  :custom
  (flycheck-idle-change-delay 1.0)
  (flycheck-display-errors-delay 0.25)
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-indication-mode 'right-fringe)
  (flycheck-buffer-switch-check-intermediate-buffers t)
  :config
  ;; Check on save and on mode enable, not on every newline.
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  :init (global-flycheck-mode))

(use-package consult-flycheck
  :after flycheck
  :bind ("M-g F" . consult-flycheck))

;;; The old hydra menu, rewritten with `transient', which is built into Emacs.
;;; `:demand' is deliberate: the prefix command has to exist when `C-c f' is
;;; bound, and a deferred form would only bind a key to a function that is not
;;; defined yet.  Requiring a built-in package costs nothing measurable.
(use-package transient
  :ensure nil
  :demand t
  :bind ("C-c f" . rl-transient-flycheck)
  :config
  ;; The suffix order of transient 0.13 (the version built into Emacs 31) is
  ;; ("key" "description" command).  With command first, `transient-define-prefix'
  ;; refuses to expand, and `use-package' turns that into a warning nobody sees.
  (transient-define-prefix rl-transient-flycheck ()
    "Flycheck."
    ["Errors"
     ("<" "Previous error" flycheck-previous-error :transient t)
     (">" "Next error"     flycheck-next-error     :transient t)
     ("l" "List errors"    flycheck-list-errors)
     ("f" "Check buffer"   flycheck-buffer)]
    ["Checker"
     ("?" "Describe checker" flycheck-describe-checker)
     ("m" "Toggle mode"      flycheck-mode)
     ("d" "Disable checker"  flycheck-disable-checker)
     ("s" "Select checker"   flycheck-select-checker)
     ("v" "Verify setup"     flycheck-verify-setup)]
    ["Jump and learn"
     ("M-g f" "Consult list" consult-flycheck)
     ("M"     "Manual"       flycheck-manual)
     ("q"     "Quit"         nil)]))

(provide 'rl-check)
;;; rl-check.el ends here
