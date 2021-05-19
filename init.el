;;; init.el --- Emacs Initialization and Configuration
;;; Commentary:
;;; Code:

(setq gc-cons-threshold (* 512 1024 1024 1024)
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 128 1024 1024)
                  gc-cons-percentage 0.1)))

(defconst emacs-dir (file-name-directory load-file-name)
  "The root dir of the Emacs configuration.")

(defvar emacs-modules-dir (expand-file-name "modules" emacs-dir)
  "The home of the Emacs modules.")

(defvar emacs-savefile-dir (expand-file-name "savefile" emacs-dir)
  "This folder stores all the automatically generated save/history-files.")

(defvar emacs-modules-file (expand-file-name "emacs-modules.el" emacs-dir)
  "This file contains a list of modules that will be loaded.")

(require 'package)

(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

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

;; load the modules
(when (file-exists-p emacs-modules-file)
  (load emacs-modules-file))

;; OSX specific settings
(when (eq system-type 'darwin)
  (require 'emacs-osx))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-buffer-alist '(("\\*quickrun\\*" display-buffer-below-selected)))
 '(mac-emulate-three-button-mouse t)
 '(package-selected-packages
	 '(poke-line which-key undo-tree doom-themes centaur-tabs smartparens quickrun exec-path-from-shell multiple-cursors doom-modeline all-the-icons-ivy-rich counsel highlight-indent-guides symbol-overlay git-gutter-fringe git-gutter fringe-helper flycheck fiplr neotree string-inflection goto-line-preview editorconfig dumb-jump drag-stuff dimmer company-box company buffer-move ag use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
