(use-package ruby-end)

(use-package ruby-mode
  :mode "\\.\\(?:a?rb\\|aslsx\\)\\'"
  :mode "/\\(?:Brew\\|Fast\\)file\\'"
  :interpreter "j?ruby\\(?:[0-9.]+\\)"
  :config
  (setq ruby-insert-encoding-magic-comment nil))

(use-package rubocop
  :hook (ruby-mode . rubocop-mode)
  :config
  (require 'rubocop))

(use-package inf-ruby
  :pin melpa-stable
  :hook (ruby-mode . inf-ruby-minor-mode))

;; (use-package bundler
;;   :pin melpa-stable
;;   :defer t
;;   :init
;;   (map! :after ruby-mode
;;         :localleader
;;         :map ruby-mode-map
;;         :prefix ("b" . "bundle")
;;         "c" #'bundle-check
;;         "C" #'bundle-console
;;         "i" #'bundle-install
;;         "u" #'bundle-update
;;         "e" #'bundle-exec
;;         "o" #'bundle-open))

(use-package rbenv)

(use-package rspec-mode
  :mode ("/\\.rspec\\'" . text-mode)
  :init
  (setq rspec-use-spring-when-possible nil)
  :config
  (set-popup-rule! "^\\*\\(rspec-\\)?compilation" :size 0.3 :ttl nil :select t)
  (map! :localleader
        :prefix "t"
        :map (rspec-verifiable-mode-map rspec-dired-mode-map rspec-mode-map)
        "a" #'rspec-verify-all
        "r" #'rspec-rerun
        :map (rspec-verifiable-mode-map rspec-mode-map)
        "v" #'rspec-verify
        "c" #'rspec-verify-continue
        "l" #'rspec-run-last-failed
        "T" #'rspec-toggle-spec-and-target
        "t" #'rspec-toggle-spec-and-target-find-example
        :map rspec-verifiable-mode-map
        "f" #'rspec-verify-method
        "m" #'rspec-verify-matching
        :map rspec-mode-map
        "s" #'rspec-verify-single
        "e" #'rspec-toggle-example-pendingness
        :map rspec-dired-mode-map
        "v" #'rspec-dired-verify
        "s" #'rspec-dired-verify-single))

(provide 'emacs-ruby)
