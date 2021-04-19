(use-package symbol-overlay
  :ensure t
  :bind
  (:map global-map
				("M-i" . symbol-overlay-put)
				("M-n" . symbol-overlay-jump-next)
				("M-p" . symbol-overlay-jump-prev)))

(provide 'emacs-highlight-symbol)
