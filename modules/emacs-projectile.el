(use-package projectile
  :bind
  (:map global-map ("C-x f" . projectile-find-file))
  :init
  (setq projectile-indexing-method 'alien)
  (setq projectile-file-exists-remote-cache-expire nil)
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map))

(provide 'emacs-projectile)
