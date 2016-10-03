(emacs-require-packages '(
                          flymake-css
                          flymake-json
                          flymake-ruby
                          flymake-yaml
                          flymake-jshint
                          flymake-jslint
                          flymake-cursor
                          ))

(add-hook 'css-mode-hook 'flymake-css-load)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)
(add-hook 'yaml-mode-hook 'flymake-yaml-load)

(custom-set-variables
 '(help-at-pt-timer-delay 0.5)
 '(help-at-pt-display-when-idle '(flymake-overlay)))

(provide 'emacs-flymake)
