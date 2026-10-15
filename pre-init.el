;;; pre-init.el --- Module paths, loaded before init.el -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Commentary:
;; Declares where the public and the private modules live and puts both
;; directories on `load-path'.  post-init.el then requires them.
;;
;; Public modules are tracked by git.  Private modules are ignored by git and
;; never leave this machine.  Private modules load last, so a private file can
;; override any public default without editing the public file.

;;; Code:

(defconst rl-config-dir (file-name-directory (expand-file-name "init.el"
                                                               minimal-emacs-user-directory))
  "Root of this configuration, with a trailing slash.")

(defconst rl-modules-dir (expand-file-name "modules/" rl-config-dir)
  "Directory of the public (tracked) modules.")

(defconst rl-private-modules-dir (expand-file-name "modules-private/" rl-config-dir)
  "Directory of the private (git-ignored) modules.")

(dolist (dir (list rl-modules-dir rl-private-modules-dir))
  (unless (file-directory-p dir)
    (make-directory dir t))
  (add-to-list 'load-path dir))

(provide 'pre-init)
;;; pre-init.el ends here
