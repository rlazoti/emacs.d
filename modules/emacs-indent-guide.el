(use-package highlight-indent-guides
  :init
  (setq highlight-indent-guides-method 'character)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (add-hook 'yaml-mode-hook 'highlight-indent-guides-mode)
  (add-hook 'web-mode-hook  'highlight-indent-guides-mode))

(provide 'emacs-indent-guide)
