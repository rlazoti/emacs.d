(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (((json-mode ruby-mode) . lsp)
         (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(provide 'emacs-lsp)
