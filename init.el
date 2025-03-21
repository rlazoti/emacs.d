;;; init.el --- Emacs Initialization and Configuration
;;; Commentary:
;;; Code:

(setq gc-cons-threshold (* 512 1024 1024 1024)
      gc-cons-percentage 0.6)

(setq read-process-output-max (* 1024 1024))

(setq native-comp-async-report-warnings-errors 'silent)
(setq package-native-compile t)
(setq native-comp-deferred-compilation t)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 128 1024 1024)
                  gc-cons-percentage 0.1)))

(defconst emacs-dir (file-name-directory load-file-name)
  "The root dir of the Emacs configuration.")

(defvar emacs-modules-dir (expand-file-name "modules" emacs-dir)
  "The home of the Emacs modules.")

(defvar emacs-private-modules-dir (expand-file-name "modules-private" emacs-dir)
  "The home of the Emacs private modules.")

(defvar emacs-savefile-dir (expand-file-name "savefile" emacs-dir)
  "This folder stores all the automatically generated save/history-files.")

(defvar emacs-modules-file (expand-file-name "emacs-modules.el" emacs-dir)
  "This file contains a list of modules that will be loaded.")

(defvar emacs-modules-private-file (expand-file-name "emacs-modules-private.el" emacs-dir)
  "This file contains a list of private modules that will be loaded.")

(require 'package)

(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")))

;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Enable packages signature verification only if GPG is installed
(setq package-check-signature (when (executable-find "gpg") 'allow-unsigned))

;; set package-user-dir to be relative to Emacs install path
(setq package-user-dir (expand-file-name "packages" emacs-dir))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(unless (file-exists-p emacs-savefile-dir)
  (make-directory emacs-savefile-dir))

;; add emacs's directories to Emacs's `load-path'
(add-to-list 'load-path emacs-modules-dir)
(add-to-list 'load-path emacs-private-modules-dir)

;; OSX specific settings
(when (eq system-type 'darwin)
  (require 'emacs-osx))

;; load the modules
(when (file-exists-p emacs-modules-file)
  (load emacs-modules-file))

;; load private modules
(when (file-exists-p emacs-modules-private-file)
  (load emacs-modules-private-file))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mac-emulate-three-button-mouse t)
 '(package-selected-packages nil)
 '(safe-local-variable-directories '("/Users/rodrigolazoti/src/github.com/Shopify/banking/"))
 '(safe-local-variable-values
   '((lsp-enabled-clients rubocop-ls)
     (lsp-enabled-clients sorbet-ls ruby-lsp-ls)
     (setf (lsp--client-priority (gethash server 'sorbet-ls)) 1)
     (lsp-sorbet-as-add-on . t) (lsp-sorbet-use-bundler . t)
     (lsp-enabled-clients sorbet-ls) (lsp-enabled-clients ruby-lsp-ls)
     (lsp-enabled-clients '(ruby-ls))
     (lsp-enabled-clients '(ruby-lsp-ls))
     (lsp-disabled-clients . sorbet-ls)
     (lsp-enabled-clients . ruby-lsp)))
 '(warning-suppress-types '((emacs) (comp) (use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blamer-face ((t :foreground "#787BE5" :background unspecified :height 140 :italic t))))
