(use-package drag-stuff
  :ensure t
	:init
	(drag-stuff-global-mode 1)
	:bind
  (:map global-map
        ("M-<up>"   . 'drag-stuff-up)
        ("M-<down>" . 'drag-stuff-down)))

(provide 'emacs-drag-stuff)
