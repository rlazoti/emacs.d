(use-package fringe-helper)
(use-package git-gutter)

(use-package git-gutter-fringe
  :ensure t
  :after (git-gutter fringe-helper)
  :hook (prog-mode . git-gutter-mode)
  :init
  (require 'git-gutter-fringe)
  :config
  (setq git-gutter-fr:side 'left-fringe)
  :custom
  (custom-set-variables
   '(git-gutter:update-interval 3)))

(provide 'emacs-git-gutter-fringe)
