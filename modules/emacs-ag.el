(use-package ag
  :ensure t
  :bind
  (:map global-map
        ("C-S-s" . ag-project-regexp))

  :config
  (setq ag-highlight-search t)
  (setq ag-reuse-buffers 't)
  (setq ag-reuse-window 't))

(provide 'emacs-ag)
