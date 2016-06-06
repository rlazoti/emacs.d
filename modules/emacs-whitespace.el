(require 'whitespace)

(setq whitespace-line-column 120)
(setq whitespace-style (quote (face spaces tabs tab-mark lines-tail)))

(custom-set-faces
 '(whitespace-space ((t (:bold t :foreground "gray20" :background nil))))
 '(whitespace-tab ((t (:foreground "gray20" :background nil)))))

(global-whitespace-mode t)

(provide 'emacs-whitespace)
