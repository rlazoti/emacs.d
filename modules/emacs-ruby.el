(use-package ruby-mode
  :mode "\\.\\(?:a?rb\\|aslsx\\)\\'"
  :mode "/\\(?:Brew\\|Fast\\)file\\'"
  :interpreter "j?ruby\\(?:[0-9.]+\\)"
  :config
  (setq ruby-insert-encoding-magic-comment nil)
  (use-package yari
    :bind ("s-i" . yari)))

(use-package rubocop
  :hook (ruby-mode . rubocop-mode))

(use-package rubocopfmt
  :hook (ruby-mode . rubocopfmt-mode))

(use-package inf-ruby
  :pin melpa-stable
  :hook (ruby-mode . inf-ruby-minor-mode))

(use-package bundler
  :after inf-ruby
  :defer t)

(use-package company-inf-ruby
  :after company inf-ruby
  :config (add-to-list 'company-backends 'company-inf-ruby))

(use-package ruby-electric
  :after ruby-mode
  :hook (ruby-mode . ruby-eletric-mode))

;(use-package ruby-end)

(use-package rbenv
  :init
  (global-rbenv-mode))

(use-package rspec-mode
  :mode ("/\\.rspec\\'" . text-mode)
  :init
  (setq rspec-use-rvm nil)
  (setq rspec-use-spring-when-possible nil))

(provide 'emacs-ruby)
