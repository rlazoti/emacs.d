(use-package drag-stuff
  :init
  (drag-stuff-global-mode 1)
  :bind
  (:map global-map
        ("M-<up>"   . 'drag-stuff-up)
        ("M-<down>" . 'drag-stuff-down)))

(provide 'emacs-drag-stuff)
