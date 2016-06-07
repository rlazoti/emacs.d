(when (version< emacs-version "24.5")
  (error "It requires at least GNU Emacs 24.5, but you're running %s" emacs-version))

(setq load-prefer-newer t)   ;; Always load newest byte code
(setq make-backup-files nil) ;; Preventing the Creation of Backup Files

(defvar emacs-dir (file-name-directory load-file-name)
  "The root dir of the Emacs configuration.")

(defvar emacs-modules-dir (expand-file-name "modules" emacs-dir)
  "The home of the Emacs modules.")

(defvar emacs-savefile-dir (expand-file-name "savefile" emacs-dir)
  "This folder stores all the automatically generated save/history-files.")

(defvar emacs-modules-file (expand-file-name "emacs-modules.el" emacs-dir)
  "This file contains a list of modules that will be loaded.")

(defvar emacs-packages-file (expand-file-name "emacs-packages.el" emacs-dir)
  "The file contains a list of external packages that will be loaded.")

(unless (file-exists-p emacs-savefile-dir)
  (make-directory emacs-savefile-dir))

;; add emacs's directories to Emacs's `load-path'
(add-to-list 'load-path emacs-modules-dir)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; load external packages
(when (file-exists-p emacs-packages-file)
  (load emacs-packages-file))

(require 'emacs-packages)

;; the modules
(when (file-exists-p emacs-modules-file)
  (load emacs-modules-file))

;; OSX specific settings
(when (eq system-type 'darwin)
  (require 'emacs-osx))
