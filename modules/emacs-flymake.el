(emacs-require-packages '(
    flymake-css
    flymake-json
    flymake-ruby
    flymake-yaml
))


(require 'flymake-css)
(add-hook 'css-mode-hook 'flymake-css-load)


(require 'flymake-json)
(add-hook 'json-mode 'flymake-json-load)


(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)


(require 'flymake-yaml)
(add-hook 'yaml-mode-hook 'flymake-yaml-load)


(provide 'emacs-flymake)
