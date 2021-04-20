(use-package fringe-helper)
(use-package git-gutter)

(use-package git-gutter-fringe
  :ensure t
  :after (git-gutter fringe-helper)
  :hook (prog-mode . git-gutter-mode)
  :init
  (require 'git-gutter-fringe)
  :config
  (setq git-gutter-fr:side 'right-fringe))

(provide 'emacs-git-gutter-fringe)
