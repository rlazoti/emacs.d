(use-package lsp-mode
  :hook ((json-mode ruby-mode) . lsp))

(use-package lsp-ui)

(provide 'emacs-lsp)
