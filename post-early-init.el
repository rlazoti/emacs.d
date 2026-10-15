;;; post-early-init.el --- Settings loaded after early-init.el -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Commentary:
;; Loaded by early-init.el after its own settings and before init.el.
;; Use it for package-system settings that must exist before init.el runs.
;;
;; The base already sets these, so nothing is repeated here:
;;   package-archives  (melpa, gnu/ELPA, nongnu)
;;   use-package-always-ensure, use-package-expand-minimally, use-package-verbose
;;   custom-theme-directory, custom-file

;;; Code:

;; MELPA stable is not used.  Everything comes from MELPA, GNU ELPA and NonGNU
;; ELPA.  A pinned package that needs MELPA stable declares `:pin' itself.

;; `package-vc' installs packages from Git.  It is built in since Emacs 30 and
;; the private modules use it for tools that are not on MELPA.

(provide 'post-early-init)
;;; post-early-init.el ends here
