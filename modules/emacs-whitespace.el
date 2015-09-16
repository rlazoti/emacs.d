(require 'whitespace)

(setq whitespace-line-column 120)
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)

(provide 'emacs-whitespace)
