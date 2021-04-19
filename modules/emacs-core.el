(setq user-full-name "Rodrigo Lazoti")
(setq user-mail-address "rodrigolazoti@gmail.com")

(setq confirm-kill-emacs 'y-or-n-p)                  ; Ask "y" or "n" before killing emacs
(setq confirm-nonexistent-file-or-buffer nil)        ; disable confirmation for creating a new buffer
(setq create-lockfiles nil)                          ; Preventing the creation of lockfiles
(setq inhibit-splash-screen t)                       ; Disable splash screen
(setq inhibit-startup-message t)                     ; disable startup message
(setq initial-scratch-message nil)                   ; Disable scratch message
(setq load-prefer-newer t)                           ; Always load newest byte code
(setq make-backup-files nil)                         ; Preventing the creation of Backup Files
(setq mouse-wheel-follow-mouse 't)                   ; scroll window under mouse
(setq mouse-wheel-progressive-speed nil)             ; don't accelerate scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))  ; scroll one line at a time
(setq ring-bell-function 'ignore)                    ; turn off all alarms
(setq scroll-step 1)                                 ; keyboard scroll one line at a time
(setq visible-bell nil)                              ; Set up the visible bel

(fset 'yes-or-no-p 'y-or-n-p) ; Ask "y" or "n" instead of "yes" or "no". Yes, laziness is great.

(menu-bar-mode -1)          ; Disable the menu bar
(scroll-bar-mode -1)        ; Disable visible scrollbar
(set-fringe-mode 10)        ; Give some breathing room
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips

(defun reload-config ()
  "reload your config without exiting Emacs"
  (interactive)
  (load "~/.emacs.d/init.el"))

(defun scroll-down-keep-cursor ()
  "Scroll the text one line down while keeping the cursor"
  (interactive)
  (scroll-down 1))

(defun scroll-up-keep-cursor ()
  "Scroll the text one line up while keeping the cursor"
  (interactive)
  (scroll-up 1))

(defun new-untitled-buffer-frame ()
  "Open a new frame with a buffer named Untitled<N>."
  (interactive)
  (switch-to-buffer (generate-new-buffer "Untitled")))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Make ESC quit prompts
(global-set-key (kbd "<f9>")      'eshell)
(global-set-key (kbd "C-x k")     'kill-this-buffer)
(global-set-key (kbd "C-x b")     'ibuffer)
(global-set-key (kbd "C-<down>")  'scroll-down-keep-cursor)
(global-set-key (kbd "C-<up>")    'scroll-up-keep-cursor)
(global-set-key (kbd "C-c n")     'new-untitled-buffer-frame)

(autoload 'ibuffer "ibuffer" "List buffers." t)

(provide 'emacs-core)
