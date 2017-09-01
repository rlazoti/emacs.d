(emacs-require-package 'smartparens)

(require 'smartparens-config)
(require 'smartparens-ruby)

(smartparens-global-mode)
(show-smartparens-global-mode t)

(sp-pair "(" ")" :wrap "s-(")
(sp-pair "[" "]" :wrap "s-[")
(sp-pair "{" "}" :wrap "s-{")

(sp-with-modes '(rhtml-mode)
  (sp-local-pair "<" ">")
  (sp-local-pair "<%" "%>"))

(provide 'emacs-smartparens)
