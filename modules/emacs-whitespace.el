;;(emacs-require-package 'unicode-whitespace)


;;(require 'unicode-whitespace)
;;(unicode-whitespace-setup 'subdued-faces)


(require 'whitespace)
(setq whitespace-line-column 120) ;; limit line length
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)


(provide 'emacs-whitespace)
