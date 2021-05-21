(use-package ruby-mode
  :mode "\\.\\(?:a?rb\\|aslsx\\)\\'"
  :mode "/\\(?:Brew\\|Fast\\)file\\'"
  :interpreter "j?ruby\\(?:[0-9.]+\\)"
  :config
  (setq ruby-insert-encoding-magic-comment nil)
  (use-package ruby-end)
  (use-package rbenv
    :init
    (setq rbenv-show-active-ruby-in-modeline nil)
    (global-rbenv-mode))

  (use-package yari
    :bind ("s-i" . yari)))

(use-package rubocop
  :after ruby-mode
  :hook (ruby-mode . rubocop-mode))

(use-package rubocopfmt
  :after ruby-mode
  :hook (ruby-mode . rubocopfmt-mode)
  :bind ("C-s-f" . rubocopfmt))

(use-package inf-ruby
  :after ruby-mode
  :pin melpa-stable
  :hook (ruby-mode . inf-ruby-minor-mode))

(use-package bundler
  :after inf-ruby
  :defer t)

(use-package company-inf-ruby
  :after company inf-ruby
  :config (add-to-list 'company-backends 'company-inf-ruby))

(use-package rspec-mode
  :mode ("/\\.rspec\\'" . text-mode)
  :init
  (setq rspec-use-rvm nil)
  (setq rspec-use-spring-when-possible nil))

(provide 'emacs-ruby)
