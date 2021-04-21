(use-package flycheck
  :ensure t
  :after exec-path-from-shell
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-indication-mode 'right-fringe)
  (setq-default right-fringe-width 10)

  (define-fringe-bitmap 'custom/flycheck-fringe-indicator
    (vector #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b11111111
            #b11111111
            #b11111111
            #b11111111
            #b11111111
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000))

  (flycheck-define-error-level 'error
    :overlay-category 'flycheck-error-overlay
    :fringe-bitmap 'custom/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-error)

  (flycheck-define-error-level 'warning
    :overlay-category 'flycheck-warning-overlay
    :fringe-bitmap 'custom/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-warning)

  (flycheck-define-error-level 'info
    :overlay-category 'flycheck-info-overlay
    :fringe-bitmap 'custom/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-info))

(use-package flycheck-pos-tip
  :after flycheck
  :init (flycheck-pos-tip-mode))

(provide 'emacs-flycheck)
