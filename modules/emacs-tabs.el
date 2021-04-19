(use-package centaur-tabs
  :demand
	:config
  (centaur-tabs-mode t)

	:init
	(setq centaur-tabs-style "wave")
	(setq centaur-tabs-set-icons t)
	(setq centaur-tabs-gray-out-icons 'buffer)

  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

(provide 'emacs-tabs)
