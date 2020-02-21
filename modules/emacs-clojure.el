(emacs-require-packages '(clojure-mode cider))

(add-hook 'clojure-mode-hook #'subword-mode)
(add-hook 'clojure-mode-hook #'smartparens-strict-mode)
(add-hook 'cider-mode-hook #'eldoc-mode)

(eval-after-load 'clojure-mode
  '(progn
     (define-key clojure-mode-map (kbd "C-o j") 'cider-jack-in)
     (define-key clojure-mode-map (kbd "C-o J") 'cider-restart)
     (define-key clojure-mode-map (kbd "s-i") 'cider-eval-last-sexp)
     (setq cider-repl-display-help-banner 'f)))

(provide 'emacs-clojure)
