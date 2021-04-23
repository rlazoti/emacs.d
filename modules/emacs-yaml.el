(use-package yaml-mode
  :mode "\\.yml\\'"
  :hook
  (yaml-mode . (lambda ()
                 (setq show-trailing-whitespace t)
                 (flyspell-prog-mode))))

(provide 'emacs-yaml)
