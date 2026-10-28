;;; rl-lsp.el --- Language servers with the built-in Eglot -*- lexical-binding: t; -*-
;;; Commentary:
;; Replaces the old modules/emacs-lsp.el (lsp-mode, lsp-ui, lsp-treemacs,
;; lsp-docker, dap-mode).
;;
;; Eglot ships with Emacs 31, so this module installs nothing.
;;
;; Features that go away with lsp-mode and are not replaced:
;; - the C-c l prefix menu of lsp-mode (replaced by the few bindings below)
;; - lsp-ui sideline and doc popup (replaced by Eldoc in the echo area)
;; - lsp-treemacs' symbol tree (replaced by `consult-eglot-symbols', M-s v) and
;;   its call-hierarchy pane (replaced by `eglot-show-call-hierarchy', C-c l h:
;;   Emacs 31 has it, it is just not on a key by default)
;; - dap-mode debugging.  If you need a debugger again, install `dap-mode';
;;   it is independent of Eglot and drives the same Debug Adapter Protocol.
;;
;; References have no Eglot command: `eglot-find-references' does not exist.
;; References come from `xref-find-references' (M-?), which is why `C-c l R'
;; below points at xref and not at Eglot.  One consequence is worth knowing:
;; xref asks a single backend -- the first in `xref-backend-functions' that
;; activates -- and in an Eglot-managed buffer that is the server, then
;; dumb-jump, then etags.  An empty answer from the server is therefore an empty
;; answer, with no fall back to the ripgrep search that would find the name.
;;
;; A language module (rl-lang-ruby, rl-lang-python, ...) is the place that
;; adds the buffer-local hook that starts Eglot.
;;
;; Diagnostics have an owner, and it is decided per language. Eglot turns on
;; Flymake in every buffer it manages, and Flycheck is global (rl-check.el), so
;; left alone both report on the same buffer: two engines, two sets of fringe
;; markers, and two error lists of which `M-g f', `M-g F' and `C-c f' read only
;; the Flycheck one. The two commands near the end of this file are the choice,
;; and each language module picks one with a reason:
;;
;;   rl-eglot-keep-flycheck     Ruby. RuboCop through Flycheck is the linter of
;;                              record there, and `rubocopfmt' (private module)
;;                              does the formatting; a server adds less than it
;;                              would cost.
;;   rl-eglot-let-server-report Python. The only Python checker Flycheck has on
;;                              this machine is py_compile, which is a syntax
;;                              check; a running pyright is strictly more.
;;
;; A buffer with no server is not managed by Eglot, so it keeps Flycheck either
;; way: the choice only ever gives up an engine that is not running.

;;; Code:

(use-package eglot
  :ensure nil
  :commands (eglot-ensure eglot eglot-shutdown eglot-rename eglot-format-buffer
                          eglot-code-actions eglot-find-declaration
                          eglot-find-implementation eglot-find-typeDefinition
                          eglot-show-call-hierarchy)
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l a" . eglot-code-actions)
              ("C-c l j" . eglot-find-declaration)
              ("C-c l i" . eglot-find-implementation)
              ("C-c l t" . eglot-find-typeDefinition)
              ("C-c l h" . eglot-show-call-hierarchy)
              ("C-c l R" . xref-find-references)
              ("C-c l x" . eglot-execute-command)
              ("C-c l d" . flymake-show-buffer-diagnostics)
              ("C-c l D" . eglot-shutdown))
  :custom
  (eglot-sync-connect nil)         ; never block the UI waiting for a server
  (eglot-connect-timeout 60)
  (jsonrpc-default-request-timeout 30)
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  (eglot-report-progress nil)
  (eglot-send-changes-idle-time 0.5)
  (eldoc-echo-area-use-multiline-p nil)
  :config
  ;; Consult shows the candidate list for completions coming from the server.
  (setq completion-in-region-function #'consult-completion-in-region))

(use-package consult-eglot
  :after eglot
  :bind (:map eglot-mode-map
              ("M-s v" . consult-eglot-symbols)))

;;; Which engine reports this buffer?
;; `C-c l d' is the list of the other engine. Where Flycheck owns the buffer it
;; is `M-g f'; where the server owns it, Flycheck has nothing to show and this is
;; the command that works. `eglot-shutdown' is the capital D next to it, which is
;; the reason `C-c l d' was given the lowercase.

(defun rl-eglot-keep-flycheck ()
  "Keep Flycheck as the diagnostics engine in this buffer.
Eglot reads `eglot-stay-out-of' before it turns Flymake on, so a
buffer-local value containing `flymake' leaves Flymake alone: see
`rl-lang-ruby.el'.  Set it from a major mode hook, which runs before
`eglot-ensure' connects."
  ;; `eglot-stay-out-of' is defined in eglot.el and a mode hook runs before that
  ;; file has been loaded, so reading it would be a void variable.  The
  ;; `eglot-ensure' on the same hook loads eglot a moment later in any case.
  (require 'eglot)
  (setq-local eglot-stay-out-of
              (cons 'flymake (remq 'flymake eglot-stay-out-of))))

(defun rl-eglot-let-server-report ()
  "Turn Flycheck off in this buffer and let the server report.
For `eglot-managed-mode-hook', which runs when a buffer starts being
managed and again when it stops; `eglot-managed-p' keeps the second
case from switching Flycheck off in a buffer that has no server."
  (when (eglot-managed-p)
    (flycheck-mode -1)))

(provide 'rl-lsp)
;;; rl-lsp.el ends here
