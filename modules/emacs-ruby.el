(use-package ruby-mode
  :mode ("\\.rb$"
         "\\.rbi$"
         "\\Gemfile$"
         "\\.gemspec$")
  :interpreter "j?ruby\\(?:[0-9.]+\\)"
  :bind
  (:map ruby-mode-map
        ("C-c r b" . ruby-send-buffer)
        ("C-c r r" . ruby-send-region)
        ("C-c r v" . ruby-refactor-extract-local-variable)
        ("C-c r m" . ruby-refactor-extract-to-method))
  :config
  (setq ruby-insert-encoding-magic-comment nil)
  (add-hook 'ruby-mode-hook
            (lambda ()
              (setq-local flycheck-command-wrapper-function
                          (lambda (command) (append '("bundle" "exec") command)))))
  (use-package ruby-end)
  (use-package rbenv
    :init
    (setq rbenv-show-active-ruby-in-modeline nil)
    (global-rbenv-mode))

  ;;(use-package chruby
  ;;  :hook (ruby-mode . chruby-use-corresponding))

  (use-package ruby-hash-syntax)

  (use-package yari
    :bind ("s-i" . yari)))

(use-package robe
  :pin melpa-stable
  :after ruby-mode
  ;;:hook (ruby-mode . robe-mode)
  :config
  (eval-after-load 'company
    '(push 'company-robe company-backends)))

(use-package rubocop
  :after ruby-mode
  :hook (ruby-mode . rubocop-mode))

(use-package rubocopfmt
  :after ruby-mode
  ;;:hook (ruby-mode . rubocopfmt-mode)
  :init
  (setq rubocopfmt-use-bundler-when-possible t)
  (setq rubocopfmt-disabled-cops
  '("Lint/Debugger"              ; Don't remove debugger calls.
    "Lint/UnusedBlockArgument"   ; Don't rename unused block arguments.
    "Lint/UnusedMethodArgument"  ; Don't rename unused method arguments.
    "Style/EmptyMethod"          ; Don't remove blank line in empty methods.
    "Cops/UnknownBetaFlag"
    ))
  :bind ("M-o" . rubocopfmt))

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
