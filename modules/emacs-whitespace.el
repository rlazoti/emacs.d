(require 'whitespace)

(setq whitespace-line-column 120
      whitespace-style
      '(face spaces tabs tab-mark lines-tail trailing))

;; (define-global-minor-mode my-global-whitespace-mode whitespace-mode
;;   (lambda ()
;;     (unless (derived-mode-p 'org-mode 'term-mode)
;;       (whitespace-mode))))

;; (my-global-whitespace-mode 1)
(global-whitespace-mode t)

(provide 'emacs-whitespace)
