;;; rl-core.el --- Startup settings, files, history, windows -*- lexical-binding: t; -*-
;;; Commentary:
;; Startup settings that are not about editing text.
;;
;; Do not repeat what the base configuration already does.  The base already sets: the startup
;; screen, backups and auto-saves (in the temp dir), `create-lockfiles',
;; `confirm-nonexistent-file-or-buffer', `ring-bell-function', `visible-bell',
;; `split-width-threshold', `split-height-threshold', the scroll variables,
;; `hscroll-*', `mouse-yank-at-point', `require-final-newline',
;; `indent-tabs-mode', `tab-width', `word-wrap', `cursor-in-non-selected-windows',
;; `highlight-nonselected-windows', `next-line-add-newlines', the undo limits,
;; `undo-limit', `read-process-output-max', `xref-show-xrefs-function',
;; `save-interprogram-paste-before-kill', `vc-follow-symlinks',
;; `ediff-window-setup-function', `delete-old-versions', the ibuffer formats,
;; the dired settings, the comint and compilation settings, the `recentf',
;; `save-place' and `hl-line' variables, `display-line-numbers-width' and
;; `display-line-numbers-widen', `custom-file'.
;;
;; The base sets variables but enables no mode.  The modes we want are enabled
;; in this file and in rl-ui.el.

;;; Code:

(require 'windmove)

;;; Frames and windows
(setq
 ;; Split side by side unless the frame is narrow.  (The base sets these too.)
 split-height-threshold nil
 split-width-threshold 160

 ;; Resizing one window resizes its neighbours proportionally.
 window-combination-resize t
 even-window-sizes 'height-only)

;; Breathe a little in the fringes.  Only meaningful in a graphical frame.
(when (fboundp 'set-fringe-mode)
  (set-fringe-mode 10))

;;; Quitting, prompts and feedback
(setq
 confirm-kill-emacs 'y-or-n-p
 ;; Never open the native file picker or the native alert box.  Completion is
 ;; always Vertico, which keeps behaviour identical in the terminal and in GUI.
 use-file-dialog nil
 use-dialog-box nil
 ;; Show the keystroke sequence in the echo area after this many seconds.
 echo-keystrokes 0.1
 ;; No beeps, no flashing frame.
 ring-bell-function 'ignore
 visible-bell nil)

;;; Files
(setq
 ;; Ask for a newline at end of file (base sets it; kept explicit).
 require-final-newline t
 ;; Opening a file under version control never asks about the symlinked copy.
 vc-follow-symlinks t
 ;; No lock files (#file#).
 create-lockfiles nil)

;;; History and positions
;; These three are the replacement for the old savefile/ directory.  All files
;; land in var/ because pre-early-init.el moved `user-emacs-directory'.
(use-package savehist
  :ensure nil
  :custom
  (history-length 1000)
  (history-delete-duplicates t)
  (savehist-additional-variables '(search-ring regexp-search-ring
                                                 kill-ring-newer))
  (savehist-autosave-interval 300)
  (savehist-save-minibuffer-history t)
  :init (savehist-mode 1))

(use-package recentf
  :ensure nil
  :custom
  (recentf-save-file (expand-file-name "recentf" user-emacs-directory))
  (recentf-max-saved-items 500)
  (recentf-exclude
   (list "\\`/tmp" "\\`/private/var/.*Trashes/" "\\.eld\\'" "\\.pack\\'"
         "COMMIT_EDITMSG" "\\`/proc/" "\\.eldc\\'" "emo-archive"
         (concat "^" (regexp-quote (expand-file-name "var/" rl-config-dir)))))
  :init (recentf-mode 1))

(use-package saveplace
  :ensure nil
  :custom (save-place-file (expand-file-name "saveplace" user-emacs-directory))
  :init (save-place-mode 1))

;; Re-read files that change on disk (git checkout, npm install, formatters).
(use-package autorevert
  :ensure nil
  :init (global-auto-revert-mode 1))

;;; Shell and compile buffers
(use-package eshell
  :ensure nil
  :commands eshell
  :custom
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-scroll-to-bottom-on-input 'this)
  :config
  ;; Prompt: current directory last component, then "> ".
  (setq eshell-prompt-function
        (lambda ()
          (concat (file-name-nondirectory
                   (directory-file-name (eshell/pwd)))
                  " > "))))

;;; Commands
(defun rl-new-untitled-buffer ()
  "Create a new empty buffer in `prog-mode'."
  (interactive)
  (switch-to-buffer (generate-new-buffer "untitled")))

(defun rl-scroll-down-keep-cursor ()
  "Scroll the text one line down without moving point."
  (interactive)
  (scroll-down 1))

(defun rl-scroll-up-keep-cursor ()
  "Scroll the text one line up without moving point."
  (interactive)
  (scroll-up 1))

(provide 'rl-core)
;;; rl-core.el ends here
