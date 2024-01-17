(use-package shadowenv
  :after exec-path-from-shell
  :custom (shadowenv-lighter "S")
  :hook (after-init . shadowenv-global-mode))

(provide 'emacs-shadowenv)
