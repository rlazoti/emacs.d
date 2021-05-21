(use-package popwin
  :init
  (popwin-mode 1)
  :config
  (push '("\*yari.*" :position :bottom :regexp t) popwin:special-display-config)
  (push '("*xref*" :position :bottom) popwin:special-display-config)
  (push '("*ag search*" :position :bottom) popwin:special-display-config)
  (push '("*ruby*" :position :bottom) popwin:special-display-config)
  (push '("*quickrun*" :position :bottom) popwin:special-display-config))

(provide 'emacs-popwin)
