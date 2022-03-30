(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq treemacs-deferred-git-apply-delay      0.5
          treemacs-follow-after-init             nil
          treemacs-expand-after-init             t
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-litter-directories            '("/node_modules" "/.venv" "/.cask" "/sorbet")
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-width                         40
          treemacs-width-is-initially-locked     nil
          treemacs-workspace-switch-cleanup      nil)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ([f6] . treemacs-display-current-project-exclusively)
        ([f5] . treemacs-refresh)))
;        ("M-0"       . treemacs-select-window)
;        ("C-x t 1"   . treemacs-delete-other-windows)
;        ("C-x t t"   . treemacs)
;        ("C-x t B"   . treemacs-bookmark)
;        ("C-x t C-t" . treemacs-find-file)
;        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-all-the-icons
  :ensure t)

(provide 'emacs-file-explorer)
