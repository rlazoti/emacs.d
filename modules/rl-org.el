;;; rl-org.el --- Org mode editing -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-org.el.
;;
;; Not ported (decision 2026-10-14):
;; - `org-agenda-files', `org-archive-location' and all four capture
;;   templates: they pointed at ~/Projects/docs/second-brain/Tasks, which does
;;   not exist on this machine any more.
;; - org-wild-notifier (agenda reminders via libnotify).
;; - company-org-block (it belonged to the company completion stack).
;;
;; If you want agenda and capture again, set `org-agenda-files' and
;; `org-capture-templates' in a private module.  The commands below stay bound:
;;   C-c l  org-store-link
;;   C-c c  org-capture
;;   C-c g  org-agenda

;;; Code:

(use-package org
  :ensure nil
  :bind (("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c g" . org-agenda)
         :map org-mode-map
         ;; Org puts the structural shifts on C-c <arrow>, the same chords
         ;; rl-keys.el uses for the windows; the mode map won and the cursor
         ;; never moved.  S-<arrow> is the same four commands, so unbinding
         ;; here costs nothing.
         ("C-c <left>"  . nil) ; org-shiftleft  -> S-<left>
         ("C-c <right>" . nil) ; org-shiftright -> S-<right>
         ("C-c <up>"    . nil) ; org-shiftup    -> S-<up>
         ("C-c <down>"  . nil)) ; org-shiftdown -> S-<down>
  :custom
  (org-todo-keywords
   '((sequence "TODO(t)" "DOING(i!)" "WAITING(w@/!)" "REVIEW(r!)"
               "|" "DONE(d!)" "CANCELLED(c@/!)")))
  (org-highest-priority ?A)
  (org-default-priority ?B)
  (org-lowest-priority ?D)
  ;; A timestamp when a TODO becomes DONE, without the time of day.
  (org-log-done 'time)
  (org-return-follows-link t)
  (org-hide-emphasis-markers t)
  (calendar-week-start-day 1)
  ;; Keep tables and drawers sane when the window is narrow.
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-src-preserve-indentation t)
  (org-edit-src-content-indentation 0)
  :hook (org-mode . visual-line-mode))

(use-package ob-shell
  :ensure nil
  :after org)

(use-package org-modern
  :after org
  :custom
  (org-modern-priority
   '((?A . "❗")
     (?B . "⬆")
     (?C . "⬇")
     (?D . "☕")))
  (org-modern-todo-faces
   '(("TODO"      :background "moss"   :foreground "white")
     ("DOING"     :background "blue"   :foreground "white")
     ("WAITING"   :background "purple" :foreground "white")
     ("REVIEW"    :background "brown"  :foreground "white")
     ("CANCELLED" :background "red"    :foreground "white")))
  :config
  ;; Babel: only the two languages that need no external binary here.  Add
  ;; (use-package ob-ruby :ensure nil :after org) and friends if you need more.
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)))
  (global-org-modern-mode))

(provide 'rl-org)
;;; rl-org.el ends here
