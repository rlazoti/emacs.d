;;; rl-projects.el --- Project root, file listing, sidebar -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-projectile.el and emacs-file-explorer.el.
;;
;; Projectile is kept (decision: not moving to project.el).  C-x f stays
;; `projectile-find-file' and s-p stays the projectile prefix map.
;;
;; Icon change: treemacs-all-the-icons -> treemacs-nerd-icons.

;;; Code:

(use-package projectile
  :custom
  (projectile-indexing-method 'alien)
  (projectile-enable-caching t)
  (projectile-completion-system 'default) ; Vertico + Orderless
  (projectile-mode-line-prefix " P")
  (projectile-file-exists-remote-cache-expire nil)
  :bind (("C-x f" . projectile-find-file)
         ("s-p"   . projectile-command-map)
         ("C-c p" . projectile-command-map))
  :config
  (projectile-mode 1)
  ;; Any directory with a VCS root is a project, including the ones with no
  ;; known marker file.
  (add-to-list 'projectile-project-root-functions
               #'projectile-root-local)
  :init
  ;; Bookmarks and cache live in var/, not in the config root.
  (setq projectile-cache-file (expand-file-name "projectile.cache" user-emacs-directory)
        projectile-known-projects-file
        (expand-file-name "projectile-bookmarks.eld" user-emacs-directory)))

(use-package treemacs
  :bind (("<f6>" . treemacs-add-and-display-current-project-exclusively)
         ("<f5>" . treemacs-refresh)
         :map global-map
         ("C-x t 1"   . treemacs-delete-other-windows)
         ("C-x t t"   . treemacs)
         ("C-x t d"   . treemacs-select-directory)
         ("C-x t B"   . treemacs-bookmark)
         ("C-x t C-t" . treemacs-find-file)
         ("C-x t M-t" . treemacs-find-tag))
  :custom
  (treemacs-width 40)
  (treemacs-width-is-initially-locked nil)
  (treemacs-indentation 2)
  (treemacs-indentation-string " ")
  (treemacs-sorting 'alphabetic-asc)
  (treemacs-show-hidden-files t)
  (treemacs-follow-after-init nil)
  (treemacs-expand-after-init t)
  (treemacs-space-between-root-nodes t)
  (treemacs-position 'left)
  (treemacs-fringe-indicator-mode 'always)
  (treemacs-no-delete-other-windows t)
  (treemacs-move-forward-on-expand nil)
  (treemacs-max-git-entries 5000)
  (treemacs-missing-project-action 'ask)
  (treemacs-litter-directories '("/node_modules" "/.venv" "/.cask" "/sorbet"))
  (treemacs-persist-file (expand-file-name "treemacs-persist" user-emacs-directory))
  (treemacs-deferred-git-apply-delay 0.5)
  (treemacs-read-string-input 'from-child-frame)
  :config
  ;; Follow mode: treemacs selects the line of the file being edited, in the
  ;; treemacs window, as point moves elsewhere.  It is turned on by treemacs
  ;; itself (`treemacs-only-during-init' in treemacs-follow-mode.el) and this
  ;; configuration used to switch it straight back off again here, which is the
  ;; only reason it was ever absent.
  ;;
  ;; `treemacs-follow-after-init' above decides nothing once this is on: the test
  ;; in treemacs-core-utils.el is an `or' of the two.  The other follow mode, `M-x
  ;; treemacs-project-follow-mode', follows the *project* of the current file and
  ;; switches this one off when enabled, so choose one or the other.
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1)
  (treemacs-fringe-indicator-mode 'always)
  ;; `deferred' needs git; `extended' needs git and python.  Pick the best
  ;; available without failing when one of them is missing.
  (cond ((not (executable-find "git")) nil)
        ((and (boundp 'treemacs-python-executable)
              treemacs-python-executable
              (executable-find treemacs-python-executable))
         (treemacs-git-mode 'deferred))
        (t (treemacs-git-mode 'simple))))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package treemacs-nerd-icons
  :after treemacs
  :config (treemacs-load-theme "nerd-icons"))

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :config (treemacs-icons-dired-mode))

(provide 'rl-projects)
;;; rl-projects.el ends here
