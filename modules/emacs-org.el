(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i)" "WAITING(w@/!)" "REVIEW(r)" "|" "DONE(d!)" "CANCELLED(c@)")))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Documents/org-notes")
  (org-roam-completion-everywhere t)

  (org-modern-todo-faces
   '(("TODO" :background "moss" :foreground "white")
     ("DOING" :background "blue" :foreground "white")
     ("WAITING" :background "purple" :foreground "white")
     ("REVIEW" :background "brown" :foreground "white")
     ("CANCELLED" :background "red" :foreground "white")))
  :bind (("C-c x l" . org-roam-buffer-toggle)
         ("C-c x f" . org-roam-node-find)
         ("C-c x i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i"    . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c x d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))


(use-package org-modern
  :after org-roam
  ;; :custom
  ;; (org-modern-priority nil)
  ;(org-modern-hide-stars nil)
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

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
