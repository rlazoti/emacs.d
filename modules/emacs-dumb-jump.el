(use-package dumb-jump
  :init
  (dumb-jump-mode)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(provide 'emacs-dumb-jump)
