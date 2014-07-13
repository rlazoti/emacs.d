(emacs-require-package 'ensime)

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(provide 'emacs-ensime)
