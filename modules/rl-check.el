;;; rl-check.el --- Syntax checking and spell checking -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-flycheck.el and emacs-flyspell.el.
;;
;; Changed:
;; - flycheck-pos-tip and pos-tip are gone.  Errors are shown with
;;   `flycheck-list-errors' and `consult-flycheck' (M-g f).
;; - flyspell-correct-ivy is gone.  Plain `flyspell-correct' uses
;;   `completing-read', which is Vertico + Orderless, so it needs no interface
;;   package.  It is declared here, and `M-$' is bound to it, because the port
;;   shipped the comment without the code: no module enabled flyspell and the
;;   README still advertised the key.
;; - the hand drawn fringe bitmaps are gone: Flycheck ships good ones.
;; - hydra-flycheck (C-c f) is replaced by the transient menu below.

;;; Code:

(use-package flycheck
  ;; Loading Flycheck is the most expensive single thing in this configuration
  ;; (400 ms of the 2.4 s: flycheck.el itself, plus dash, f, spinner and the
  ;; fringe bitmaps it defines on a display), and at startup there is nothing for
  ;; it to check.  `global-flycheck-mode' is a globalized minor mode whose
  ;; per-buffer predicate only turns Flycheck on where a checker exists, so
  ;; adding `flycheck-mode' to the three families that have checkers -- the same
  ;; three `stripspace' and `indent-bars' use in rl-ui.el -- reaches the same
  ;; buffers, one step later: the first programming buffer, instead of the first
  ;; second of every session.
  :custom
  (flycheck-idle-change-delay 1.0)
  (flycheck-display-errors-delay 0.25)
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-indication-mode 'right-fringe)
  (flycheck-buffer-switch-check-intermediate-buffers t)
  :config
  ;; Check on save and on mode enable, not on every newline.
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  :hook ((prog-mode text-mode conf-mode) . flycheck-mode))

;;; `:commands', not `:after flycheck': with `:after' the command exists only
;;; once Flycheck has loaded, which it now may not have.  The autoload does the
;;; right thing either way, because `consult-flycheck' requires Flycheck itself.
(use-package consult-flycheck
  :commands (consult-flycheck)
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

;;; Spell checking
;;
;; Same reason as the Flycheck deferral above, opposite failure mode: a checker
;; that is not installed does not stay quiet here.  `ispell' starts its process
;; on the first word it checks, so a machine without aspell would take an error
;; in whatever buffer you happened to type in.  Both hooks therefore call a
;; function that reads `rl-check-spell-program', resolved once at load because
;; `executable-find' walks `exec-path' and a buffer hook is the wrong place to do
;; it.  `make doctor' reports the absence, which is the only place it shows.
;;
;; `text-mode' alone is the prose side.  Measured on this machine, term-mode,
;; shell-mode, comint-mode, eshell-mode, compilation-mode, grep-mode, help-mode,
;; dired-mode and tabulated-list modes are not `text-mode' descendants, so
;; terminals, listings and command output stay unchecked; org-mode,
;; message-mode, markdown-mode and git-commit-mode are, which is the point.
;;
;; Two names worth knowing before editing this block.  `flyspell-prog-mode' is a
;; function, not a minor mode: it sets `flyspell-generic-check-word-predicate'
;; and turns on `flyspell-mode', so a code buffer shows `flyspell-mode' on and
;; that is correct.  And `ispell-skip-separated-message' -- the option that used
;; to silence the comment auto-fill prompt -- no longer exists in Emacs 31, so a
;; `:custom' of it is legal Elisp that does nothing, which is what
;; `make validate' looks for.

(defconst rl-check-spell-program
  (or (executable-find "aspell")
      (executable-find "hunspell"))
  "Full path of the spell program to run, or nil if neither is installed.
The configuration expects aspell and accepts hunspell because that is what some
machines carry instead.")

(defun rl-check-spell-prog ()
  "Spell-check the comments and strings of a code buffer, if a program exists."
  (when rl-check-spell-program
    (flyspell-prog-mode)))

(defun rl-check-spell-text ()
  "Spell-check a prose buffer, if a program exists."
  (when rl-check-spell-program
    (flyspell-mode)))

(use-package flyspell
  ;; `:ensure nil': built in.  Deferred by the two hooks, so neither flyspell.el
  ;; nor ispell.el loads before the first buffer that needs one of them.
  :ensure nil
  :custom
  ;; An absolute path, not a name: two aspell installs on one machine differ by
  ;; version and by dictionary, and a name lets `exec-path' order decide.
  (ispell-program-name (or rl-check-spell-program ispell-program-name))
  :hook ((prog-mode . rl-check-spell-prog)
         (text-mode . rl-check-spell-text)))

(use-package flyspell-correct
  ;; The default interface is `flyspell-correct-completing-read', so no interface
  ;; package is needed and Vertico + Orderless give the UI -- which is why
  ;; `flyspell-correct-ivy' went away in the rewrite.  `M-$' replaces the
  ;; built-in `ispell-word': candidates in the minibuffer instead of an in-place
  ;; replacement that you cycle with the same key.
  :commands (flyspell-correct-at-point)
  :bind ("M-$" . flyspell-correct-at-point))

(provide 'rl-check)
;;; rl-check.el ends here
