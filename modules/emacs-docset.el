(use-package counsel-dash
  :defer t
  :config
  (setq counsel-dash-docsets-path "~/.docsets")
  (setq counsel-dash-docsets-url "https://raw.github.com/Kapeli/feeds/master")
  (setq counsel-dash-min-length 3)
  (setq counsel-dash-candidate-format "%d %n (%t)")
  (setq counsel-dash-enable-debugging nil)
  (setq counsel-dash-browser-func 'browse-url)
  (setq counsel-dash-ignored-docsets nil)

  :init
  (defun counsel-dash-at-point ()
    (interactive)
    (counsel-dash (thing-at-point 'symbol)))

  :bind (:map global-map ("C-?" . counsel-dash-at-point))

  :hook ((emacs-lisp-mode . (lambda () (setq-local counsel-dash-docsets '("Emacs Lisp"))))
         (ruby-mode . (lambda () (setq-local counsel-dash-docsets '("Ruby" "Ruby Gems" "Ruby on Rails"))))
         (js-mode . (lambda () (setq-local counsel-dash-docsets '("JavaScript" "React"))))
         (typescript-mode . (lambda () (setq-local counsel-dash-docsets '("TypeScript" "React"))))))

(provide 'emacs-docset)
