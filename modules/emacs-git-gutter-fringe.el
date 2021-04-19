(use-package git-gutter
	:ensure t)

(use-package fringe-helper
	:ensure t
	:after git-gutter)

(use-package git-gutter-fringe
	:ensure t
	:after fringe-helper

	:config
	(setq git-gutter-fr:side 'left-fringe)
	(set-face-foreground 'git-gutter-fr:modified "blue")
	(set-face-foreground 'git-gutter-fr:added "green")
	(set-face-foreground 'git-gutter-fr:deleted "red")

	:hook (prog-mode . git-gutter-mode))

(provide 'emacs-git-gutter-fringe)
