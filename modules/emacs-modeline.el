(use-package all-the-icons
  :ensure t)

(use-package nyan-mode
  :ensure t
  :init
  (nyan-mode t))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-height 14)
  (doom-modeline-def-modeline 'main
    '(bar window-number matches buffer-info remote-host buffer-position selection-info)
    '(objed-state misc-info persp-name github debug input-method buffer-encoding lsp major-mode process vcs checker " ")))

(provide 'emacs-modeline)
