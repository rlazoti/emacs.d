(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (((ruby-mode) . lsp-deferred)
         ((typescript-mode) . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq
   lsp-response-timeout 25
   lsp-headerline-breadcrumb-enable t
   lsp-enable-links nil)
  )

(use-package lsp-treemacs
  :config (lsp-treemacs-sync-mode 1))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq
   lsp-ui-doc-show-with-cursor nil
   lsp-ui-sideline-enable t
   lsp-ui-doc-enable t
   ;; lsp-ui-peek-enable t
   )
  )

(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode)
  :hook ((ruby-mode . (lambda () (require 'dap-ruby))))
)

(provide 'emacs-lsp)
