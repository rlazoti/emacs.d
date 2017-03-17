(emacs-require-package 'neotree)

(global-set-key [f5] 'neotree-refresh)
(global-set-key [f6] 'neotree-toggle)

(setq neo-theme 'ascii)
(setq neo-window-position 'right)
(setq neo-window-width 40)
(setq neo-smart-open t)

(custom-set-faces
 '(neo-header-face ((t (:foreground "deep sky blue" :slant normal :weight bold :height 120 :family "Monaco"))))
 '(neo-root-dir-face ((t (:foreground "deep sky blue" :slant normal :weight bold :height 120 :family "Monaco"))))
 '(neo-dir-link-face ((t (:foreground "deep sky blue" :slant normal :weight bold :height 120 :family "Monaco"))))
 '(neo-file-link-face ((t (:foreground "White" :weight normal :height 120 :family "Monaco")))))

(provide 'emacs-neotree)
