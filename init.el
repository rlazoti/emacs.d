
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(when (version< emacs-version "24.5")
  (error "It requires at least GNU Emacs 24.5, but you're running %s" emacs-version))

(setq load-prefer-newer t)   ;; Always load newest byte code
(setq make-backup-files nil) ;; Preventing the creation of Backup Files
(setq create-lockfiles nil) ;; Preventing the creation of lockfiles

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(help-at-pt-display-when-idle (quote (flymake-overlay)) nil (help-at-pt))
 '(help-at-pt-timer-delay 0.5)
 '(mac-emulate-three-button-mouse t)
 '(package-selected-packages
	 (quote
		(zeal-at-point yari which-key wgrep-ag web-mode web-beautify sublimity smex smartparens slime-company rvm ruby-tools rbenv rainbow-mode play-routes-mode pig-mode neotree multiple-cursors markdown-mode json-mode js2-mode inf-ruby ido-ubiquitous highlight-symbol git-gutter-fringe flymake-yaml flymake-ruby flymake-json flymake-jslint flymake-jshint flymake-cursor flymake-css flx-ido fiplr expand-region evil-nerd-commenter ensime elisp-slime-nav dumb-jump drag-stuff company-web company-quickhelp common-lisp-snippets color-theme-sanityinc-tomorrow clojure-snippets cider buffer-move ag ace-jump-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-preview ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-scrollbar-bg ((t (:background "lightgray" :foreground "lightgray"))))
 '(company-scrollbar-fg ((t (:background "darkred" :foreground "darkred"))))
 '(company-tooltip ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-annotation ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-annotation-selection ((t (:background "steelblue" :foreground "white"))))
 '(company-tooltip-common ((((type x)) (:inherit company-tooltip :weight bold)) (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold)) (t (:inherit company-tooltip-selection))))
 '(company-tooltip-selection ((t (:background "steelblue" :foreground "white"))))
 '(neo-dir-link-face ((t (:foreground "deep sky blue" :slant normal :weight bold :height 120 :family "Monaco"))))
 '(neo-file-link-face ((t (:foreground "White" :weight normal :height 120 :family "Monaco"))))
 '(neo-header-face ((t (:foreground "deep sky blue" :slant normal :weight bold :height 120 :family "Monaco"))))
 '(neo-root-dir-face ((t (:foreground "deep sky blue" :slant normal :weight bold :height 120 :family "Monaco"))))
 '(whitespace-space ((t (:bold t :foreground "gray20" :background nil))))
 '(whitespace-tab ((t (:foreground "gray20" :background nil)))))
