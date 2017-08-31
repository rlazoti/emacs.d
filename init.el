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

;; Measure startup time
(defun my-conf/time-subtract-millis (b a)
  (* 1000.0 (float-time (time-subtract b a))))

(defvar my-conf/require-times nil
  "A list of (FEATURE . LOAD-DURATION).
LOAD-DURATION is the time taken in milliseconds to load FEATURE.")

(defadvice require (around my-conf/build-require-times (feature &optional filename noerror) activate)
  "Note in `my-conf/require-times' the time taken to require each feature."
  (let* ((already-loaded (memq feature features))
         (require-start-time (and (not already-loaded) (current-time))))
    (prog1
        ad-do-it
      (when (and (not already-loaded) (memq feature features))
        (let ((time (my-conf/time-subtract-millis (current-time) require-start-time)))
          (add-to-list 'my-conf/require-times
                       (cons feature time)
                       t))))))

(defun my-conf/show-init-time ()
  (message "[INFO] Init completed in %.2fms"
           (my-conf/time-subtract-millis after-init-time before-init-time)))

(add-hook 'after-init-hook 'my-conf/show-init-time)

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
