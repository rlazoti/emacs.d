(defun reload-config ()
    "reload your config without exiting Emacs"
    (interactive)
    (load "~/.emacs.d/init.el"))


;; open shell in the current buffer
(global-set-key (kbd "<f9>") 'shell)


(global-set-key (kbd "C-x b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)


;; scroll whitout moving the cursor
(defun scroll-down-keep-cursor () 
   ;; Scroll the text one line down while keeping the cursor 
   (interactive) 
   (scroll-down 1)) 

(defun scroll-up-keep-cursor () 
   ;; Scroll the text one line up while keeping the cursor 
   (interactive) 
   (scroll-up 1)) 

(global-set-key (kbd "C-<down>") 'scroll-down-keep-cursor) 
(global-set-key (kbd "C-<up>") 'scroll-up-keep-cursor) 


;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq confirm-nonexistent-file-or-buffer nil) ;; disable confirmation for creating a new buffer


;; turn off all alarms
(setq ring-bell-function 'ignore)


;; global key to create a new buffer
(random t) ; seed it randomly
(global-set-key (kbd "C-c n")
  (lambda()
    (interactive)
    (switch-to-buffer (concatenate 'string "*new" (number-to-string (random 9999)) "*"))
  )
)


(provide 'emacs-core)
