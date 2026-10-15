;;; post-init.el --- Loads the public modules, then the private ones -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Commentary:
;; The only place that decides what is loaded.  Keep this list short: one line
;; per public module.  Order matters only for the modules that change a shared
;; variable (rl-core and rl-editor before the rest).
;;
;; Nothing here contains settings.  Settings live in modules/.
;;
;; Package notes:
;; - `use-package-always-ensure' is t (the base configuration sets it), so a
;;   package in a `use-package' form installs itself when it is missing.
;; - Built-in packages use `:ensure nil'.
;; - Every package is deferred by `:bind', `:hook', `:commands' or `:after'.
;;   Do not use `:demand' without a reason.

;;; Code:

;;; Public modules
(require 'rl-core)
(require 'rl-editor)
(require 'rl-keys)
(require 'rl-run)
(require 'rl-ui)
(require 'rl-font)
(require 'rl-theme)
(require 'rl-completion)
(require 'rl-undo)
(require 'rl-projects)
(require 'rl-git)
(require 'rl-search)
(require 'rl-check)
(require 'rl-lsp)
(require 'rl-treesit)
(require 'rl-doctor)          ; report of what is missing; needs rl-treesit
(require 'rl-org)
(require 'rl-markdown)
(require 'rl-web)
(require 'rl-lang-ruby)
(require 'rl-lang-python)
(require 'rl-lang-config)

;;; Per-system modules
(when (memq system-type '(darwin darwin-macintosh))
  (require 'rl-macos))

;;; Settings changed with M-x customize go to custom.el (set by early-init.el
;;; to <config dir>/custom.el, which git ignores).  Loading it last means the
;;; customization wins over the modules above.
(load custom-file 'noerror 'nomessage)

;;; Private modules: identity, machine paths, employer tooling.
;; The file is git-ignored and may be absent.  It is always loaded last.
(minimal-emacs-load-user-init "modules-private.el")

(provide 'post-init)
;;; post-init.el ends here
