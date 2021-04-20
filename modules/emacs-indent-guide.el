(use-package highlight-indent-guides
  :init
  (setq highlight-indent-guides-method 'character)
  :hook (prog-mode . highlight-indent-guides-mode))

(provide 'emacs-indent-guide)
