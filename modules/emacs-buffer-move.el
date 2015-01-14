(emacs-require-package 'buffer-move)


(global-set-key (kbd "C-c C-c <up>")     'buf-move-up)
(global-set-key (kbd "C-c C-c <down>")   'buf-move-down)
(global-set-key (kbd "C-c C-c <left>")   'buf-move-left)
(global-set-key (kbd "C-c C-c <right>")  'buf-move-right)


(provide 'emacs-buffer-move)
