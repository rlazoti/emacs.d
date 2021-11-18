;; (use-package neotree
;;   :defer t
;;   :init
;;   (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
;;   ;(setq neo-theme 'ascii)
;;   (setq neo-window-position 'left)
;;   (setq neo-window-width 40)
;;   (setq neo-smart-open t)
;;   (setq neo-show-hidden-files t)
;;   (setq neo-hidden-regexp-list
;;         '(;; vcs folders
;;           "^\\.\\(?:git\\|hg\\|svn\\)$"
;;           ;; compiled files
;;           "\\.\\(?:pyc\\|o\\|elc\\|lock\\|css.map\\|class\\)$"
;;           ;; generated files, caches or local pkgs
;;           "^\\(?:node_modules\\|vendor\\|.\\(project\\|cask\\|yardoc\\|sass-cache\\)\\)$"
;;           ;; org-mode folders
;;           "^\\.\\(?:sync\\|export\\|attach\\)$"
;;           ;; temp files
;;           "~$"
;;           "^#.*#$"))

;;   :bind
;;   (:map global-map
;;         ([f5] . neotree-refresh)
;;         ([f6] . neotree-toggle)))

(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq ;treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          ;treemacs-directory-name-transformer    #'identity
          ;treemacs-display-in-side-window        t
          ;treemacs-eldoc-display                 t
          ;treemacs-file-event-delay              5000
          ;treemacs-file-extension-regex          treemacs-last-period-regex-value
          ;treemacs-file-follow-delay             0.2
          ;treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             nil
          treemacs-expand-after-init             t
          ;treemacs-git-command-pipe              ""
          ;treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          ;treemacs-is-never-other-window         nil
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
          ;treemacs-recenter-after-project-jump   'always
          ;treemacs-recenter-after-project-expand 'on-distance
          treemacs-litter-directories            '("/node_modules" "/.venv" "/.cask" "/sorbet")
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          ;treemacs-silent-filewatch              nil
          ;treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          ;treemacs-tag-follow-cleanup            t
          ;treemacs-tag-follow-delay              1.5
          ;treemacs-user-mode-line-format         nil
          ;treemacs-user-header-line-format       nil
          treemacs-width                         40
          treemacs-width-is-initially-locked     nil
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;; (treemacs-resize-icons 44)
    ;(with-eval-after-load 'treemacs
    ;  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
    (treemacs-follow-mode nil)
    (treemacs-filewatch-mode nil)
    ;(treemacs-fringe-indicator-mode 'always)
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
;;   :bind
;;   (:map global-map
;;         ([f5] . neotree-refresh)
;;         ([f6] . neotree-toggle)))



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
