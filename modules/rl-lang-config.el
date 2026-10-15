;;; rl-lang-config.el --- Small modes: yaml, json, docker, terraform, graphql, shell -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-yaml.el, emacs-json.el, emacs-docker.el,
;; emacs-terraform.el, emacs-graphql.el and emacs-sh-script.el.  These are kept
;; as one module: each of them is one or two lines.
;;
;; Changed:
;; - json-mode (the MELPA package) is gone.  Emacs 31 maps .json to
;;   `js-json-mode' and remaps it to `json-ts-mode' when the grammar is
;;   installed, so the built-in pair already covers both cases.  The old module
;;   also matched plain .js files as json-mode, which broke JS files.
;; - docker.el (the `M-x docker' client) is gone: the docker CLI is not
;;   installed.  `dockerfile-mode' stays because it only edits text.
;; - docker-compose-mode is gone: it is no longer in the MELPA archive.
;; - company-terraform is gone (corfu + cape have no terraform backend; the
;;   terraform CLI is not installed either, so completion there had nothing to
;;   complete from).
;; - yaml: `yaml-ts-mode' is built in and is used when the grammar exists;
;;   `yaml-mode' remains as the fallback.

;; Comments:
;; - `yaml-mode' below does not declare a `:mode'.  Emacs 31 maps .yaml through
;;   `yaml-ts-mode' when the grammar is installed, and falls back to this
;;   `yaml-mode' otherwise: `treesit-enabled-modes' (see rl-treesit.el) installs
;;   the remap `yaml-mode -> yaml-ts-mode' only for available grammars.

(use-package yaml-mode
  :custom (yaml-indent-offset 2))

(use-package dockerfile-mode)

(use-package terraform-mode)

(use-package graphql-mode)

(use-package sh-script
  :ensure nil
  :hook (after-save . executable-make-buffer-file-executable-if-script-p))

(use-package conf-mode
  :ensure nil
  :mode ("\\.env\\(?:\\.[a-z]+\\)?\\'" . conf-mode))

(provide 'rl-lang-config)
;;; rl-lang-config.el ends here
