(use-package all-the-icons)

(use-package minions
  :init (minions-mode 1))

(use-package nyan-mode
  :config (nyan-mode t)
  :custom (nyan-animate-nyancat t))

(use-package doom-modeline
  :after flycheck
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-height 14)
  (doom-modeline-def-modeline 'main
    '(bar window-number matches buffer-info remote-host buffer-position selection-info)
    '(objed-state misc-info persp-name github debug input-method buffer-encoding lsp major-mode process vcs checker " ")))

(provide 'emacs-modeline)
