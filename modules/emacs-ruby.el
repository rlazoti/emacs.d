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

  (use-package chruby
    :hook (ruby-mode . chruby-use-corresponding))

  (use-package ruby-hash-syntax)

  (use-package yari
    :bind ("s-i" . yari)))

(use-package robe
  :pin melpa-stable
  :after ruby-mode
  :hook (ruby-mode . robe-mode)
  :config
  (eval-after-load 'company
    '(push 'company-robe company-backends)))

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

(use-package minitest
  :ensure t
  :hook (ruby-mode . minitest-mode))

(use-package projectile-rails
  :init
  (setq projectile-rails-vanilla-command "bin/rails"
        projectile-rails-spring-command "bin/spring"
        projectile-rails-zeus-command "bin/zeus")
  :config
  (projectile-rails-global-mode)
  (define-key projectile-rails-mode-map (kbd "s-r") 'hydra-projectile-rails/body))

(provide 'emacs-ruby)
