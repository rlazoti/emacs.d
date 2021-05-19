(use-package neotree
  :ensure t
  :defer t
  :config
  (setq neo-theme 'ascii)
  (setq neo-window-position 'left)
  (setq neo-window-width 40)
  (setq neo-smart-open t)
  (setq neo-show-hidden-files t)
  (setq neo-hidden-regexp-list
        '(;; vcs folders
          "^\\.\\(?:git\\|hg\\|svn\\)$"
          ;; compiled files
          "\\.\\(?:pyc\\|o\\|elc\\|lock\\|css.map\\|class\\)$"
          ;; generated files, caches or local pkgs
          "^\\(?:node_modules\\|vendor\\|.\\(project\\|cask\\|yardoc\\|sass-cache\\)\\)$"
          ;; org-mode folders
          "^\\.\\(?:sync\\|export\\|attach\\)$"
          ;; temp files
          "~$"
          "^#.*#$"))

  :bind
  (:map global-map
        ([f5] . neotree-refresh)
        ([f6] . neotree-toggle)))

(provide 'emacs-file-explorer)
