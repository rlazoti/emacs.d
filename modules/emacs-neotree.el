(emacs-require-package 'neotree)

(global-set-key [f5] 'neotree-refresh)
(global-set-key [f6] 'neotree-toggle)

(setq neo-theme 'ascii)
(setq neo-window-position 'right)
(setq neo-window-width 40)

(provide 'emacs-neotree)
