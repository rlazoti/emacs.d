(emacs-require-package 'ag)

(setq ag-highlight-search t)
(setq ag-reuse-buffers 't)
(global-set-key (kbd "C-S-s") 'ag-project-regexp)

(provide 'emacs-ag)
