(emacs-require-package 'unicode-whitespace)


(require 'unicode-whitespace)
(unicode-whitespace-setup 'subdued-faces)
(add-hook 'prog-mode-hook #'whitespace-mode)


(provide 'emacs-whitespace)
