(emacs-require-packages '(clojure-mode cider))

(add-hook 'clojure-mode-hook #'subword-mode)
(add-hook 'clojure-mode-hook #'smartparens-strict-mode)

(provide 'emacs-clojure)
