(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (((ruby-mode) . lsp-deferred)
         ((typescript-mode) . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq
   lsp-disabled-clients '(rubocop-ls ruby-lsp-ls)
   lsp-response-timeout 25
   lsp-headerline-breadcrumb-enable t
   lsp-enable-links nil)
  )
                                       ;  (with-eval-after-load 'lsp-mode (mapc #'lsp-flycheck-add-mode '(ruby-mode typescript-mode))))

(use-package lsp-treemacs)

(use-package lsp-ui
  :commands lsp-ui-mode
  :config (setq lsp-ui-doc-show-with-cursor nil))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(provide 'emacs-lsp)
