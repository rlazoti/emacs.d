(use-package all-the-icons
  :ensure t)

(use-package nyan-mode
    :init
    :config
    (nyan-mode t))

(use-package doom-modeline
  :ensure t
  :hook (doom-modeline-mode . size-indication-mode)
  :hook (doom-modeline-mode . column-number-mode)
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 14))

(provide 'emacs-modeline)
