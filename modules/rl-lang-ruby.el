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

;;; Language servers
;; Ruby LSP turns off references, rename and workspace symbols when it finds
;; Sorbet in the project: it expects the Sorbet server to serve them.  lsp-mode
;; ran both servers; Eglot runs one per buffer.  `rass' (rassumfrassum, install
;; with `uv tool install rassumfrassum') merges the two into one connection.
;;
;; `rass' exits if any server it is asked to start is missing, so the choice is
;; made per buffer, in the buffer's own (Shadowenv) `exec-path': a zone with
;; only one of the servers still gets that one.

(defun rl-ruby-eglot-contact (&optional _interactive _project)
  "Return the Eglot contact for the language servers this Ruby buffer can run."
  (let ((ruby-lsp (executable-find "ruby-lsp"))
        (sorbet (and (executable-find "srb")
                     (locate-dominating-file default-directory "sorbet/config")))
        (rass (executable-find "rass")))
    (cond
     ((and ruby-lsp sorbet rass)
      '("rass" "--" "ruby-lsp" "--" "srb" "tc" "--lsp" "--disable-watchman"))
     (ruby-lsp '("ruby-lsp"))
     (sorbet '("srb" "tc" "--lsp" "--disable-watchman"))
     (t (user-error "No Ruby language server on exec-path (ruby-lsp, srb)")))))

;; Sorbet adds a non-standard `requestMethod' field to its replies.  Emacs 31's
;; `jsonrpc-connection-receive' destructures messages without allowing extra
;; keys, so the reply is dropped with "Keyword argument :requestMethod not one
;; of ..." and the request (references, rename, ...) waits until it times out.

(defun rl-jsonrpc-drop-request-method (args)
  "Remove the :requestMethod key from the message in ARGS (CONN MESSAGE)."
  (let ((message (cadr args)))
    (if (plist-member message :requestMethod)
        (list (car args)
              (cl-loop for (key value) on message by #'cddr
                       unless (eq key :requestMethod)
                       append (list key value)))
      args)))

(with-eval-after-load 'jsonrpc
  (advice-add 'jsonrpc-connection-receive :filter-args
              #'rl-jsonrpc-drop-request-method))

(with-eval-after-load 'eglot
  (setq eglot-server-programs
        (cons '((ruby-mode ruby-ts-mode) . rl-ruby-eglot-contact)
              (assoc-delete-all '(ruby-mode ruby-ts-mode) eglot-server-programs))))

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
