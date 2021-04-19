(setq gc-cons-threshold (* 512 1024 1024 1024)
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 128 1024 1024)
                  gc-cons-percentage 0.1)))

(setq user-full-name "Rodrigo Lazoti")
(setq user-mail-address "rodrigolazoti@gmail.com")
(setq load-prefer-newer t)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq confirm-kill-emacs 'y-or-n-p)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)

(global-set-key (kbd "C-x k") 'kill-this-buffer)
(fset 'yes-or-no-p 'y-or-n-p)
(scroll-bar-mode 0)
