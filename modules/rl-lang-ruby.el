;;; rl-lang-ruby.el --- Ruby editing, tests, REPL -*- lexical-binding: t; -*-
;;; Commentary:
;; The public half of the old modules/emacs-ruby.el.
;;
;; Moved to modules-private/rl-ruby-work.el (machine or employer specific):
;; rbenv, rubocop, rubocopfmt, projectile-rails, yari, the "bundle exec"
;; wrapper for flycheck, chruby.
;;
;; Not ported at all:
;; - robe: pinned at 0.8.6, needs the old static-analyzer gem, and
;;   `robe-mode' was never enabled in the old config.
;; - C-c r v / C-c r m bound to `ruby-refactor-extract-local-variable' and
;;   `ruby-refactor-extract-to-method': those commands do not exist in Emacs 31
;;   and no package provided them, so the chords were dead.
;; - C-c r b / C-c r r bound to `ruby-send-buffer' and `ruby-send-region':
;;   also not defined by Emacs 31.  Use inf-ruby (`C-c C-l' to load a file).
;; - ruby-end: `electric-pair-mode' covers it.
;;
;; With the ruby grammar installed (M-x rl-treesit-install-missing) Emacs uses
;; `ruby-ts-mode' automatically; without it, plain `ruby-mode'.

;;; Code:

(use-package ruby-mode
  :ensure nil
  :mode ("\\.rbi\\'" "\\Gemfile\\'" "\\.gemspec\\'")
  :interpreter "j?ruby\\(?:[0-9.]+\\)"
  :custom
  (ruby-insert-encoding-magic-comment nil)
  :config
  ;; Diagnostics: Flycheck keeps them.  `rl-eglot-keep-flycheck' is one of the
  ;; two options listed in rl-lsp.el, chosen here because RuboCop -- which the
  ;; private module installs, with `rubocopfmt' doing the formatting with it --
  ;; is the Ruby linter of record.  `eglot-ensure' connects later, on
  ;; `post-command-hook', so the order of these two lines does not matter.
  (dolist (hook '(ruby-mode-hook ruby-ts-mode-hook))
    (add-hook hook #'rl-eglot-keep-flycheck)
    (add-hook hook #'eglot-ensure)))

(use-package inf-ruby
  :after ruby-mode
  :hook ((ruby-mode ruby-ts-mode) . inf-ruby-minor-mode))

(use-package rspec-mode
  :custom
  (rspec-use-rvm nil)
  (rspec-use-spring-when-possible nil))

(use-package minitest
  :hook ((ruby-mode ruby-ts-mode) . minitest-mode))

(provide 'rl-lang-ruby)
;;; rl-lang-ruby.el ends here
