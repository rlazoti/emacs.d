(emacs-require-package 'sr-speedbar)


;; open/close speedbar global key
(global-set-key [f6] 'sr-speedbar-toggle)
(global-set-key [f5] 'speedbar-refresh)


;; sr-speedbar custom defs
(setq make-backup-files nil)
(setq sr-speedbar-auto-refresh nil)
(setq sr-speedbar-max-width 72)
(setq sr-speedbar-width-x 50)
(setq sr-speedbar-width-console 50)
(setq speedbar-obj-do-check nil)
(setq speedbar-show-unknown-files t)
(setq speedbar-use-images nil)
(setq speedbar-vc-do-check nil)


(provide 'emacs-sr-speedbar)
