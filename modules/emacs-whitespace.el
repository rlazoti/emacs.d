(require 'whitespace)

(setq whitespace-line-column 120
      whitespace-style
      '(face spaces tabs tab-mark lines-tail))

(global-whitespace-mode t)

(provide 'emacs-whitespace)
