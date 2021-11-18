(use-package centaur-tabs
  :demand

  :config
  (centaur-tabs-headline-match)
  (centaur-tabs-mode t)

  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules."
    (list
     (cond
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(magit-process-mode
                              magit-status-mode
                              magit-diff-mode
                              magit-log-mode
                              magit-file-mode
                              magit-blob-mode
                              magit-blame-mode
                              )))
       "Emacs")
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(helpful-mode
                          help-mode))
       "Help")
      ((memq major-mode '(org-mode
                          org-agenda-clockreport-mode
                          org-src-mode
                          org-agenda-mode
                          org-beamer-mode
                          org-indent-mode
                          org-bullets-mode
                          org-cdlatex-mode
                          org-agenda-log-mode
                          diary-mode))
       "OrgMode")
      (t "Primary"))))

  :custom
  (centaur-tabs-cycle-scope 'tabs)
  (centaur-tabs-set-icons t)
  (centaur-tabs-height 36)
  (centaur-tabs-gray-out-icons 'buffer)
  (centaur-tabs-set-bar 'left)
  (centaur-tabs-show-navigation-buttons t)
  (centaur-tabs-down-tab-text "  ")
  (centaur-tabs-backward-tab-text "  ")
  (centaur-tabs-forward-tab-text "  ")
  (centaur-tabs-new-tab-text "  ")
  (centaur-tabs-close-button "")

  ;(centaur-tabs-style "wave")

  :bind
  ;("C-<prior>" . centaur-tabs-backward)
  ;("C-<next>" . centaur-tabs-forward)
  ("C-c t k" . centaur-tabs-kill-unmodified-buffers-in-current-group))

(provide 'emacs-tabs)
