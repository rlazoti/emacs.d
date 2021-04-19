(use-package neotree
  :ensure t
  :defer t
  :config
  (setq neo-theme 'ascii)
  (setq neo-window-position 'left)
  (setq neo-window-width 40)
  (setq neo-smart-open t)
  :bind
  (:map global-map
				("<f5>" . neotree-refresh)
				("<f6>" . neotree-toggle)))

(provide 'emacs-file-explorer)
