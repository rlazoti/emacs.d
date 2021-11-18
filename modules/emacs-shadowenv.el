(use-package shadowenv
  :after ruby-mode typescript-mode exec-path-from-shell
  :hook ((ruby-mode . shadowenv-mode)
         (typescript-mode . shadowenv-mode))
  :custom
  (shadowenv-lighter "S"))

(provide 'emacs-shadowenv)
