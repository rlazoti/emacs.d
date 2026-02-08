(use-package shadowenv
  :ensure t
  :after exec-path-from-shell
  :custom (shadowenv-lighter "S")
  :hook (after-init . shadowenv-global-mode))

(provide 'emacs-shadowenv)
