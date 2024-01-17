(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i!)" "WAITING(w@/!)" "REVIEW(r!)" "|" "DONE(d!)" "CANCELLED(c@/!)")))

(setq org-highest-priority ?A
      org-default-priority ?B
      org-lowest-priority ?D)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ruby . t)
   (shell . t)
   (js . t)
   (org . t)
   (python . t)
   (sql . t)))

(use-package ob-css :ensure nil :after org)
(use-package ob-emacs-lisp :ensure nil :after org)
(use-package ob-js :ensure nil :after org)
(use-package ob-org :ensure nil :after org)
(use-package ob-shell :ensure nil :after org)
(use-package ob-sql :ensure nil :after org)

(setq calendar-week-start-day 1)

;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/Projects/docs/second-brain/Tasks"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Avoid adding the time stamp when a TODO is set to done
(setq org-log-done-with-time nil)

;; Follow the links
(setq org-return-follows-link  t)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Remap the change priority keys to use the UP or DOWN key
(define-key org-mode-map (kbd "C-x <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-x <down>") 'org-priority-down)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-cg" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

(setq org-archive-location "~/Projects/docs/second-brain/Tasks/archived.org::* Archived Tasks")

(setq org-capture-templates
      '(
        ("t" "To-Dos - Today"
         entry (file+headline "~/Projects/docs/second-brain/Tasks/1-today.org" "Today Tasks")
         "* TODO [#C] %?\n:CREATED: %t\n "
         :empty-lines 1)

        ("w" "To-Dos - This Week"
         entry (file+headline "~/Projects/docs/second-brain/Tasks/2-this-week.org" "This Week Tasks")
         "* TODO [#C] %?\n:CREATED: %t\n "
         :empty-lines 1)

        ("m" "To-Dos - This Month"
         entry (file+headline "~/Projects/docs/second-brain/Tasks/3-this-month.org" "This Month Tasks")
         "* TODO [#C] %?\n:CREATED: %t\n "
         :empty-lines 1)

        ("b" "To-Dos - Backlog"
         entry (file+headline "~/Projects/docs/second-brain/Tasks/0-backlog.org" "Backlog Tasks")
         "* TODO [#C] %?\n:CREATED: %t\n "
         :empty-lines 1)
        ))

(use-package org-wild-notifier
  :after org
  :custom
  (alert-default-style 'libnotify)
  (org-wild-notifier-notification-title "Agenda Reminder")
  :config (org-wild-notifier-mode))

(use-package company-org-block
  :ensure t
  :custom
  (company-org-block-edit-style 'auto)
  (company-minimum-prefix-length 1)
  :hook ((org-mode . (lambda ()
                       (setq-local company-backends '(company-org-block))
                       (company-mode +1)))))

(use-package org-modern
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda)
  :custom
  (org-modern-priority
   '((?A . "❗")
     (?B . "⬆")
     (?C . "⬇")
     (?D . "☕️")))
  (org-modern-todo-faces
   '(("TODO" :background "moss" :foreground "white")
     ("DOING" :background "blue" :foreground "white")
     ("WAITING" :background "purple" :foreground "white")
     ("REVIEW" :background "brown" :foreground "white")
     ("CANCELLED" :background "red" :foreground "white"))))

;; (use-package org-modern-indent
;;   :after org-modern
;;   :straight (org-modern-indent :host github :repo "jdtsmith/org-modern-indent")
;;   :hook
;;   (org-indent-mode . org-modern-indent-mode))

;; (use-package org-easy-img-insert
;;   :config
;;   (autoload 'org-easy-img-insert "org-easy-img-insert" "Launch org-easy-img-insert with  org-mode" t)
;;   (add-hook 'org-mode-hook (lambda () (org-easy-img-insert 1))))


;; (use-package org-superstar
;;   :hook (org-mode . org-superstar-mode))

;; (use-package org-fancy-priorities
;;   :ensure t
;;   :hook
;;   (org-mode . org-fancy-priorities-mode)
;;   :config
;;   (setq org-fancy-priorities-list '("❗" "⬆" "⬇" "☕")))

(provide 'emacs-org)
