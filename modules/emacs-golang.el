(use-package go-mode
  :config
  (add-hook 'go-mode-hook #'lsp)
  (add-hook 'go-mode-hook (lambda () (add-hook 'before-save-hook 'gofmt-before-save))))

(provide 'emacs-golang)
