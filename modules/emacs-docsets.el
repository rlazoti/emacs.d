(emacs-require-package 'counsel-dash)

(require 'counsel-dash)

(setq counsel-dash-docsets-path "~/.emacs.d/docsets")
(setq counsel-dash-docsets-url "https://raw.github.com/Kapeli/feeds/master")
(setq counsel-dash-min-length 3)
(setq counsel-dash-candidate-format "%d %n (%t)")
(setq counsel-dash-enable-debugging nil)
(setq counsel-dash-browser-func 'browse-url)
(setq counsel-dash-ignored-docsets nil)

;; (defun counsel-dash-at-point ()
;;   (interactive)
;;   (counsel-dash (thing-at-point 'symbol)))

(add-hook 'emacs-lisp-mode-hook (lambda () (setq-local counsel-dash-docsets '("Emacs Lisp"))))
(add-hook 'ruby-mode-hook (lambda () (setq-local counsel-dash-docsets '("Ruby"))))
(add-hook 'js2-mode-hook (lambda () (setq-local counsel-dash-docsets '("JavaScript" "Jquery" "EmberJS"))))
(add-hook 'scala-mode-hook (lambda () (setq-local counsel-dash-docsets '("Scala" "Java"))))

(provide 'emacs-docsets)
