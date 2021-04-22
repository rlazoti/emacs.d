(use-package yasnippet
  :defer 1
  :diminish yas-minor-mode
  :config (yas-global-mode))

(use-package yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))


(provide 'emacs-yasnippet)
