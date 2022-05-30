(use-package mini-frame
  :custom
  (mini-frame-detach-on-hide nil)
  (mini-frame-show-parameters '((left . 0.5) (top . 0.25) (width . 0.5) (height . 1)))
  (resize-mini-frames t)
  (mini-frame-mode t)
  (mini-frame-internal-border-color "#bcd4e6")
  )

(provide 'emacs-mini-frame)
