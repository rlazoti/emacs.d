(use-package blamer
  :custom
  (blamer-idle-time 2)
  (blamer-min-offset 90)
  :custom-face
  (blamer-face ((t :foreground "#787BE5"
                    :background nil
                    :height 140
                    :italic t)))
  :config
  (global-blamer-mode 1))

(provide 'emacs-blamer)
