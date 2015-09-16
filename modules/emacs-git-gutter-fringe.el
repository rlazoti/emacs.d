(emacs-require-packages '(fringe-helper git-gutter git-gutter-fringe))

(require 'git-gutter-fringe)

(setq git-gutter-fr:side 'left-fringe)
(set-face-foreground 'git-gutter-fr:modified "blue")
(set-face-foreground 'git-gutter-fr:added    "green")
(set-face-foreground 'git-gutter-fr:deleted  "red")

(add-hook 'prog-mode-hook #'git-gutter-mode)

(provide 'emacs-git-gutter-fringe)
