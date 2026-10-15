;;; rl-run.el --- Run a file, a region, or a build command -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-run-file.el.  `exec-path-from-shell' is
;; loaded here (and not in rl-macos.el) because quickrun, flycheck, rg, eglot
;; and magit all depend on the same PATH fix on macOS.

;;; Code:

(use-package exec-path-from-shell
  :if (and (eq system-type 'darwin)
           (or (display-graphic-p) (daemonp)))
  :demand t
  :custom
  (exec-path-from-shell-arguments nil)
  (exec-path-from-shell-variables
   '("PATH" "MANPATH" "TMPDIR" "SSH_AUTH_SOCK" "SSH_AGENT_PID"
     "GPG_AGENT_INFO" "LANG" "LC_CTYPE" "_rbenv_setup_" "RUBYOPT"
     "RBENV_ROOT" "RBENV_VERSION" "RBENV_SHELL" "PYENV_ROOT"
     "NVM_DIR" "NODE_PATH" "GOPATH" "GOROOT"))
  :config
  (exec-path-from-shell-initialize))

(use-package quickrun
  :after exec-path-from-shell
  :bind (("<f7>" . quickrun-region)
         ("<f8>" . quickrun)))

;;; Commands that need no package
(use-package compile
  :ensure nil
  :custom
  (compilation-ask-about-save nil)
  (compilation-always-kill t)
  (compilation-scroll-output 'first-error))

(provide 'rl-run)
;;; rl-run.el ends here
