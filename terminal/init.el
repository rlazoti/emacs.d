(setq load-prefer-newer t)   ;; Always load newest byte code
(setq make-backup-files nil) ;; Preventing the creation of Backup Files
(setq create-lockfiles nil) ;; Preventing the creation of lockfiles

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

(setq user-full-name "Rodrigo Lazoti")
(setq user-mail-address "rodrigolazoti@gmail.com")

;; Ask "y" or "n" instead of "yes" or "no". Yes, laziness is great.
(fset 'yes-or-no-p 'y-or-n-p)

;; Ask "y" or "n" before killing emacs
(setq confirm-kill-emacs 'y-or-n-p)

;; kill the current buffer without prompting
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; Disable scrollbar
(scroll-bar-mode 0)

;; Disable splash screen and scratch message
(setq inhibit-splash-screen t
      initial-scratch-message nil)
