(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (((ruby-mode) . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq ;lsp-modeline-code-actions-enable nil
        ;lsp-modeline-diagnostics-enable nil
        lsp-headerline-breadcrumb-enable t
        lsp-headerline-breadcrumb-segments '(symbols))

  (with-eval-after-load 'lsp-mode (mapc #'lsp-flycheck-add-mode '(ruby-mode))))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config (setq lsp-ui-doc-show-with-cursor nil))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(provide 'emacs-lsp)
