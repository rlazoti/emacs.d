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
;; - lsp-treemacs (call hierarchy and symbol trees)
;; - dap-mode debugging.  If you need a debugger again, install `dap-mode';
;;   it is independent of Eglot and drives the same Debug Adapter Protocol.
;;
;; A language module (rl-lang-ruby, rl-lang-python, ...) is the place that
;; adds the buffer-local hook that starts Eglot.

;;; Code:

(use-package eglot
  :ensure nil
  :commands (eglot-ensure eglot eglot-shutdown eglot-rename eglot-format-buffer
                          eglot-code-actions eglot-find-declaration
                          eglot-find-implementation eglot-find-typeDefinition)
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l a" . eglot-code-actions)
              ("C-c l j" . eglot-find-declaration)
              ("C-c l i" . eglot-find-implementation)
              ("C-c l t" . eglot-find-typeDefinition)
              ("C-c l x" . eglot-execute-command)
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

(provide 'rl-lsp)
;;; rl-lsp.el ends here
