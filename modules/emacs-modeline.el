(use-package all-the-icons
  :ensure t)

(use-package nyan-mode
    :init
    :config
    (nyan-mode t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  ((doom-modeline-height 14)))

(provide 'emacs-modeline)